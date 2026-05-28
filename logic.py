import re
import gradio as gr
from config import token_classifier
from utils import post_process_corrected_text, compare_texts, is_gerund
from database import get_rule_by_slug, get_random_exercise, get_exercise_for_rule


# rule-based аналіз контексту
def analyze_comma_context(sentence, comma_positions):
    # словники слів
    interjections = {
        "ох", "ах", "ех", "ой", "гей", "о", "ого", "тьху", "алло", "агов", "стій",
        "ну", "геть", "господи", "боже", "жах", "матінко", "стоп", "ба", "фе",
        "тсс", "годі", "цить", "ай", "ух", "фу",
    }
    affirmations_negations = {
        "так", "ні", "авжеж", "еге", "егеж", "аякже", "овва", "атож", "гаразд",
        "добре", "звісно", "певно", "певна річ"
    }
    parenthetical = {
        "мабуть", "здається", "здавалося", "кажуть", "безумовно", "по-перше",
        "по-друге", "по-третє", "нарешті", "наприклад", "зокрема", "власне",
        "до речі", "щоправда", "отже", "проте", "однак", "мовляв", "на жаль",
        "на щастя", "на сором", "на диво", "очевидно", "певно", "зрозуміло",
        "безперечно", "по-моєму", "по-твоєму", "як кажуть", "пам'ятаю", "справді",
        "бачите", "знаєте", "уявіть", "між іншим", "як відомо", "чуєте",
        "одним словом", "коротше", "буває", "сподіваюся", "може", "правду кажучи",
        "бувало", "як видається", "навпаки", "на довершення", "крім того", "втім"
    }

    rep_conjunctions = {"і", "й", "ні", "ані", "то", "чи", "або", "чи то", "не то"}
    adversative_conjunctions = {
        "а", "але", "однак", "проте", "а проте", "зате", "та", "так", "хоча"
    }
    joining_conjunctions = {"і", "а також", "ще й", "а то й", "та й", "та ще"}
    concessive_conjunctions = {
        "хоч", "дарма що", "незважаючи на", "навіть якщо"
    }

    paired_conjunctions = {
        "а й": "не тільки", "але й": "не тільки", "а ще й": "не тільки",
        "але також і": "не тільки", "так і": "як", "як": "не так",
        "але": "хоч", "та": "хоч", "скільки": "не стільки"
    }

    generalizing_markers = {"а саме", "як-от", "як", "наприклад"}
    comparative_markers = {
        "як", "мов", "наче", "немов", "ніби", "як і", "ніж", "мовби", "немовби", "нібито"
    }
    limiting_markers = {
        "крім", "опріч", "за винятком", "особливо", "включаючи", "замість",
        "навіть", "зокрема"
    }
    subordinate_conjunctions = {
        "що", "щоб", "бо", "тому що", "через те що", "якщо", "якби", "коли", "де",
        "куди", "звідки", "який", "чия", "чиє", "чиї", "хто"
    }
    coordinating_conjunctions = {"і", "й", "або", "чи"}
    appositive_markers = {"тобто", "себто", "цебто"}

    found_slugs = []

    for i, idx in enumerate(comma_positions):
        start_search = comma_positions[i - 1] + 1 if i > 0 else 0
        pre_segment = sentence[start_search:idx].strip().split()
        post_segment = sentence[idx + 1:].strip().split()

        if not pre_segment:
            continue

        w1_before = re.sub(r'[^\w\-]', '', pre_segment[-1]).lower()
        w1_after = re.sub(r'[^\w\-]', '', post_segment[0]).lower() if post_segment else ""

        w2_after = (
                w1_after + " " + re.sub(r'[^\w\-]', '', post_segment[1]).lower()
        ) if len(post_segment) >= 2 else ""
        w3_after = (
                w2_after + " " + re.sub(r'[^\w\-]', '', post_segment[2]).lower()
        ) if len(post_segment) >= 3 else ""
        w4_after = (
                w3_after + " " + re.sub(r'[^\w\-]', '', post_segment[3]).lower()
        ) if len(post_segment) >= 4 else ""
        w2_before = (
                re.sub(r'[^\w\-]', '', pre_segment[-2]).lower() + " " + w1_before
        ) if len(pre_segment) >= 2 else ""

        # виділення контексту від коми до крапки, знаку питання чи оклику
        left_text = sentence[:idx]
        left_boundaries = [m.end() for m in re.finditer(r'[.!?]\s*', left_text)]
        current_sentence_left = left_text[left_boundaries[-1]:] if left_boundaries else left_text

        slug = None

        # перевірка на вигуки
        if w1_before in interjections:
            slug = "interjection"
        # перевірка на стверджувальні/заперечні слова
        elif w1_before in affirmations_negations or w2_before in affirmations_negations:
            slug = "affirmative_words"

        # парні сполучники
        if not slug:
            for tail, head in paired_conjunctions.items():
                if tail in [w1_after, w2_after, w3_after, w4_after]:
                    if bool(re.search(rf"\b{re.escape(head)}\b", current_sentence_left.lower())):
                        slug = "hom_double_conj"
                        break

        # узагальнювальні слова
        if not slug and (w1_after in generalizing_markers or w2_after in generalizing_markers):
            marker_len = 1 if w1_after in generalizing_markers else 2
            words_to_check = post_segment[marker_len:marker_len + 4]
            if ',' in " ".join(words_to_check):
                slug = "hom_summary"

        # допустові конструкції
        if not slug:
            if w1_after == "що" and "незважаючи на те" in current_sentence_left.lower():
                slug = "concessive"
            elif (w1_after in concessive_conjunctions or
                  w2_after in concessive_conjunctions or
                  w4_after in concessive_conjunctions):
                slug = "concessive"

        # підрядні речення
        if not slug:
            is_subordinate_after = (
                    w1_after in subordinate_conjunctions or
                    w2_after in subordinate_conjunctions
            )
            is_start_with_sub = False
            if i == 0:
                first_word = re.sub(r'[^\w\-]', '', sentence.split()[0]).lower()
                if first_word in subordinate_conjunctions:
                    is_start_with_sub = True
            if is_subordinate_after or is_start_with_sub:
                slug = "complex_subord"

        # складносурядні речення
        if not slug:
            if w1_after in coordinating_conjunctions or w2_after in coordinating_conjunctions:
                target_conj = w1_after if w1_after in coordinating_conjunctions else w2_after
                is_repeated = bool(re.search(rf"\b{re.escape(target_conj)}\b", current_sentence_left.lower()))
                if not is_repeated:
                    slug = "complex_coord"

        # обмежувально-уточнювальні конструкції
        if not slug:
            if w1_after in limiting_markers or w2_after in limiting_markers:
                slug = "limiting_clarifying"
            else:
                for word in pre_segment:
                    if re.sub(r'[^\w\-]', '', word).lower() in limiting_markers:
                        slug = "limiting_clarifying"
                        break

        # прикладки з маркерами
        if not slug:
            if w1_after in appositive_markers or w2_after in appositive_markers:
                slug = "apposition_markers"
            else:
                for word in pre_segment:
                    if re.sub(r'[^\w\-]', '', word).lower() in appositive_markers:
                        slug = "apposition_markers"
                        break

        # порівняльні конструкції
        if not slug and (w1_after in comparative_markers or w2_after in comparative_markers):
            slug = "comparative"

        # повторювані сполучники
        if not slug:
            if any(
                    (c == w1_after or c == w2_after) and bool(re.search(rf"\b{re.escape(c.split()[0])}\b", current_sentence_left.lower()))
                    for c in rep_conjunctions
            ):
                slug = "repeat_conj"

        # інші випадки
        if not slug:
            if (w1_after in joining_conjunctions or
                    w2_after in joining_conjunctions or
                    w3_after in joining_conjunctions):
                slug = "hom_add_conj"
            elif w1_after in adversative_conjunctions or w2_after in adversative_conjunctions:
                slug = "protyp_conj"
            elif w1_before == w1_after and w1_before != "":
                slug = "word_repeat"
            elif (any(is_gerund(re.sub(r'[^\w\-]', '', w)) for w in pre_segment) or
                  any(is_gerund(re.sub(r'[^\w\-]', '', w)) for w in post_segment)):
                slug = "gerund"
            elif (w1_before in parenthetical or w2_before in parenthetical or
                  w1_after in parenthetical or w2_after in parenthetical):
                slug = "parenthetical"

        if slug:
            found_slugs.append(slug)

    return found_slugs

