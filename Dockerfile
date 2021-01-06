FROM alpine AS xpra-base

ENV XPRA_VERSION=4.0.5

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-amd64.tar.gz /tmp
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

COPY rootfs/bin /bin

RUN add-pkg \
    bash \
    dbus-x11 \
    ffmpeg-libs \
    gtk+3.0 \
    libvpx \
    openssh \
    py3-cairo \
    py3-dbus \
    py3-gobject3 \
    py3-lz4 \
    py3-netifaces \
    py3-paramiko \
    py3-pillow \
    py3-rencode \
    python3 \
    ttf-droid \
    ttf-droid-nonlatin \
    x264 \
    xauth \
    xhost \
    xorg-server \
    && add-pkg py3-inotify --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
&& add-pkg --virtual build-deps \
    autoconf \
    automake \
    curl \
    cython \
    ffmpeg-dev \
    gcc \
    git \
    gtk+3.0-dev \
    libc-dev \
    libjpeg-turbo-dev \
    libtool \
    libvpx-dev \
    libxcomposite-dev \
    libxext-dev \
    libxkbfile-dev \
    libxrandr-dev \
    libxrandr-dev \
    libxtst-dev \
    make \
    musl-dev \
    nasm \
    py3-gobject3-dev \
    python3-dev \
    util-macros \
    x264-dev \
    xorg-server-dev \
    yasm \
&& git clone https://github.com/ncopa/su-exec.git \
    /tmp/su-exec \
    && cd /tmp/su-exec \
    && make \
    && chmod 770 su-exec \
    && mv su-exec /usr/sbin/ \
&& git clone https://gitlab.freedesktop.org/xorg/driver/xf86-video-dummy.git \
    /tmp/xf86-video-dummy \
    && cd /tmp/xf86-video-dummy \
    && libtoolize \
    && aclocal \
    && autoheader \
    && autoconf \
    && automake \
    --add-missing \
    --force-missing \
    && ./configure \
    && make \
    && make install \
    && mkdir -p /usr/lib/xorg/modules/drivers/ \
    && mv /usr/local/lib/xorg/modules/drivers/dummy_drv.so \
    /usr/lib/xorg/modules/drivers/ \
&& cd /tmp \
    && curl http://www.xpra.org/src/xpra-$XPRA_VERSION.tar.xz -o xpra.tar.xz \
    && tar -xf "xpra.tar.xz" \
    && cd "xpra-${XPRA_VERSION}" \
    && echo -e 'Section "Module"\n  Load "fb"\n  EndSection' \
    >> etc/xpra/xorg.conf \
    && python3 setup.py install \
    --verbose \
    --with-Xdummy \
    --with-Xdummy_wrapper \
    --with-bencode \
    --with-clipboard \
    --with-csc_swscale \
    --with-cython_bencode \
    --with-dbus \
    --with-enc_ffmpeg \
    --with-enc_x264 \
    --with-gtk_x11 \
    --with-pillow \
    --with-server \
    --with-vpx \
    --with-vsock \
    --with-x11 \
    --without-client \
    --without-csc_libyuv \
    --without-cuda_kernels \
    --without-cuda_rebuild \
    --without-dec_avcodec2 \
    --without-enc_x265 \
    --without-mdns \
    --without-opengl \
    --without-printing \
    --without-uinput \
    --without-sound \
    --without-strict \
    --without-webcam \
    && mkdir -p /var/run/xpra/ \
&& del-pkg build-deps \
    && rm -rf /var/cache/* /tmp/* /var/log/* ~/.cache \
    && mkdir -p /var/cache/apk \
&& mkdir -p /var/run/sshd \
    && chmod 0755 /var/run/sshd \
    && ssh-keygen -A

COPY rootfs/ /

ENV DISPLAY=":14"            \
    SHELL="/bin/bash"        \
    SSHD_PORT="22"           \
    START_XORG="yes"         \
    XPRA_HTML="no"           \
    XPRA_MODE="start"        \
    XPRA_READONLY="no"       \
    XORG_DPI="96"            \
    XPRA_COMPRESS="0"        \
    XPRA_DPI="0"             \
    XPRA_ENCODING="rgb"      \
    XPRA_HTML_DPI="96"       \
    XPRA_KEYBOARD_SYNC="yes" \
    XPRA_MMAP="yes"          \
    XPRA_SHARING="yes"       \
    XPRA_TCP_PORT="10000"

ENV GID="1000"         \
    GNAME="xpra"       \
    UHOME="/home/xpra" \
    UID="1000"         \
    UNAME="xpra" \
    XDG_DATA_HOME=/config/data \
    XDG_CONFIG_HOME=/config/config \
    XDG_CACHE_HOME=/config/cache

EXPOSE $SSHD_PORT $XPRA_TCP_PORT

ENTRYPOINT ["/init"]
