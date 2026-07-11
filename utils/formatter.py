def employee_to_input(employee_df):

    employee = employee_df.iloc[0]

    input_data = {

        "edu_level": employee["edu_level"],
        "company_size_name": employee["company_size_name"],
        "job_level_name": employee["job_level_name"],

        "ai_adoption_level": employee["ai_adoption_level"],
        "creativity_requirement": employee["creativity_requirement"],
        "human_interaction_level": employee["human_interaction_level"],

        "industry_name": employee["industry_name"],
        "role_name": employee["role_name"]
    }

    return input_data