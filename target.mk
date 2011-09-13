export TARGET_MK := ''

ifeq "1" "1"
export CROSS_COMPILE := i586-mingw32msvc-
export BUILD := DEBUG
export NOWVERBOSE := 1
else
export BUILD := DEBUG
export NOWVERBOSE := 1
endif
