import re
import os

directory = "data/test/annotated"
ann_files = [os.path.join(directory, f) for f in os.listdir(directory) if f.endswith(".ann")]

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


processed = transform_annotations(ann_files)
punctuation_count = len(re.findall(r":::error_type=Punctuation}", processed))
print(f"Кількість пунктуаційних помилок: {punctuation_count}")
