select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    SRVYSTU.SRVYSTU_ENTRY_TERM_CODE Entry_Term,
    
    GOREMAL.GOREMAL_EMAIL_ADDRESS Email_Address,
    GOREMAL2.GOREMAL_EMAIL_ADDRESS Per_Email_Address,

    SPRADDR.SPRADDR_STREET_LINE1 Street_1,
    SPRADDR.SPRADDR_STREET_LINE2 Street_2,
    SPRADDR.SPRADDR_CITY City,
    SPRADDR.SPRADDR_STAT_CODE State,
    substr(SPRADDR.SPRADDR_ZIP,1,5) Zip_Code   

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220

    join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'

    left outer join GOREMAL GOREMAL2 on GOREMAL2.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL2.GOREMAL_EMAL_CODE = 'PERS'
        and GOREMAL2.GOREMAL_STATUS_IND = 'A'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'

    left outer join SHRLGPA SHRLGPA2 on SHRLGPA2.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA2.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA2.SHRLGPA_GPA_TYPE_IND = 'T'
         and SHRLGPA2.SHRLGPA_GPA is not null

    left outer join SPRADDR SPRADDR on SPRADDR.SPRADDR_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SPRADDR.SPRADDR_ATYP_CODE in ('PR')
         and SPRADDR.SPRADDR_STATUS_IND is null
         and SPRADDR.SPRADDR_VERSION = (
             select max(SPRADDR_VERSION)
             from SPRADDR SPRADDR1
             where SPRADDR1.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
             and SPRADDR1.SPRADDR_ATYP_CODE in ('PR')
             and SPRADDR1.SPRADDR_STATUS_IND is null)
        and SPRADDR.SPRADDR_SURROGATE_ID = (
             select max(SPRADDR_SURROGATE_ID)
             from SPRADDR SPRADDR1
             where SPRADDR1.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
             and SPRADDR1.SPRADDR_ATYP_CODE in ('PR')
             and SPRADDR1.SPRADDR_STATUS_IND is null)

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
      and exists( select * from SFRSTCR where SFRSTCR_PIDM = SPRIDEN_PIDM and SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE and SFRSTCR_RSTS_CODE = 'RE')

order by
      SPRIDEN.SPRIDEN_LAST_NAME