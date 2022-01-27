Select
    GORADID.GORADID_ADDITIONAL_ID SU_ID,
    --unit_name, unit_id, cip_code, person_id

    SPBPERS.SPBPERS_ETHN_CDE citizen_race_ethnicity_code,

    CASE
        when SGBSTDN.SGBSTDN_DEGC_CODE_1 = 'PHD' then 1
        else 2
    END degree_code,

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
        when SGBSTDN.SGBSTDN_STYP_CODE = 'N' then 1
        else 2
    END firsttime_code
    
--   support_source_code, support_mechanism_code

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
    sgbstdn.sgbstdn_degc_code_1 desc, spbpers.spbpers_sex desc, stvstyp_surrogate_id asc
