EXTERNAL_CODES = '01A', '01B', '01C', '01D', '01Z', '030', '031',	\
	'032', '032A', '033A', '033B', '033C', '033D', '034', '034A',	\
	'034B', '034C', '03A', '03B', '03C', '03D', '03E', '03F',	\
	'03G', '03J', '03K', '03L', '03M', '03P', '03Q', '03R',		\
	'03S', '03T', '03U', '03V', '03Z', '04A', '04B', '04C',		\
	'04D', '04E', '04F', '04G', '04H', '04J', '04Z', '05A',		\
	'05B', '05C', '05D', '05E', '05F', '05G', '05H', '05J',		\
	'05K', '05L', '05M', '05N', '05P', '05Q', '05R', '05T',		\
	'05Z', '05ZZA', '05ZZB', '05ZZC', '05ZZD', '05ZZE', '05ZZF',	\
	'05ZZK', '05ZZL', '05ZZM', '05ZZN', '05ZZP', '05ZZT', '07A',	\
	'07B', '07C', '07D', '07E', '07F', '07T', '07Z', '08A',		\
	'08B', '08C', '08D', '08E', '08F', '08G', '08H', '08J',		\
	'08K', '08L', '08M', '08N', '08P', '08Q', '08R', '08S',		\
	'08Z', '16A', '16B', '16C', '16D', '16E', '16F', '16Z',		\
	'18A', '18B', '19A', '19B', '19C', '19Z', '20A', '20B',		\
	'20C', '20D', '20Z', '27', 'S001', 'S002', 'S003', 'S004',	\
	'S005', 'S006', 'S007', 'S008', 'S009', 'S010', 'S011',		\
	'S012', 'S013', 'S014', 'S015', 'S016', 'S017', 'S020',		\
	'S021', 'S022', 'S023', 'S024', 'S025', 'S026', 'S027',		\
	'S028', 'S029', 'S030', 'S031', 'S032', 'S033', 'S034',		\
	'S035', 'S036', 'S037', 'S038', 'S040', 'S041', 'S042',		\
	'S043', 'S044', 'S045', 'S046', 'S047', 'S051', 'S052',		\
	'S054', 'S055', 'S056', 'S057', 'S058', 'S061', 'S062',		\
	'S063', 'S064', 'S065', 'S067', 'S068', 'S081', 'S083',		\
	'S084', 'S085', 'S086', 'S092', 'S093', 'S094', 'S100',		\
	'S101', 'S102', 'S109', 'S110', 'S111', 'S112', 'S113',		\
	'S114', 'S115', 'S116', 'S117', 'S118', 'S119', 'S120',		\
	'S121', 'S122', 'S123', 'S124', 'S125', 'S126', 'S128',		\
	'S130', 'S132', 'S249', 'S250', 'S251', 'S252', 'S253'


all : sustained_by_race.csv complaints_by_race.csv number_complaints.csv \
	number_complaints_rolled.csv disciplines.csv dispositions.csv

sustained_by_race.csv :
	psql -d complaints -c " \
	COPY (SELECT race, COUNT(complainant_id) \
	      FROM (SELECT distinct race, complainant_id \
                    FROM complainants INNER JOIN accused \
                    USING (complaint_id) \
                    WHERE complaint IN ($(EXTERNAL_CODES)) \
                    AND final_finding = 'SU') AS _ \
               GROUP BY race) \
         TO STDOUT WITH CSV HEADER" > $@

complaints_by_race.csv :
	psql -d complaints -c " \
	COPY (SELECT race, COUNT(complainant_id) \
	      FROM (SELECT distinct race, complainant_id \
                    FROM complainants INNER JOIN accused \
                    USING (complaint_id) \
                    WHERE complaint IN ($(EXTERNAL_CODES)) \
                    ) AS _ \
               GROUP BY race) \
         TO STDOUT WITH CSV HEADER" > $@

number_complaints_rolled.csv :
	psql -d complaints -c " \
	COPY (SELECT complaint_count, COUNT(*) \
	      FROM (SELECT officer_id, COUNT(*) AS complaint_count \
                    FROM accused \
                    WHERE complaint IN ($(EXTERNAL_CODES)) \
                    GROUP BY officer_id) AS _ \
               GROUP BY complaint_count \
	       ORDER BY COUNT(*) DESC) \
         TO STDOUT WITH CSV HEADER" > $@

number_complaints.csv :
	psql -d complaints -c " \
	COPY (SELECT officer_id, COUNT(*) AS complaint_count \
              FROM accused \
              WHERE complaint IN ($(EXTERNAL_CODES)) \
               GROUP BY officer_id) \
         TO STDOUT WITH CSV HEADER" > $@

disciplines.csv :
	psql -d complaints -c " \
	COPY (SELECT final_discipline, COUNT(*) \
              FROM accused \
              WHERE complaint IN ($(EXTERNAL_CODES)) \
               GROUP BY final_discipline) \
         TO STDOUT WITH CSV HEADER" > $@

dispositions.csv :
	psql -d complaints -c " \
	COPY (SELECT final_finding, COUNT(*) \
              FROM accused \
              WHERE complaint IN ($(EXTERNAL_CODES)) \
               GROUP BY final_finding) \
         TO STDOUT WITH CSV HEADER" > $@



