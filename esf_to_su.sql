select 
spriden_pidm, 
spriden_first_name,
spriden_last_name,
spriden_mi,
spriden_id, 
ssbsect.ssbsect_subj_code subj,
ssbsect.ssbsect_crse_numb numb

from spriden s

     join stvterm t on t.stvterm_code = 202220

     join sgbstdn a on a.sgbstdn_pidm = s.spriden_pidm
          and a.sgbstdn_stst_code = 'AS'
          and a.sgbstdn_term_code_eff = fy_sgbstdn_eff_term(a.sgbstdn_pidm, t.stvterm_code)

inner join SFRSTCR SFRSTCR on SFRSTCR.SFRSTCR_PIDM = s.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RW', 'RE')
        and SFRSTCR.SFRSTCR_TERM_CODE = t.STVTERM_CODE

inner join ssbsect ssbsect on ssbsect.ssbsect_crn = sfrstcr.sfrstcr_crn
        and ssbsect.ssbsect_gmod_code= 'Y'
--join shrtckg g on g.shrtckg_pidm = s.spriden_pidm and g.shrtckg_term_code = t.stvterm_code


where s.spriden_ntyp_code is null
and s.spriden_change_ind is null
--and spriden_id = 'F00171621'
--cond 1          and a.sgbstdn_majr_code_1 in ('SUS')
--cond 2
 
and (exists(

select * 
from sfrstcr r 
where r.sfrstcr_pidm = s.spriden_pidm
and r.sfrstcr_term_code = t.stvterm_Code
and r.sfrstcr_rsts_code like 'R%'
and r.sfrstcr_gmod_code = 'Y')
and a.sgbstdn_majr_code_1 not in ('EHS', 'SUS','0000','VIS')
)

order by
s.spriden_search_last_name, s.spriden_first_name
