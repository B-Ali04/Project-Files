/*
STAT CHECK!
in 2021, 1279 students recieved an offer for financial aid
of that group only 809 registered to take a course

and thats what we know so far.

*/

select    
    SPRIDEN.SPRIDEN_ID Banner_ID,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    (select * from dual) SAP_CODE,
    SHRTTRM.SHRTTRM_ASTD_CODE_END_OF_TERM SAP_INTERIM,
    STVASTD.STVASTD_DESC SAP_DESC,
    (select * from dual) Buffer_,
    SGBSTDN.SGBSTDN_LEVL_CODE Student_Level,
    GOREMAL.GOREMAL_EMAIL_ADDRESS Email_Address,
    GOREMAL2.GOREMAL_EMAIL_ADDRESS Pers_Email,
    SARADAP.SARADAP_TERM_CODE_ENTRY Term_Code,
    SHRTGPA.SHRTGPA_HOURS_ATTEMPTED Semester_HC,
    SHRTGPA.SHRTGPA_HOURS_EARNED Semester_HP,
    SHRTGPA.SHRTGPA_QUALITY_POINTS Semester_Grd_Pts,
    trunc(SHRTGPA.SHRTGPA_GPA,3) Semester_GPA,
    SHRLGPA.SHRLGPA_HOURS_ATTEMPTED Cumulative_HC,
    SHRLGPA.SHRLGPA_HOURS_EARNED Cumulative_HP,
    SHRLGPA.SHRLGPA_QUALITY_POINTS Cumulative_Grd_Pts,
    SPRADDR.SPRADDR_STREET_LINE1 Street_1,
    SPRADDR.SPRADDR_STREET_LINE2 Street_2,
    SPRADDR.SPRADDR_CITY City,
    SPRADDR.SPRADDR_STAT_CODE State,
    substr(SPRADDR.SPRADDR_ZIP,1,5) Zip_Code,
    (select * from dual) rorspar_fund_code/*,

    --see outer join below
    case
      when exists(
select * from rpratrm rpratrm where rpratrm.rpratrm_pidm = spriden.spriden_pidm and rpratrm.rpratrm_period = stvterm.stvterm_code 
and rpratrm.rpratrm_fund_code in ('FSUB', 'FUSB', 'FPLS', 'FPELL', 'FFWS', 'FSEOG', 'FGPLS')) then 'Y' else 'N' end AID
    --select * from rpratrm 
    */,
    SHRTTRM.SHRTTRM_term_code,
SHRTTRM.SHRTTRM_record_status_date,
    SHRTTRM.SHRTTRM_ASTD_CODE_END_OF_TERM SAP_CODE_1,
    SHRTTRM.SHRTTRM_ASTD_DATE_END_OF_TERM SAP_TERM_1
        
    --SHRTRM SEQUENCE
    
    
from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220--:ListBox1.STVTERM_CODE

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, 202220)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'

    left outer join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'
 
    left outer join GOREMAL GOREMAL2 on GOREMAL2.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL2.GOREMAL_EMAL_CODE = 'PERS'
        and GOREMAL2.GOREMAL_STATUS_IND = 'A'
        and GOREMAL2.GOREMAL_SURROGATE_ID = (
            select max(GOREMAL_SURROGATE_ID)
            from GOREMAL GOREMAL
            where GOREMAL.GOREMAL_PIDM = GOREMAL2.GOREMAL_PIDM
            and GOREMAL2.GOREMAL_EMAL_CODE = 'PERS'
            and GOREMAL2.GOREMAL_STATUS_IND = 'A'
        ) 
        
    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, 202220)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'

    left outer join shrtgpa shrtgpa on shrtgpa.shrtgpa_pidm = spriden.spriden_pidm
         and shrtgpa_term_code = stvterm.stvterm_code
         and shrtgpa.shrtgpa_gpa_type_ind = 'I' 
         --above join needs final testing
    
    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'O'
         and SHRLGPA.SHRLGPA_GPA is not null         

    --left outer join rpratrm rpratrm on rpratrm.rpratrm_pidm = spriden.spriden_pidm and rpratrm.rpratrm_period = stvterm.stvterm_code
           -- ...to be included following 1/5/2021
           -- left outer join SHRTTRM SHRTTRM on SHRTTRM.SHRTTRM_PIDM = SPRIDEN.SPRIDEN_PIDM and SHRTTRM.SHRTTRM_ASTD_CODE_END_OF_TERM is not null and SHRTTRM.SHRTTRM_TERM_CODE <= STVTERM.STVTERM_CODE

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
             
    left outer join SARADAP SARADAP on SARADAP.SARADAP_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SARADAP.SARADAP_TERM_CODE_ENTRY = STVTERM.STVTERM_CODE         

    left outer join SHRTTRM SHRTTRM on SHRTTRM.SHRTTRM_PIDM = SPRIDEN.SPRIDEN_PIDM and SHRTTRM.SHRTTRM_TERM_CODE = STVTERM_CODE

    left outer join STVASTD STVASTD on STVASTD.STVASTD_CODE = SHRTTRM.SHRTTRM_ASTD_CODE_END_OF_TERM

where 
     spriden_ntyp_code is null 
     and spriden_change_ind is null         

order by 
    spriden_last_name
