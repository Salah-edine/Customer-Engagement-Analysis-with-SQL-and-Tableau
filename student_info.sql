
SELECT
i.student_id,
i.student_country,
i.date_registered,
CASE
WHEN i.student_id NOT IN  (SELECT student_id FROM 365_student_learning) THEN NULL
ELSE l.date_watched
END AS date_watched,
CASE
WHEN i.student_id NOT IN  (SELECT student_id FROM 365_student_learning) THEN 0
ELSE l.minutes_watched
END AS minutes_watched,
CASE
WHEN i.student_id NOT IN  (SELECT student_id FROM 365_student_learning) THEN 0
ELSE 1
END AS onboarded,
CASE
WHEN i.student_id  IN  (SELECT student_id FROM purchases_info) AND p.start_date<date_watched<p.end_date THEN 1
ELSE 0
END AS paid
FROM 365_student_info i
LEFT JOIN 365_student_learning l ON l.student_id = i.student_id;

SELECT
SUM(minutes_watched)
FROM 365_student_learning;

SELECT
student_id,
student_country,
date_registered,
date_watched,
minutes_watched,
onboarded,
MAX(paid) AS paid
FROM
(SELECT
a.*,
IF(date_watched BETWEEN p.date_start AND p.date_end, 1, 0) AS paid
FROM
(SELECT 
i.*,
l.date_watched,
IF( l.student_id IS NULL, 0 , SUM(l.minutes_watched)) as minutes_watched,
IF ( l.student_id IS NULL, 0, 1) AS onboarded
FROM 365_student_info i
LEFT JOIN 365_student_learning l USING(student_id)
GROUP BY student_id, date_watched) a
LEFT JOIN purchases_info p USING(student_id)) b
GROUP BY student_id, date_watched;