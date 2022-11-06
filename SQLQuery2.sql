WITH
 final_table AS (
 SELECT
   opened.age_bucket,
   opened.open_time,
   closed.sent_time
 FROM (
   SELECT
     DISTINCT ab.age_bucket,
     sum (time_spent) AS open_time
   FROM
     activities a
   JOIN
     age_breakdown ab
   ON
     a.user_id = ab.user_id
   WHERE
     activity_type = 'open'
   GROUP BY
     ab.age_bucket) opened
 JOIN (
   SELECT
     DISTINCT ab.age_bucket,
     sum (time_spent) AS sent_time
   FROM
     activities a
   JOIN
     age_breakdown ab
   ON
     a.user_id = ab.user_id
   WHERE
     activity_type = 'send'
   GROUP BY
     ab.age_bucket) closed
 ON
   opened.age_bucket=closed.age_bucket)
SELECT
 final_table.age_bucket,
 ROUND(final_table.open_time/(final_table.open_time+final_table.sent_time)*100.0, 2) AS openscr,
 round (final_table.sent_time/(final_table.open_time+final_table.sent_time)*100.0,
   2) AS clsscr
FROM
 final_table