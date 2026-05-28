import os
from transformers import pipeline
from supabase import create_client

# підключення моделі
model_path = os.path.abspath("model")

token_classifier = pipeline(
    "token-classification",
    model=model_path,
    tokenizer=model_path,
    aggregation_strategy="none",
    ignore_labels=[]
)

# підключення supabase
SUPABASE_URL = "https://txlnduafnjtzrtjtnjhz.supabase.co"  # os.environ.get("SUPABASE_URL")
SUPABASE_KEY = "sb_publishable_3N6ZDr39KJ9IkQBXYqPLVg_4zVTSohb"  # os.environ.get("SUPABASE_KEY")

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
