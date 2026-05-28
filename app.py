import gradio as gr
from logic import analyze_punctuation, get_next_exercise


def check_answer(choice, correct_val, hint_val, author_val):
    if not choice: return [gr.update(visible=False)] * 4

    is_correct = str(choice).strip() == str(correct_val).strip()
    result_text = "### 🎉 Правильно!" if is_correct else "### 💡 Спробуйте ще раз."

    return (
        gr.update(value=result_text, visible=True),
        gr.update(value=f"**💡 Пояснення:**\n\n{hint_val}", visible=True) if hint_val else gr.update(visible=False),
        gr.update(value=f"_Автор речення: {author_val}_", visible=True) if author_val else gr.update(visible=False),
        gr.update(visible=True)  # Показуємо кнопку "Інша вправа"
    )


# дизайн

custom_css = """
/* світла тема */
.gradio-container { max-width: 850px !important; margin: 40px auto !important; }
body { background-color: #f7f5f2 !important; }
.primary-btn { 
    background: #2d3748 !important; 
    color: white !important; 
    border-radius: 10px !important; 
    border: none !important;
}
.primary-btn:hover { background: #1a202c !important; }
.output-card { 
    background: #fdfcfb !important; 
    padding: 20px !important; 
    border-radius: 16px !important; 
    box-shadow: 0 4px 15px rgba(0,0,0,0.02) !important; 
    margin-bottom: 20px;
    border: 1px solid #eeebe6 !important;
}
.gradio-container textarea {
    background-color: #faf9f7 !important;
    border-color: #e2e0db !important;
}
.error-block { 
    background: #fff0f0 !important; 
    border-left: 5px solid #fecaca !important; 
    padding: 15px !important; 
    border-radius: 8px !important; 
    margin-bottom: 20px;
    color: #7f1d1d !important;
}
.theory-block { 
    background: #f0f4f8 !important; 
    border-left: 5px solid #cbd5e1 !important; 
    padding: 15px !important; 
    border-radius: 8px !important; 
    color: #334155 !important;
}
.result-block { 
    background: #f0fdf4 !important; 
    border-left: 5px solid #86efac !important; 
    padding: 15px !important; 
    border-radius: 8px !important; 
    margin-top: 15px;
    margin-bottom: 10px;
    color: #166534 !important;
}
.hint-block { 
    background: #fffbeb !important; 
    border-left: 5px solid #fbbf24 !important; 
    padding: 15px !important; 
    border-radius: 8px !important; 
    margin-top: 10px;
    color: #78350f !important;
}
/* темна тема */
.dark, .dark :root, .dark body, .dark .gradio-container { 
    background-color: #0f172a !important; 
}
.dark .main, .dark .gradio-container-4-0-0 {
    background-color: #0f172a !important;
}
.dark h1, .dark p, .dark label, .dark .markdown-text {
    color: #f8fafc !important;
}
.dark .output-card { 
    background: #1e293b !important; 
    border: 1px solid #334155 !important; 
}
.dark .gradio-container textarea {
    background-color: #1e293b !important;
    border-color: #334155 !important;
    color: #f8fafc !important;
}
.dark .error-block { 
    background: #2d1a1a !important; 
    border-left-color: #f56565 !important; 
    color: #fed7d7 !important; 
}
.dark .theory-block { 
    background: #1e3a8a !important; 
    border-left-color: #3b82f6 !important; 
    color: #e0f2fe !important; 
}
.dark .result-block { 
    background: #064e3b !important; 
    border-left-color: #34d399 !important; 
    color: #d1fae5 !important; 
}
.dark .hint-block { 
    background: #422006 !important; 
    border-left-color: #f59e0b !important; 
    color: #fef3c7 !important; 
}
.dark .exercise-container { 
    background: #1e293b !important; 
    border: 1px solid #334155 !important; 
}
.dark .gradio-group { 
    background-color: transparent !important; 
    border-color: #334155 !important; 
}
"""

theme = gr.themes.Soft(
    primary_hue="blue",
    neutral_hue="slate"
).set(
    body_background_fill="#f7f5f2",
    block_background_fill="#fdfcfb",
    input_background_fill="#faf9f7",
    button_primary_background_fill="#2d3748"
)


