FROM ubuntu:rolling
LABEL maintainer="burmjeff"

ARG GST_VERSION=1.18.0

#Define build dependencies
ARG buildDeps='autoconf \
  automake \
  autopoint \
  bison \
  flex \
  libtool \
  yasm \
  nasm \
  git-core \
  build-essential \
  gettext \
  meson \
  libegl1-mesa-dev \
  libgl1-mesa-dev \
  libgles2-mesa-dev \
  libavfilter-dev \
  libglib2.0-dev \
  libgirepository1.0-dev \
  libpthread-stubs0-dev \
  libssl-dev \
  liborc-dev \
  libmpg123-dev \
  libmp3lame-dev \
  libsoup2.4-dev \
  libshout3-dev \
  libpulse-dev \
  libva-dev \
  libxv-dev \
  libalsa-ocaml-dev \
  libcdparanoia-dev \
  libopus-dev \
  libpango1.0-dev \
  libvisual-0.4-dev \
  libvorbisidec-dev \
  libaa1-dev \
  libcaca-dev \
  libdv4-dev \
  libflac-dev \
  libjack-dev \
  libtag1-dev \
  libdrm-dev \
  libvpx-dev \
  libwavpack-dev \
  libass-dev \
  libzbar-dev \
  libx265-dev \
  libx264-dev \
  libwildmidi-dev \
  libvulkan-dev \
  libx11-dev \
  libxrandr-dev \
  libwayland-dev \
  wayland-protocols \
  libwebp-dev \
  libwebrtc-audio-processing-dev \
  libvdpau-dev \
  libsrtp2-dev \
  libvo-aacenc-dev \
  libvo-amrwbenc-dev \
  libbs2b-dev \
  libdc1394-22-dev \
  libdca-dev \
  libfaac-dev \
  libfaad-dev \
  libfdk-aac-dev \
  libfluidsynth-dev \
  libcurl-ocaml-dev \
  libgme-dev \
  libgsm1-dev \
  librtmp-dev \
  libcurl-ocaml-dev \
  libjpeg-turbo8-dev \
  liba52-0.7.4-dev \
  libcdio-dev \
  libtwolame-dev \
  libx264-dev \
  libmpeg2-4-dev \
  libsidplay1-dev \
  gobject-introspection \
  libudev-dev \
  python3-pip \
  python3-gi \
  python-gi-dev \
  python3-dev \
  graphviz \
  libopencv-dev \
  libnice-dev \
  libgtk-3-dev \
  libx11-xcb-dev'

RUN mkdir /config

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y \
  ffmpeg \
  wget \
  curl \
  tar \
  libcdparanoia0 \
  libshout3 \
  liblcms2-2 \
  libzbar0 \
  libegl1 \
  libva-wayland2 \
  libvorbisidec1 \
  libdv4 \
  libgtk-3-0 \
  libfaad2 \
  libfluidsynth2 \
  libopenexr25 \
  libvo-aacenc0 \
  libnice10 \
  libvo-amrwbenc0 \
  libwildmidi2 \
  liba52-0.7.4 \
  libvisual-0.4-0 \
  libsidplay1v5 \
  libxdamage1 \
  libaa1 \
  libpython3.9 \
  libfdk-aac2 \
  libwebrtc-audio-processing1 \
  libmpeg2-4 \
  libdca0 \
  libsoup2.4-1 \
  libfaac0 \
  libsrtp2-1 \
  libtag1v5
  
