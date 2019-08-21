# Microsoft Developer Studio Generated NMAKE File, Based on TestDLL.dsp
!IF "$(CFG)" == ""
CFG=TestDLL - Win32 Debug
!MESSAGE No configuration specified. Defaulting to TestDLL - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "TestDLL - Win32 Release" && "$(CFG)" != "TestDLL - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "TestDLL.mak" CFG="TestDLL - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "TestDLL - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "TestDLL - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "TestDLL - Win32 Release"

OUTDIR=.\..
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\..\ 
# End Custom Macros

ALL : "$(OUTDIR)\fwatch.dll"


CLEAN :
	-@erase "$(INTDIR)\apihijack.obj"
	-@erase "$(INTDIR)\chandler.obj"
	-@erase "$(INTDIR)\dllmain.obj"
	-@erase "$(INTDIR)\fdb.obj"
	-@erase "$(INTDIR)\scripth.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\fwatch.dll"
	-@erase "$(OUTDIR)\fwatch.exp"
	-@erase "$(OUTDIR)\fwatch.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /G6 /MT /W3 /Ox /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "TESTDLL_EXPORTS" /Fp"$(INTDIR)\TestDLL.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\TestDLL.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib shlwapi.lib Winmm.lib version.lib /nologo /dll /incremental:no /pdb:"$(OUTDIR)\fwatch.pdb" /machine:I386 /def:".\testdll.def" /out:"$(OUTDIR)\fwatch.dll" /implib:"$(OUTDIR)\fwatch.lib" 
DEF_FILE= \
	".\testdll.def"
LINK32_OBJS= \
	"$(INTDIR)\apihijack.obj" \
	"$(INTDIR)\chandler.obj" \
	"$(INTDIR)\dllmain.obj" \
	"$(INTDIR)\fdb.obj" \
	"$(INTDIR)\scripth.obj"

"$(OUTDIR)\fwatch.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "TestDLL - Win32 Debug"

OUTDIR=.\..
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\..\ 
# End Custom Macros

ALL : "$(OUTDIR)\TestDLL.dll"


CLEAN :
	-@erase "$(INTDIR)\apihijack.obj"
	-@erase "$(INTDIR)\chandler.obj"
	-@erase "$(INTDIR)\dllmain.obj"
	-@erase "$(INTDIR)\fdb.obj"
	-@erase "$(INTDIR)\scripth.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\TestDLL.dll"
	-@erase "$(OUTDIR)\TestDLL.exp"
	-@erase "$(OUTDIR)\TestDLL.ilk"
	-@erase "$(OUTDIR)\TestDLL.lib"
	-@erase "$(OUTDIR)\TestDLL.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MTd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "TESTDLL_EXPORTS" /Fp"$(INTDIR)\TestDLL.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\TestDLL.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib shlwapi.lib /nologo /dll /incremental:yes /pdb:"$(OUTDIR)\TestDLL.pdb" /debug /machine:I386 /def:".\testdll.def" /out:"$(OUTDIR)\TestDLL.dll" /implib:"$(OUTDIR)\TestDLL.lib" /pdbtype:sept 
DEF_FILE= \
	".\testdll.def"
LINK32_OBJS= \
	"$(INTDIR)\apihijack.obj" \
	"$(INTDIR)\chandler.obj" \
	"$(INTDIR)\dllmain.obj" \
	"$(INTDIR)\fdb.obj" \
	"$(INTDIR)\scripth.obj"

"$(OUTDIR)\TestDLL.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("TestDLL.dep")
!INCLUDE "TestDLL.dep"
!ELSE 
!MESSAGE Warning: cannot find "TestDLL.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "TestDLL - Win32 Release" || "$(CFG)" == "TestDLL - Win32 Debug"
SOURCE=..\apihijack.cpp

"$(INTDIR)\apihijack.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=.\chandler.cpp

"$(INTDIR)\chandler.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\dllmain.cpp

"$(INTDIR)\dllmain.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\fdb.cpp

"$(INTDIR)\fdb.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\scripth.cpp

"$(INTDIR)\scripth.obj" : $(SOURCE) "$(INTDIR)"



!ENDIF 

