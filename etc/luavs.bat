@rem Script to build Lua under "Visual Studio .NET Command Prompt".
@rem Do not run from this directory; run it from the toplevel: etc\luavs.bat .
@rem It creates lua51_Win32.dll, lua51_Win32.lib, lua.exe, and luac.exe in src.
@rem (contributed by David Manura and Mike Pall)

@setlocal
@call "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" x86

@rem Check if debug mode is requested via command line argument
@if "%1"=="debug" (
  @echo Building in DEBUG mode with PDB files and assertions enabled...
  @set MYCOMPILE=cl /nologo /MDd /Od /Zi /W3 /c /D_CRT_SECURE_NO_DEPRECATE /D_DEBUG /DLUA_USE_APICHECK
  @set MYLINK=link /nologo /DEBUG /PDB:
) else (
  @echo Building in RELEASE mode...
  @set MYCOMPILE=cl /nologo /MD /O2 /W3 /c /D_CRT_SECURE_NO_DEPRECATE
  @set MYLINK=link /nologo
)
@set MYMT=mt /nologo

cd src
%MYCOMPILE% /DLUA_BUILD_AS_DLL l*.c
del lua.obj luac.obj
@if "%1"=="debug" (
  %MYLINK%lua51_Win32.pdb /DLL /out:lua51_Win32.dll l*.obj
) else (
  %MYLINK% /DLL /out:lua51_Win32.dll l*.obj
)
if exist lua51_Win32.dll.manifest^
  %MYMT% -manifest lua51_Win32.dll.manifest -outputresource:lua51_Win32.dll;2
%MYCOMPILE% /DLUA_BUILD_AS_DLL lua.c
@if "%1"=="debug" (
  %MYLINK%lua.pdb /out:lua.exe lua.obj lua51_Win32.lib
) else (
  %MYLINK% /out:lua.exe lua.obj lua51_Win32.lib
)
if exist lua.exe.manifest^
  %MYMT% -manifest lua.exe.manifest -outputresource:lua.exe
%MYCOMPILE% l*.c print.c
del lua.obj linit.obj lbaselib.obj ldblib.obj liolib.obj lmathlib.obj^
    loslib.obj ltablib.obj lstrlib.obj loadlib.obj
@if "%1"=="debug" (
  %MYLINK%luac.pdb /out:luac.exe *.obj
) else (
  %MYLINK% /out:luac.exe *.obj
)
if exist luac.exe.manifest^
  %MYMT% -manifest luac.exe.manifest -outputresource:luac.exe
@if "%1"=="debug" (
  del *.obj *.manifest
  @echo Debug build complete - PDB files generated
) else (
  del *.obj *.manifest
)
cd ..