# формування вихідних даних
def format_output_data(words, labels, original_input):
    final_sentence = []
    for i in range(len(words)):
        word = words[i]
        if labels[i] == 1: word += ","
        final_sentence.append(word)

    raw_result = " ".join(final_sentence)
    result_text = post_process_corrected_text(raw_result)
    comparison_report, has_errors = compare_texts(original_input, result_text)

    comma_positions = [m.start() for m in re.finditer(',', result_text)]
    found_slugs = analyze_comma_context(result_text, comma_positions) if comma_positions else []

    unique_rules = {}
    for slug in found_slugs:
        rule = get_rule_by_slug(slug)
        if rule and rule['rule_name'] not in unique_rules:
            unique_rules[rule['rule_name']] = {
                "id": rule['rule_id'],
                "theory": f"## 📘 {rule['rule_name']}\n\n{rule['explanation']}"
            }

    rule_names = list(unique_rules.keys())

    if not has_errors:
        btn_label = "🎯 Потренуватись"
        default_theory = "### 🧠 Чудова робота! Пропонуємо потренуватись:"
    else:
        btn_label = "📖 Переглянути правило та вправу"
        default_theory = unique_rules[rule_names[0]]["theory"] if rule_names else ""

    show_selector = gr.update(
        choices=rule_names,
        value=rule_names[0] if rule_names else None,
        visible=True if len(rule_names) > 1 else False
    )

    show_btn = gr.update(value=btn_label, visible=True) if (rule_names or not has_errors) else gr.update(visible=False)

    return (
        result_text,
        gr.update(value=comparison_report, visible=True),
        show_btn,
        show_selector,
        default_theory,
        unique_rules
    )

