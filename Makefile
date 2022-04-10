# Author: Dylan Turner
# Description: Build file for SOS. Requires root access

# Settings

## Basic system settings

LFS_PKG_VERS :=			11.1
LFS_PKG_TAR :=			lfs-packages-$(LFS_PKG_VERS)
LFS_PKG_TAR_URL :=		http://ftp.lfs-matrix.net/pub/lfs/lfs-packages/$(LFS_PKG_TAR).tar
LFS_PKG_SRC_FLDR :=		$(PART)/sources/$(LFS_PKG_TAR)

### Set to your PC's cores + 1:
CORES :=				17

## Binutils stuff

BINUTILS_DIR :=			$(LFS_PKG_SRC_FLDR)/$(LFS_PKG_VERS)/binutils-2.38
BINUTILS_BUILD_DIR :=	$(BINUTILS_DIR)/binutils-2.38/build
GNU_AR_BIN :=			$(PART)/tools/bin/x86_64-lfs-linux-gnu-ar

## All packages
PACKAGES_DEP :=			$(GNU_AR_BIN) \

# Targets

## Helper targets
.PHONY: all
all: $(PACKAGES_DEP)

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

### Download sources

$(PART)/sources/$(LFS_PKG_TAR).tar:
	wget $(LFS_PKG_TAR_URL) -O $@

$(LFS_PKG_SRC_FLDR): $(PART)/sources/$(LFS_PKG_TAR).tar
	mkdir -p $@
	tar xvf $< -C $@

### Binutils

$(BINUTILS_DIR): $(LFS_PKG_SRC_FLDR)
	mkdir -p $@
	tar xvf $@.tar.xz -C $@

$(BINUTILS_BUILD_DIR): $(BINUTILS_DIR)
	mkdir -p $@

$(GNU_AR_BIN): $(BINUTILS_BUILD_DIR)
	cd $<; ../configure \
		--prefix=$(PART)/tools --with-sysroot=$(PART) \
		--target=$(shell uname -m)-lfs-linux-gnu --disable-nls --disable-werror
	make -C $< -j$(CORES)
	make -C $< install

## Main targets


