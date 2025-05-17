import tkinter as tk
from tkinter import scrolledtext
from transformers import pipeline
import re

# ініціалізація моделі
token_classifier = pipeline(
    "token-classification",
    model=r"model",
    tokenizer=r"model"
)


def preprocess_text(text):
    # Замінити кілька пробілів одним
    text = re.sub(r'\s{2,}', ' ', text)

    # Забрати пробіл перед комою
    text = re.sub(r'\s+,', ',', text)

    # Додати пробіл після коми, якщо його немає
    text = re.sub(r',(?=\S)', ', ', text)

    return text.strip()


# основна функція обробки
def process_text():
    raw_text = input_field.get("1.0", tk.END)
    sentence = preprocess_text(raw_text)
    predictions = token_classifier(sentence)

    words = []
    labels = []
    token_to_word_idx = {}

    current_word = ""
    current_label = None
    word_idx = -1

    for idx, pred in enumerate(predictions):
        token = pred['word']
        label = pred['entity']

        if token.startswith('▁'):
            if current_word:
                words.append(current_word)
                labels.append(current_label)
            current_word = token[1:]
            current_label = label
            word_idx += 1
        else:
            current_word += token

        token_to_word_idx[idx] = word_idx

    if current_word:
        words.append(current_word)
        labels.append(current_label)

    # пошук контекстів
    context_words = 3
    contexts = []

    for idx, pred in enumerate(predictions):
        label = pred['entity']
        if label in ['LABEL_1', 'LABEL_2']:
            word_index = token_to_word_idx[idx]
            left = words[max(0, word_index - context_words):word_index]
            target = words[word_index]
            right = words[word_index + 1: word_index + 1 + context_words]

            if label == 'LABEL_1':
                marker = f"[{target}],"
                tag = "Відсутня кома"
            else:
                marker = f"[{target}]"
                tag = "Зайва кома"

            full_context = ' '.join(left + [marker] + right)
            contexts.append((tag, full_context))

    # побудова виправленого речення
    filtered_tokens = [pred for pred in predictions if pred['entity'] != 'LABEL_2']
    result = []
    current_token = ""

    for pred in filtered_tokens:
        word = pred['word']
        label = pred['entity']

        if word.startswith('▁'):
            if current_token:
                result.append(current_token)
            current_token = word[1:]
        else:
            current_token += word

        if label == 'LABEL_1':
            result.append(current_token + ',')
            current_token = ""

    if current_token:
        result.append(current_token)

    final_sentence = ' '.join(result)

    # вивід результату
    output_field.delete("1.0", tk.END)
    output_field.insert(tk.END, f"{final_sentence}\n\n")

    output_field.insert(tk.END, f"Звіт:\n")
    if contexts:
        output_field.insert(tk.END, f"{'Тип помилки':<15} | Контекст\n")
        output_field.insert(tk.END, "-" * 70 + "\n")
        for tag, context in contexts:
            output_field.insert(tk.END, f"{tag:<15} | {context}\n")
    else:
        output_field.insert(tk.END, "Жодних пунктуаційних помилок з комою не виявлено.\n")


def clear_fields():
    input_field.delete("1.0", tk.END)
    output_field.delete("1.0", tk.END)

# стилі
font_main = ("Verdana", 12)
bg_main = "#eaf4f4"
bg_entry = "#ffffff"
text_color = "#1f2d3d"
highlight_color = "#5cb85c"
error_color = "#d9534f"
divider_color = "#cfd8dc"
button_bg = "#f1f8f9"

root = tk.Tk()
root.title("Аналіз української пунктуації з комою")
root.geometry("880x570")
root.configure(bg=bg_main)

# поле введення
input_label = tk.Label(root, text="Введіть текст:", font=font_main, bg=bg_main, fg=text_color)
input_label.pack(anchor='w', padx=12, pady=(12, 0))

input_field = scrolledtext.ScrolledText(root, wrap=tk.WORD, height=5, font=font_main, bg=bg_entry, fg=text_color,
                                        insertbackground=text_color)
input_field.pack(fill=tk.X, padx=12, pady=6, ipadx=4, ipady=4)

# роздільник
tk.Frame(root, height=2, bd=0, relief=tk.SUNKEN, bg=divider_color).pack(fill=tk.X, padx=12, pady=10)

# кнопки
button_frame = tk.Frame(root, bg=bg_main)
button_frame.pack()

analyze_button = tk.Button(
    button_frame, text="Аналізувати", command=process_text,
    bg=highlight_color, fg="white", font=font_main, padx=12, pady=6, relief=tk.FLAT
)
analyze_button.pack(side=tk.LEFT, padx=8)

clear_button = tk.Button(
    button_frame, text="Очистити", command=clear_fields,
    bg=error_color, fg="white", font=font_main, padx=12, pady=6, relief=tk.FLAT
)
clear_button.pack(side=tk.LEFT, padx=8)

# роздільник
tk.Frame(root, height=2, bd=0, relief=tk.SUNKEN, bg=divider_color).pack(fill=tk.X, padx=12, pady=10)

# поле виводу
output_label = tk.Label(root, text="Відредагований текст:", font=font_main, bg=bg_main, fg=text_color)
output_label.pack(anchor='w', padx=12, pady=(0, 4))

output_field = scrolledtext.ScrolledText(root, wrap=tk.WORD, font=font_main, bg=bg_entry, fg=text_color,
                                         insertbackground=text_color)
output_field.pack(expand=True, fill='both', padx=12, pady=(0, 12), ipadx=4, ipady=4)

root.mainloop()
