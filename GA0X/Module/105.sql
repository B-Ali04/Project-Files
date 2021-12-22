SARADAP_STYP_CODE in ('R', 'N', 'G')
and exists(
    select * from SFRSTCR
    where SFRSTCR_TERM_CODE = SGBSTDN_TERM_CODE_EFF
    and SFRSTCR_PIDM = SPRIDEN_PIDM
    )