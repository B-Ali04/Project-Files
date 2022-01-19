Select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') Student_Name,
    GORADID.GORADID_ADDITIONAL_ID SU_ID,
    STVCLAS.STVCLAS_CODE Student_Class,
    SGBSTDN.SGBSTDN_DEGC_CODE_1 Degree_Program,
    SGBSTDN.SGBSTDN_TERM_CODE_EFF Semester,
    STVSTYP.STVSTYP_DESC Student_Type,
    s.shrttrm_astd_code_end_of_term astd_EOT,
    s.shrttrm_term_Code SAP_TCE
    
from
    SPRIDEN SPRIDEN
/*****************************************************************************************************************************************************/
    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220--:DropDown1.STVTERM_CODE
/*****************************************************************************************************************************************************/
    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_LEVL_CODE = 'UG'
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
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

left outer join shrttrm s on s.shrttrm_pidm = spriden.spriden_pidm
    and s.shrttrm_term_Code = (select max(shrttrm_term_Code) from shrttrm s2 where s2.shrttrm_pidm = spriden.spriden_pidm and shrttrm_term_code != stvterm.stvterm_code)
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW'))
        
order by STVSTYP_SURROGATE_ID        
