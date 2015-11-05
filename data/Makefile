include config.mk

all : accused.table officers.table complaints.table ipra_employees.table police_employees.table complainants.table

accused.table : officers.table unnormalized_accused.table
	psql -d complaints -c "CREATE TABLE accused AS SELECT complaint_id, officer_id, complaint, recommended_finding, recommended_discipline, final_finding, final_discipline FROM unnormalized_accused INNER JOIN officers USING (officer_name, date_of_appointment, star)"
	psql -d complaints -c "DROP TABLE unnormalized_accused"

officers.table : unnormalized_accused.table
	psql -d complaints -c "CREATE TABLE officers AS SELECT DISTINCT officer_name, star, date_of_appointment, race, gender, current_rank, current_unit FROM unnormalized_accused"
	psql -d complaints -c "ALTER TABLE officers ADD COLUMN officer_id SERIAL PRIMARY KEY"

complainants.table : complainants.csv
	csvsql --db "postgresql://$(PG_USER):$(PG_PASS)@$(PG_HOST):$(PG_PORT)/$(PG_DB)" \
	-y 1000 --no-inference --tables complainants --insert $< 
	psql -d complaints -c "ALTER TABLE complainants ADD COLUMN complainant_id SERIAL PRIMARY KEY"

%.table : %.csv
	csvsql --db "postgresql://$(PG_USER):$(PG_PASS)@$(PG_HOST):$(PG_PORT)/$(PG_DB)" \
	-y 1000 --no-inference --tables $* --insert $< 

.INTERMEDIATE : 4a.csv 4b.csv 4c.csv 4d.csv 4e.csv 4f.csv 4g.csv 4h.csv
complainants.csv : 4a.csv 4b.csv 4c.csv 4d.csv 4e.csv 4f.csv 4g.csv 4h.csv
	csvstack $^ > $@

.INTERMEDIATE : 2a.csv 2b.csv 2c.csv 2d.csv 2e.csv 2f.csv 2g.csv 2h.csv
unnormalized_accused.csv : 2a.csv 2b.csv 2c.csv 2d.csv 2e.csv 2f.csv 2g.csv 2h.csv
	csvstack $^ > $@

.INTERMEDIATE : 1a.csv 1b.csv 1c.csv 1d.csv 1e.csv 1f.csv 1g.csv 1h.csv
complaints.csv : 1a.csv 1b.csv 1c.csv 1d.csv 1e.csv 1f.csv 1g.csv 1h.csv
	csvstack $^ > $@


%.xls :
	unzip -p "Four Years of Complaint Data.zip" "*foia 14-5509 - report $**" > $@

4%.csv : 4%.xls
	in2csv $< | python ../scripts/complainants.py > $@

2%.csv : 2%.xls
	in2csv $< | python ../scripts/accused.py > $@

1%.csv : 1%.xls
	in2csv $< | python ../scripts/complaint.py > $@

.INTERMEDIATE : ipra_employees.csv
ipra_employees.csv : Current_Employee_Names__Salaries__and_Position_Titles.csv
	cat $< | python ../scripts/ipra.py > $@

.table : police_employees.csv
police_employees.csv : position_span.csv
	cat $< | python ../scripts/positions.py > $@
