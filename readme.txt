OLCS-Ranker is a post-database searching software for peptide identification. The
software package implements solvers for cost-sensitive Ranker (CS-Ranker) model.
The goal of the package is to identify correct PSMs output from the database
searching engines based on target-decoy strategy. OLCS-Ranker do not depend on
any particular searching engine. It could be applied to deal with the PSM records
output by the search engine of Sequest, X!Tandem, Mascot, Tide, Comet, etc., once
the sample data are provided in the required format. OLCS-Ranker is developed
mainly in Matlab and naturally supports Matlab platform. Moreover, the complied
Exe files are also provided, thus OLCS-Ranker commands could also run in Windows
OS after installing Matlab Runtime Complier (MRC, a free software). Alternatively,
we have also provided a web-based GUI for users of OLCS-Ranker. A user can visit
http://161.6.5.181:8000/olcs-ranker/. In case that the server is under maintenance,
please contact zhonghang.xia@wku.edu.


Exe files of OLCS-Ranker 

Version 4.4.2



1. Prerequisites for Deployment 

. Verify the MATLAB runtime is installed and ensure you    have installed version 8.5 (R2015a).   

. If the MATLAB runtime is not installed, do the following:
  (1) enter
  
      >>mcrinstaller
      
      at MATLAB prompt. The MCRINSTALLER command displays the 
      location of the MATLAB runtime installer.

  (2) run the MATLAB runtime installer.

Or download the Windows 64-bit version of the MATLAB runtime for R2015a 
from the MathWorks Web site by navigating to

   http://www.mathworks.com/products/compiler/mcr/index.html
   
   
For more information about the MATLAB runtime and the MATLAB runtime installer, see Package and Distribute in the MATLAB Compiler documentation  in the MathWorks Documentation Center.    


NOTE: You will need administrator rights to run MCRInstaller. 


2. Files to Deploy and Package

Files to package for Standalone 
================================
-olcs_read.exe
-olcs_solve.exe
-olcs_write.exe
-olcs_version.exe
-olcs_split.exe
-MCRInstaller.exe 
   -if end users are unable to download the MATLAB runtime using the above  link, include it when building your component by clicking the "Runtime downloaded from web" link in the Deployment Tool
 -This readme file 

3. Definitions

For information on deployment terminology, go to http://www.mathworks.com/help. Select MATLAB Compiler >   Getting Started > About Application Deployment > Application Deployment Terms in the MathWorks Documentation Center.





