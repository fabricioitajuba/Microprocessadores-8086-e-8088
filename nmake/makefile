# Para compilar: nmake
# Nome do programa final (sem a extensão .exe)
TARGET = ex01

# Arquivos de código-fonte (.asm) e objetos (.obj)
SOURCES = $(TARGET).asm
OBJECTS = $(TARGET).obj

# Compilador e Linker do MASM 6.11
AS = ml
LD = link

# Flags de Compilação (ML)
# /c   - Apenas compila, não linka automaticamente
# /Zi  - Inclui informações de debug (útil para o CodeView)
# /Fl  - Gera um arquivo de listagem (.lst)
ASFLAGS = /c /Zi /Fl

# Flags do Linker (LINK)
# /CO  - Inclui informações de debug para o CodeView
LDFLAGS = /CO

# Regra principal (padrão)
all: $(TARGET).exe

# Como gerar o executável a partir do objeto
$(TARGET).exe: $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS);

# Como gerar o arquivo objeto a partir do .asm
$(OBJECTS): $(SOURCES)
	$(AS) $(ASFLAGS) $(SOURCES)

# Limpar arquivos temporários gerados no build
clean:
	del *.obj
	del *.lst
	del *.ilk
	del *.pdb

