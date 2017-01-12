X264_10_SRC_NAME = x264-snapshot-20170111-2245-stable
X264_10_SRC_ARCHIVE = src/$(X264_10_SRC_NAME).tar.bz2

X264_10_SRC_DIR = /tmp/x264_10
X264_10_LIB_INSTALL_DIR = $(shell pwd)/build/lib
X264_10_INCLUDE_INSTALL_DIR = $(shell pwd)/build/include
X264_10_ARTIFACT = $(shell pwd)/build/lib/libx264_10.a
X264_10_CONFIG_OPTS = --disable-cli --enable-static --disable-opencl --bit-depth=10

$(X264_10_ARTIFACT): $(X264_ARTIFACT)
	# init
	@mkdir -p $(X264_10_SRC_DIR)
	# unpack archive
	@tar -jxvf $(X264_10_SRC_ARCHIVE) -C $(X264_10_SRC_DIR)
	# build
	cd $(X264_10_SRC_DIR)/$(X264_10_SRC_NAME) ;  ./configure --prefix=$(X264_10_SRC_DIR)/installed $(X264_10_OPTS) $(X264_10_CONFIG_OPTS) ; \
	   make -j4 ; cp /tmp/x264_10/$(X264_10_SRC_NAME)/libx264.a $(X264_10_ARTIFACT)
	# clean
	@rm -rf $(X264_10_SRC_DIR)
 
clean-x264_10:
	@rm -f $(X264_10_ARTIFACT)
