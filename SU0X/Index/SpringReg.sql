/*  SU Spring Registration   */
select
    SPRIDEN.SPRIDEN_ID BannerID,
    SPRIDEN.SPRIDEN_LAST_NAME LastName,
    SPRIDEN.SPRIDEN_FIRST_NAME FirstName,
    SSBSECT.SSBSECT_SUBJ_CODE,
    SSBSECT.SSBSECT_CRSE_NUMB,
    SHRTCKN.SHRTCKN_CRSE_TITLE
/*    STVCLAS.STVCLAS_DESC StudentClass,
    STVMAJR.STVMAJR_DESC Program_of_Study,
    STVDEGC.STVDEGC_CODE DegreeProgram,
    SGBSTDN.SGBSTDN_STYP_CODE RegType,
    SGBSTDN.SGBSTDN_STST_CODE STST_CODE,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Exp_Grad_Date*/

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202240
--perhaps term code start date < sysdate ??
    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GORADID.GORADID_ADID_CODE = 'SUID'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_STST_CODE in ('AS')

    left outer join sfrstcr on sfrstcr_pidm = spriden_pidm and sfrstcr_rsts_Code in ('RE','RW') and sfrstcr_term_code = stvterm_Code and sfrstcr_gmod_code = 'Y'

    join ssbsect on ssbsect_crn = sfrstcr_crn and ssbsect_term_code = stvterm_Code

    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, SGBSTDN.SGBSTDN_TERM_CODE_EFF)

    left outer join SHRTCKN SHRTCKN on SHRTCKN.SHRTCKN_CRN = SSBSECT.SSBSECT_CRN and SHRTCKN.SHRTCKN_TERM_CODE = 202220 and SHRTCKN.SHRTCKN_REG_SEQ = 1
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
        and SFRSTCR.SFRSTCR_GMOD_CODE = 'Y'
    )

order by
    SPRIDEN.SPRIDEN_LAST_NAME
