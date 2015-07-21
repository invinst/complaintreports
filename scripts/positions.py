import fileinput
import csv
import sys

reader = csv.reader(fileinput.input())
writer = csv.writer(sys.stdout)

writer.writerow([header.lower() for header in reader.next()])

for row in reader :
    name = row[1]
    name = name.split()
    if len(name[-1]) == 1 :
        name = name[:-1]
    name = [each.replace("'", ' ').strip() for each in name]
    name = ' '.join(name)
    row[1] = name
    writer.writerow(row)
        
