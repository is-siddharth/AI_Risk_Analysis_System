import joblib
import pandas as pd

from pathlib import Path


# ==========================
# Load Saved Artifacts
# ==========================

MODEL_DIR = Path(__file__).resolve().parent.parent / "model"

mappings = joblib.load(MODEL_DIR / "mappings.pkl")
feature_columns = joblib.load(MODEL_DIR / "columns.pkl")


# ==========================
# Create DataFrame
# ==========================

def create_dataframe(user_input):
    """
    Convert user input dictionary into a one-row DataFrame.
    """
    return pd.DataFrame([user_input])


# ==========================
# Apply Ordinal Mappings
# ==========================

def apply_mappings(df):

    df["edu_level"] = df["edu_level"].map(
        mappings["education_mapping"]
    )

    df["company_size_name"] = df["company_size_name"].map(
        mappings["company_mapping"]
    )

    df["job_level_name"] = df["job_level_name"].map(
        mappings["job_level_mapping"]
    )

    df["ai_adoption_level"] = df["ai_adoption_level"].map(
        mappings["level_mapping"]
    )

    df["creativity_requirement"] = df["creativity_requirement"].map(
        mappings["level_mapping"]
    )

    df["human_interaction_level"] = df["human_interaction_level"].map(
        mappings["level_mapping"]
    )

    return df


# ==========================
# One-Hot Encoding
# ==========================

def encode_categories(df):

    df = pd.get_dummies(
        df,
        columns=[
            "industry_name",
            "role_name"
        ],
        drop_first=True
    )

    return df


# ==========================
# Align Feature Columns
# ==========================

def align_columns(df):

    df = df.reindex(
        columns=feature_columns,
        fill_value=0
    )

    return df


# ==========================
# Complete Preprocessing Pipeline
# ==========================

def preprocess_input(user_input):

    df = create_dataframe(user_input)

    df = apply_mappings(df)

    df = encode_categories(df)

    df = align_columns(df)

    return df


# ==========================
# Testing
# ==========================

if __name__ == "__main__":

    sample_input = {

        "edu_level": "Master's",
        "company_size_name": "Large",
        "job_level_name": "Senior",

        "ai_adoption_level": "High",
        "creativity_requirement": "Medium",
        "human_interaction_level": "Low",

        "industry_name": "Technology",
        "role_name": "Data Analyst"
    }

    processed_df = preprocess_input(sample_input)

    print(processed_df.shape)
    print(processed_df.columns.tolist())