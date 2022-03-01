select 
spriden_pidm, 
spriden_first_name,
spriden_last_name,
spriden_mi,

spriden_id,
g.shrtckg_grde_code_final
/*
c.shrtckn_term_Code,

*/
from spriden s
join stvterm t on t.stvterm_code = 202220

join sgbstdn a on a.sgbstdn_pidm = s.spriden_pidm
     and a.sgbstdn_stst_code = 'AS'
     and a.sgbstdn_term_code_eff = fy_sgbstdn_eff_term(a.sgbstdn_pidm, t.stvterm_code)
     and a.sgbstdn_majr_code_1 not in ('0000', 'EHS', 'SUS', 'VIS')

join shrtckg g on g.shrtckg_pidm = s.spriden_pidm and g.shrtckg_term_code = t.stvterm_code

--left outer join sfrstcr r on r.sfrstcr_pidm = s.spriden_pidm and r.sfrstcr_term_code = t.stvterm_code


where s.spriden_ntyp_code is null
and s.spriden_change_ind is null

and exists(

select * 
from sfrstcr r 
where r.sfrstcr_pidm = s.spriden_pidm
and r.sfrstcr_term_code = t.stvterm_Code
and r.sfrstcr_rsts_code like 'R%'
and r.sfrstcr_gmod_code = 'Y')

order by
s.spriden_search_last_name, s.spriden_first_name
