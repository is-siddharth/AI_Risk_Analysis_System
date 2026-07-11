# ==========================
# Risk Information
# ==========================

RISK_INFO = {

    0: {
        "level": "Low",
        "recommendation": (
            "Continue employee development and maintain regular engagement."
        )
    },

    1: {
        "level": "Medium",
        "recommendation": (
            "Monitor employee engagement and consider targeted training opportunities."
        )
    },

    2: {
        "level": "High",
        "recommendation": (
            "Initiate retention discussion and create a personalized intervention plan."
        )
    }

}


# ==========================
# Get Risk Information
# ==========================

def get_risk_info(prediction):
    """
    Returns the risk level and HR recommendation
    for the predicted class.
    """
    return RISK_INFO[prediction]


# ==========================
# Testing
# ==========================

if __name__ == "__main__":

    prediction = 2

    result = get_risk_info(prediction)

    print(f"Prediction : {prediction}")
    print(f"Risk Level : {result['level']}")
    print(f"Recommendation : {result['recommendation']}")