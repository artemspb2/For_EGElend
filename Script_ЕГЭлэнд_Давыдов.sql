SELECT
	courses.id AS course_id,
	courses.name AS courses_name,
	subjects.name AS subject_name,
	subjects.project AS subject_type,
	course_types.name AS course_type,
	courses.starts_at AS courses_date_start,
	users.ID AS user_id,
	users.last_name AS last_name,
	cities.name AS city_name,
	course_users.active,
/* не понимаю какая дата является дата_открытия_курса_ученику */
	course_users.created_at AS дата_открытия_курса_ученику, 
/* получилось много отрицательных значений - либо расчет неправильный, либо
это так и надо 
P.S. вижу во втором задании, что студенты могли добавиться на курс до его старта*/
    CASE
        WHEN course_users.updated_at IS NOT NULL 
        THEN
            EXTRACT(YEAR FROM AGE(CAST(course_users.updated_at AS TIMESTAMP), CAST(course_users.created_at AS TIMESTAMP))) * 12 +
            EXTRACT(MONTH FROM AGE(CAST(course_users.updated_at AS TIMESTAMP), CAST(course_users.created_at AS TIMESTAMP)))
        ELSE
            0
    END AS full_months_course_opened_for_user,
    COUNT(DISTINCT homework_done.homework_id) AS hmwrk_cnt,
    -- в задании не указано, но нужно для построения дашборда
    course_users.updated_at
from users 
LEFT JOIN cities  ON users.city_id = cities.id
LEFT JOIN course_users  ON users.id = course_users.user_id 
LEFT JOIN courses  ON course_users.course_id = courses.id 
LEFT JOIN subjects  ON courses.subject_id = subjects.id
LEFT JOIN course_types  ON courses.course_type_id = course_types.id
--LEFT JOIN homework_done  ON users.id = homework_done.user_id
LEFT JOIN lessons ON courses.id = lessons.course_id
LEFT JOIN homework_lessons ON lessons.id = homework_lessons.lesson_id
LEFT JOIN homework_done ON homework_lessons.homework_id = homework_done.homework_id
-- можно было бы посчитать оконной функцией  вместо группировки и COUNT 
GROUP BY courses.id, courses.name, subjects.name, subjects.project, course_types.name, courses.starts_at,
users.ID, users.last_name, cities.name, course_users,  course_users, full_months_course_opened_for_user,
course_users.active, course_users.created_at, course_users.updated_at