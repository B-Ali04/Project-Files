Select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    SPRIDEN.SPRIDEN_MI MI,
    --SPBPERS.SPBPERS_PREF_FIRST_NAME Pref_Name,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Exp_Grad_Date,
    GOREMAL.GOREMAL_EMAIL_ADDRESS Email_Address,
    SPRADDR.SPRADDR_STREET_LINE1 Street_1,
    SPRADDR.SPRADDR_STREET_LINE2 Street_2,
    SPRADDR.SPRADDR_CITY City,
    SPRADDR.SPRADDR_STAT_CODE State,
    substr(SPRADDR.SPRADDR_ZIP,1,5) Zip_Code,
    SPRTELE.SPRTELE_PHONE_AREA Area_Code,
    SPRTELE.SPRTELE_PHONE_NUMBER Phone_Number,
    SPRADDR2.SPRADDR_STREET_LINE1 Street_1,
    SPRADDR2.SPRADDR_STREET_LINE2 Street_2,
    SPRADDR2.SPRADDR_CITY City,
    SPRADDR2.SPRADDR_STAT_CODE State,
    substr(SPRADDR2.SPRADDR_ZIP,1,5) Zip_Code,
    SPRTELE2.SPRTELE_PHONE_AREA Alt_Area_Code,
    SPRTELE2.SPRTELE_PHONE_NUMBER Alt_Phone_Number/*,
    sprtele.**/
        
    --select * from sprtele
from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220--:ListBox1.STVTERM_CODE

    join SPBPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM

    join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'

   join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_STST_CODE = 'IG'

    left outer join SPRADDR SPRADDR on SPRADDR.SPRADDR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SPRADDR.SPRADDR_ATYP_CODE in ('MA')
        and SPRADDR.SPRADDR_STATUS_IND is null
        and SPRADDR.SPRADDR_VERSION = (
             select max(SPRADDR_VERSION)
             from SPRADDR SPRADDR1
             where SPRADDR1.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
             and SPRADDR1.SPRADDR_ATYP_CODE in ('MA')
             and SPRADDR1.SPRADDR_STATUS_IND is null)
        and SPRADDR.SPRADDR_SURROGATE_ID = (
             select max(SPRADDR_SURROGATE_ID)
             from SPRADDR SPRADDR1
             where SPRADDR1.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
             and SPRADDR1.SPRADDR_ATYP_CODE in ('MA')
             and SPRADDR1.SPRADDR_STATUS_IND is null)

    left outer join SPRADDR SPRADDR2 on SPRADDR2.SPRADDR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SPRADDR2.SPRADDR_ATYP_CODE in ('PR')
        and SPRADDR2.SPRADDR_STATUS_IND is null
        and SPRADDR2.SPRADDR_VERSION = (
             select max(SPRADDR_VERSION)
             from SPRADDR SPRADDR1
             where SPRADDR1.SPRADDR_PIDM = SPRADDR2.SPRADDR_PIDM
             and SPRADDR1.SPRADDR_ATYP_CODE in ('PR')
             and SPRADDR1.SPRADDR_STATUS_IND is null)
        and SPRADDR2.SPRADDR_SURROGATE_ID = (
             select max(SPRADDR_SURROGATE_ID)
             from SPRADDR SPRADDR1
             where SPRADDR1.SPRADDR_PIDM = SPRADDR2.SPRADDR_PIDM
             and SPRADDR1.SPRADDR_ATYP_CODE in ('PR')
             and SPRADDR1.SPRADDR_STATUS_IND is null)
             
    left outer join SPRTELE SPRTELE on SPRTELE.SPRTELE_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SPRTELE.SPRTELE_TELE_CODE in ('AC')   
         and SPRTELE.SPRTELE_SURROGATE_ID = (
             select max(SPRTELE_SURROGATE_ID)
             from SPRTELE SPRTELE1
             where SPRTELE1.SPRTELE_PIDM = SPRTELE.SPRTELE_PIDM
             and SPRTELE1.SPRTELE_TELE_CODE in ('AC')) 
             
    left outer join SPRTELE SPRTELE2 on SPRTELE2.SPRTELE_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SPRTELE2.SPRTELE_TELE_CODE in ('PC')   
        and SPRTELE2.SPRTELE_SURROGATE_ID = (
             select max(SPRTELE_SURROGATE_ID)
             from SPRTELE SPRTELE1
             where SPRTELE1.SPRTELE_PIDM = SPRTELE2.SPRTELE_PIDM
             and SPRTELE1.SPRTELE_TELE_CODE in ('PC'))          
            
       /* and SPRTELE.SPRTELE_TELE_CODE in ('PC')*/
       /* and SPRTELE.SPRTELE_VERSION = (
             select max(SPRTELE_VERSION)
             from SPRTELE SPRTELE1
             where SPRTELE1.SPRTELE_PIDM = SPRTELE.SPRTELE_PIDM
             and SPRTELE1.SPRTELE_TELE_CODE in ('PC'))*/
/*        and SPRTELE.SPRTELE_SURROGATE_ID = (
             select max(SPRTELE_SURROGATE_ID)
             from SPRTELE SPRTELE1
             where SPRTELE1.SPRTELE_PIDM = SPRTELE.SPRTELE_PIDM
             and SPRTELE1.SPRTELE_TELE_CODE in ('PC'))*/
   /* left outer join SPRTELE SPRTELE2 on SPRTELE2.SPRTELE_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SPRTELE2.SPRTELE_TELE_CODE in ('PR')
        and SPRTELE2.SPRTELE_VERSION = (
             select max(SPRTELE_VERSION)
             from SPRTELE SPRTELE1
             where SPRTELE1.SPRTELE_PIDM = SPRTELE2.SPRTELE_PIDM
             and SPRTELE1.SPRTELE_TELE_CODE in ('PR'))
        and SPRTELE2.SPRTELE_SURROGATE_ID = (
             select max(SPRTELE_SURROGATE_ID)
             from SPRTELE SPRTELE1
             where SPRTELE1.SPRTELE_PIDM = SPRTELE2.SPRTELE_PIDM
             and SPRTELE1.SPRTELE_TELE_CODE in ('PR'))*/
--        select * from stvtele
        
        
    

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
--$addfilter

order by
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME
