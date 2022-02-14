(
    SGBSTDN.SGBSTDN_MAJR_CODE_1 in ('AFSC', 'ENBI', 'CONB', 'EEIN', 'FOHE', 'WLSC')
    and(
        (
            not exists(
                select *

                from SFRSTCR SFRSTCR
                join SHRTCKN SHRTCKN on SHRTCKN.SHRTCKN_CRN = SFRSTCR.SFRSTCR_CRN

                where SPRIDEN.SPRIDEN_PIDM = SFRSTCR.SFRSTCR_PIDM
                and SFRSTCR.SFRSTCR_RSTS_CODE = 'RE'
                and SHRTCKN.SHRTCKN_SUBJ_CODE = 'EFB'
                and SHRTCKN.SHRTCKN_CRSE_NUMB = 202
            )
        and not exists(
                select *

                from SHRTCKN SHRTCKN

                where SPRIDEN.SPRIDEN_PIDM = SHRTCKN.SHRTCKN_PIDM
                and SHRTCKN.SHRTCKN_SUBJ_CODE = 'EFB'
                and SHRTCKN.SHRTCKN_CRSE_NUMB = 202
            )
        )
    or(
            not exists(
                select *

                from REL_STUDENT_ACAD_HISTORY REL

                where SPRIDEN.SPRIDEN_PIDM = REL.PIDM
                and REL.SUBJ_CODE = 'EFB'
                and REL.CRSE_NUMB = 202
            )
        )
    )
)