# отримання нової вправи
def get_next_exercise(rule_id):
    ex = get_exercise_for_rule(rule_id) if rule_id else get_random_exercise()
    if not ex:
        return [gr.update(visible=False)] * 8

    options = [o['option_text'] for o in ex['options']]
    return (
        f"### 📝 Практичне завдання\n{ex['question']}",
        gr.update(choices=options, value=None, visible=True),
        gr.update(value="", visible=False),
        gr.update(value="", visible=False),
        gr.update(value="", visible=False),
        ex['correct_answer'],
        ex['hint'],
        ex['author']
    )


def analyze_punctuation(user_input):
    if not user_input or not user_input.strip():
        return (
            "Введіть текст",
            gr.update(visible=False),
            gr.update(visible=False),
            gr.update(choices=[], value=None, visible=False),
            "",
            {}
        )
    input_for_model = re.sub(r'[,.!?:;\\-]{2,}', ' ', user_input)
    clean_text = input_for_model.replace(",", "")
    predictions = token_classifier(clean_text)
    words, labels = [], []
    current_word, current_label = "", 0
    for i, pred in enumerate(predictions):
        token = pred['word']
        if token.startswith(' ') or token.startswith('▁') or i == 0:
            if current_word:
                words.append(current_word)
                labels.append(current_label)
            current_word = token.replace(' ', '').replace('▁', '')
            current_label = 0
        else:
            current_word += token
        if pred['entity'] in ['LABEL_1', 'COMMA']: current_label = 1
    if current_word:
        words.append(current_word)
        labels.append(current_label)
    return format_output_data(words, labels, user_input)
