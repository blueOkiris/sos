# Author: Dylan Turner
# Description: Build file for SOS. Requires root access

# Settings

## Basic system settings

LFS_PKG_VERS :=			11.1
LFS_PKG_TAR :=			lfs-packages-$(LFS_PKG_VERS)
LFS_PKG_SRC_FLDR :=		$(PART)/sources/$(LFS_PKG_TAR)

### Set to your PC's cores + 1:
CORES :=				17

# Targets

## Helper targets
.PHONY: all
all: packages

.PHONY: clean
clean:
	rm -rf $(PART)/sources/*
	rm -rf $(PART)/tools/*
	rm -rf $(PART)/etc/*
	rm -rf $(PART)/var/*
	rm -rf $(PART)/usr/bin/*
	rm -rf $(PART)/usr/sbin/*
	rm -rf $(PART)/usr/lib/*
	rm -rf $(PART)/usr/lib64/*

### Helpers in other files

include sources.mak
include cross-toolchain.mak

.PHONY: packages
packages: $(PACKAGES_DEP)

## Main targets

