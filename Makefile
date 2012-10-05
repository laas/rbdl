all: rbdl

VERSION     = a54206e4f413
TARBALL     = build/rbdl-$(VERSION).tar.bz2
TARBALL_URL = \
https://bitbucket.org/rbdl/rbdl/get/$(VERSION).tar.bz2
UNPACK_CMD  = tar xfj
SOURCE_DIR  = build/rbdl-rbdl-$(VERSION)
TARBALL_PATCH =

MD5SUM_FILE = rbdl-$(VERSION).tar.bz2.md5sum

INSTALL_DIR = install

CMAKE_FLAGS = \
	-DCMAKE_BUILD_TYPE:STRING='RelWithDebInfo' \
	-DCMAKE_INSTALL_PREFIX:STRING=`rospack find rbdl`/$(INSTALL_DIR)/ \
	-DBUILD_TESTS:BOOL=TRUE \
	-DBUILD_ADDON_URDFREADER:BOOL=FALSE

include $(shell rospack find mk)/download_unpack_build.mk

rbdl: $(INSTALL_DIR)/installed

$(INSTALL_DIR)/installed: $(SOURCE_DIR)/unpacked
	cd $(SOURCE_DIR)	  		\
	&& cmake . $(CMAKE_FLAGS)		\
	&& make			  		\
	&& make install
	touch $(INSTALL_DIR)/installed

clean:
	rm -rf $(SOURCE_DIR) $(INSTALL_DIR)

wipe: clean
	rm -rf build
