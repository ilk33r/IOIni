# Makefile for IOIni

BUILD := release
SOURCE_ROOT_DIR=$(shell pwd)
BUILD_ROOT_DIR=$(SOURCE_ROOT_DIR)/Build
MODULE_CACHE_PATH=$(BUILD_ROOT_DIR)/ModuleCache
PACKAGE_ROOT_DIR=..

OS = $(shell uname)
SWIFT = swift
Darwin_CLANG = clang++
SWIFT_LINUX_PATH=$(shell which swiftc)
Linux_CLANG = clang++ $(shell dirname $(shell dirname $(SWIFT_LINUX_PATH)))/lib/swift/linux/x86_64/swift_begin.o
CLANG = $($(OS)_CLANG)

DEBUG.release = -gnone -O -whole-module-optimization
DEBUG.debug = -g -Onone
DEBUG := $(DEBUG.$(BUILD))

XCODE = $(shell xcode-select -p)
SDK = $(shell xcrun --show-sdk-path)

LSB_OS = $(shell lsb_release -si)
LSB_VER = $(shell lsb_release -sr)

Darwin_SWIFTC_FLAGS.release = -sdk $(SDK) -D $(OS)_$(subst .,_,$(shell uname -r)) -Xcc -D$(OS)=1
Darwin_SWIFTC_FLAGS.debug= -sdk $(SDK) -D $(OS)_$(subst .,_,$(shell uname -r)) -D DEBUG -Xcc -D$(OS)=1
Darwin_SWIFTC_FLAGS := $(Darwin_SWIFTC_FLAGS.$(BUILD))
Linux_SWIFTC_FLAGS = -I linked/LinuxBridge
Linux_EXTRA_FLAGS.release = -D $(LSB_OS)_$(subst .,_,$(LSB_VER))
Linux_EXTRA_FLAGS.debug = -D $(LSB_OS)_$(subst .,_,$(LSB_VER)) -D DEBUG
Linux_EXTRA_FLAGS := $(Linux_EXTRA_FLAGS.$(BUILD)) -D $(OS) -Xcc -D$(OS)=1

SWIFT_Darwin_libs = $(XCODE)/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx
SWIFT_Linux_libs = $(shell dirname $(shell dirname $(shell which swiftc)))/lib/swift/linux
SWIFT_libs = $(SWIFT_$(OS)_libs)

SWIFT_Static_Darwin_libs = $(XCODE)/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift_static/macosx
SWIFT_Static_Linux_libs = $(shell dirname $(shell dirname $(shell which swiftc)))/lib/swift_static/linux
SWIFT_Static_libs = $(SWIFT_Static_$(OS)_libs)

all: IOIni-Module

modulecache:
	@mkdir -p $(BUILD_ROOT_DIR)
	@mkdir -p $(BUILD_ROOT_DIR)/lib
	@mkdir -p $(BUILD_ROOT_DIR)/lib/x86_64
	@mkdir -p $(BUILD_ROOT_DIR)/frameworks
	@mkdir -p $(MODULE_CACHE_PATH)
	
include $(SOURCE_ROOT_DIR)/IOIni/MakefileSub
	
IOIni-Module: modulecache IOIni

clean: IOIni-clean

dist-clean: clean
	@rm -rf $(BUILD_ROOT_DIR)
	
.PHONY: all clean dist-clean


	
