import fileinput
import csv
import sys
from collections import defaultdict, OrderedDict

complainants = defaultdict(list)

columns = (('gender', 4),
           ('race', 7))

reader = csv.reader(fileinput.input())

for _ in range(20) :
    reader.next()

for row in reader :
    if any(row) :
        if row[0] :
            complaint_id = row[2]
        elif 'end of record' not in row :
            complainant = OrderedDict((key, row[position])
                                      for key, position 
                                      in columns)
            complainants[complaint_id].append(complainant)

header = ['complaint_id']
header += complainants.values()[0][0].keys()

writer = csv.writer(sys.stdout)
writer.writerow(header)
for complaint_id, officers in complainants.items() :
    for officer in officers :
        row = officer.values()
        row.insert(0, complaint_id)
        writer.writerow(row)
        
