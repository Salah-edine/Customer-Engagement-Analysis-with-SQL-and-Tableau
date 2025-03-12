
USE 365_database;


WITH cts AS(
SELECT
i.course_id,
i.course_title,
ROUND(SUM(l.minutes_watched), 2) AS total_minutes_watched,
ROUND(SUM(l.minutes_watched)/ COUNT(DISTINCT l.student_id), 2) AS average_minutes
FROM 365_course_info i
JOIN 365_student_learning l USING(course_id)
GROUP BY course_id
ORDER BY course_id)
SELECT
i.course_id,
i.course_title,
c.total_minutes_watched,
c.average_minutes,
COUNT(r.course_rating) as number_of_ratings,
ROUND(AVG(r.course_rating), 2) as average_ratings
FROM 365_course_info i
LEFT JOIN 365_course_ratings r  using(course_id)
JOIN cts c USING(course_id)
GROUP BY course_id
ORDER BY course_id;


