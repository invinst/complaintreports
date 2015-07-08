include config.mk

all : accused.table officers.table complaints.table complaint_types.table ipra_employees.table employment_history.table

accused.table : officers.table unnormalized_accused.table
	psql -d complaints -c "CREATE TABLE accused AS SELECT complaint_id, officer_id, complaint, recommended_finding, recommended_discipline, final_finding, final_discipline FROM unnormalized_accused INNER JOIN officers USING (officer_name, date_of_appointment, star)"
	psql -d complaints -c "DROP TABLE unnormalized_accused"

officers.table : unnormalized_accused.table
	psql -d complaints -c "CREATE TABLE officers AS SELECT DISTINCT officer_name, star, date_of_appointment, race, gender, current_rank, current_unit FROM unnormalized_accused"
	psql -d complaints -c "ALTER TABLE officers ADD COLUMN officer_id SERIAL PRIMARY KEY"

%.table : %.csv
	csvsql --db "postgresql://$(PG_USER):$(PG_PASS)@$(PG_HOST):$(PG_PORT)/$(PG_DB)" \
	-y 1000 --no-inference --tables $* --insert $< 

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

.INTERMEDIATE : ipra_employees.csv
ipra_employees.csv : Current_Employee_Names__Salaries__and_Position_Titles.csv
	cat $< | python scripts/ipra.py > $@

%_staffing.csv :
	wget -O $@ "https://data.cityofchicago.org/resource/$(word 1, $(subst _, ,$@)).csv?department=POLICE&\$$where=starts_with(job_titles, 'POLICE OFFICER') OR starts_with(job_titles, 'SERGEANT') OR starts_with(job_titles, 'LIEUTENANT') OR starts_with(job_titles, 'CAPTAIN') OR job_titles = 'CHIEF' OR job_titles = 'DEPUTY CHIEF' OR job_titles = 'SUPERINTENDENT' OR job_titles = 'FIRST DEPUTY SUPERINTENDENT' OR starts_with(job_titles, 'COMMANDER')&\$$limit=15000"

.INTERMEDIATE : 8c7s-25ji_staffing.csv 2014_staffing.csv
2014_staffing.csv : 8c7s-25ji_staffing.csv 
	python scripts/rank.py $< > $@

.INTERMEDIATE : 4pid-t6mp_staffing.csv 2013_staffing.csv
2013_staffing.csv : 4pid-t6mp_staffing.csv 
	python scripts/rank.py $< > $@

.INTERMEDIATE : vpki-baq8_staffing.csv 2012_staffing.csv 
2012_staffing.csv : vpki-baq8_staffing.csv
	python scripts/rank.py $< > $@

employment_history.table : 2014_staffing.table 2013_staffing.table 2012_staffing.table


