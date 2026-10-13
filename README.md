# jnr-jenner-analytics-part-II-drop-down-to-open-source-spss-run-regression
Jenner Analytics part II drop down to open source spss run regression
     /*---
     c:/utl/jnr-jenner-analytics-part-II-drop-down-to-open-source-spss-run-regression.sas
     ---*/
    
     Jenner Analytics part II drop down to open source spss run regression
    
     One of the nice features of this post is the integration of three languages in one
     Jenner Script. Jenner/SPSS/duckDB.
    
     Too long to post see
     https://github.com/rogerjdeangelis/jnr-jenner-analytics-part-II-drop-down-to-open-source-spss-run-regression
    
     Related
     https://github.com/rogerjdeangelis/jnr-jenner-analytics-part-I-inline-drop-down-to-duckdb-sql
    
    CONTENTS
    
       1  How to install duckDB packages (only need to do once, like packages in R and Python)
       2  How duckDB sanwich macro returns a macro variables to Jenner
       3  Create Regression input SPSS Table
       4  SPSS Regression AOV Outputs
       5  DuckDB min and max of residuals
       6  Create html table from duckDB maxmin table
       7  Drop down macro sanwiches for SPSS and duckDB
    
    /******************************************************************************************************************/
    /* 1. HOW TO INSTALL PACKAGES INTO YOUR DATABASE, D:/DUCKDB/MYDB.DUCKDB                                           */
    /*    THIS ONLY HAS TO BE DONE ONCE.                                                                              */
    /*    NOTE POSTGRES IS A MINIMUM CROSS COMPILER NOT THE FULL POSTGRES BINARY                                      */
    /******************************************************************************************************************/
    
    /*--- LOAD PACKAGE READ_STAT AND POSTGRES INTO MYDB.DAUCDB ---*/
    %jnr_duckbeginx;
    cards4;
    INSTALL read_stat FROM community;
    INSTALL postgres;
    ;;;;
    %jnr_duckendx(
      duckdb=d:/duckdb/mydb.duckdb);
    
    
    /******************************************************************************************************************/
    /* 2  HOW DUCKDB SANWICH MACRO RETURNS A MACRO VARIABLES TO JENNER                                                */
    /******************************************************************************************************************/
    
    /*--- SEND SELECTED TEXT TO WINDOWS CLIPBOARD ---*/
    %jnr_duckbeginx;
    cards4;
    .mode list
    .headers off
    .once |clip.exe
    SELECT 'Hello from duckDb';
    ;;;;
    %jnr_duckendx(return=from);
    
    %put &=from;
    
    /*--- THIS WILL APPEAR IN THE LOG ---*/
    FROM=Hello from duckDb
    
    /*--- THIS IS HOW MACRO JNR_DUCKENDX READS THE CLIPBOARD AND POPULATES MACRO VARIABLE FROM
    filename clp clipbrd;
    data _null_;
      infile clp;
      input;
      putlog _infile_;
      call symputx("&return",_infile_);
    ---*/
    
    LOG:   9:57:58
    -=============
    
    NOTE: Copyright (c) 2026 Jenner Analytics Ltd., London, England.
    NOTE: Jenner v1.5.97 (build v1.5.97+921fdf5fb7.20261010T011618Z)
          Licensed to Roger DeAngelis, Serial 3BF7B3E6.
    NOTE: DATA _null_
    
    autexec started.
    
    NOTE: DATA elapsed:
      wall  0.00 seconds
      cpu   0.00 seconds
    NOTE: Library WORKX assigned path=d:\wpswrkx.
    NOTE: DATA workx.class
    
    NOTE: Processing inline DATALINES (19 lines)
    
    NOTE: Read 19 rows from DATALINES.
    NOTE: The data set WORKX.CLASS has 19 observations and 5 variables.
    NOTE: DATA elapsed:
      wall  0.00 seconds
      cpu   0.00 seconds
    NOTE: DATA _null_
    
    LOG:   9:57:58
    NOTE: DATA _null_ completed. Output written to FILE PRINT
    NOTE: Option SASAUTOS changed to c:/otojnr.
    NOTE: DATA _null_
    
    NOTE: Reading from fileref c:/jnr/runsas_selection.sas (c:/jnr/runsas_selection.sas)
        1 %jnr_duckbeginx;
        2 cards4;
        3 .mode list
        4 .headers off
        5 .once |clip.exe
        6 SELECT 'Hello from duckDb';
        7 ;;;;
        8 %jnr_duckendx(return=from);
        9
       10 %put &=from;
    
    NOTE: Read 10 rows from c:/jnr/runsas_selection.sas.
    NOTE: DATA elapsed:
      wall  0.00 seconds
      cpu   0.00 seconds
    NOTE: DATA _null_
    
    autoexec completed   9:57:58
    
    NOTE: DATA elapsed:
      wall  0.00 seconds
      cpu   0.00 seconds
    NOTE: DATA _null_
    
    NOTE: Writing to fileref D:\wpswrk/duck_resolve.sql (D:\wpswrk/duck_resolve.sql)
    NOTE: Processing inline DATALINES (4 lines)
    .mode list
    .headers off
    .once |clip.exe
    SELECT 'Hello from duckDb';
    
    NOTE: Read 4 rows from DATALINES.
    NOTE: DATA elapsed:
      wall  0.00 seconds
      cpu   0.00 seconds
    NOTE: Fileref RUT assigned to device PIPE (payload: duckdb  -f D:\wpswrk/duck_resolve.sql).
    NOTE: DATA _null_
    
    NOTE: Reading from fileref rut (D:\wpswrk\jenner_pipe_RUT_93edb86e1ee74511bf3aac4526e536dc.tmp)
    
    NOTE: Read 0 rows from rut.
    NOTE: DATA elapsed:
      wall  0.00 seconds
      cpu   0.00 seconds
    NOTE: Fileref RUT cleared.
    NOTE: Fileref CLP assigned to device CLIPBRD (payload: (none)).
    NOTE: DATA _null_
    
    NOTE: Reading from fileref clp (D:\wpswrk\jenner_clipbrd_CLP_11f36c44cff34c12a7316146357115a2.tmp)
    *******  Hello from duckDb   ********
    
    NOTE: Read 1 rows from clp.
    
    NOTE: DATA elapsed:
      wall  0.01 seconds
      cpu   0.00 seconds
    
    FROM=Hello from duckDb
    
    /******************************************************************************************************************/
    /* 3  CREATE REGRESSION INPUT SPSS TABLE                                                                          */
    /******************************************************************************************************************/
    
    %utlfkil(d:/sav/have.sav);
    
    libname sav spss "d:/sav";
    
    data sav.have; /* creates spss d:/sav/have.sav  ---*/
    informat
      NAME $8.
      SEX $1.
      AGE 8.
      WEIGHT 8.
    ;
    input
     NAME SEX AGE WEIGHT;
    cards4;
    Alfred M 14 112.5
    Alice F 13 84
    Barbara F 13 98
    Carol F 14 102.5
    Henry M 14 102.5
    ;;;;
    run;quit;
    
    options nocenter;
    proc print data=sav.have;
    title "Input for SPSS Regression";
    run;
    
    1 LIST: 16:22:36
    ================
    
    Input for SPSS Regression
    
      Obs  NAME      SEX  AGE  WEIGHT
    
        1  Alfred    M     14     113
        2  Alice     F     13      84
        3  Barbara   F     13      98
        4  Carol     F     14     103
        5  Henry     M     14     103
    
    1 LOG:  16:22:36
    ================
    
    NOTE: Copyright (c) 2026 Jenner Analytics Ltd., London, England.
    NOTE: Jenner v1.5.97 (build v1.5.97+921fdf5fb7.20261010T011618Z)
          Licensed to Roger DeAngelis, Serial 3BF7B3E6.
    NOTE: DATA _null_
    
    autexec started.
    
    NOTE: DATA elapsed:
      wall  0.00 seconds
      cpu   0.00 seconds
    NOTE: Library WORKX assigned path=d:\wpswrkx.
    NOTE: DATA workx.class
    
    NOTE: Processing inline DATALINES (19 lines)
    
    NOTE: Read 19 rows from DATALINES.
    NOTE: The data set WORKX.CLASS has 19 observations and 5 variables.
    NOTE: DATA elapsed:
      wall  0.00 seconds
      cpu   0.00 seconds
    NOTE: DATA _null_
    
    NOTE: DATA _null_ completed. Output written to FILE PRINT
    NOTE: Option SASAUTOS changed to c:/otojnr.
    NOTE: DATA _null_
    
    NOTE: Reading from fileref c:/jnr/runsas_selection.sas (c:/jnr/runsas_selection.sas)
        1 libname sav spss "d:/sav";
        2 data sav.have; /* creates spss d:/sav/have.sav  ---*/
        3 informat
        4   NAME $8.
        5   SEX $1.
        6   AGE 8.
        7   WEIGHT 8.
        8 ;
        9 input
       10  NAME SEX AGE WEIGHT;
       11 cards4;
       12 Alfred M 14 112.5
       13 Alice F 13 84
       14 Barbara F 13 98
       15 Carol F 14 102.5
       16 Henry M 14 102.5
       17 ;;;;
       18 run;quit;
       19
       20 options nocenter;
       21 proc print data=sav.have;
       22 title "Input for SPSS Regression";
       23 run;
    
    NOTE: Read 23 rows from c:/jnr/runsas_selection.sas.
    NOTE: DATA elapsed:
      wall  0.00 seconds
      cpu   0.00 seconds
    NOTE: DATA _null_
    
    autoexec completed  16:22:36
    
    NOTE: DATA elapsed:
      wall  0.00 seconds
      cpu   0.00 seconds
    NOTE: Library SAV assigned path=d:/sav.
    NOTE: SAV has no row-streaming writer; streaming to intermediate D:\wpswrk\have.sav.dsj_stage.avro and converting at step end.
    NOTE: DATA sav.have
    
    NOTE: ed:
      wall  0.00 seconds
      cpu   0.00 seconds
    NOTE: Library SAV assigned path=d:/sav.
    NOTE: SAV has no row-streaming writer; streaming to intermediate D:\wpswrk\have.sav.dsj_stage.avro and converting at step end.
    NOTE: DATA sav.have
    
    NOTE: 