#Install build dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y $buildDeps && \
  rm -rf /var/lib/apt/lists/* && \


# Fetch and build GStreamer
  git clone -b $GST_VERSION --depth 1 https://gitlab.freedesktop.org/gstreamer/gstreamer.git && \
  cd gstreamer && \
  git checkout $GST_VERSION && \
  meson build --prefix=/usr --libdir=/usr/lib --buildtype=release && \
  ninja -C build -j `nproc` && \
  ninja -C build install && \
  cd .. && \
  rm -rvf /gstreamer && \

# Fetch and build gst-plugins-base
  git clone -b $GST_VERSION --depth 1 https://gitlab.freedesktop.org/gstreamer/gst-plugins-base.git && \
  cd gst-plugins-base && \
  meson build --prefix=/usr --libdir=/usr/lib --buildtype=release && \
  ninja -C build -j `nproc` && \
  ninja -C build install && \
  cd .. && \
  rm -rvf /gst-plugins-base && \

# Fetch and build gst-plugins-good
  git clone -b $GST_VERSION --depth 1 https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git && \
  cd gst-plugins-good && \
  meson build --prefix=/usr --libdir=/usr/lib --buildtype=release && \
  ninja -C build -j `nproc` && \
  ninja -C build install && \
  cd .. && \
  rm -rvf /gst-plugins-good && \

# Fetch and build gst-plugins-bad
  git clone -b $GST_VERSION --depth 1 https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad.git && \
  cd gst-plugins-bad && \
  meson build --prefix=/usr --libdir=/usr/lib --buildtype=release && \
  ninja -C build -j `nproc` && \
  ninja -C build install && \
  cd .. && \
  rm -rvf /gst-plugins-bad && \

# Fetch and build gst-plugins-ugly
  git clone -b $GST_VERSION --depth 1 https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git && \
  cd gst-plugins-ugly && \
  meson build --prefix=/usr --libdir=/usr/lib --buildtype=release && \
  ninja -C build -j `nproc` && \
  ninja -C build install && \
  cd .. && \
  rm -rvf /gst-plugins-ugly && \
  
# Fetch and build gst-libav
  git clone -b $GST_VERSION --depth 1 https://gitlab.freedesktop.org/gstreamer/gst-libav.git && \
  cd gst-libav && \
  meson build --prefix=/usr --libdir=/usr/lib --buildtype=release && \
  ninja -C build -j `nproc` && \
  ninja -C build install && \
  cd .. && \
  rm -rvf /gst-libav && \
  
# Fetch and build gst-rtsp-server
  git clone -b $GST_VERSION --depth 1 https://gitlab.freedesktop.org/gstreamer/gst-rtsp-server.git && \
  cd gst-rtsp-server && \
  meson build --prefix=/usr --libdir=/usr/lib --buildtype=release && \
  ninja -C build -j `nproc` && \
  ninja -C build install && \
  cd .. && \
  rm -rvf /gst-rtsp-server && \
  
# Fetch and build gstreamer-vaapi
  git clone -b $GST_VERSION --depth 1 https://gitlab.freedesktop.org/gstreamer/gstreamer-vaapi.git && \
  cd gstreamer-vaapi && \
  meson build --prefix=/usr --libdir=/usr/lib --buildtype=release && \
  ninja -C build -j `nproc` && \
  ninja -C build install && \
  cd .. && \
  rm -rvf /gstreamer-vaapi && \
  
# Fetch and build gst-python
  git clone -b $GST_VERSION --depth 1 https://gitlab.freedesktop.org/gstreamer/gst-python.git && \
  cd gst-python && \
  meson build --prefix=/usr --libdir=/usr/lib --buildtype=release && \
  ninja -C build -j `nproc` && \
  ninja -C build install && \
  cd .. && \
  rm -rvf /gst-python && \

# Do some cleanup
  apt-get purge -y --auto-remove $buildDeps && \
  apt-get clean && \
  apt-get autoremove -y

#Fetch and install rtsp-simple-server
RUN wget https://github.com/aler9/rtsp-simple-server/releases/download/v0.17.14/rtsp-simple-server_v0.17.14_linux_amd64.tar.gz -O rtsp-simple-server.tar.gz && \
    tar zxfvp rtsp-simple-server.tar.gz && \
    chmod +x rtsp-simple-server && \
    mv rtsp-simple-server /usr/bin && \
    mv rtsp-simple-server.yml /config && \
    rm -f rtsp-simple-server.tar.gz

# environment variables

# ports and volumes
VOLUME /config
EXPOSE 8554
EXPOSE 8000/UDP
EXPOSE 8001/UDP
CMD ["rtsp-simple-server", "/config/rtsp-simple-server.yml"]
