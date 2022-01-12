Select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') Student_Name,
/* Personal prefence *removed* */
    GOREMAL.GOREMAL_EMAIL_ADDRESS Email_Address,
    SPBPERS.SPBPERS_SEX Sex,
    STVCLAS.STVCLAS_DESC Student_Class,
    SGBSTDN.SGBSTDN_DEGC_CODE_1 Deg_Program,
/* Attribute definitions *temporarily removed* */
    SHRDGMR_GRAD_DATE graddate, /* temporary change*/
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Exp_Grad_Date,
    (Select * from dual) disturbia,     
    case
        when SGRADVR.PIDM is null then ''
        else f_format_name(SGRADVR.ADVR_PIDM,'LF30')
    end  Advisor_Name,
    SGBSTDN.SGBSTDN_DEPT_CODE Dept,
    (Select * from dual) Rio, 
    SGBSTDN.SGBSTDN_MAJR_CODE_1 Majr,
    sgbstdn.sgbstdn_term_code_eff
    /* Citzenship *removed* */

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202140

    join SPBPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM,STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
--         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
         --and SGBSTDN.SGBSTDN_DEPT_CODE = 'EFB'

    join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'

    /* Term / Cum GPA *removed* */

    /* National Data *removed* */
    left outer join rel_student_advisor SGRADVR on SGRADVR.PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGRADVR.TERM_CODE = STVTERM.STVTERM_CODE
        and SGRADVR.primary_ind = 1
        and SGRADVR.PIDM like '%'

    left outer join SHRDGMR SHRDGMR on SHRDGMR.SHRDGMR_PIDM = SPRIDEN.SPRIDEN_PIDM 

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

    where
    exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM_CODE
    )
    and SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
/*    
    and ( 
        (sgbstdn.sgbstdn_term_code_admit = STVTERM.STVTERM_CODE )
        or exists( select 1 from sfrstcr 
        
       \* put variable here *\ 
        
        where sfrstcr_term_code >= 202120
        
        \*variable: formatted previous term*\ 
                   and sfrstcr_rsts_code = 'RE' and sfrstcr_pidm = SPRIDEN.SPRIDEN_PIDM))
        and not exists (select 1 from shrdgmr where shrdgmr_levl_code = sgbstdn_levl_code
        and shrdgmr_pidm = spriden_pidm
        and shrdgmr_degs_code = 'GR' ) */

/*
Variance

*/
/*  adjust    */
    --and spriden_last_name = 'D'amico'
    --and SPRIDEN_ID = 'F00170477'

order by
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME
    
    /*variable!!*/
    
/*    select
case
    when to_char(STVTERM.STVTERM_START_DATE, 'MM') >= '08' then to_char(to_number(to_char(STVTERM.STVTERM_START_DATE,'YYYY')) ) || '40'
    else to_char(STVTERM.STVTERM_START_DATE,'YYYY') || '20'
end as 
from dual
join STVTERM STVTERM on STVTERM.STVTERM_CODE = :lb_Select_Term_Code.STVTERM_CODE
*/
