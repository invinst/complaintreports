include config.mk

all : accused.table officers.table complaints.table

accused.table : officers.table unnormalized_accused.table
	psql -d complaints -c "CREATE TABLE accused AS SELECT complaint_id, officer_id, current_unit, current_rank, complaint, recommended_finding, recommended_discipline, final_finding, final_discipline FROM unnormalized_accused INNER JOIN officers USING (officer_name, date_of_appointment, star)"
	psql -d complaints -c "DROP TABLE unnormalized_accused"

officers.table : unnormalized_accused.table
	psql -d complaints -c "CREATE TABLE officers AS SELECT DISTINCT officer_name, star, date_of_appointment, race, gender FROM unnormalized_accused"
	psql -d complaints -c "ALTER TABLE officers ADD COLUMN officer_id SERIAL PRIMARY KEY"

%.table : %.csv
	csvsql --db "postgresql://$(PG_USER):$(PG_PASS)@$(PG_HOST):$(PG_PORT)/$(PG_DB)" \
	-y 1000 --tables $* --insert $< 

.INTERMEDIATE : 2a.csv 2b.csv 2c.csv 2d.csv 2e.csv 2f.csv 2g.csv 2h.csv
unnormalized_accused.csv : 2a.csv 2b.csv 2c.csv 2d.csv 2e.csv 2f.csv 2g.csv 2h.csv
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


