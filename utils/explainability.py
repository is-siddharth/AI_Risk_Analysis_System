import joblib
import pandas as pd

from pathlib import Path


# =====================================================
# Load Model Artifacts
# =====================================================

MODEL_DIR = Path(__file__).resolve().parent.parent / "model"

model = joblib.load(
    MODEL_DIR / "model.pkl"
)

feature_columns = joblib.load(
    MODEL_DIR / "columns.pkl"
)


# =====================================================
# Feature Labels
# =====================================================

FEATURE_LABELS = {

    "ai_adoption_level": "AI Adoption Level",

    "company_size_name": "Company Size",

    "job_level_name": "Job Level",

    "creativity_requirement": "Creativity Requirement",

    "human_interaction_level": "Human Interaction Level"

}


# =====================================================
# Reverse Mappings
# =====================================================

REVERSE_MAPPINGS = {

    "edu_level": {
        0: "High School",
        1: "Bachelor's",
        2: "Master's",
        3: "PhD"
    },

    "company_size_name": {
        0: "Small",
        1: "Medium",
        2: "Large"
    },

    "job_level_name": {
        0: "Entry",
        1: "Mid",
        2: "Senior"
    },

    "ai_adoption_level": {
        0: "Low",
        1: "Medium",
        2: "High"
    },

    "creativity_requirement": {
        0: "Low",
        1: "Medium",
        2: "High"
    },

    "human_interaction_level": {
        0: "Low",
        1: "Medium",
        2: "High"
    }

}


# =====================================================
# Helper Functions
# =====================================================

def clean_feature_name(feature):
    """
    Convert technical feature names into
    business-friendly labels.
    """

    if feature in FEATURE_LABELS:
        return FEATURE_LABELS[feature]

    return feature.replace("_", " ").title()


def decode_value(row):
    """
    Convert encoded numerical values back
    into business-friendly labels.
    """

    feature = row["feature"]
    value = row["value"]

    if feature in REVERSE_MAPPINGS:
        return REVERSE_MAPPINGS[feature].get(value, value)

    return value


# =====================================================
# Global Feature Importance
# =====================================================

def get_feature_importance():
    """
    Return the global feature importance
    of the trained Random Forest model.
    """

    importance_df = pd.DataFrame({

        "feature": feature_columns,
        "importance": model.feature_importances_

    })

    importance_df = importance_df.sort_values(
        by="importance",
        ascending=False
    )

    importance_df["feature_name"] = (
        importance_df["feature"]
        .apply(clean_feature_name)
    )

    return importance_df[
        [
            "feature_name",
            "importance"
        ]
    ]


# =====================================================
# Employee Risk Drivers
# =====================================================

def get_employee_drivers(employee_df):
    """
    Return the Top 5 features contributing
    to an employee's predicted layoff risk.
    """

    driver_df = pd.DataFrame({

        "feature": feature_columns,

        "importance": model.feature_importances_,

        "value": employee_df.iloc[0].values

    })

    driver_df["display_value"] = (
        driver_df.apply(
            decode_value,
            axis=1
        )
    )

    driver_df["impact"] = (
        driver_df["importance"] *
        driver_df["value"].abs()
    )

    driver_df["impact_percentage"] = (
        driver_df["impact"] * 100
    )

    driver_df = driver_df.sort_values(
        by="impact",
        ascending=False
    )

    driver_df["feature_name"] = (
        driver_df["feature"]
        .apply(clean_feature_name)
    )

    return driver_df[
    [
        "feature_name",
        "display_value",
        "impact_percentage"
    ]
    ].head(5)