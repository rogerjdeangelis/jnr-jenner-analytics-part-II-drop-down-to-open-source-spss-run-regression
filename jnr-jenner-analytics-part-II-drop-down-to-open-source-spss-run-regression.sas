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

NOTE: Processing inline DATALINES (5 lines)

NOTE: Read 5 rows from DATALINES.
NOTE: The data set SAV.HAVE has 5 observations and 4 variables.
NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.02 seconds
NOTE: PROC PRINT data=sav.have

NOTE: PROC PRINT completed: 5 observations printed, 4 variables

/******************************************************************************************************************/
/* 4  SPSS Regression AOV                                                                                         */
/******************************************************************************************************************/

%utlfkil(d:\sav\want.sav);

%symdel from / nowarn;

%jnr_psppbegin;
cards4;
GET FILE="d:/sav/have.sav".
REGRESSION
/VARIABLES=weight
  /DEPENDENT=age
  /METHOD=ENTER
  /SAVE PRED RESID.
SAVE
OUTFILE="d:\sav\want.sav".
HOST COMMAND=['<nul set /p="Hello from SPSS" | clip'].
;;;;
%jnr_psppend(return=from);

%put --- &=from ---;

libname sav spss "d:/sav";
options nocenter;
proc print data=sav.want;
title "Residuals and Predicted Values";
run;

LIST: 11:33:51
==============

Macro variable from was created from SPSS

--- FROM=Hello from SPSS ---

                    Model Summary (AGE)
+---+--------+-----------------+--------------------------+
| R |R Square|Adjusted R Square|Std. Error of the Estimate|
+---+--------+-----------------+--------------------------+
|.78|     .62|              .49|                       .39|
+---+--------+-----------------+--------------------------+

                     ANOVA (AGE)
+----------+--------------+--+-----------+----+----+
|          |Sum of Squares|df|Mean Square|  F |Sig.|
+----------+--------------+--+-----------+----+----+
|Regression|           .74| 1|        .74|4.81|.116|
|Residual  |           .46| 3|        .15|    |    |
|Total     |          1.20| 4|           |    |    |
+----------+--------------+--+-----------+----+----+

                              Coefficients (AGE)
+----------+----------------------------+-------------------------+----+----+
|          | Unstandardized Coefficients|Standardized Coefficients|    |    |
|          +-----------+----------------+-------------------------+    |    |
|          |     B     |   Std. Error   |           Beta          |  t |Sig.|
+----------+-----------+----------------+-------------------------+----+----+
|(Constant)|       9.45|            1.90|                      .00|4.98|.008|
|WEIGHT    |        .04|             .02|                      .78|2.19|.116|
+----------+-----------+----------------+-------------------------+----+----+

Residuals and Predicted Values

  Obs  NAME      SEX  AGE  WEIGHT   RES1  PRED1

    1  Alfred    M     14     113  -0.12  14.12
    2  Alice     F     13      84   0.06  12.94
    3  Barbara   F     13      98  -0.52  13.52
    4  Carol     F     14     103   0.29  13.71
    5  Henry     M     14     103   0.29  13.71


LOG:  11:55:44
==============

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

LOG:  11:55:44
NOTE: DATA _null_ completed. Output written to FILE PRINT
NOTE: Option SASAUTOS changed to c:/otojnr.
NOTE: DATA _null_

NOTE: Reading from fileref c:/jnr/runsas_selection.sas (c:/jnr/runsas_selection.sas)
    1
    2 %utlfkil(d:\sav\want.sav);
    3
    4 %symdel from / nowarn;
    5
    6 %jnr_psppbegin;
    7 cards4;
    8 GET FILE="d:/sav/have.sav".
    9 REGRESSION
   10 /VARIABLES=weight
   11   /DEPENDENT=age
   12   /METHOD=ENTER
   13   /SAVE PRED RESID.
   14 SAVE
   15 OUTFILE="d:\sav\want.sav".
   16 HOST COMMAND=['<nul set /p="Hello from SPSS" | clip'].
   17 ;;;;
   18 %jnr_psppend(return=from);
   19
   20 %put --- &=from ---;
   21
   22 libname sav spss "d:/sav";
   23 options nocenter;
   24 proc print data=sav.want;
   25 title "Residuals and Predicted Values";
   26 run;

