import re
import os

# список директорій
datasets = {
    "train": "ua-gec/data/gec-only/train/annotated",
    "test": "ua-gec/data/gec-only/test/annotated"
}


def count_raw_punctuation(ann_files):
    total_errors = 0
    total_punct = 0
    commas = 0
    missing_commas = 0
    extra_commas = 0

    for filename in ann_files:
        with open(filename, "r", encoding="utf-8") as f:
            content = f.read()

            # пошук абсолютно всіх помилок для загального підрахунку
            all_errors_patt = r"\{.*?=>.*?:::error_type=.*?\}"
            total_errors += len(re.findall(all_errors_patt, content))

            # пошук усіх тегів пунктуації
            patt = r"\{(.*?)=>(.*?):::error_type=Punctuation\}"
            all_punct = re.findall(patt, content)

            total_punct += len(all_punct)

            for left, right in all_punct:
                has_comma_left = "," in left
                has_comma_right = "," in right

                # рахуємо кому лише якщо її статус дійсно змінився
                if has_comma_left != has_comma_right:
                    commas += 1

                    if not has_comma_left and has_comma_right:
                        missing_commas += 1
                    elif has_comma_left and not has_comma_right:
                        extra_commas += 1

    return total_errors, total_punct, commas, missing_commas, extra_commas


# роздільний збір та обрахунок даних
for name, directory in datasets.items():
    if not os.path.exists(directory):
        print(f"Директорію {name} не знайдено, пропускаємо.")
        continue

    # збір файлів для поточної папки
    ann_files = [os.path.join(directory, f) for f in os.listdir(directory) if f.endswith(".ann")]

    # підрахунок сирих помилок з файлів
    total_err, total_punct, comma_punct, missing, extra = count_raw_punctuation(ann_files)

    # розрахунок часток у відсотках
    pct_punct_of_all = (total_punct / total_err * 100) if total_err > 0 else 0
    pct_comma_of_punct = (comma_punct / total_punct * 100) if total_punct > 0 else 0

    # вивід результатів
    print(f"Набір даних: {name.upper()}")
    print(f"Усього помилок усіх типів: {total_err}")
    print(f"Загальна кількість пунктуаційних помилок: {total_punct} ({pct_punct_of_all:.2f}% від усіх помилок)")
    print(f"Кількість помилок із комою: {comma_punct} ({pct_comma_of_punct:.2f}% від пунктуаційних)")
    print(f"• Пропущено ком (необхідно додати): {missing}")
    print(f"• Зайвих ком (необхідно видалити): {extra}\n")
