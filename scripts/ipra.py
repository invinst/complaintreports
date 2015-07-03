import fileinput
import csv
import sys

reader = csv.reader(fileinput.input())
writer = csv.writer(sys.stdout)

writer.writerow([header.lower() for header in reader.next()])

for row in reader :
    name = row[0]
    name = name.split()
    if len(name[-1]) == 1 :
        name = name[:-1]
    name = [each.replace("'", ' ').strip() for each in name]
    name = ' '.join(name)
    if name == 'NEAL, WILBERT' :
        name = 'NEAL JR, WILBERT'
    if name == 'PRIETO, DENNIS' :
        name = 'PRIETO JR, DENNIS'
    row[0] = name
    writer.writerow(row)
        
additional_investigators = ["HERNANDEZ, NEOMI",
                            "CURETON, PAMELA",
                            "GALINDO, MARGARITA",
                            "FLEMING, BRIAN",
                            "WILLIAMS, ONETTA",
                            "DUFFY, MICHAEL",
                            "WALSH, WILLIAM"]
                            
for investigator in additional_investigators :
    writer.writerow([investigator])
