all : sustained_by_race.csv complaints_by_race.csv number_complaints.csv \
	number_complaints_rolled.csv

sustained_by_race.csv :
	psql -d complaints -c " \
	COPY (SELECT race, COUNT(complainant_id) \
	      FROM (SELECT distinct race, complainant_id \
                    FROM complainants INNER JOIN accused \
                    USING (complaint_id) \
                    WHERE complaint IN ('01B', '05A', '05B', '05C', \
                                        '05D', '05F', '05G', '05H', \
                                        '05J', '05K', '05L', '05M', \
                                        '05N', '05P', '05Q', '03A', \
                                        '03B', '03C', '03D', '03E', \
                                        '03F', '03G', '04A', '04B', \
                                        '04C', '04D', '04E', '04F', \
                                        '04G', '04H', '04J') \
                    AND final_finding = 'SU') AS _ \
               GROUP BY race) \
         TO STDOUT WITH CSV HEADER" > $@

complaints_by_race.csv :
	psql -d complaints -c " \
	COPY (SELECT race, COUNT(complainant_id) \
	      FROM (SELECT distinct race, complainant_id \
                    FROM complainants INNER JOIN accused \
                    USING (complaint_id) \
                    WHERE complaint IN ('01B', '05A', '05B', '05C', \
                                        '05D', '05F', '05G', '05H', \
                                        '05J', '05K', '05L', '05M', \
                                        '05N', '05P', '05Q', '03A', \
                                        '03B', '03C', '03D', '03E', \
                                        '03F', '03G', '04A', '04B', \
                                        '04C', '04D', '04E', '04F', \
                                        '04G', '04H', '04J') \
                    ) AS _ \
               GROUP BY race) \
         TO STDOUT WITH CSV HEADER" > $@

number_complaints_rolled.csv :
	psql -d complaints -c " \
	COPY (SELECT complaint_count, COUNT(*) \
	      FROM (SELECT officer_id, COUNT(*) AS complaint_count \
                    FROM accused \
                    WHERE complaint IN ('01B', '05A', '05B', '05C', \
                                        '05D', '05F', '05G', '05H', \
                                        '05J', '05K', '05L', '05M', \
                                        '05N', '05P', '05Q', '03A', \
                                        '03B', '03C', '03D', '03E', \
                                        '03F', '03G', '04A', '04B', \
                                        '04C', '04D', '04E', '04F', \
                                        '04G', '04H', '04J') \
                    GROUP BY officer_id) AS _ \
               GROUP BY complaint_count \
	       ORDER BY COUNT(*) DESC) \
         TO STDOUT WITH CSV HEADER" > $@

number_complaints.csv :
	psql -d complaints -c " \
	COPY (SELECT officer_id, COUNT(*) AS complaint_count \
              FROM accused \
              WHERE complaint IN ('01B', '05A', '05B', '05C', \
                                  '05D', '05F', '05G', '05H', \
                                  '05J', '05K', '05L', '05M', \
                                  '05N', '05P', '05Q', '03A', \
                                  '03B', '03C', '03D', '03E', \
                                  '03F', '03G', '04A', '04B', \
                                  '04C', '04D', '04E', '04F', \
                                  '04G', '04H', '04J') \
               GROUP BY officer_id) \
         TO STDOUT WITH CSV HEADER" > $@

