#include ${PARENTDIR}/mk/x264.mk
#include ${PARENTDIR}/mk/x264_10.mk
#include ${PARENTDIR}/mk/faac.mk
FFMPEG_EXTERNAL_DEPS = $(X264_ARTIFACT) $(FAAC_ARTIFACT) $(RTMP_ARTIFACT)

FFMPEG_SRC_NAME = ffmpeg-2.1.1
FFMPEG_SRC_ARCHIVE = $(REALPARENTDIR)/external/src/$(FFMPEG_SRC_NAME).tar.bz2

FFMPEG_SRC_DIR = /tmp/ffmpeg
FFMPEG_LIB_INSTALL_DIR = $(shell pwd)/build/external/lib
FFMPEG_INCLUDE_INSTALL_DIR = $(REALPARENTDIR)/build/external/include
FFMPEG_ARTIFACTS = build/external/lib/libavfilter.a build/external/lib/libavformat.a build/external/lib/libavcodec.a\
 build/external/lib/libavutil.a build/external/lib/libswscale.a build/external/lib/libswresample.a\
 build/external/lib/libpostproc.a
FFMPEG_CONFIG_OPTS = --disable-shared --enable-static --enable-gpl --disable-ffplay --disable-ffmpeg\
 --disable-ffserver --disable-ffprobe --disable-avdevice --enable-nonfree --enable-zlib --enable-postproc\
 --enable-libfaac --enable-libx264 --disable-bzlib --enable-runtime-cpudetect \
 --disable-decoder=vp8 --disable-encoder=ac3 --enable-encoder=ac3_fixed

STATICLIBS += $(FFMPEG_ARTIFACTS) $(FFMPEG_EXTERNAL_DEPS)
EXTERNALDEPS += build/external/lib/libavcodec.a

$(FFMPEG_ARTIFACTS): $(FFMPEG_EXTERNAL_DEPS) $(X264_10_ARTIFACT)
	# init
	@mkdir -p $(FFMPEG_SRC_DIR)
	# unpack archive
	@tar -jxvf $(FFMPEG_SRC_ARCHIVE) -C $(FFMPEG_SRC_DIR)
	# build
	cd $(FFMPEG_SRC_DIR)/$(FFMPEG_SRC_NAME) ; /usr/bin/patch -p1 < $(REALPARENTDIR)/external/src/$(FFMPEG_SRC_NAME).patch ; \
	./configure --prefix=$(FFMPEG_SRC_DIR)/installed $(FFMPEG_OPTS) $(FFMPEG_CONFIG_OPTS) \
	  --libdir=$(FFMPEG_LIB_INSTALL_DIR) --incdir=$(FFMPEG_INCLUDE_INSTALL_DIR) --extra-cflags=-I$(FFMPEG_INCLUDE_INSTALL_DIR) \
	  --extra-ldflags=-L$(FFMPEG_LIB_INSTALL_DIR) ; make -j8 install 
	# clean
	@rm -rf $(FFMPEG_SRC_DIR)
 
clean-ffmpeg: #clean-lame clean-x264 clean-x264_10 clean-faac clean-vpx clean-ogg clean-vorbis clean-rtmp
	@rm -f $(FFMPEG_ARTIFACTS)