NOTE: Read 26 rows from c:/jnr/runsas_selection.sas.
NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.02 seconds
NOTE: DATA _null_

autoexec completed  11:55:44

NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
NOTE: DATA _null_

NOTE: Writing to fileref D:\wpswrk/pspp_resolve.sps (D:\wpswrk/pspp_resolve.sps)
NOTE: Processing inline DATALINES (9 lines)
GET FILE="d:/sav/have.sav".
REGRESSION
/VARIABLES=weight
  /DEPENDENT=age
  /METHOD=ENTER
  /SAVE PRED RESID.
SAVE
OUTFILE="d:\sav\want.sav".
HOST COMMAND=['<nul set /p="Hello from SPSS" | clip'].

NOTE: Read 9 rows from DATALINES.
NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
NOTE: Fileref RUT assigned to device PIPE (payload: c:\PROGRA~1\PSPP\bin\pspp.exe D:\wpswrk/pspp_resolve.sps).
NOTE: DATA _null_

NOTE: Reading from fileref rut (D:\wpswrk\jenner_pipe_RUT_34b5ece8f8c44e59bd14e21422c86167.tmp)
                    Model Summary (AGE)
+---+--------+-----------------+--------------------------+
| R |R Square|Adjusted R Square|Std. Error of the Estimate|
+---+--------+-----------------+--------------------------+
|.78|     .62|              .49|                       .39|
+---+--------+-----------------+--------------------------+

                     ANOVA (AGE)
+----------+--------------+--+-----------+----+----+
|          |Sum of Squares|df|Mean Square|  F |Sig.|
+----------+--------------+--+-----------+----+----+
|Regression|           .74| 1|        .74|4.81|.116|
|Residual  |           .46| 3|        .15|    |    |
|Total     |          1.20| 4|           |    |    |
+----------+--------------+--+-----------+----+----+

                              Coefficients (AGE)
+----------+----------------------------+-------------------------+----+----+
|          | Unstandardized Coefficients|Standardized Coefficients|    |    |
|          +-----------+----------------+-------------------------+    |    |
|          |     B     |   Std. Error   |           Beta          |  t |Sig.|
+----------+-----------+----------------+-------------------------+----+----+
|(Constant)|       9.45|            1.90|                      .00|4.98|.008|
|WEIGHT    |        .04|             .02|                      .78|2.19|.116|
+----------+-----------+----------------+-------------------------+----+----+

NOTE: Read 25 rows from rut.
NOTE: DATA elapsed:
  wall  0.01 seconds
  cpu   0.00 seconds
NOTE: Fileref RUT cleared.
NOTE: Fileref CLIP assigned to device CLIPBRD (payload: (none)).
NOTE: DATA _null_

NOTE: Reading from fileref clip (D:\wpswrk\jenner_clipbrd_CLIP_8c965c0422ee4b99bcc00b1908b98b43.tmp)

*******  Hello from SPSS   ********

NOTE: Read 1 rows from clip.
NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
--- FROM=Hello from SPSS ---
NOTE: Library SAV assigned path=d:/sav.
NOTE: PROC PRINT data=sav.want

NOTE: PROC PRINT completed: 5 observations printed, 6 variables


/******************************************************************************************************************/
/* 5  DUCKDB MIN AND MAX RESIDUALS                                                                                */
/******************************************************************************************************************/

%symdel from / nowarn;

%utlfkil(d:/parquet/maxmin.parquet)

%jnr_duckbeginx;
cards4;
LOAD read_stat;
drop table if exists maxmin;
create
   table maxmin as
select
   max(res1) as residual_max
  ,min(res1) as residual_min
from
  read_stat('d:/sav/want.sav');
COPY maxmin TO 'd:/parquet/maxmin.parquet' (FORMAT PARQUET);
.mode list
.headers off
.once |clip.exe
SELECT 'Hello from duckDb';
;;;;
%jnr_duckendx(
  return=from);

