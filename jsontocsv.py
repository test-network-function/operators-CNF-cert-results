import csv
import json

# Load the JSON data
with open('merged-certified-results-august.json', 'r') as f:
    data = json.load(f)

rows = []
for item in data:
    for key, value in item['results'].items():
        for test in value:
            row = {'Operator': item['Operator'], 'TestName': test['testID']['id'], 'TestSuite':test['testID']['suite'],'State': test['state'],'Reason': test['failureReason'], 'CategoryClassification': test['categoryClassification']}
            rows.append(row)

with open('certified-operators-august.csv', 'w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=['Operator', 'TestName', 'TestSuite','State', 'CategoryClassification','Reason'])
    writer.writeheader()
    writer.writerows(rows)

