Select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    f_format_name(SPRIDEN_PIDM, 'LFMI') Full_Name,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    SGBSTDN.SGBSTDN_LEVL_CODE Student_Level,
    SGBSTDN.SGBSTDN_STST_CODE Reg_Status,
    STVCLAS.STVCLAS_DESC Student_Class,
    STVDEGC.STVDEGC_CODE Degree_Program,
    STVMAJR.STVMAJR_DESC Major_Program,
    case
      when ((SHRLGPA.SHRLGPA_GPA > 3.0) and (SHRLGPA.SHRLGPA_GPA < 3.333)) then 'Cum Laude'
      when ((SHRLGPA.SHRLGPA_GPA > 3.334) and (SHRLGPA.SHRLGPA_GPA < 3.829)) then 'Magna Cum Laude'
      when ((SHRLGPA.SHRLGPA_GPA > 3.830)) then 'Summa Cum Laude'
        else ''
          end as Graduating_Honors,

    case
         when SHRTTRM.SHRTTRM_ASTD_CODE_DL in ('PR','PL') then 'Presidents List'
         when SHRTTRM.SHRTTRM_ASTD_CODE_DL = 'DL' then 'Deans List'
           else ''
    end as Deans_List,

    case
         when SGRSATT.SGRSATT_ATTS_CODE = 'UHON' then 'Upper Division Honors'
           else ''
    end as Honors_Student,

    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Exp_Grad_Date,
    GOREMAL.GOREMAL_EMAIL_ADDRESS Email_Address

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = :DropDown1.STVTERM_CODE

    join SPBPERS SPBPERS on SPBPERS.SPBPERS_pidm = SPRIDEN.SPRIDEN_PIDM

    left outer join SARADAP SARADAP on SARADAP.SARADAP_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SARADAP.SARADAP_TERM_CODE_ENTRY = STVTERM.STVTERM_CODE

    join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
        and GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')

    left outer join SGRSATT SGRSATT on SGRSATT.SGRSATT_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGRSATT.SGRSATT_ATTS_CODE = 'UHON'
         and SGRSATT.SGRSATT_TERM_CODE_EFF = (
             select max(SGRSATT_TERM_CODE_EFF)
             from SGRSATT SGRSATT2
             where SGRSATT2.SGRSATT_PIDM = SPRIDEN.SPRIDEN_PIDM)

    left outer join SHRTTRM SHRTTRM on SHRTTRM.SHRTTRM_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRTTRM.SHRTTRM_ASTD_CODE_DL in ('PL','PR','DL')
         and SHRTTRM.SHRTTRM_TERM_CODE = (
             select max(SHRTTRM_TERM_CODE)
             from SHRTTRM SHRTTRM2
             where SHRTTRM2.SHRTTRM_PIDM = SPRIDEN.SPRIDEN_PIDM)

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA_GPA_TYPE_IND = 'O'
         and SHRLGPA_LEVL_CODE = SGBSTDN_LEVL_CODE

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

    left outer join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1

    left outer join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and SGBSTDN.SGBSTDN_DEGC_CODE_1 = :DropDown4.SGBSTDN_DEGC_CODE_1
    and SGBSTDN.SGBSTDN_STST_CODE = 'IG'
    and SGBSTDN.SGBSTDN_LEVL_CODE = :DropDown2.STVLEVL_CODE

--$beginorder

order by
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME

--$endorder