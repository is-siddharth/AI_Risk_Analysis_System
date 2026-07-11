from utils.database import get_employee_by_id
from utils.formatter import employee_to_input


employee = get_employee_by_id(1)

data = employee_to_input(employee)

print(data)