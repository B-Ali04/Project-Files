select * from rad_goal_dtl@dgw13.dgw r
left outer join spriden spriden on spriden.spriden_id = r.rad_id
and spriden.spriden_ntyp_code is null
and spriden.spriden_change_ind is null

where rad_catalog_yr = 2021
