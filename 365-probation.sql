Select
    f_format_name(spriden_pidm, 'LF30') LF,
    SPRIDEN.SPRIDEN_ID Banner_ID,
    SHRLGPA.SHRLGPA_GPA Cum_GPA,
    SGBSTDN.SGBSTDN_DEGC_CODE_1 Degc, 
    shrtgpa.shrtgpa_gpa current_term_gpa,
    SHRTGPA.SHRTGPA_TERM_CODE Cur_Sem_sem,
    GOREMAL.GOREMAL_EMAIL_ADDRESS Email,
    SHRTTRM.shrttrm_astd_code_end_of_term ASTD_Active,
    shrttrm_term_code As_of,
    stvclas_Code,
    stvstyp_code
    
from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE in (202140)
    
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
join STVSTYP STVSTYP on STVSTYP.STVSTYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
         and SHRLGPA.SHRLGPA_GPA is not null             
  
    left outer join SHRTGPA SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRTGPA.SHRTGPA_TERM_CODE = STVTERM.STVTERM_CODE
        and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'        

left outer join shrttrm shrttrm on shrttrm.shrttrm_pidm = spriden.spriden_pidm
     and shrttrm.shrttrm_term_code = (
     select max(shrttrm_term_code) from shrttrm s
     where s.shrttrm_pidm = spriden.spriden_pidm
     and s.shrttrm_term_code < stvterm_code
     and shrttrm_astd_code_end_of_term is not null
     )
     
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW')
    )

and shrttrm_astd_code_end_of_term = 'P1'
--and stvstyp_code not in ('T','F')
order by

        SPRIDEN.SPRIDEN_SEARCH_LAST_NAME        
