from utils.preprocessing import (
    create_dataframe,
    apply_mappings,
    encode_categories,
    align_columns
)

from utils.prediction import predict_employee_risk

from utils.recommendation import (
    get_risk_level,
    get_recommendation
)

from utils.explainability import get_employee_drivers


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


# -------------------------
# Preprocessing
# -------------------------

df = create_dataframe(sample_input)

df = apply_mappings(df)

df = encode_categories(df)

df = align_columns(df)


# -------------------------
# Prediction
# -------------------------

prediction, confidence = predict_employee_risk(df)


# -------------------------
# Recommendation
# -------------------------

risk = get_risk_level(prediction)

recommendation = get_recommendation(risk)


# -------------------------
# Explainability
# -------------------------

drivers = get_employee_drivers(df)


# -------------------------
# Final Output
# -------------------------

print("AI Workforce Risk Assessment")
print("---------------------------")

print("Risk Level:", risk)

print("Confidence:", round(confidence * 100, 2), "%")

print("\nRecommendation:")
print(recommendation)

print("\nKey Risk Drivers")
print("----------------")

print(drivers)