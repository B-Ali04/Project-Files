select     
    SPRIDEN.SPRIDEN_ID Banner_ID,
    f_format_name(spriden_pidm, 'LF30') Student_Name,
    SHRTTRM.SHRTTRM_ASTD_CODE_END_OF_TERM ASTD_Code 
    
    from spriden
    
    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202120
    
    left outer join SHRTTRM SHRTTRM on SHRTTRM.SHRTTRM_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRTTRM.SHRTTRM_TERM_CODE = STVTERM.STVTERM_CODE
         
    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_STST_CODE in ('AS') 
        and SGBSTDN.SGBSTDN_LEVL_CODE = 'UG'           

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
         and SHRLGPA.SHRLGPA_GPA is not null

    left outer join SHRTGPA SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRTGPA.SHRTGPA_TERM_CODE = STVTERM.STVTERM_CODE
        and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'

    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    join STVSTYP STVSTYP on STVSTYP.STVSTYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and SHRTTRM.SHRTTRM_ASTD_CODE_END_OF_TERM = 'P1'
    
    and (
       (
       SHRLGPA.SHRLGPA_GPA < 2.00
       and SHRLGPA.SHRLGPA_GPA_HOURS > 60
            )
    or(SHRLGPA.SHRLGPA_GPA < 1.850
       and SHRLGPA.SHRLGPA_GPA_HOURS <= 60
       and SHRLGPA.SHRLGPA_GPA_HOURS >= 31
            )             
    or(SHRLGPA.SHRLGPA_GPA < 1.700
       and SHRLGPA.SHRLGPA_GPA_HOURS < 30
            )  
    )
    or( SHRTGPA.SHRTGPA_GPA < 2.000 and SGBSTDN.SGBSTDN_DEGC_CODE_1 = 'AAS')

ORDER BY
      SPRIDEN_LAST_NAME
