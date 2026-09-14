rem cd 8086
rem cd nmake
nmake
exe2bin main main.com
del *.obj
del main.exe
main