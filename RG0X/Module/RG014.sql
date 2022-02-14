(SHRLGPA.SHRLGPA_GPA > 3.1750000)
and(
    exists(
        select *

        from SHRTGPA SHRTGPA

        where SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
            and SGBSTDN.SGBSTDN_STYP_CODE not in ('G','T','F','N')
            and SGBSTDN.SGBSTDN_LEVL_CODE not in ('GR')
    )
)
