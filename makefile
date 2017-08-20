
ifeq ($(OS),Windows_NT)
	fnREMOVE_ALL = del /F /S /Q
	fnCOPY_FILE = copy
	fnFIX_PATH = $(subst /,\,$1)
else
	fnREMOVE_ALL = rm -rf
	fnCOPY_FILE = cp -f
	fnFIX_PATH = $1
endif

bin/sgsouzel-win32.exe: src/cppbc_sgs_ouzel.cpp src/sgs_ouzel.cpp sgscript/ext/sgsxgmath.c sgscript/ext/sgs_prof.c ouzel/build/libouzel.a sgscript/lib/libsgscript.a | bin/Resources
	$(CXX) -std=gnu++11 -o $@ $^ -Isgscript/src -Iouzel/ouzel -Louzel/build -louzel -Lsgscript/lib -lsgscript -lkernel32 -luser32 -lgdi32 -lole32 -loleaut32 -lOpenGL32 -ldsound -ld3d11 -ldinput8 -lxinput -luuid -ldxguid -lshlwapi -u WinMain

bin/Resources: ouzel/samples/Resources
	-robocopy $(call fnFIX_PATH,$<) $(call fnFIX_PATH,$@) /E

src/cppbc_sgs_ouzel.cpp: src/sgs_ouzel.hpp | sgscript/bin/sgsvm.exe
	sgscript/bin/sgsvm.exe -p sgscript/ext/cppbc.sgs src/sgs_ouzel.hpp -iname sgs_ouzel.hpp

sgscript/bin/sgsvm.exe:
	$(MAKE) -C sgscript arch=auto vm
sgscript/lib/libsgscript.a:
	$(MAKE) -C sgscript arch=auto static=1
ouzel/build/libouzel.a:
	$(MAKE) -C ouzel/build
