import os
import re
import json
from transformers import AutoTokenizer
# токенізатор моделі
tokenizer = AutoTokenizer.from_pretrained("ukr-models/xlm-roberta-base-uk")


# обробка файлів .ann
def transform_annotations(ann_files):
    result_text = ""
    for filename in ann_files:
        with open(filename, "r", encoding="utf-8") as f:
            content = f.read()

            def handle_annotation(match):
                left, right, err_type = match.group(1), match.group(2), match.group(3)
                if err_type == "Punctuation" and ("," in left or "," in right):
                    return match.group(0)
                else:
                    return f"{right}"

            pattern = r"\{(.*?)=>(.*?):::error_type=(.*?)\}"
            content = re.sub(pattern, handle_annotation, content)
            result_text += content + "\n\n"
    return result_text


# створення датасету
def extract_samples(annotated_text):
    samples = []
    total_marks = 0
    total_tokens = 0  # лічильник усіх токенів
    paragraphs = annotated_text.strip().split("\n")

    for paragraph in paragraphs:
        if not paragraph.strip():
            continue

        comma_positions = []
        clean_text = ""
        idx = 0

        # пошук анотацій з комами
        for match in re.finditer(r"\{(.*?)=>(.*?):::error_type=Punctuation}", paragraph):
            start, end = match.span()
            left, right = match.group(1), match.group(2)

            # видалення всіх правильні коми
            text_before = paragraph[idx:start]
            parts = text_before.split(",")
            for i, part in enumerate(parts):
                clean_text += part
                if i < len(parts) - 1:
                    current_tokens = tokenizer.tokenize(clean_text)
                    if current_tokens:
                        comma_positions.append(len(current_tokens) - 1)
                        total_marks += 1

            # видалення коми з помилкового варіанту і виставлення міьки
            clean_text += left.replace(",", "")
            if "," in right:
                current_tokens = tokenizer.tokenize(clean_text)
                if current_tokens:
                    comma_positions.append(len(current_tokens) - 1)
                    total_marks += 1

            idx = end

        # додавання решти тексту
        remaining_parts = paragraph[idx:].split(",")
        for i, part in enumerate(remaining_parts):
            clean_text += part
            if i < len(remaining_parts) - 1:
                current_tokens = tokenizer.tokenize(clean_text)
                if current_tokens:
                    comma_positions.append(len(current_tokens) - 1)
                    total_marks += 1

        tokens = tokenizer.tokenize(clean_text)
        labels = [0] * len(tokens)

        for pos in comma_positions:
            if 0 <= pos < len(labels):
                labels[pos] = 1

        total_tokens += len(labels)  # додаємо токени поточного абзацу

        samples.append({
            "text": " ".join(tokens),
            "labels": labels
        })

    # обрахунок міток без ком
    total_zeros = total_tokens - total_marks

    print(f"Загальна кількість токенів у файлі: {total_tokens}")
    print(f"• Міток LABEL_0 (кома не потрібна): {total_zeros}")
    print(f"• Міток LABEL_1 (вставка коми): {total_marks}")
    return samples


# збереження у формат .json
def process_and_save(directory, output_file):
    if not os.path.exists(directory):
        print(f"Директорію {directory} не знайдено.")
        return

    ann_files = sorted([os.path.join(directory, f) for f in os.listdir(directory) if f.endswith(".ann")])
    processed = transform_annotations(ann_files)
    dataset = extract_samples(processed)

    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    with open(output_file, "w", encoding="utf-8") as f:
        for item in dataset:
            json.dump(item, f, ensure_ascii=False)
            f.write("\n")
    print(f'Записано у "{output_file}"\n')


# запуск
directory = "ua-gec/data/gec-only/test/annotated"
output_file = "dataset/test.json"
process_and_save(directory, output_file)
