include config.mk

all : accused.table complaints.table

%.table : %.csv
	csvsql --db "postgresql://$(PG_USER):$(PG_PASS)@$(PG_HOST):$(PG_PORT)/$(PG_DB)" \
	-y 1000 --tables $* --insert $< 

.INTERMEDIATE : 2a.csv 2b.csv 2c.csv 2d.csv 2e.csv 2f.csv 2g.csv 2h.csv
accused.csv : 2a.csv 2b.csv 2c.csv 2d.csv 2e.csv 2f.csv 2g.csv 2h.csv
	csvstack $^ > $@

.INTERMEDIATE : 1a.csv 1b.csv 1c.csv 1d.csv 1e.csv 1f.csv 1g.csv 1h.csv
complaints.csv : 1a.csv 1b.csv 1c.csv 1d.csv 1e.csv 1f.csv 1g.csv 1h.csv
	csvstack $^ > $@


%.xls :
	unzip -p "Four Years of Complaint Data.zip" "*foia 14-5509 - report $**" > $@

2%.csv : 2%.xls
	in2csv $< | python scripts/accused.py > $@

1%.csv : 1%.xls
	in2csv $< | python scripts/complaint.py > $@


