rem cd 8086
rem cd Projetos
rem cd Proj02
del Proj02.com
nmake
exe2bin Proj02 Proj02.com
del *.obj
del Proj02.exe
Proj02 A B C D

