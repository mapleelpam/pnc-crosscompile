# include 'product.mk' if it exists, otherwise include 'x86-qemu-proxy.mk'
ifeq ($(wildcard product.mk),product.mk)
include product.mk
else
include pnc.mk
endif

# put personal customizations and variable overrides in 'config.mk'
# which is never checked into source control
-include config.mk

# ENV_NAME, BASH_INIT_FILE must be defined in *-env.mk
ifndef ENV_NAME
$(error ENV_NAME not defined)
endif
ifndef BASH_INIT_FILE
$(error BASH_INIT_FILE not defined)
endif

# PACKAGES, TARGET_DIR and EMULATOR must be defined in 'product makefiles' like arm-embedded-tutorial.mk or x86-qemu-proxy.mk
ifndef PACKAGES
$(error PACKAGES not defined)
endif
ifndef TARGET_DIR
$(error TARGET_DIR not defined)
endif
ifndef SYSROOT_BIN_DIR
$(error SYSROOT_BIN_DIR not defined)
endif


.PHONY: all
all: .fetched
.PHONY: shell
shell:
	@bash --init-file $(HOME)/.bashrc --init-file $(BASH_INIT_FILE)
.fetched:
	make fetch
	touch $@

PACKAGE_FETCH_TARGETS := $(patsubst %,%-fetch,cross-compiler $(PACKAGES))
PACKAGE_BUILD_TARGETS := $(patsubst %,%-build,$(PACKAGES))
PACKAGE_CLEAN_TARGETS := $(patsubst %,%-clean,virtual-machine $(PACKAGES))
PACKAGE_INSTALL_TARGETS := $(patsubst %,%-install,$(PACKAGES))
.PHONY: $(PACKAGE_FETCH_TARGETS) $(PACKAGE_BUILD_TARGETS) $(PACKAGE_CLEAN_TARGETS) $(PACKAGE_INSTALL_TARGETS)

.PHONY: fetch fetch-list
fetch: $(PACKAGE_FETCH_TARGETS)
fetch-list: FETCH_OPTION := --just-print
fetch-list: $(PACKAGE_FETCH_TARGETS)

.PHONY: package-list
package-list:
	@echo $(PACKAGES)

all: $(PACKAGE_BUILD_TARGETS)

.PHONY: clean
clean: $(PACKAGE_CLEAN_TARGETS)
	rm -fr $(BUILD_DIR) $(SYSROOT_DIR)

.PHONY: install target-dir-check
install: target-dir-check $(PACKAGE_INSTALL_TARGETS)
target-dir-check:
	mkdir -p $(TARGET_DIR)
	@dir-exists-and-writable $(TARGET_DIR)

# SMP_MFLAGS: -jN_CPU for make
export SMP_MFLAGS := -j$(shell getconf _NPROCESSORS_ONLN)
include packages/*.mk

.PHONY: help
help:
	@echo -e 'targets:\n' \
	'\tshell: get an interactive shell with appropriate development environment settings\n' \
	'\tfetch-list: print a list of URLs and SHA1SUMs\n' \
	'\tfetch: download and extract all sources\n' \
	'\tpackage-list: print component packages' \
	'\tall: fetch and build\n' \
	'\tinstall: create nfsroot or image files\n' \
	'\tclean: clean the component packages\n' \

pn-translator/build/Makefile:CMakeLists.txt
	cd pn-translator/
	mkdir build
	cd build
	cmake ..
	
