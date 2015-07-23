RTMP_SRC_NAME = librtmp-2.4
RTMP_SRC_ARCHIVE = src/$(RTMP_SRC_NAME).tar.bz2

RTMP_SRC_DIR = /tmp/rtmp
RTMP_LIB_INSTALL_DIR = $(shell pwd)/build/lib
RTMP_INCLUDE_INSTALL_DIR = $(shell pwd)/build/include/librtmp
RTMP_ARTIFACT = $(shell pwd)/build/lib/librtmp.a

$(RTMP_ARTIFACT):
	# init
	@mkdir -p $(RTMP_SRC_DIR)
	# unpack archive
	@tar -jxvf $(RTMP_SRC_ARCHIVE) -C $(RTMP_SRC_DIR)
	# build
	mkdir -p $(RTMP_INCLUDE_INSTALL_DIR)
	mkdir -p $(RTMP_LIB_INSTALL_DIR)/pkgconfig
	cd $(RTMP_SRC_DIR)/$(RTMP_SRC_NAME) ; libdir=$(RTMP_LIB_INSTALL_DIR) incdir=$(RTMP_INCLUDE_INSTALL_DIR) \
	XCFLAGS=$(RTMP_OPTS) make -j4 XDEF=-DNO_SSL SHARED= install
	# clean
	@rm -rf $(RTMP_SRC_DIR)
 
clean-rtmp:
	@rm -f $(RTMP_ARTIFACT)
