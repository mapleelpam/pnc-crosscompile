-include target.mk
ifndef TARGET_MK
$(error Missing target.mk. Copy from target.mk.tmlp to target.mk then configure it first !)
endif

# enforce SHELL as bash by gmake guild suggestion
unexport SHELL
export SHELL = /bin/bash

# CROSS_COMPILER_PREFIX := /opt/crosstools/ia32-4.4
# GCC_VERSION := 4.4.1

export CC := $(CROSS_COMPILE)gcc
export HOST := $(shell $(CC) -dumpmachine)
export ARCH := $(shell echo $(HOST) | cut -d'-' -f1)

export ENV_NAME := pnc-crosscompile

# export LIBC_PREBUILT_DIR := $(CROSS_COMPILER_PREFIX)/$(HOST)/libc/atom
# export GDBSERVER_TARGET_EXE := $(LIBC_PREBUILT_DIR)/usr/bin/gdbserver
# export KERNEL_IMAGE_PATH_IN_SOURCE := arch/x86/boot/bzImage

# CROSS_COMPILER_FETCH_INFO := [ dict( \
	url='http://www.codesourcery.com/sgpp/lite/ia32/portal/package5318/public/i686-pc-linux-gnu/ia32-4.4-44-i686-pc-linux-gnu-i386-linux.tar.bz2', \
	sha1sum='c0147165772f89eaf2bc69e05da895fd9dd63bd2', \
	extracted_name='ia32-4.4', \
) ]

PREFIX := $(shell pwd)
export SYSROOT_DIR := $(PREFIX)/sysroot
export BASH_INIT_FILE := $(PREFIX)/scripts/bash-init.env
export PATH := $(PREFIX)/bin:$(SYSROOT_DIR)/bin:$(PATH)
export CC := $(CROSS_COMPILE)gcc
export CXX := $(CROSS_COMPILE)g++
export LD := $(CROSS_COMPILE)ld
export AR := $(CROSS_COMPILE)ar
export RANLIB := $(CROSS_COMPILE)ranlib
export STRIP := $(CROSS_COMPILE)strip
export RC := $(CROSS_COMPILE)windres

# XZ: we want to default to pxz once it's in Fedora:
# http://jnovy.fedorapeople.org/pxz/
export XZ := xz

# TARGET_{LIB,BIN}_DIR: intentionally using '=' instead of ':=' here to reference the not yet defined TARGET_DIR
export TARGET_LIB_DIR = $(TARGET_DIR)/lib
export TARGET_BIN_DIR = $(TARGET_DIR)/bin


export BUILD_DIR := $(PREFIX)/build

# INCLUDE_DIR, LIB_DIR: where we put headers and libraries to compile against
export INCLUDE_DIR := $(SYSROOT_DIR)/include
export LIB_DIR := $(SYSROOT_DIR)/lib
export SYSROOT_BIN_DIR := $(SYSROOT_DIR)/bin
export PKG_CONFIG_PATH=$(SYSROOT_DIR)/lib/pkgconfig

# PKG_BUILD_ROOT: temporary installation directory like rpm's RPM_BUILD_ROOT
export PKG_BUILD_ROOT := $(BUILD_DIR)/pkg-build-root

# Verbose switch
export V := 1

CFLAGS :=

# Compiler verbose
ifeq "$(V)" "1"
ifndef NOWVERBOSE
CFLAGS += -Wall -Wextra
endif
endif

# Default build type eq DEBUG
export BUILD ?= DEBUG

# DEBUG build
ifeq "$(BUILD)" "DEBUG"
CFLAGS += -O0 -g -pipe -DDEBUG
endif

# RELEASE build
ifeq "$(BUILD)" "RELEASE"
CFLAGS += -Os -g -pipe -DNDEBUG
endif

# Arch - linux
ifeq ($(findstring linux,$(HOST)), linux)
ifeq ($(findstring x86_64,$(HOST)), x86_64)
CFLAGS += -march=nocona -m64
else
CFLAGS += -march=i686 -m32
endif
endif

# Arch - mingw
ifeq ($(findstring mingw32,$(HOST)), mingw32)
CFLAGS += -march=pentium3 -m32
endif

# mingw only flags
ifeq ($(findstring mingw32,$(HOST)), mingw32)
CFLAGS += -mwin32 -mthreads
endif

# not for Linux
ifneq ($(findstring linux,$(HOST)), linux)
# '-static -Wl,--disable-auto-import' cause configure error for Universal-Binary build, and '--disable-auto-import' is not recognizable by MAC's linker.
#LDFLAGS += -static-libgcc -static -Wl,--disable-auto-import
ifeq ($(findstring mingw32,$(HOST)), mingw32)
LDFLAGS += -static-libgcc -static-libstdc++ -static
LDFLAGS += -Wl,--enable-auto-import
endif
endif

# Common compiler and linker flags

# If the gcc used has FORTIFY_SOURCE and strack protection (ssp) support, use it, see:
# http://fedoraproject.org/wiki/Security/Features#Compile_Time_Buffer_Checks_.28FORTIFY_SOURCE.29
CFLAGS += -Wp,-D_FORTIFY_SOURCE=2

# http://gcc.gnu.org/onlinedocs/gcc-4.4.0/gcc/Code-Gen-Options.html#index-fexceptions-1951
##TEST##CFLAGS += -fexceptions -fnon-call-exceptions
CFLAGS += -fexceptions

# http://www.kernel.org/doc/man-pages/online/pages/man7/feature_test_macros.7.html, search for 'FILE_OFFSET_BITS'
CFLAGS += -D_FILE_OFFSET_BITS=64



# Fixme: dirty flags. Move into boost.mk & pnc.mk ?
ifeq ($(findstring darwin,$(HOST)), darwin)
   CFLAGS += -DBOOST_ASIO_DISABLE_KQUEUE
endif
CFLAGS += -DBOOST_PYTHON_STATIC_LIB -DBOOST_THREAD_USE_LIB

ifeq ($(findstring darwin,$(HOST)), darwin)
export MACOSX_SDK_DIR=/Developer/SDKs/MacOSX10.5.sdk
CFLAGS += -arch i386
LDFLAGS += -arch i386
LDFLAGS += -Wl,-search_paths_first
endif

# http://gcc.gnu.org/onlinedocs/gcc-4.4.0/gcc/Optimize-Options.html#index-fstack_002dprotector-795
# http://gcc.gnu.org/onlinedocs/gcc-4.4.0/gcc/Optimize-Options.html#index-param-798, search for 'ssp-buffer-size'
CFLAGS += -fstack-protector --param=ssp-buffer-size=4
ifeq ($(findstring mingw32,$(HOST)), mingw32)
LDFLAGS += $(shell $(CC) -print-file-name=libssp.a)
endif

#########

# Default include and library path
CFLAGS += -I$(INCLUDE_DIR)
CXXFLAGS = $(CFLAGS)
OBJCFLAGS = $(CFLAGS)
OBJCXXFLAGS = $(CFLAGS)
LDFLAGS += -L$(LIB_DIR)

# export flags as default
export CFLAGS
export CXXFLAGS
export OBJCFLAGS
export OBJCXXFLAGS
export LDFLAGS
