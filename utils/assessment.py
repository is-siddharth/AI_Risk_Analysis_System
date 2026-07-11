from utils.preprocessing import preprocess_input
from utils.prediction import predict_employee_risk
from utils.recommendation import get_risk_info
from utils.explainability import get_employee_drivers


# ==========================
# Complete Employee Assessment
# ==========================

def assess_employee(employee_input):
    """
    Run the complete employee assessment pipeline.
    """

    # Preprocess input
    processed_df = preprocess_input(employee_input)

    # Predict layoff risk
    prediction, confidence, probabilities = predict_employee_risk(processed_df)

    # Get business interpretation
    risk_info = get_risk_info(prediction)

    # Get key risk drivers
    drivers = get_employee_drivers(processed_df)

    # Return complete assessment
    return {

        "prediction": prediction,

        "risk_level": risk_info["level"],

        "confidence": confidence,

        "probabilities": probabilities,

        "recommendation": risk_info["recommendation"],

        "drivers": drivers
    }