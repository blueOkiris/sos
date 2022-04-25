# Author: Dylan Turner
# Description: Targets to download LFS sources

# Defs

LFS_PKG_TAR_URL :=		http://ftp.lfs-matrix.net/pub/lfs/lfs-packages/$(LFS_PKG_TAR).tar

# Targets

$(PART)/sources/$(LFS_PKG_TAR).tar:
	wget $(LFS_PKG_TAR_URL) -O $@

$(LFS_PKG_SRC_FLDR): $(PART)/sources/$(LFS_PKG_TAR).tar
	mkdir -p $@
	tar xvf $< -C $@
