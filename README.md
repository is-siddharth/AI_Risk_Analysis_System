# 🤖 AI Workforce Risk Assessment System

A production-ready Streamlit application that predicts employee layoff risk using Machine Learning and provides explainable HR intervention recommendations.

This application is the deployment version of my flagship end-to-end Data Analytics & Machine Learning project, **AI Workforce Layoff Risk Analytics & Prediction System**.

## 🚀 Features

- Assess existing employees using Employee ID
- Evaluate new employee profiles
- Layoff risk prediction using Random Forest Classifier
- Prediction confidence score
- Risk probability distribution
- Explainable AI with key risk drivers
- HR intervention recommendations
- Interactive Streamlit interface

## 🛠 Tech Stack

- Python
- Streamlit
- Pandas
- Scikit-learn
- Joblib
- PostgreSQL
- Random Forest Classifier

## 📂 Project Structure

```
AI-Workforce_Risk_System/

│
├── app.py
│
├── model/
│   ├── model.pkl
│   ├── columns.pkl
│   └── mappings.pkl
│
├── utils/
│   ├── assessment.py
│   ├── database.py
│   ├── explainability.py
│   ├── formatter.py
│   ├── prediction.py
│   ├── preprocessing.py
│   └── recommendation.py
│
├── notebook/
│
├── assets/
│
├── requirements.txt
│
└── README.md
```

## 🧠 Machine Learning Model

- Algorithm: Random Forest Classifier
- Prediction Classes:
  - Low Risk
  - Medium Risk
  - High Risk
- Model Accuracy: **88.5%**

The prediction pipeline includes:

- Data preprocessing
- Ordinal encoding
- One-Hot Encoding
- Feature alignment
- Probability prediction
- Explainable feature importance

## 📊 Application Workflow

```
Employee Information
        │
        ▼
Data Preprocessing
        │
        ▼
Machine Learning Model
        │
        ▼
Risk Prediction
        │
        ▼
Probability Scores
        │
        ▼
HR Recommendation
        │
        ▼
Key Risk Drivers
```

## 💼 Business Problem

Organizations are increasingly adopting AI and automation, making workforce planning more important than ever.

This application helps HR teams identify employees who may be at greater risk of workforce transition and provides actionable recommendations to support proactive decision-making.

## 📌 Current Capabilities

- Existing Employee Assessment
- New Employee Assessment
- Risk Classification
- Prediction Confidence
- Explainable AI
- HR Recommendations
- Interactive Dashboard

## 🔮 Future Improvements

- PostgreSQL integration for adding new employees
- Interactive visualizations
- Risk trend dashboards
- Authentication & user management
- Streamlit Community Cloud deployment
- Docker support
- CI/CD pipeline


## 👨‍💻 Author

**Siddharth Rana**

Aspiring Data Analyst | Business Intelligence Developer | Machine Learning Enthusiast


## ⭐ If you found this project interesting, consider giving it a star!