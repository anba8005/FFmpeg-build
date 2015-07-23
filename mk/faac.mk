FAAC_SRC_NAME = faac-1.28
FAAC_SRC_ARCHIVE = src/$(FAAC_SRC_NAME).tar.bz2

FAAC_SRC_DIR = /tmp/faac
FAAC_LIB_INSTALL_DIR = $(shell pwd)/build/lib
FAAC_INCLUDE_INSTALL_DIR = $(shell pwd)/build/include
FAAC_ARTIFACT = $(shell pwd)/build/lib/libfaac.a
FAAC_CONFIG_OPTS = --enable-static --disable-shared --without-mp4v2 --without-frontend

$(FAAC_ARTIFACT):
	# init
	@mkdir -p $(FAAC_SRC_DIR)
	# unpack archive
	@tar -jxvf $(FAAC_SRC_ARCHIVE) -C $(FAAC_SRC_DIR)
	# build
	cd $(FAAC_SRC_DIR)/$(FAAC_SRC_NAME) ;  ./configure --prefix=$(FAAC_SRC_DIR)/installed $(FAAC_OPTS) $(FAAC_CONFIG_OPTS) \
	  --libdir=$(FAAC_LIB_INSTALL_DIR) --includedir=$(FAAC_INCLUDE_INSTALL_DIR) ; make -j4 install 
	# clean
	@rm -rf $(FAAC_SRC_DIR)
 
clean-faac:
	@rm -f $(FAAC_ARTIFACT)
