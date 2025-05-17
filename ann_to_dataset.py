import os
import re
import json
from transformers import AutoTokenizer

tokenizer = AutoTokenizer.from_pretrained("ukr-models/xlm-roberta-base-uk")

# функція для обробки анотацій з файлів
def transform_annotations(ann_files):
    result_text = ""

    for filename in ann_files:
        with open(filename, "r", encoding="utf-8") as f:
            content = f.read()

            # Обробка кожної анотації у форматі {...}
            def handle_annotation(match):
                left, right, err_type = match.group(1), match.group(2), match.group(3)
                if err_type == "Punctuation" and ("," in left or "," in right):
                    return match.group(0)  # лишаємо як є, якщо помилка з комою
                else:
                    return f"{right}"  # лишаємо виправлене

            # пошук і заміна непотрібних анотацій
            pattern = r"\{(.*?)=>(.*?):::error_type=(.*?)\}"
            content = re.sub(pattern, handle_annotation, content)
            result_text += content + "\n\n"

    return result_text


# функція для витягування прикладів для навчання
def extract_samples(annotated_text):
    samples = []
    total_insertions = 0
    total_deletions = 0
    paragraphs = annotated_text.strip().split("\n")

    for paragraph in paragraphs:
        if not paragraph.strip():
            continue

        comma_insert_positions = []  # де треба вставити кому (1 на попередньому слові)
        comma_delete_positions = []  # де треба видалити кому (1 на самій комі)

        clean_text = ""
        idx = 0

        for match in re.finditer(r"\{(.*?)=>(.*?):::error_type=Punctuation}", paragraph):
            start, end = match.span()
            left, right = match.group(1), match.group(2)

            # додаємо до чистого тексту початкову помилку (left)
            clean_text += paragraph[idx:start] + left
            idx = end

            current_tokens = tokenizer.tokenize(clean_text)
            token_index = len(current_tokens) - 1

            # якщо потрібно вставити кому
            if right == "," and left != ",":
                comma_insert_positions.append(token_index)
                total_insertions += 1
            # якщо потрібно видалити кому
            elif left == "," and right != ",":
                # поточний токен — це кома
                comma_delete_positions.append(token_index)
                total_deletions += 1

        # додаємо решту тексту після останньої анотації
        clean_text += paragraph[idx:]

        tokens = tokenizer.tokenize(clean_text)
        labels = [0] * len(tokens)

        for pos in comma_insert_positions:
            if 0 <= pos < len(labels):
                labels[pos] = 1  # вставити кому після цього слова

        for pos in comma_delete_positions:
            if 0 <= pos < len(labels) and tokens[pos] == ",":
                labels[pos] = 2  # видалити кому

        samples.append({
            "text": " ".join(tokens),
            "labels": labels
        })

    print(f"Кома потрібна (вставка): {total_insertions}")
    print(f"Кома зайва (видалення): {total_deletions}")

    return samples


# функція для обробки і збереження датасету
def process_and_save(directory, output_file):
    # зчитування всіх файлів .ann з директорії
    ann_files = sorted([os.path.join(directory, f) for f in os.listdir(directory) if f.endswith(".ann")])
    # отримання анотованого тексту
    processed = transform_annotations(ann_files)
    # створення датасету для навчання
    dataset = extract_samples(processed)
    # збереження у файл
    with open(output_file, "w", encoding="utf-8") as f:
        for item in dataset:
            json.dump(item, f, ensure_ascii=False)
            f.write("\n")
    print(f'Записано {len(dataset)} рядків у "{output_file}"')


directory = "data/train/annotated"
output_file = "dataset/train.json"
process_and_save(directory, output_file)
