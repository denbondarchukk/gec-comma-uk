import random
from config import supabase

# отримання правила з бази даних за slug
def get_rule_by_slug(slug):
    try:
        response = supabase.table("punctuation_rule").select("*").eq("slug", slug).execute()
        if response.data:
            return response.data[0]
    except Exception:
        pass
    return None

# отримання випадкової вправи з бази даних
def get_random_exercise():
    try:
        exercises_resp = supabase.table("exercise").select("*").execute()
        if not exercises_resp.data:
            return None

        exercise = random.choice(exercises_resp.data)
        options_resp = supabase.table("exercise_option").select("*").eq(
            "exercise_id", exercise['exercise_id']
        ).execute()

        if not options_resp.data:
            return None

        correct_answer = None
        for opt in options_resp.data:
            if opt['is_correct'] in [True, 'true', 'True']:
                correct_answer = opt['option_text']
                break

        return {
            "question": exercise['question'],
            "options": options_resp.data,
            "correct_answer": correct_answer,
            "hint": exercise.get('detailed_hint', ''),
            "author": exercise.get('author_name', '')
        }
    except Exception:
        return None

# отримання вправи для конкретного правила
def get_exercise_for_rule(rule_id):
    try:
        exercise_resp = supabase.table("exercise").select("*").eq("rule_id", rule_id).execute()
        if not exercise_resp.data:
            return None

        exercise = random.choice(exercise_resp.data)
        options_resp = supabase.table("exercise_option").select("*").eq(
            "exercise_id", exercise['exercise_id']
        ).execute()

        if not options_resp.data:
            return None

        correct_answer = None
        for opt in options_resp.data:
            if opt['is_correct'] in [True, 'true', 'True']:
                correct_answer = opt['option_text']
                break

        return {
            "question": exercise['question'],
            "options": options_resp.data,
            "correct_answer": correct_answer,
            "hint": exercise.get('detailed_hint', ''),
            "author": exercise.get('author_name', '')
        }
    except Exception:
        return None
