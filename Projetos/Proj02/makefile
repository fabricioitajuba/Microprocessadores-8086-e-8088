# Nome do executável final
TARGET = Proj02.exe

# Lista de todos os arquivos objetos (.obj) que serão gerados
# Adicione aqui os nomes de todos os seus módulos separados por espaço
OBJECTS = Proj02.obj imp_car.obj imp_hexa.obj imp_deci.obj crlf.obj imp_str.obj

# Compilador e Linker do MASM 6.11
AS = ml
LD = link

# Flags de Compilação
# /c   - Apenas compila para .obj (obrigatório para múltiplos arquivos)
# /Zi  - Inclui informações de debug para o CodeView (opcional)
ASFLAGS = /c /Zi

# Flags do Linker
# /CO  - Mantém informações de debug no executável (opcional)
LDFLAGS = /CO

# Regra principal (Alvo padrão)
all: $(TARGET)

# Regra de Linkagem: Junta todos os .obj em um .exe
$(TARGET): $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS), $(TARGET);

# Regra de Sufixo (Regra Implícita): 
# Ensina o NMAKE a transformar qualquer arquivo .asm em .obj automaticamente
.asm.obj:
	$(AS) $(ASFLAGS) $<

# Limpar arquivos temporários e executáveis antigos
clean:
	del *.obj
	del *.exe
	del *.ilk
	del *.pdb
	del *.lst

