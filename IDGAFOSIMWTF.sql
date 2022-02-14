
Select
    (select 1 from dual) Continuing_Probation,
    SPRIDEN.SPRIDEN_ID Banner_ID,
    f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LF30') Student_Name,
    stvclas_code class_code,
        trunc(SHRTGPA.SHRTGPA_GPA, 3) Semester_GPA,
        trunc(SHRLGPA.SHRLGPA_GPA, 3) Cumulative_GPA,    /*
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    GORADID.GORADID_ADDITIONAL_ID SUid,
    STVCLAS.STVCLAS_DESC Student_Class,
    STVMAJR.STVMAJR_DESC Major_Program,
    STVDEGC.STVDEGC_CODE Degree_Program,
    SGBSTDN.SGBSTDN_STYP_CODE Reg_Type,
    stvstyp_desc styp_desc, 
    SGBSTDN.SGBSTDN_STST_CODE STST_CODE,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Exp_Grad_Date,
    */
    REL.ASTD_CODE, rel.*

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = 202220 --:parm_term_code_select.STVTERM_CODE

    join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
         and GORADID.GORADID_ADID_CODE = 'SUID'

    left outer join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS', 'UNDC')
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'

    left outer join REL_STUDENT_STANDING REL on REL.PIDM = SPRIDEN.SPRIDEN_PIDM
         and REL.TERM_CODE <= STVTERM.STVTERM_CODE

    left outer join SHRTGPA SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRTGPA.SHRTGPA_TERM_CODE = REL.TERM_CODE
        and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
         and SHRLGPA.SHRLGPA_GPA is not null
         
    join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    
    join STVSTYP STVSTYP on STVSTYP.STVSTYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE
    
    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, rel.TERM_CODE)


/*     and REL.ASTD_TERM_CODE = (
         select max(ASTD_TERM_CODE)
         from rel_Student_standing r
         where r.pidm = spriden.spriden_pidm
         and astd_term_code <= stvterm.stvterm_Code
     )
     */

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
and stvclas_code in ('FR', 'SO','JR','SR','S5')
    and exists(
        select * from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
              and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
              and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW')
    )
    
and (
        (
            SHRTGPA.SHRTGPA_GPA < 2.00
            and REL.ASTD_CODE = 'P1'
            and REl.ASTD_TERM_CODE = STVTERM.STVTERM_CODE
            and REL.TERM_CODE <= STVTERM.STVTERM_CODE
        )
        
        or(
            ((
         SHRLGPA.SHRLGPA_GPA_HOURS < 30.0
         and SHRLGPA.SHRLGPA_GPA < 1.7000000
        )
        or(
        SHRLGPA.SHRLGPA_GPA_HOURS >= 30.0
        and SHRLGPA.SHRLGPA_GPA_HOURS < 60.0
        and SHRLGPA.SHRLGPA_GPA < 1.850
        )
        or(
        SHRLGPA.SHRLGPA_GPA_HOURS >= 60.0
        and SHRLGPA.SHRLGPA_GPA < 2.000
        )))

        )

--    ex1 F00163766 con 1
/**************************************/
     /*
     and REL.ASTD_CODE like 'P%'
     and REL.TERM_CODE = STVTERM.STVTERM_CODE
     */
/*       
     and REL.TERM_CODE = STVTERM.STVTERM_CODE
and shrtgpa.shrtgpa_gpa < 2.00
         and REL.ASTD_CODE like 'P%'
   
     and (
     (
         shrtgpa.shrtgpa_gpa < 2.00
         and REL.ASTD_CODE like 'P%'
      )   
         or( REL.ASTD_CODE like 'P%'

        -- main campus standards
        and ((
         SHRLGPA.SHRLGPA_GPA_HOURS < 30.0
         and SHRLGPA.SHRLGPA_GPA < 1.7000000
        )
        or(
        SHRLGPA.SHRLGPA_GPA_HOURS >= 30.0
        and SHRLGPA.SHRLGPA_GPA_HOURS < 60.0
        and SHRLGPA.SHRLGPA_GPA < 1.850
        )
        or(
        SHRLGPA.SHRLGPA_GPA_HOURS >= 60.0
        and SHRLGPA.SHRLGPA_GPA < 2.000
        )
            )         
         )
     )
*/     
/*
     and exists(
     select * from REL_STUDENT_STANDING d2
     where spriden.spriden_pidm = d2.pidm
     and d2.astd_code = 'P1'
     and d2.astd_term_code < stvterm_code
     )
*/
order by

  --STVCLAS.STVCLAS_SURROGATE_ID asc, stvstyp.stvstyp_surrogate_id desc, 
  SPRIDEN.SPRIDEN_LAST_NAME asc, rel.term_code--, SPRIDEN.SPRIDEN_FIRST_NAME
