Select
    GORADID.GORADID_ADDITIONAL_ID SU_ID,
    (select * from dual) unit_id,
    STVMAJR.STVMAJR_CIPC_CODE cip_code,
    --unit_name, unit_id, cip_code, person_id
    (select 0 from dual) unit_name,
    
        
    SPRIDEN.SPRIDEN_ID person_id,

    CASE
        when SGBSTDN.SGBSTDN_DEGC_CODE_1 = 'PHD' then 1
        when SGBSTDN.SGBSTDN_DEGC_CODE_1 like 'M%%' then 2
        else 2
    END degree_code,

    CASE
        when SPBPERS.SPBPERS_SEX = 'M' then 1
        when SPBPERS.SPBPERS_SEX = 'F' then 2
        else null
    END sex_code,

    SRVYSTU.SRVYSTU_RACE_CODE citizen_race_ethnicity_code,
    SRVYSTU.SRVYSTU_RACE_DESC citizen_race_ethnicity_desc,

    CASE
        when SGBSTDN.SGBSTDN_DEGC_CODE_1 = 'PHD' then 1
        when SGBSTDN.SGBSTDN_DEGC_CODE_1 like 'M%%' then 2
        else 2
    END degree_level_code,

    CASE
        when SRVYSTU.SRVYSTU_FULL_PART_IND = 'F' then 1
        else 2
    END enrollment_code,
    CASE
        when SPBPERS.SPBPERS_SEX = 'M' then 1
        when SPBPERS.SPBPERS_SEX = 'F' then 2
        else null
    END sex_code,
    CASE
        when SGBSTDN.SGBSTDN_STYP_CODE in ('N', 'F', 'T','G') then 1
        else 2
    END firsttime_code,    
--   support_source_code, support_mechanism_code
    (select 00 from dual) support_source_code,
    (select 00 from dual) support_mechanism_code,
    SRVYSTU.SRVYSTU_CITIZEN_DESC Citizenship_Desc,
    STVDEPT.STVDEPT_DESC Department_desc

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220--:DropDown1.STVTERM_CODE

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

    left outer join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

    left outer join STVDEPT STVDEPT on STVDEPT.STVDEPT_CODE = SGBSTDN.SGBSTDN_DEPT_CODE

    left outer join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    left outer join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

    join STVSTYP STVSTYP on STVSTYP.STVSTYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE
    
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