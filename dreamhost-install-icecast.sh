#!/bin/bash

LIBXML2_VER="2.15.4"
LIBXSLT_VER="1.1.45"
LIBOGG_VER="1.3.6"
LIBVORBIS_VER="1.3.7"
LIBIGL0O_VER="0.9.5"
LIBRHASH_VER="1.4.6"
ICECAST_VER="2.5.0"

CURRENT_DIR=$(pwd)

USERNAME=$(whoami)

setup () {
    mkdir tmp && cd tmp
}

cleanup () {
    echo "DELETING TEMPORARY DIRECTORY: $CURRENT_DIR/tmp"
    # rm -rf "$CURRENT_DIR/tmp"
}

get-deps () {
    # Download
    wget "http://downloads.xiph.org/releases/icecast/icecast-$ICECAST_VER.tar.gz" \
	&& wget "https://download.gnome.org/sources/libxslt/1.1/libxslt-$LIBXSLT_VER.tar.xz" \
	&& wget "http://downloads.xiph.org/releases/ogg/libogg-$LIBOGG_VER.zip" \
	&& wget "http://downloads.xiph.org/releases/vorbis/libvorbis-$LIBVORBIS_VER.zip"
    # Unpack
    tar xvfz *.tar.gz && tar xJf *.tar.xz && unzip \*.zip
}

install_stuff () {
    if [ ! -d ~/usr/bin ]; then
	cd ~/ && mkdir -p usr/bin
    fi
    if [ ! -d ~/usr/var/log/icecast ]; then
	mkdir -p usr/var/log/icecast
    fi
    if ! grep -q ':~/usr/bin' ~/.bash_profile; then
       echo 'PATH=$PATH:~/usr/bin' >> ~/.bash_profile && source ~/.bash_profile
     fi
    cd "$CURRENT_DIR/tmp/libxslt-$LIBXSLT_VER/" && \
	./configure --prefix="/home/$USERNAME/usr" && \
	make && make install && \
	cd "$CURRENT_DIR/tmp/libogg-$LIBOGG_VER/" && \
	./configure --prefix="/home/$USERNAME/usr" && \
	make && make install && \
	cd "$CURRENT_DIR/tmp/libvorbis-$LIBVORBIS_VER/" && \
	./configure --prefix="/home/$USERNAME/usr" && \
	make && make install && \
	cd "$CURRENT_DIR/tmp/icecast-$ICECAST_VER/" && \
	./configure --prefix="/home/$USERNAME/usr" && \
	make && make install
}

setup && get-deps && install_stuff

cleanup
