
ROOTDIR = ../../..
VMDIR = ../..

include $(ROOTDIR)/nopsys/compilation.conf
include plugins

# -ffreestanding
CFLAGS = $(CFLAGS_ARCH) -std=gnu11 -Wall --no-pie -nostdinc -nostdlib \
			-fno-stack-protector -g -O1 -fno-inline -fno-omit-frame-pointer -r \
			-Wno-unknown-pragmas 

DEFS  = -DNO_STD_FILE_SUPPORT -DDEBUG -DLSB_FIRST $(DEFS_ARCH) $(XDEFS)

COGDIR    = $(VMDIR)/spur64src/vm
CROSSDIR  = $(VMDIR)/platforms/Cross
NOPSYSDIR = $(VMDIR)/platforms/nopsys

VM_BUILDDIR=../opensmalltalk-vm/platforms/nopsys/build

OPENLIBMDIR = $(VMDIR)/third-party/openlibm
OPENLIBM = $(OPENLIBMDIR)/libopenlibm.a


CROSS_C_FILES  = $(wildcard $(CROSSDIR)/vm/*.c)
COG_C_FILES    = $(COGDIR)/cogit.c $(COGDIR)/gcc3x-cointerp.c
NOPSYS_C_FILES = $(wildcard $(NOPSYSDIR)/*.c)

ALLPLUGIN_OBJS = $(addsuffix .pluginobj, $(INTERNAL_PLUGINS)) 


VMSRC  = $(filter-out interp.c, $(CROSS_C_FILES) $(NOPSYS_C_FILES) $(COG_C_FILES))
VMOBJS = $(notdir $(VMSRC:.c=.o)) $(ALLPLUGIN_OBJS)
VMOBJS_BUILD = $(addprefix build/, $(VMOBJS))

# PLUGIN variable is defined externally, when calling make (for a specific plugin)

INCS =-I$(CROSSDIR)/plugins/$(PLUGIN) -I$(CROSSDIR)/vm -I$(COGDIR) -I$(NOPSYSDIR) -I$(ROOTDIR)/nopsys/src -I$(ROOTDIR)/nopsys/src/libc

ifeq ($(PLUGIN),SqueakFFIPrims)
	ALL_PLUGIN_C_FILES = $(wildcard ../../src/plugins/$(PLUGIN)/SqueakFFIPrims.c) $(wildcard $(CROSSDIR)/plugins/$(PLUGIN)/*.c)
else
	ALL_PLUGIN_C_FILES = $(wildcard ../../src/plugins/$(PLUGIN)/*.c) $(wildcard $(CROSSDIR)/plugins/$(PLUGIN)/*.c)
endif
PLUGIN_C_FILES = $(filter-out $(CROSSDIR)/plugins/$(PLUGIN)/BitBltArm%, $(ALL_PLUGIN_C_FILES))
PLUGIN_OBJS = $(notdir $(PLUGIN_C_FILES:.c=.o))
PLUGIN_OBJS_BUILD = $(addprefix build/, $(PLUGIN_OBJS))

# setup make path so that it finds .c files
VPATH = $(COGDIR):$(CROSSDIR)/vm:$(NOPSYSDIR):$(VMDIR)/src/plugins/$(PLUGIN):$(CROSSDIR)/plugins/$(PLUGIN)

cognos: build_dir sqNamedPrims.h $(VMOBJS_BUILD) $(INTERNAL_LIBS) $(OPENLIBM)
	$(CC) -o build/vm.obj $(CFLAGS) $(VMOBJS_BUILD) $(INTERNAL_LIBS) $(OPENLIBM)
#$(LDFLAGS)

sqNamedPrims.h: plugins 
	./gen_plugins_file.sh $(INTERNAL_PLUGINS)
	rm -f $(VM_BUILDDIR)/sqNamedPrims.o

build/%.o: %.c
	$(CC) -o $@ -c $(CFLAGS) $(INCS) $(DEFS) $<

# to make a plugin, we call ourselves recursively, specifying which files have to be compiled
build/%.pluginobj:
	@$(MAKE) XDEFS=-DSQUEAK_BUILTIN_PLUGIN PLUGIN=$* plugin

$(OPENLIBM):
	sed -i.bak 's/CFLAGS_add += -fno-gnu89-inline -fno-builtin/CFLAGS_add += -fno-gnu89-inline -fno-builtin -fno-stack-protector/' $(OPENLIBMDIR)/Make.inc
	#The backup is needed for the command to work in MAC
	rm $(OPENLIBMDIR)/Make.inc.bak 
	make USEGCC=1 -C $(OPENLIBMDIR)

plugin: $(PLUGIN_OBJS_BUILD) 
	$(AR) rc build/$(PLUGIN).pluginobj $(PLUGIN_OBJS_BUILD)
	$(RM) $(PLUGIN_OBJS_BUILD)

iso: cognos
	export VM_BUILDDIR=$(VM_BUILDDIR) && make -C $(ROOTDIR)/nopsys $@

try-%: cognos
	export VM_BUILDDIR=$(VM_BUILDDIR) && make -C $(ROOTDIR)/nopsys $@ 

clean:
	rm -rf build/*
	make -C $(ROOTDIR)/nopsys clean

build_dir: $(IMAGE)
	mkdir -p build/extra


