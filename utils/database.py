import psycopg2
import pandas as pd


def create_connection():

    connection = psycopg2.connect(
        host="localhost",
        database="ai_workforce_intervention",
        user="postgres",
        password="312003",
        port="5432"
    )

    return connection



def get_employee_by_id(emp_id):

    connection = create_connection()

    query = """
    SELECT *
    FROM AI_Workforce.Reporting_View
    WHERE EMP_ID = %s;
    """

    df = pd.read_sql(
        query,
        connection,
        params=(emp_id,)
    )

    connection.close()

    return df

if __name__ == "__main__":

    employee = get_employee_by_id(1)

    print(employee)