Select
    GORADID.GORADID_ADDITIONAL_ID SU_ID,
    (select 0 from dual) unit_name,
    (select -1 from dual) unit_id,  
    SPRIDEN.SPRIDEN_ID person_id,
    STVMAJR.STVMAJR_CIPC_CODE cip_code,
    SPBPERS.SPBPERS_ETHN_CDE citizen_race_ethnicity_code,
    SGBSTDN.SGBSTDN_DEGC_CODE_1 degree_code,
    SRVYSTU.SRVYSTU_FULL_PART_IND enrollment_code,
    SPBPERS.SPBPERS_SEX sex_code,
    SGBSTDN.SGBSTDN_STYP_CODE firsttime_code,
    (select 1 from dual) support_source_code,
    (select 2 from dual) support_mechanism_code

    
--   support_source_code, support_mechanism_code

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220  --:DropDown1.STVTERM_CODE

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_LEVL_CODE = 'GR'
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('UNDC', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
         and GORADID.GORADID_ADID_CODE = 'SUID'

    left outer join SPBPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM
   
    join STVSTYP STVSTYP on STVSTYP.STVSTYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE

    left outer join srvystu srvystu on srvystu.srvystu_pidm = spriden.spriden_pidm
         and srvystu_Term_Code = stvterm.stvterm_code
         and srvystu_status_code = 'AS'
         and srvystu_preterm_class_yr_code not in ('BG')
         and srvystu_posterm_class_yr_code not in ('BG')
         and srvystu_type_code not in ('X')
         and srvystu_curric_1_major_code not in ('UNDC','SUS','VIS','0000')
         
    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    
    join STVCIPC STVCIPC on STVCIPC.STVCIPC_CODE = STVMAJR.STVMAJR_CIPC_CODE
    
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW'))

order by
    SGBSTDN.SGBSTDN_DEGC_CODE_1 desc, SPBPERS.SPBPERS_SEX desc, STVSTYP.STVSTYP_SURROGATE_ID asc
