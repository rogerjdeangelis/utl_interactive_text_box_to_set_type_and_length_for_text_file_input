Interactive text box to set type and length for text file input;

A better import than 'proc import' for text files.

see
https://communities.sas.com/t5/Base-SAS-Programming/Reading-raw-data-from-an-external-files/m-p/427974

Bug? SAS interactive functions like window and %window do not work inside DOSUBL.

utl_submit_py64 macro on end of message


A  Pop up textbox will appear

    +--+---------------------------+
    |  |              --   []  [X] |
    +--+---------------+-----------+
    |                              |
    | +--------------------------+ |
    | |informat empid  name      | |
    | +--------------------------+ |
    |                              |
    | [COMMIT]                     |
    |                              |
    +------------------------------+

 All you have to do is edit the informat textbox supplying type and length

    +--+---------------------------+
    |  |              --   []  [X] |
    +--+---------------+-----------+
    |                              |
    | +--------------------------+ |
    | |informat empid 5. name $8.| |
    | +--------------------------+ |
    |                              |
    | [COMMIT]                     |
    |                              |
    +------------------------------+


INPUT Two files, one with variable names and another with data)
================================================================

   d:/txt/meta.txt

      empid  name

   d:/txt/have.txt

      101 Tasin
      102 Andy
      103 Ted
      104 Mikael
      105 Senastien


PROCESS (all the code)
======================

