import fileinput
import csv
import datetime
import sys
from collections import defaultdict, OrderedDict

def excelDate(epoch) :
    return datetime.date(1899,12,30) + datetime.timedelta(days=int(epoch))

complaints = []

columns = (('complaint_id', 0),
           ('beat', 2),
           ('location_code', 3),
           ('address_number', 4),
           ('address_street', 5),
           ('city_state_zip', 7),
           ('incident_date', 9),
           ('start_date', 10),
           ('end_date', 11))


reader = csv.reader(fileinput.input())

for _ in range(21) :
    reader.next()

for row in reader :
    if any(row) :
        if row[0] :
            complaint = OrderedDict((key, row[position])
                                    for key, position 
                                    in columns)

            if complaint['address_number'] == '----' :
                complaint['address_number'] = ''
            if complaint['address_street'] == '-----' :
                complaint['address_street'] = ''
            if complaint['city_state_zip'] == '-----' :
                complaint['city_state_zip'] = ''
            if complaint['start_date'] :
                complaint['start_date'] = excelDate(float(complaint['start_date']))
            if complaint['end_date'] :
                complaint['end_date'] = excelDate(float(complaint['end_date']))

        elif row[11] :
            complaint['investigator'] = row[11]
            complaints.append(complaint)

header = complaints[0].keys()

writer = csv.writer(sys.stdout)
writer.writerow(header)
for complaint in complaints :
    writer.writerow(complaint.values())
        
