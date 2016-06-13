FDK_AAC_SRC_NAME = fdk-aac-0.1.4
FDK_AAC_SRC_ARCHIVE = src/$(FDK_AAC_SRC_NAME).tar.gz

FDK_AAC_SRC_DIR = /tmp/fdk-aac
FDK_AAC_LIB_INSTALL_DIR = $(shell pwd)/build/lib
FDK_AAC_INCLUDE_INSTALL_DIR = $(shell pwd)/build/include
FDK_AAC_ARTIFACT = $(shell pwd)/build/lib/libfdk-aac.a
FDK_AAC_CONFIG_OPTS = --enable-static --disable-shared

$(FDK_AAC_ARTIFACT):
	# init
	@mkdir -p $(FDK_AAC_SRC_DIR)
	# unpack archive
	@tar -zxvf $(FDK_AAC_SRC_ARCHIVE) -C $(FDK_AAC_SRC_DIR)
	# build
	cd $(FDK_AAC_SRC_DIR)/$(FDK_AAC_SRC_NAME) ; ./autogen.sh ; ./configure --prefix=$(FDK_AAC_SRC_DIR)/installed $(FDK_AAC_OPTS) $(FDK_AAC_CONFIG_OPTS) \
	  --libdir=$(FDK_AAC_LIB_INSTALL_DIR) --includedir=$(FDK_AAC_INCLUDE_INSTALL_DIR) ; make -j4 install 
	# clean
	@rm -rf $(FDK_AAC_SRC_DIR)
 
clean-fdk-aac:
	@rm -f $(FDK_AAC_ARTIFACT)
