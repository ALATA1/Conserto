from robot.api import ExecutionResult
result = ExecutionResult('output.xml')
stats = result.statistics
print(f"Number of Failed Tests: {stats.total.failed}")
print(f"Total number of Tests: {stats.total.passed}")