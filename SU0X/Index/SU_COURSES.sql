/*
su courses
*/

select * from REL_COURSE_SECTIONS
where term_code = 202220
--and subj_code = 'ACC'
and dept_code = 'SU'
order by subj_code
