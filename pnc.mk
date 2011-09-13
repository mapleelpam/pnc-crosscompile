include build-env.mk

export TARGET_DIR := TARGET
export PACKAGE_DIR := PACKAGE

#### boost
NECESSARY_PACKAGES += boost 
NECESSARY_PACKAGES += thrift 
#NECESSARY_PACKAGES += programnode-translator

PACKAGES := $(NECESSARY_PACKAGES)

