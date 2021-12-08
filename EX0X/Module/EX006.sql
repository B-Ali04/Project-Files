Select
    SPRIDEN.SPRIDEN_ID BANNER_ID,
    SPRIDEN.SPRIDEN_LAST_NAME LAST_NAME,
    SPRIDEN.SPRIDEN_FIRST_NAME FIRST_NAME,
    STVCLAS.STVCLAS_DESC STUDENT_CLASS,
    STVMAJR.STVMAJR_DESC PROGRAM_OF_STUDY,
    STVDEGC.STVDEGC_CODE DEGREE_PROGRAM,
    SGBSTDN.SGBSTDN_STYP_CODE REG_TYPE,
    SGBSTDN.SGBSTDN_STST_CODE STST_Code,
    SGBSTDN.SGBSTDN_TERM_CODE_ADMIT ADMIT_TERM,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE EXP_GRAD_DATE,
    STVCLAS.STVCLAS_SURROGATE_ID

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = :DropDown1.STVTERM_CODE

    join SPBPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_STST_CODE = :DropDown2.STVSTST_CODE
         and SGBSTDN.SGBSTDN_EXP_GRAD_DATE >= to_date(:DropDown5.STVTERM_END_DATE) - 30
         and SGBSTDN.SGBSTDN_EXP_GRAD_DATE <= to_date(:DropDown5.STVTERM_END_DATE) + 120

    join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'

    left outer join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

    left outer join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    left outer join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

    left outer join STVLEVL STVLEVL on STVLEVL.STVLEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and STVMAJR.STVMAJR_CODE = :ListBox1.SGBSTDN_MAJR_CODE_1
--$addfilter

--$beginorder

order by
      SPRIDEN.SPRIDEN_SEARCH_LAST_NAME

--$endorder