%symdel informat/ nowarn;
data want;

  if _n_=0 then do;
    %let rc=%sysfunc(dosubl(%nrstr(
       * read variable names and place in macro variable nams;
       data _null_;
         infile "d:/txt/meta.txt";
         input;
         call symputx("nams",_infile_);
         put _infile_;
         stop;
       run;quit;

       * use python to create textbox with default "informat empid name";
       %utl_submit_py64(resolve('
        import pyperclip;
       from tkinter import *;
       root=Tk();
       def retrieve_input():;
       .    inputValue=textBox.get("1.0","end-1c");
       .    print(inputValue);
       .    pyperclip.copy(inputValue);
       textBox=Text(root, height=1, width=44);
       textBox.pack();
       textBox.insert(END, "informat &nams");
       buttonCommit=Button(root, height=1, width=10, text="Commit",
                           command=lambda: retrieve_input());
       buttonCommit.pack();
       mainloop();
       '),return=informat);
    )));
   end;

   &informat;
   infile "d:/txt/have.txt";
   input &nams;
run;quit;

OUTPUT
======

  WORK.WANT total obs=5

    EMPID    NAME

     101     Tasin
     102     Andy
     103     Ted
     104     Mikael
     105     Senastie

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data _null_;
  file "d:/txt/meta.txt";
  put "empid" +1 "name";
run;quit;

data _null;
  file "d:/txt/have.txt";
  input empid name$;
  put empid name$;
cards4;
101 Tasin
102 Andy
103 Ted
104 Mikael
105 Senastien
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%symdel informat/ nowarn;
data want;

  if _n_=0 then do;
    %let rc=%sysfunc(dosubl(%nrstr(
       * read variable names and place in macro variable nams;
       data _null_;
         infile "d:/txt/meta.txt";
         input;
         call symputx("nams",_infile_);
         put _infile_;
         stop;
       run;quit;

       * use python to create textbox with default "informat empid name";
       %utl_submit_py64(resolve('
        import pyperclip;
       from tkinter import *;
       root=Tk();
       def retrieve_input():;
       .    inputValue=textBox.get("1.0","end-1c");
       .    print(inputValue);
       .    pyperclip.copy(inputValue);
       textBox=Text(root, height=1, width=44);
       textBox.pack();
       textBox.insert(END, "informat &nams");
       buttonCommit=Button(root, height=1, width=10, text="Commit",
                           command=lambda: retrieve_input());
       buttonCommit.pack();
       mainloop();
       '),return=informat);
    )));
   end;

   %put &=informat;
   &informat;
   infile "d:/txt/have.txt";
   input &nams;
run;quit;

*_
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
;
import pyperclip
from tkinter import *
root=Tk()
def retrieve_input():
    inputValue=textBox.get("1.0","end-1c")
    print(inputValue)
    pyperclip.copy(inputValue)
textBox=Text(root, height=1, width=44)
textBox.pack()
textBox.insert(END, "informat empid name")
buttonCommit=Button(root, height=1, width=10, text="Commit",
      command=lambda:
 retrieve_input())
buttonCommit.pack()
mainloop()

NOTE: 13 records were written to the file PY_PGM.
      The minimum record length was 384.
      The maximum record length was 384.
NOTE: DATA statement used (Total process time):
      real time           0.03 seconds
      cpu time            0.04 seconds


e:\saswork\wrk\_TD4520_BEAST_\py_pgm.py
NOTE: The infile RUT is:
      Unnamed Pipe Access Device,
      PROCESS=C:\Python_27_64bit/python.exe e:\saswork\wrk\_TD4520_BEAST_\py_pgm.py,
      RECFM=V,LRECL=32767

NOTE: 2 lines were written to file PRINT.
NOTE: 2 records were read from the infile RUT.
      The minimum record length was 26.
      The maximum record length was 26.
NOTE: DATA statement used (Total process time):
      real time           18.27 seconds
      cpu time            0.06 seconds


NOTE: Fileref RUT has been deassigned.
NOTE: Fileref PY_PGM has been deassigned.
NOTE: Variable TXT is uninitialized.
NOTE: The infile CLP is:
      (no system-specific pathname available),
      (no system-specific file attributes available)

*******  informat empid 5. name $8.
NOTE: 1 record was read from the infile CLP.
      The minimum record length was 26.
      The maximum record length was 26.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds


323       )));
324      end;
325      %put &=informat;
INFORMAT=informat empid 5. name $8.
326      &informat;
327      infile "d:/txt/have.txt";
328      input &nams;
329   run;

NOTE: The infile "d:/txt/have.txt" is:
      Filename=d:\txt\have.txt,
      RECFM=V,LRECL=32767,File Size (bytes)=56,
      Last Modified=17Jan2018:09:12:49,
      Create Time=04Dec2017:13:47:41

NOTE: 5 records were read from the infile "d:/txt/have.txt".
      The minimum record length was 7.
      The maximum record length was 12.
NOTE: The data set WORK.WANT has 5 observations and 2 variables.
NOTE: DATA statement used (Total process time):
      real time           18.46 seconds
      cpu time            0.23 seconds


*             __   _  _
 _ __  _   _ / /_ | || |    _ __ ___   __ _  ___ _ __ ___
| '_ \| | | | '_ \| || |_  | '_ ` _ \ / _` |/ __| '__/ _ \
| |_) | |_| | (_) |__   _| | | | | | | (_| | (__| | | (_) |
| .__/ \__, |\___/   |_|   |_| |_| |_|\__,_|\___|_|  \___/
|_|    |___/
;


%macro utl_submit_py64(
      pgm
     ,return=  /* name for the macro variable from Python */
     )/des="Semi colon separated set of python commands - drop down to python";

  * write the program to a temporary file;
  filename py_pgm "%sysfunc(pathname(work))/py_pgm.py" lrecl=32766 recfm=v;
  data _null_;
    length pgm  $32755 cmd $1024;
    file py_pgm ;
    pgm=&pgm;
    semi=countc(pgm,';');
      do idx=1 to semi;
        cmd=cats(scan(pgm,idx,';'));
        if cmd=:'. ' then
           cmd=trim(substr(cmd,2));
         put cmd $char384.;
         putlog cmd $char384.;
      end;
  run;quit;
  %let _loc=%sysfunc(pathname(py_pgm));
  %put &_loc;
  filename rut pipe  "C:\Python_27_64bit/python.exe &_loc";
  data _null_;
    file print;
    infile rut;
    input;
    put _infile_;
  run;
  filename rut clear;
  filename py_pgm clear;

  * use the clipboard to create macro variable;
  %if "&return" ^= "" %then %do;
    filename clp clipbrd ;
    data _null_;
     length txt $200;
     infile clp;
     input;
     putlog "*******  " _infile_;
     call symputx("&return",_infile_,"G");
    run;quit;
  %end;

%mend utl_submit_py64;


