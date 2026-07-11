import streamlit as st

from utils.database import get_employee_by_id
from utils.formatter import employee_to_input
from utils.assessment import assess_employee

st.set_page_config(
    page_title="AI Workforce Risk Assessment System",
    page_icon="🤖",
    layout="wide"
)

if "new_employee" not in st.session_state:
    st.session_state["new_employee"] = None

if "assessment_result" not in st.session_state:
    st.session_state["assessment_result"] = None

st.sidebar.title("Navigation")

page = st.sidebar.radio(
    "Go to",
    [
        "Home",
        "Existing Employee",
        "New Employee",
        "About Project"
    ]
)

if page == "Home":

    st.title("AI Workforce Risk Assessment System")

    st.subheader(
        "AI-powered employee layoff risk prediction and HR intervention platform"
    )

    st.write(
        """
        This application uses analytics and machine learning
        to assess workforce transition risk and provide
        actionable HR recommendations.
        """
    )

    st.divider()

    st.subheader("Project Pipeline")

    st.write(
        """
        Excel → PostgreSQL → SQL Analysis → Power BI 
        → Machine Learning → Streamlit Application
        """
    )

    st.divider()

    col1, col2, col3 = st.columns(3)

    with col1:
        st.metric(
            "Model",
            "Random Forest"
        )

    with col2:
        st.metric(
            "Accuracy",
            "88.5%"
        )

    with col3:
        st.metric(
            "Features",
            "43"
        )
    
    st.info(
        """
        Use the sidebar to assess existing employees,
        evaluate new employee profiles, and explore
        project details.
        """
    )


elif page == "Existing Employee":

    st.header("Existing Employee Risk Assessment")

    emp_id = st.number_input(
        "Enter Employee ID",
        min_value=1,
        step=1
    )


    if st.button("Assess Employee"):

        employee = get_employee_by_id(emp_id)


        if employee.empty:

            st.error("Employee not found.")


        else:

            employee_input = employee_to_input(employee)

            result = assess_employee(employee_input)

            st.success(
                f"Employee {emp_id} found. Assessment completed successfully."
            )

            # ==========================================
            # Employee Profile
            # ==========================================

            st.subheader("Employee Profile")

            col1, col2, col3 = st.columns(3)

            with col1:
                st.metric(
                    "Employee ID",
                    int(employee["emp_id"].iloc[0])
                )

                st.metric(
                    "Education",
                    employee["edu_level"].iloc[0]
                )

            with col2:
                st.metric(
                    "Industry",
                    employee["industry_name"].iloc[0]
             )

                st.metric(
                    "Company Size",
                    employee["company_size_name"].iloc[0]
                )

            with col3:
                st.metric(
                    "Role",
                    employee["role_name"].iloc[0]
                )

                st.metric(
                    "Job Level",
                    employee["job_level_name"].iloc[0]
                )

            st.divider()

    # ==========================================
    # Risk Assessment
    # ==========================================

            st.subheader("Risk Assessment")

            col1, col2 = st.columns(2)

            with col1:
                st.metric(
                    "Risk Level",
                    result["risk_level"]
             )

            with col2:
             st.metric(
                    "Confidence",
                    f"{result['confidence']*100:.2f}%"
                )

            st.divider()

    # ==========================================
    # Risk Probability Distribution
    # ==========================================

            st.subheader("Risk Probability Distribution")

            st.write(f"🟢 Low Risk: **{result['probabilities'][0]*100:.2f}%**")

            st.progress(float(result["probabilities"][0]))

            st.write(f"🟡 Medium Risk: **{result['probabilities'][1]*100:.2f}%**")

            st.progress(float(result["probabilities"][1]))

            st.write(f"🔴 High Risk: **{result['probabilities'][2]*100:.2f}%**")

            st.progress(float(result["probabilities"][2]))

            st.divider()

    # ==========================================
    # Recommendation
    # ==========================================

            st.subheader("HR Recommendation")

            st.info(
             result["recommendation"]
            )

            st.divider()

    # ==========================================
    # Explainability
    # ==========================================

            st.subheader("Key Risk Drivers")

            st.dataframe(
                result["drivers"],
                use_container_width=True,
             hide_index=True
            )

