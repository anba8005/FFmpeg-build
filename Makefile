.DEFAULT_GOAL := ffmpeg

RTMP_OPTS = -fPIC
FAAC_OPTS = --with-pic 
X264_OPTS = --enable-pic
X264_10_OPTS = --enable-pic

include mk/rtmp.mk
include mk/faac.mk
include mk/fdk-aac.mk
include mk/x264.mk
include mk/x264_10.mk

FFMPEG_CONFIG_OPTS = --enable-pic --disable-shared --enable-static --enable-gpl --disable-ffplay --enable-ffmpeg \
 --disable-ffserver --enable-ffprobe --enable-nonfree --enable-zlib --enable-postproc \
 --enable-libfaac --enable-libx264 --disable-bzlib --enable-runtime-cpudetect \
 --disable-d3d11va --disable-d3d11va --disable-d3d11va --disable-d3d11va --disable-d3d11va \
 --disable-libxcb --enable-sdl --disable-xlib --disable-debug --enable-decklink --disable-indev=jack \
 --enable-libfreetype --enable-libfdk-aac

FFMPEG_SRC_DIR = $(realpath ../FFmpeg)
FFMPEG_LIB_INSTALL_DIR = $(shell pwd)/build/lib
FFMPEG_INCLUDE_DIR = $(shell pwd)/src/include
FFMPEG_INCLUDE_INSTALL_DIR = $(shell pwd)/build/include
FFMPEG_X264_ARTIFACT = $(FFMPEG_LIB_INSTALL_DIR)/libx264.a
FFMPEG_CONFIG = $(FFMPEG_SRC_DIR)/config.mak

FFMPEG_ARTIFACT = $(shell pwd)/build/ffmpeg
FFMPEG_10_ARTIFACT = $(shell pwd)/build/ffmpeg-10bit
FFPROBE_ARTIFACT = $(shell pwd)/build/ffprobe


deps: $(RTMP_ARTIFACT) $(X264_ARTIFACT) $(X264_10_ARTIFACT) $(FAAC_ARTIFACT) $(FDK_AAC_ARTIFACT)

config: $(FFMPEG_CONFIG)

$(FFMPEG_CONFIG): deps
	mkdir -p $(shell pwd)/build
	# link 8-bit h264
	rm -f $(FFMPEG_X264_ARTIFACT)
	ln -s $(X264_ARTIFACT) $(FFMPEG_X264_ARTIFACT)
	#
	cd $(FFMPEG_SRC_DIR) ; ./configure $(FFMPEG_OPTS) $(FFMPEG_CONFIG_OPTS) --libdir=$(FFMPEG_LIB_INSTALL_DIR) \
	--incdir=$(FFMPEG_INCLUDE_INSTALL_DIR) --disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages \
	--prefix=/tmp/ffmpeg \
	--extra-cflags="-I$(FFMPEG_INCLUDE_DIR) -I$(FFMPEG_INCLUDE_INSTALL_DIR)" \
	--extra-ldflags="-L$(FFMPEG_LIB_INSTALL_DIR) -ldl" --extra-libs=-ldl

ffmpeg:
	# link 8-bit h264
	rm -f $(FFMPEG_X264_ARTIFACT)
	ln -s $(X264_ARTIFACT) $(FFMPEG_X264_ARTIFACT)
	# build
	cd $(FFMPEG_SRC_DIR) ; make -j8 
	# copy 
	mv $(FFMPEG_SRC_DIR)/ffmpeg $(FFMPEG_ARTIFACT)
	cp $(FFMPEG_SRC_DIR)/ffprobe $(FFPROBE_ARTIFACT)
	rm $(FFMPEG_SRC_DIR)/ffmpeg_g
	# link 10-bit h264
	rm -f $(FFMPEG_X264_ARTIFACT)
	ln -s $(X264_10_ARTIFACT) $(FFMPEG_X264_ARTIFACT)
	# build
	cd $(FFMPEG_SRC_DIR) ; make -j8
	# copy
	mv $(FFMPEG_SRC_DIR)/ffmpeg $(FFMPEG_10_ARTIFACT)
	# install
	cd $(FFMPEG_SRC_DIR) ; make install

clean:
	cd $(FFMPEG_SRC_DIR) ; make clean
	
distclean: clean-x264 clean-x264_10 clean-faac clean-rtmp
	cd $(FFMPEG_SRC_DIR) ; make distclean 
	rm -rf $(shell pwd)/build
	

