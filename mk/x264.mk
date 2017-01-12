X264_SRC_NAME = x264-snapshot-20170111-2245-stable
X264_SRC_ARCHIVE = src/$(X264_SRC_NAME).tar.bz2

X264_SRC_DIR = /tmp/x264
X264_LIB_INSTALL_DIR = $(shell pwd)/build/lib
X264_INCLUDE_INSTALL_DIR = $(shell pwd)/build/include
X264_ARTIFACT = $(shell pwd)/build/lib/libx264_8.a
X264_CONFIG_OPTS = --disable-cli --enable-static --disable-opencl --bit-depth=8

$(X264_ARTIFACT):
	# init
	@mkdir -p $(X264_SRC_DIR)
	# unpack archive
	@tar -jxvf $(X264_SRC_ARCHIVE) -C $(X264_SRC_DIR)
	# build
	cd $(X264_SRC_DIR)/$(X264_SRC_NAME) ;  ./configure --prefix=$(X264_SRC_DIR)/installed $(X264_OPTS) $(X264_CONFIG_OPTS) \
	  --libdir=$(X264_LIB_INSTALL_DIR) --includedir=$(X264_INCLUDE_INSTALL_DIR) ; make -j4 install ; \
	  mv $(X264_LIB_INSTALL_DIR)/libx264.a $(X264_ARTIFACT)
	# clean
	@rm -rf $(X264_SRC_DIR)
 
clean-x264:
	@rm -f $(X264_ARTIFACT)