%put --- &=from ---;

options nocenter;
proc print data='d:/parquet/maxmin.parquet';
title "duckdb Maximums and Minimuns"
run;

LIST: 11:01:15
==============

FROM LOG

--- FROM=Hello from duckDb ---

duckdb Maximums and Minimuns

  Obs  residual_max   residual_min

    1  0.2920457196  -0.5211103336

LOG:  10:59:19
==============

NOTE: Copyright (c) 2026 Jenner Analytics Ltd., London, England.
NOTE: Jenner v1.5.97 (build v1.5.97+921fdf5fb7.20261010T011618Z)
      Licensed to Roger DeAngelis, Serial 3BF7B3E6.
NOTE: DATA _null_

autexec started.

NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.02 seconds
NOTE: Library WORKX assigned path=d:\wpswrkx.
NOTE: DATA workx.class

NOTE: Processing inline DATALINES (19 lines)

NOTE: Read 19 rows from DATALINES.
NOTE: The data set WORKX.CLASS has 19 observations and 5 variables.
NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
NOTE: DATA _null_

LOG:  10:59:19
NOTE: DATA _null_ completed. Output written to FILE PRINT
NOTE: Option SASAUTOS changed to c:/otojnr.
NOTE: DATA _null_

NOTE: Reading from fileref c:/jnr/runsas_selection.sas (c:/jnr/runsas_selection.sas)
    1 %symdel from / nowarn;
    2
    3 %utlfkil(d:/parquet/maxmin.parquet)
    4
    5 %jnr_duckbeginx;
    6 cards4;
    7 LOAD read_stat;
    8 drop table if exists maxmin;
    9 create
   10    table maxmin as
   11 select
   12    max(res1) as residual_max
   13   ,min(res1) as residual_min
   14 from
   15   read_stat('d:/sav/want.sav');
   16 COPY maxmin TO 'd:/parquet/maxmin.parquet' (FORMAT PARQUET);
   17 .mode list
   18 .headers off
   19 .once |clip.exe
   20 SELECT 'Hello from duckDb';
   21 ;;;;
   22 %jnr_duckendx(
   23   return=from);
   24
   25 %put --- &=from ---;

NOTE: Read 25 rows from c:/jnr/runsas_selection.sas.
NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
NOTE: DATA _null_

autoexec completed  10:59:19

NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
NOTE: DATA _null_

NOTE: Writing to fileref D:\wpswrk/duck_resolve.sql (D:\wpswrk/duck_resolve.sql)
NOTE: Processing inline DATALINES (14 lines)
LOAD read_stat;
drop table if exists maxmin;
create
   table maxmin as
select
   max(res1) as residual_max
  ,min(res1) as residual_min
from
  read_stat('d:/sav/want.sav');
COPY maxmin TO 'd:/parquet/maxmin.parquet' (FORMAT PARQUET);
.mode list
.headers off
.once |clip.exe
SELECT 'Hello from duckDb';

NOTE: Read 14 rows from DATALINES.
NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
NOTE: Fileref RUT assigned to device PIPE (payload: duckdb  -f D:\wpswrk/duck_resolve.sql).
NOTE: DATA _null_

NOTE: Reading from fileref rut (D:\wpswrk\jenner_pipe_RUT_51c6b2a0cc6b441fafe489a341ee0955.tmp)

NOTE: Read 0 rows from rut.
NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
NOTE: Fileref RUT cleared.
NOTE: Fileref CLP assigned to device CLIPBRD (payload: (none)).
NOTE: DATA _null_

NOTE: Reading from fileref clp (D:\wpswrk\jenner_clipbrd_CLP_99b63daa35bd4758be524f2ab9d2cc9a.tmp)
*******  Hello from duckDb   ********

NOTE: Read 1 rows from clp.
NOTE: DATA elapsed:
  wall  0.00 seconds
  cpu   0.00 seconds
--- FROM=Hello from duckDb ---


