import re

# видалення коми, якщо модель поставила її там, де вже є інший знак
def post_process_corrected_text(text):
    text = re.sub(r',(\s*[-–—])', r'\1', text)
    text = re.sub(r'([-–—]\s*),', r'\1', text)
    text = re.sub(r'\s+', ' ', text)
    return text.strip()

# перевірка, чи є слово дієприслівником
def is_gerund(word):
    word = word.lower()
    suffixes = (
        'учи', 'ючи', 'ачи', 'ячи', 'учись', 'ючись', 'ачись', 'ячись',
        'вши', 'ши', 'вшись', 'шись'
    )
    return any(word.endswith(s) for s in suffixes) and len(word) > 3

# детектор 'хуліганства'
def compare_texts(original_text, corrected_text):
    error_report = []

    if re.search(r'[,.!?:;\\-]{2,}', original_text):
        error_report.append(
            "⚠️ **Виявлено надмірну пунктуацію:** у тексті присутні множинні знаки підряд або дивні комбінації."
        )

    original_sentences = re.split(r'(?<=[.!?])\s+', original_text.strip())
    corrected_sentences = re.split(r'(?<=[.!?])\s+', corrected_text.strip())

    for idx, (orig_s, corr_s) in enumerate(zip(original_sentences, corrected_sentences)):
        s_num = idx + 1
        orig_tokens = [t for t in orig_s.split() if t]
        corr_tokens = [t for t in corr_s.split() if t]

        i_orig = 0
        for i_corr in range(len(corr_tokens)):
            if i_orig >= len(orig_tokens):
                break

            clean_orig = re.sub(r'[^\w\s]', '', orig_tokens[i_orig])
            clean_corr = re.sub(r'[^\w\s]', '', corr_tokens[i_corr])

            if clean_orig == clean_corr:
                has_comma_orig = ',' in orig_tokens[i_orig]
                has_comma_corr = ',' in corr_tokens[i_corr]

                if not has_comma_orig and has_comma_corr:
                    error_report.append(
                        f"- У реченні №{s_num} **пропущено кому** після слова «{clean_orig}»"
                    )
                elif has_comma_orig and not has_comma_corr:
                    error_report.append(
                        f"- У реченні №{s_num} була **зайва кома** біля слова «{clean_orig}»"
                    )
                i_orig += 1
            else:
                i_orig += 1

    has_errors = len(error_report) > 0

    if not has_errors:
        return "✨ Пунктуаційних помилок з комами не виявлено!", has_errors

    return "### Аналіз допущених помилок:\n" + "\n".join(error_report), has_errors
