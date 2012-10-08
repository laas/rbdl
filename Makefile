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
	-DCMAKE_CXX_FLAGS_RELWITHDEBINFO:STRING="-O2 -g -fpermissive" \
	-DBUILD_TESTS:BOOL=TRUE \
	-DBUILD_ADDON_URDFREADER:BOOL=TRUE

include $(shell rospack find mk)/download_unpack_build.mk

rbdl: $(INSTALL_DIR)/installed

# This build step incorporates a crude hack to remove the Eigen library
# embedded in RBDL and build the library against the system library
# instead.
# Also, replace the ros.cmake file which does not behave correctly.
$(INSTALL_DIR)/installed: $(SOURCE_DIR)/unpacked
	cd $(SOURCE_DIR)	  		\
	&& rm -rf src/Eigen			\
	&& ln -sf `pkg-config --cflags-only-I --cflags eigen3 | sed "s|-I\([^ ]*\)|\1/Eigen|g"` src \
	&& cp `rospack find rbdl`/ros.cmake addons/urdfreader/CMake/ros.cmake \
	&& cmake . $(CMAKE_FLAGS)		\
	&& make			  		\
	&& make install				\
	&& rm -rf `rospack find rbdl`/$(INSTALL_DIR)/include/rbdl/Eigen
	touch $(INSTALL_DIR)/installed

clean:
	rm -rf $(SOURCE_DIR) $(INSTALL_DIR)

wipe: clean
	rm -rf build
