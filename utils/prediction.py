import joblib

from pathlib import Path


# ==========================
# Load Trained Model
# ==========================

MODEL_DIR = Path(__file__).resolve().parent.parent / "model"

model = joblib.load(
    MODEL_DIR / "model.pkl"
)


# ==========================
# Prediction
# ==========================

def predict_employee_risk(processed_df):
    """
    Predict layoff risk from a preprocessed DataFrame.
    """

    prediction = model.predict(processed_df)[0]

    probabilities = model.predict_proba(processed_df)[0]

    confidence = max(probabilities)

    return prediction, confidence, probabilities