rem cd 8086
rem cd Projetos
rem cd Proj01
nmake
exe2bin Proj01 Proj01.com
del *.obj
del Proj01.exe
Proj01