elif page == "New Employee":

    st.title("New Employee Assessment")

    st.write(
        """
        Create a new employee profile and assess
        the employee's layoff risk using the trained
        AI prediction model.
        """
    )

    st.divider()

    st.subheader("Employee Information")

    col1, col2 = st.columns(2)

    with col1:

        education = st.selectbox(
            "Education",
            [
                "High School",
                "Bachelor's",
                "Master's",
                "PhD"
            ]
        )

        company_size = st.selectbox(
            "Company Size",
            [
                "Small",
                "Medium",
                "Large"
            ]
        )

        job_level = st.selectbox(
            "Job Level",
            [
                "Entry",
                "Mid",
                "Senior"
            ]
        )

        industry = st.selectbox(
            "Industry",
            [
                "Education",
                "Finance",
                "Healthcare",
                "Manufacturing",
                "Retail",
                "Technology"
            ]
        )

    with col2:

        role = st.selectbox(
            "Role",
            [
                "Customer Support",
                "Data Analyst",
                "Finance Manager",
                "HR Manager",
                "Marketing Specialist",
                "Operations Manager",
                "Product Manager",
                "Sales Executive",
                "Software Engineer",
                "Teacher"
            ]
        )

        ai_level = st.selectbox(
            "AI Adoption Level",
            [
                "Low",
                "Medium",
                "High"
            ]
        )

        creativity = st.selectbox(
            "Creativity Requirement",
            [
                "Low",
                "Medium",
                "High"
            ]
        )

        interaction = st.selectbox(
            "Human Interaction Level",
            [
                "Low",
                "Medium",
                "High"
            ]
        )

    st.divider()

    # ==========================================
    # Add Employee
    # ==========================================

    if st.button("➕ Add Employee"):

        employee_input = {

            "edu_level": education,
            "company_size_name": company_size,
            "job_level_name": job_level,
            "industry_name": industry,
            "role_name": role,
            "ai_adoption_level": ai_level,
            "creativity_requirement": creativity,
            "human_interaction_level": interaction

        }

        st.session_state["new_employee"] = employee_input
        st.session_state["assessment_result"] = None

        st.success("Employee profile created successfully.")

        st.info(
            """
            The employee has not yet been assessed.

            Click **Assess Employee** below to generate
            an AI-powered layoff risk prediction.
            """
        )

    # ==========================================
    # Assess Employee
    # ==========================================

    if st.session_state.get("new_employee") is not None:

        if st.button("🤖 Assess Employee"):

            employee = st.session_state["new_employee"]

            st.session_state["assessment_result"] = assess_employee(employee)

    # ==========================================
    # Display Results
    # ==========================================

    if st.session_state.get("assessment_result") is not None:

        employee = st.session_state["new_employee"]
        result = st.session_state["assessment_result"]

        st.success("Employee assessment completed successfully.")

        st.divider()

        st.subheader("Employee Profile Summary")

        col1, col2, col3 = st.columns(3)

        with col1:

            st.metric(
                "Education",
                employee["edu_level"]
            )

            st.metric(
                "Company Size",
                employee["company_size_name"]
            )

        with col2:

            st.metric(
                "Industry",
                employee["industry_name"]
            )

            st.metric(
                "Job Level",
                employee["job_level_name"]
            )

        with col3:

            st.metric(
                "Role",
                employee["role_name"]
            )

            st.metric(
                "AI Adoption",
                employee["ai_adoption_level"]
            )

        st.divider()

        st.subheader("Risk Assessment")

        col1, col2 = st.columns(2)

        with col1:

            st.metric(
                "Risk Level",
                result["risk_level"]
            )

        with col2:

            st.metric(
                "Confidence",
                f"{result['confidence']*100:.2f}%"
            )

        st.divider()

        st.subheader("Risk Probability Distribution")

        st.write(
            f"🟢 Low Risk: **{result['probabilities'][0]*100:.2f}%**"
        )
        st.progress(float(result["probabilities"][0]))

        st.write(
            f"🟡 Medium Risk: **{result['probabilities'][1]*100:.2f}%**"
        )
        st.progress(float(result["probabilities"][1]))

        st.write(
            f"🔴 High Risk: **{result['probabilities'][2]*100:.2f}%**"
        )
        st.progress(float(result["probabilities"][2]))

        st.divider()

        st.subheader("HR Recommendation")

        st.info(
            result["recommendation"]
        )

        st.divider()

        st.subheader("Key Risk Drivers")

        st.dataframe(
            result["drivers"],
            use_container_width=True,
            hide_index=True
        )


elif page == "About Project":

    st.title("About Project")

    st.subheader("Business Problem")

    st.write(
        """
        Organizations are facing workforce disruption due to
        automation and AI adoption. Identifying employees who
        may face higher transition risk can help HR teams
        design proactive intervention strategies.
        """
    )

    st.divider()

    st.subheader("Objective")

    st.write(
        """
        The objective of this system is to predict employee
        layoff risk while providing explainable insights and
        HR recommendations.
        """
    )

    st.divider()

    st.subheader("Technology Stack")

    st.write(
        """
        - Excel: Initial data inspection
        - PostgreSQL: Database management and SQL analysis
        - Power BI: Interactive analytics dashboard
        - Python: Data processing and machine learning
        - Random Forest: Risk prediction model
        - Streamlit: Application deployment
        """
    )

    st.divider()

    st.subheader("Machine Learning Model")

    st.write(
        """
        The prediction engine uses a Random Forest Classifier.
        The model evaluates employee attributes and predicts
        three risk categories:

        - Low Risk
        - Medium Risk
        - High Risk
        """
    )

    st.divider()

    st.subheader("System Architecture")

    st.code(
        """
Employee Data
      |
      ↓
Data Processing
      |
      ↓
Feature Engineering
      |
      ↓
Random Forest Model
      |
      ↓
Risk Prediction
      |
      ↓
HR Recommendation
        """
    )

