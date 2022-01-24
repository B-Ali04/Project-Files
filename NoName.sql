Select
    f_format_name(spriden_pidm, 'LF30') LF,
    SPRIDEN.SPRIDEN_ID Banner_ID,
    SGBSTDN.SGBSTDN_DEGC_CODE_1 Degc, 
/*
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
   */
    --SGBSTDN.SGBSTDN_TERM_CODE_EFF Semester,
    
    trunc(SHRLGPA.SHRLGPA_GPA,3) Cumulative_GPA,
    STVSTYP.STVSTYP_CODE Student_Type,
    
    SHRTGPA2.SHRTGPA_TERM_CODE Prev_Sem_sem,
    trunc(SHRTGPA2.SHRTGPA_GPA,3) Prev_Sem_GPA,

     CASE
       when shrtgpa2.shrtgpa_gpa < 2.0000 then 'Y'
       else null
       END Probation,
    
           SHRTGPA.SHRTGPA_TERM_CODE Cur_Sem_sem,
    trunc(SHRTGPA.SHRTGPA_GPA,3) Cur_Sem_GPA,
 CASE
       when shrtgpa.shrtgpa_gpa < 2.0000 then 'Y'
       else null
       END Probation,
    
    GOREMAL.GOREMAL_EMAIL_ADDRESS Email,
       CASE
       when (shrtgpa.shrtgpa_gpa < 2.0000 and  shrtgpa2.shrtgpa_gpa < 2.0000) then 'Y'
       else null
       END Sus_Case,
       
       CASE
       when ((shrtgpa2.shrtgpa_gpa < 2.0000) and (
        -- main campus standards
        (
         SHRLGPA.SHRLGPA_HOURS_EARNED < 30.0
         and SHRLGPA.SHRLGPA_GPA < 1.7000000
        )
        or(
        SHRLGPA.SHRLGPA_HOURS_EARNED >= 30.0
        and SHRLGPA.SHRLGPA_HOURS_EARNED < 60.0
        and SHRLGPA.SHRLGPA_GPA < 1.850
        )
        or(
        SHRLGPA.SHRLGPA_HOURS_EARNED >= 60.0
        and SHRLGPA.SHRLGPA_GPA < 2.000
        )
            )) then 'Y'
       else null
       END ACAD_Case,
       
       CASE
       when (exists( select * from shrttrm s where s.shrttrm_pidm = spriden.spriden_pidm and s.shrttrm_astd_code_end_of_term like 'P%' and  s.shrttrm_term_code < stvterm_code)) then 'Y'
       else null
       END prev_prob,
       SHRLGPA_GPA_HOURS GPA_HOURS
       
from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE in (202220)

    join SPBPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM
    
    join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'    

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
         and GORADID.GORADID_ADID_CODE = 'SUID'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_STST_CODE in ('AS')--, 'IG')
        and SGBSTDN.SGBSTDN_LEVL_CODE = 'UG'

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

    join STVDEPT STVDEPT on STVDEPT.STVDEPT_CODE = SGBSTDN.SGBSTDN_DEPT_CODE

    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1
    
    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    
    join STVSTYP STVSTYP on STVSTYP.STVSTYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE
       
/*     
   
    left outer join shrttrm s2 on s2.shrttrm_pidm = spriden.spriden_pidm 
         and s2.shrttrm_term_code = 202120
         
*/
    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
         and SHRLGPA.SHRLGPA_GPA is not null             
    
    left outer join SHRTGPA SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRTGPA.SHRTGPA_TERM_CODE = STVTERM.STVTERM_CODE
        and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'

left outer join SHRTGPA SHRTGPA2 on SHRTGPA2.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRTGPA2.SHRTGPA_GPA_TYPE_IND = 'I'
                and SHRTGPA2.SHRTGPA_TERM_CODE = (
                select max(shrtgpa_term_code) from SHRTGPA s2
                where s2.SHRTGPA_PIDM = SHRTGPA.SHRTGPA_PIDM
                and s2.SHRTGPA_TERM_CODE  < STVTERM.STVTERM_CODE)
                --and SHRTGPA2.SHRTGPA_TERM_CODE < STVTERM.STVTERM_CODE
    
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
and sgbstdn.sgbstdn_styp_Code in ('C')
    and exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW')
    )
    
    and SHRLGPA_GPA  < 2.000
--and SHRTGPA2.SHRTGPA_TERM_CODE < STVTERM.STVTERM_CODE
order by

        SPRIDEN.SPRIDEN_SEARCH_LAST_NAME
