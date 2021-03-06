select
    SPRIDEN.SPRIDEN_ID BannerID,
    SPRIDEN.SPRIDEN_LAST_NAME LastName,
    SPRIDEN.SPRIDEN_FIRST_NAME FirstName,
    STVCLAS.STVCLAS_DESC StudentClass,
    STVMAJR.STVMAJR_DESC Program_of_Study,
    STVDEGC.STVDEGC_CODE DegreeProgram,
    SGBSTDN.SGBSTDN_STYP_CODE RegType,
    SGBSTDN.SGBSTDN_STST_CODE STST_CODE,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Exp_Grad_Date

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = :ListBox1.STVTERM_CODE

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GORADID.GORADID_ADID_CODE = 'SUID'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_STST_CODE = 'AS'--:DropDown1.STVSTST_CODE

    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, SGBSTDN.SGBSTDN_TERM_CODE_EFF)

    join SGRSATT SGRSATT on SGRSATT.SGRSATT_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGRSATT.SGRSATT_TERM_CODE_EFF = STVTERM.STVTERM_CODE


where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
--$addfilter


--$beginorder

order by
    SPRIDEN.SPRIDEN_LAST_NAME

--$endorder
