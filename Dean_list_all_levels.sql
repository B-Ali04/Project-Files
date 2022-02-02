/*    Dean's List    */

select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    STVCLAS.STVCLAS_DESC Student_Class,
    STVDEGC.STVDEGC_CODE Degree_Program,
    substr(SHRTGPA.SHRTGPA_GPA, 1, 5) Semester_GPA,

    case
         when SHRTTRM.SHRTTRM_ASTD_CODE_DL = 'DL' then 'Deans List'
           else ''
    end as Deans_List,
    case
         when SHRTTRM.SHRTTRM_ASTD_CODE_DL in ('PL','PR') then 'Presidents List'
           else ''
    end as Presidents_List,
    case
         when SHRTGPA.SHRTGPA_GPA = 4 then '4.0 List'
           else ''
    end as Presidents_Commendation  
      /*
SHRTGPA_GPA,
    case
         when (SHRTGPA.SHRTGPA_GPA >= 3.500 and SHRTGPA.SHRTGPA_GPA < 3.850 and shrtgpa.shrtgpa_gpa_hours >= 12.000)  then 'Deans List'
           else ''
    end as Deans_List,
    case
/* i forgot the idea we had on monday that cleans this up
        when (SHRTGPA.SHRTGPA_GPA >= 3.850 and SHRTGPA.SHRTGPA_GPA != 4 and shrtgpa.shrtgpa_gpa_hours >= 12.000) then 'Presidents List'
           else ''
    end as Presidents_List,
    case
         when SHRTGPA.SHRTGPA_GPA = 4 and shrtgpa.shrtgpa_gpa_hours >= 12.000 then '4.0 List'
           else ''
    end as Presidents_Commendation
    
    */
/*, (shrtgpa_quality_points / shrtgpa_gpa_hours) chalk, shrtgpa.*
/*SHRTGPA_GPA_HOURS,
SHRTGPA_HOURS_ATTEMPTED*/

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220--:parm_term_code_select.STVTERM_CODE

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GORADID.GORADID_ADID_CODE = 'SUID'

    left outer join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'
        
    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
--        and SGBSTDN.SGBSTDN_LEVL_CODE = 'UG'
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)

    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, SGBSTDN.SGBSTDN_TERM_CODE_EFF)

    left outer join SHRTGPA SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRTGPA.SHRTGPA_TERM_CODE = STVTERM.STVTERM_CODE
        and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'

    left outer join SHRTTRM SHRTTRM on SHRTTRM.SHRTTRM_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRTTRM.SHRTTRM_TERM_CODE = STVTERM.STVTERM_CODE
         
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
--$addfilter

and SHRTGPA_GPA > 3.500 
and shrtgpa.shrtgpa_gpa_hours >= 12.000

--$beginorder

    and not exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
        and SFRSTCR.SFRSTCR_GRDE_CODE in( 'I', 'IF')
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE')
    )

order by
    SPRIDEN.SPRIDEN_LAST_NAME

--$endorder
