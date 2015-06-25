import fileinput
import csv
import datetime
import sys
from collections import defaultdict, OrderedDict

def excelDate(epoch) :
    return datetime.date(1899,12,30) + datetime.timedelta(days=int(epoch))

complaints = defaultdict(list)

columns = (('officer_name', 4), 
           ('gender', 9),
           ('race', 13),
           ('date_of_appointment', 15),
           ('current_unit', 17),
           ('current_rank',20),
           ('star', 24),
           ('complaint', 26),
           ('recommended_finding', 31),
           ('recommended_discipline', 33),
           ('final_finding', 37),
           ('final_discipline', 39))

reader = csv.reader(fileinput.input())

for _ in range(17) :
    reader.next()

for row in reader :
    if any(row) :
        if row[0] :
            complaint_id = row[0]
        elif 'end of record' not in row :
            accused = OrderedDict((key, row[position])
                                  for key, position 
                                  in columns)
            if accused['date_of_appointment'] :
                accused['date_of_appointment'] = excelDate(float(accused['date_of_appointment']))
            if accused['star'] :
                accused['star'] = int(float(accused['star']))
            if accused['current_unit'] :
                accused['current_unit'] = int(float(accused['current_unit']))


            complaints[complaint_id].append(accused)

header = ['complaint_id']
header += complaints.values()[0][0].keys()

writer = csv.writer(sys.stdout)
writer.writerow(header)
for complaint_id, officers in complaints.items() :
    for officer in officers :
        row = officer.values()
        row.insert(0, complaint_id)
        writer.writerow(row)
        
