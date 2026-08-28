# Microprocessadores 8086 e 8088

### - Copiar a pasta /8086 para dentro da pasta do DOSBOX

### - Copiar a pasta /Exemplos para dentro da pasta /8086

### - Editar o arquivo dosbox.conf e inserir as seguintes linhas no final do arquivo:

```
[autoexec]
@echo off
MOUNT C C:\DOSBox
SET PATH=C:\8086\MASM;%PATH%
SET PATH=C:\8086\TASM;%PATH%
C:
```

### - para montar usando o MASM (compilar):
masm ex01.asm;

### - para linkar usando o MASM:
link ex01.obj;

### - para executar:
ex01
