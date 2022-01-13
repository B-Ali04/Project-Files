Select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    GORADID.GORADID_ADDITIONAL_ID SUid,
    STVCLAS.STVCLAS_DESC Student_Class,
    STVMAJR.STVMAJR_DESC Major_Program,
    STVDEGC.STVDEGC_CODE Degree_Program,
    SGBSTDN.SGBSTDN_STYP_CODE Reg_Type,
    SGBSTDN.SGBSTDN_STST_CODE STST_CODE,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Exp_Grad_Date,
    trunc(SHRTGPA.SHRTGPA_GPA, 3) Semester_GPA,
    trunc(SHRLGPA.SHRLGPA_GPA, 3) Cumulative_GPA,
    SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1 Minor_1,
    SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1_2 Minor_2

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = :DropDown1.STVTERM_CODE

    join SPBPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
         and GORADID.GORADID_ADID_CODE = 'SUID'

    join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
         and GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
         and GOREMAL.GOREMAL_EMAL_CODE = 'SU'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_STST_CODE = :DropDown2.STVSTST_CODE
         and SGBSTDN.SGBSTDN_LEVL_CODE = :DropDown3.STVLEVL_CODE

    left outer join SHRTGPA SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRTGPA.SHRTGPA_TERM_CODE = STVTERM.STVTERM_CODE
        and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I' --o includes nulls

    left outer join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

    left outer join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    left outer join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and exists(
        select * from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
              and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
              and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW')
    )
    and (SHRLGPA.SHRLGPA_GPA < 3.000)
         and SGBSTDN.SGBSTDN_LEVL_CODE = 'GR'
--$addfilter

--$beginorder

order by
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME

--$endorder