/******************************************************************************************************************/
/* 6  CREATE HTML TABLE FROM DUCKDB MAXMIN TABLE                                                                  */
/******************************************************************************************************************/

ods html file="d:/htm/jnr_maxmin.html";
options nocenter;
proc print data='d:/parquet/maxmin.parquet';
title "duckdb Maximums and Minimuns"
run;
ods html close;


/******************************************************************************************************************/
/* 7  DROPDOWN SANWICHES TO DUCKDB AND SPSS                                                                       */
/******************************************************************************************************************/


filename ft15f001 "c:/otojnr/jnr_duckbeginx.sas";
parmcards4;
%macro jnr_duckbeginx(
    resolve=Y
    )/des="Allow additional quote(backtic) and provide for macro resolution";

  %local pth;
  %let pth=%sysfunc(pathname(work));

  %utlfkil(&pth/duck_resolve.sql);

  data _null_;
    length _infile_ $255;
    file "&pth/duck_resolve.sql";
    input;
    if upcase("&resolve")=:"Y" then _infile_=resolve(_infile_);
    if index(_infile_,"`") then
        _infile_=translate(_infile_,"27"x,"`");
    put _infile_;
    putlog _infile_;

%mend jnr_duckbeginx;
;;;;
run;


filename ft15f001 "c:/otojnr/jnr_duckendx.sas";
parmcards4;
%macro jnr_duckendx(
   duckdb=
   ,prq=d:/parquet
   ,return=
   )/des="DUCKDB  execute sql script";
run;

/*--- to pass text into a windows clipboard us the following
.mode list
.headers off
.once |clip.exe
SELECT 'Hello from duckDb';
---*/

  %local pth;
  %let pth=%sysfunc(pathname(work));

  options noxwait noxsync;
  filename rut pipe "duckdb &duckdb -f &pth/duck_resolve.sql";
  run;quit;
  data _null_;
    infile rut;
    input;
    putlog _infile_;
  run;

  filename rut clear;

  * use the clipboard to create macro variable;
  %if "&return" ^= "" %then %do;
    %*let return=from;
    filename clp clipbrd;
    data _null_;
     infile clp;
     input;
     putlog "*******  " _infile_ "  ********";
     call symputx("&return",_infile_,"G");
    run;quit;
  %end;

%mend jnr_duckendx;
;;;;
run;


filename ft15f001 "c:/otojnr/jnr_psppbegin.sas";
parmcards4;
%macro jnr_psppbegin(
    resolve=Y
    )/des="Allow additional quote(backtic) and provide for macro resolution";

  %local pth;
  %let pth=%sysfunc(pathname(work));

  %utlfkil(&pth/pspp_resolve.sps);

  data _null_;
    length _infile_ $255;
    file "&pth/pspp_resolve.sps";
    input;
    if upcase("&resolve")=:"Y" then _infile_=resolve(_infile_);
    if index(_infile_,"`") then
        _infile_=translate(_infile_,"27"x,"`");
    put _infile_;
    putlog _infile_;

%mend jnr_psppbegin;
;;;;
run;

filename ft15f001 "c:/otojnr/jnr_psppend.sas";
parmcards4;
%macro jnr_psppend(
    return=
   )/des="execute spss script";
run;
  %local pth;
  %let pth=%sysfunc(pathname(work));

  options noxwait noxsync;
  filename rut pipe "c:\PROGRA~1\PSPP\bin\pspp.exe &pth/pspp_resolve.sps";
  run;quit;
  data _null_;
    infile rut;
    input;
    putlog _infile_;
    file print;
    put _infile_;
  run;

  filename rut clear;

  * use the clipboard to create macro variable;
  %if "&return" ^= "" %then %do;
    filename clip clipbrd;
    data _null_;
     infile clip;  /*--- created from the SPSS script ---*/
     input;
     putlog "*******  " _infile_ "  ********";
     call symputx("&return",_infile_,"G");
    run;quit;
  %end;

%mend jnr_psppend;
;;;;
run;

/******************************************************************************************************************/
/*  END                                                                                                           */
/******************************************************************************************************************/
