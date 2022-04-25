# Author: Dylan Turner
# Description:
# - Helper makefile for building the cross toolchain: binutils, gcc, headers, glibc, and libstdc++

# Defs

## All packages
PACKAGES_DEP +=			$(GNU_AR_BIN) \
						setup-gcc

## Binutils stuff

BINUTILS_DIR :=			$(LFS_PKG_SRC_FLDR)/$(LFS_PKG_VERS)/binutils-2.38
BINUTILS_BUILD_DIR :=	$(BINUTILS_DIR)/binutils-2.38/build
GNU_AR_BIN :=			$(PART)/tools/bin/x86_64-lfs-linux-gnu-ar

## GCC stuff

GCC_DIR :=				$(LFS_PKG_SRC_FLDR)/$(LFS_PKG_VERS)/gcc-11.2.0
GCC_BUILD_DIR :=		$(BINUTILS_DIR)/binutils-2.38/build
MPFR_DIR :=				$(BINUTILS_DIR)/mpfr-4.1.0
GCC_MPFR_DIR :=			$(GCC_DIR)/mpfr
GMP_DIR :=				$(BINUTILS_DIR)/gmp-6.2.1
GCC_5566_DIR :=			$(GCC_DIR)/gmp
MPC_DIR :=				$(BINUTILS_DIR)/mpc-1.2.1
GCC_MPC_DIR :=			$(GCC_DIR)/mpc556

# Targets

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

### Gcc

$(GCC_DIR): $(LFS_PKG_SRC_FLDR)
	mkdir -p $@
	tar xvf $@.tar.xz -C $@

$(GCC_BUILD_DIR): $(GCC_DIR)
	mkdir -p $@

$(MPFR_DIR): $(LFS_PKG_SRC_FLDR)
	mkdir -p $@
	tar xvf $@.tar.xz -C $@

$(GCC_MPFR_DIR): $(MPFR_DIR) $(GCC_DIR)
	cp $< $@

$(GMP_DIR): $(LFS_PKG_SRC_FLDR)
	mkdir -p $@
	tar xvf $@.tar.xz -C $@

$(GCC_GMP_DIR): $(GMP_DIR) $(GCC_DIR)
	cp $< $@

$(MPC_DIR): $(LFS_PKG_SRC_FLDR)
	mkdir -p $@
	tar xvf $@.tar.gz -C $@

$(GCC_MPC_DIR): $(MPC_DIR) $(GCC_DIR)
	cp $< $@

.PHONY: setup-gcc
setup-gcc: $(GCC_BUILD_DIR) $(GCC_MPC_DIR) $(GCC_GMP_DIR) $(GCC_MPFR_DIR)
	cd $<; ../configure \
		--target=$(shell uname -m)-lfs-linux-gnu \
		--prefix=$(PART)/tools \
		--with-glibc-version=2.35 \
		--with-sysroot=$(PART) \
		--with-newlib \
		--without-headers \
		--enable-initfini-array \
		--disable-nls \
		--disable-shared \
		--disable-multilib \
		--disable-decimal-float \
		--disable-threads \
		--disable-libatomic \
		--disable-libgomp \
		--disable-libquadmath \
		--disable-libssp \
		--disable-libvtv \
		--disable-libstdcxx \
		--enable-languages=c,c++
	make -C $< -j$(CORES)
	make -C $< install
