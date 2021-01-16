FROM golang:1.15.6-alpine3.12
LABEL maintainer="burmjeff"

RUN apk add --no-cache \
    ffmpeg \
    gstreamer \
    curl \
    bash
   
RUN mkdir /config

RUN wget https://github.com/aler9/rtsp-simple-server/releases/download/v0.13.2/rtsp-simple-server_v0.13.2_linux_amd64.tar.gz -O rtsp-simple-server.tar.gz && \
    tar zxfvp rtsp-simple-server.tar.gz && \
    chmod +x rtsp-simple-server && \
    mv rtsp-simple-server /usr/bin && \
    mv rtsp-simple-server.yml /config && \
    rm -f rtsp-simple-server.tar.gz
    
# environment variables

# ports and volumes
VOLUME /config
EXPOSE 8554
CMD ["rtsp-simple-server", "run", "/config/rtsp-simple-server.yml"]
