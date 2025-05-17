# GEC Comma UK

**GEC Comma UK** — це інструмент для виявлення та виправлення пунктуаційних помилок, пов’язаних із вживанням коми в українських текстах. Проєкт побудований на основі донавченої трансформерної моделі та призначений для навчання, досліджень і вдосконалення мовної грамотності.

## Структура проєкту

- `datasets/` — анотовані дані.
- `data/` — корпус для донавчання.
- `ann_to_dataset.py` — скрипт для підготовки датасету з анотацій.
- `punctuation_error_counter.py` — підрахунок пунктуаційних помилок з комою у даних.
- `comma_error_detector_training.ipynb` — ноутбук із кодом донавчання моделі.
- `interface.py` — скрипт для взаємодії з моделлю.

## Модель

Опублікована на [Hugging Face](https://huggingface.co/denbondarchukk/gec-comma-uk)

## Встановлення

```bash
git clone https://github.com/denbondarchukk/gec-comma-uk.git comma_project
cd comma_project
pip install -r requirements.txt
```

## Запуск системи
Щоб розгорнути та запустити проект локально, виконайте наступні кроки:
1. Створіть віртуальне середовище
2. Завантажте модель з Hugging Face
3. Завантажте репозиторій з GitHub
4. Запустіть interface.py