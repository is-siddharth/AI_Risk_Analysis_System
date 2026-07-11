from utils.database import get_employee_by_id
from utils.formatter import employee_to_input
from utils.assessment import assess_employee


employee = get_employee_by_id(1)

employee_input = employee_to_input(employee)

result = assess_employee(employee_input)

print(result)