# функція відображення вправи при натисканні кнопки
def open_theory_with_cleanup(selected_rule_name, rules_dict):
    from database import get_random_exercise, get_exercise_for_rule

    if not selected_rule_name or not rules_dict:
        ex = get_random_exercise()
        theory = "### 🎯 Чудова робота! Пропонуємо потренуватись:"
        rule_id = None
    else:
        rule_data = rules_dict.get(selected_rule_name)
        if rule_data:
            theory = rule_data["theory"]
            rule_id = rule_data["id"]
            ex = get_exercise_for_rule(rule_id)
        else:
            ex = get_random_exercise()
            theory = "### 🎯 Чудова робота! Пропонуємо потренуватись:"
            rule_id = None

    if not ex:
        return [
            gr.update(visible=True),
            theory,
            "### 🚧 Вправу ще не додано",
            gr.update(visible=False),
            gr.update(value="", visible=False),
            gr.update(value="", visible=False),
            gr.update(value="", visible=False),
            gr.update(visible=False),
            "",
            "",
            "",
            None
        ]

    opts = [o['option_text'] for o in ex['options']]

    return [
        gr.update(visible=True),
        theory,
        f"### 📝 Практичне завдання\n{ex['question']}",
        gr.update(choices=opts, value=None, visible=True),
        gr.update(value="", visible=False),
        gr.update(value="", visible=False),
        gr.update(value="", visible=False),
        gr.update(visible=False),
        ex['correct_answer'],
        ex['hint'],
        ex['author'],
        rule_id
    ]

with gr.Blocks(theme=theme, css=custom_css) as demo:
    correct_answer_storage = gr.State("")
    hint_storage = gr.State("")
    author_storage = gr.State("")
    theory_storage = gr.State("")
    rules_dictionary_storage = gr.State({})
    current_rule_id = gr.State(None)

    with gr.Column():
        gr.Markdown("# ✍️ Пунктуаційний помічник")
        input_txt = gr.Textbox(label="Ваш текст:", placeholder="Введіть текст...", lines=4)
        btn = gr.Button("Проаналізувати", variant="primary", elem_classes="primary-btn")

        with gr.Column(elem_classes="output-card"):
            output_text = gr.Textbox(label="Виправлений варіант", interactive=False)
            error_report_display = gr.Markdown(visible=False, elem_classes="error-block")

            rule_selector = gr.Dropdown(label="Знайдено кілька правил. Оберіть тему:", visible=False)
            show_rule_btn = gr.Button("📖 Переглянути правило та потренуватись", visible=False)

        with gr.Column(visible=False) as theory_exercise_section:
            output_theory = gr.Markdown(elem_classes="theory-block")
            with gr.Column(elem_classes="exercise-container"):
                ex_question = gr.Markdown()
                ex_options = gr.Radio(label="Оберіть варіант:")
                ex_result = gr.Markdown(visible=False, elem_classes="result-block")
                ex_hint = gr.Markdown(visible=False, elem_classes="hint-block")
                ex_author = gr.Markdown(visible=False)
                next_ex_btn = gr.Button("🔄 Спробувати іншу вправу", visible=False)

    # клік "Проаналізувати"
    btn.click(
        fn=analyze_punctuation,
        inputs=input_txt,
        outputs=[output_text, error_report_display, show_rule_btn, rule_selector, theory_storage,
                 rules_dictionary_storage]
    ).then(fn=lambda: gr.update(visible=False), outputs=theory_exercise_section)

    # клік "Переглянути правило"
    show_rule_btn.click(
        fn=open_theory_with_cleanup,
        inputs=[rule_selector, rules_dictionary_storage],
        outputs=[
            theory_exercise_section, output_theory, ex_question, ex_options,
            ex_result, ex_hint, ex_author, next_ex_btn,
            correct_answer_storage, hint_storage, author_storage, current_rule_id
        ]
    )

    # перевірка відповіді
    ex_options.change(
        fn=check_answer,
        inputs=[ex_options, correct_answer_storage, hint_storage, author_storage],
        outputs=[ex_result, ex_hint, ex_author, next_ex_btn]
    )

    # наступна вправа
    next_ex_btn.click(
        fn=get_next_exercise,
        inputs=current_rule_id,
        outputs=[ex_question, ex_options, ex_result, ex_hint, ex_author, correct_answer_storage, hint_storage,
                 author_storage]
    )

if __name__ == "__main__":
    demo.launch()
