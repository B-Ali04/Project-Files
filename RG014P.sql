Select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') Student_Name,
    GORADID.GORADID_ADDITIONAL_ID SU_ID,
    STVCLAS.STVCLAS_DESC Student_Class,
    SGBSTDN.SGBSTDN_DEGC_CODE_1 Degree_Program,
    SGBSTDN.SGBSTDN_TERM_CODE_EFF Semester,
    STVSTYP.STVSTYP_DESC Student_Type,
    SGBSTDN.SGBSTDN_STST_CODE REG_STAT,
    SHRLGPA_GPA sum,
    SHRTGPA_GPA term

from
    SPRIDEN SPRIDEN
/*****************************************************************************************************************************************************/
    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220--:DropDown1.STVTERM_CODE
/*****************************************************************************************************************************************************/
    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         --and SGBSTDN.SGBSTDN_LEVL_CODE = 'UG'
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
         and GORADID.GORADID_ADID_CODE = 'SUID'

    join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'
/*****************************************************************************************************************************************************/
    left outer join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

    left outer join STVDEPT STVDEPT on STVDEPT.STVDEPT_CODE = SGBSTDN.SGBSTDN_DEPT_CODE

    left outer join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    left outer join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

    join STVSTYP STVSTYP on STVSTYP.STVSTYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE
/*****************************************************************************************************************************************************/

    left outer join SHRTGPA SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRTGPA_TERM_CODE = STVTERM.STVTERM_CODE
         and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
         and SHRLGPA.SHRLGPA_GPA is not null

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    
    
    and exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW'))
/*****************************************************************************************************************************************************/
and(SHRLGPA.SHRLGPA_GPA > 3.1750000)
and exists(select * from shrtgpa where shrtgpa_pidm = spriden_pidm and shrtgpa_term_code < stvterm_code and shrtgpa_gpa > 3.175 )
--and SGBSTDN.SGBSTDN_STYP_CODE not in ('G','T','F')
and SGBSTDN.SGBSTDN_STYP_CODE in ('C','D')


--$beginorder

order by
    STVSTYP.STVSTYP_SURROGATE_ID,
    --STVCLAS.STVCLAS_SURROGATE_ID, 
    --SPRIDEN.SPRIDEN_SEARCH_LAST_NAME
    SHRLGPA_GPA asc
