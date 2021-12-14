Select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    SPRIDEN.SPRIDEN_MI MI,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPBPERS.SPBPERS_PREF_FIRST_NAME Pref_Name,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Grad_Date,
    SGBSTDN.SGBSTDN_DEGC_CODE_1 Deg,
    SGBSTDN.SGBSTDN_MAJR_CODE_1 Major,
    GOREMAL.GOREMAL_EMAIL_ADDRESS Email_Address,
    SPBPERS.SPBPERS_SEX Sex,
    /*
    case
         when spbpers_sex in ('M') then 'He/Him/His'
         when spbpers_sex in ('F') then 'She/Her/Hers'
         when spbpers_sex in ('N') then 'Them/Their/Theirs'  
           else ''
    end Pronoun,
    */
    SGBSTDN.SGBSTDN_DEPT_CODE Dept,
    SPRADDR.SPRADDR_STREET_LINE1 Street_1,
    SPRADDR.SPRADDR_STREET_LINE2 Street_2,
    SPRADDR.SPRADDR_CITY City,
    SPRADDR.SPRADDR_STAT_CODE State,
    substr(SPRADDR.SPRADDR_ZIP,1,5) Zip_Code,
  Max( decode(spraddr.spraddr_atyp_code,'MA',spraddr.spraddr_natn_code) ) "lo_nation",
    SPRTELE.SPRTELE_PHONE_AREA Area_Code,
    SPRTELE.SPRTELE_PHONE_NUMBER Phone_Number,
    SPRADDR2.SPRADDR_STREET_LINE1 Perm_Street_1,
    SPRADDR2.SPRADDR_STREET_LINE2 Perm_Street_2,
    SPRADDR2.SPRADDR_CITY Perm_City,
    SPRADDR2.SPRADDR_STAT_CODE Perm_State,
    substr(SPRADDR2.SPRADDR_ZIP,1,5) Perm_Zip_Code,
    --SPRADDR2.SPRADDR_CNTY_CODE Country1,
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
--        select * from stvcnty select * from spraddr
        
        --select* from spbpers
    

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    
    group by
        SPRIDEN.SPRIDEN_ID ,
    SPRIDEN.SPRIDEN_FIRST_NAME ,
    SPRIDEN.SPRIDEN_MI,
    SPRIDEN.SPRIDEN_LAST_NAME ,
    SPBPERS.SPBPERS_PREF_FIRST_NAME,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE,
    SGBSTDN.SGBSTDN_DEGC_CODE_1,
    SGBSTDN.SGBSTDN_MAJR_CODE_1,
    GOREMAL.GOREMAL_EMAIL_ADDRESS ,
    SPBPERS.SPBPERS_SEX,
    /*
    case
         when spbpers_sex in ('M') then 'He/Him/His'
         when spbpers_sex in ('F') then 'She/Her/Hers'
         when spbpers_sex in ('N') then 'Them/Their/Theirs'  
           else ''
    end Pronoun,
    */
    SGBSTDN.SGBSTDN_DEPT_CODE,
    SPRADDR.SPRADDR_STREET_LINE1 ,
    SPRADDR.SPRADDR_STREET_LINE2 ,
    SPRADDR.SPRADDR_CITY ,
    SPRADDR.SPRADDR_STAT_CODE ,
    substr(SPRADDR.SPRADDR_ZIP,1,5),
 spraddr.spraddr_natn_code,
    SPRTELE.SPRTELE_PHONE_AREA ,
    SPRTELE.SPRTELE_PHONE_NUMBER ,
    SPRADDR2.SPRADDR_STREET_LINE1,
    SPRADDR2.SPRADDR_STREET_LINE2,
    SPRADDR2.SPRADDR_CITY ,
    SPRADDR2.SPRADDR_STAT_CODE,
    substr(SPRADDR2.SPRADDR_ZIP,1,5),
    --SPRADDR2.SPRADDR_CNTY_CODE Country1,
    SPRTELE2.SPRTELE_PHONE_AREA ,
    SPRTELE2.SPRTELE_PHONE_NUMBER 
--$addfilter

order by
    SPRIDEN.SPRIDEN_LAST_NAME
