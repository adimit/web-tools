FROM debian:jessie

MAINTAINER Aleksandar Dimitrov <aleks.dimitrov@gmail.com>

ENV runtime_dependencies="git imagemagick ffmpeg rsync file"
ENV build_dependencies="curl"
ENV git_lfs_version "1.5.5"

RUN echo "deb http://ftp.debian.org/debian jessie-backports main" \
  > /etc/apt/sources.list.d/backports.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -qy $runtime_dependencies $build_dependencies \
 && tmp=$(mktemp -d) \
 && cd $tmp \
 && curl -LO https://github.com/git-lfs/git-lfs/releases/download/v${git_lfs_version}/git-lfs-linux-amd64-${git_lfs_version}.tar.gz \
 && tar xf git-lfs-linux-amd64-${git_lfs_version}.tar.gz \
 && mv git-lfs-${git_lfs_version}/git-lfs /usr/local/bin \
 && cd /usr/local/ \
 && git clone https://github.com/Jack000/Expose.git \
 && apt-get remove -qy $build_dependencies \
 && apt-get autoremove -qy \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf $tmp

ENV PATH /usr/local/Expose:$PATH

RUN useradd -ms /bin/bash builder
USER builder
WORKDIR /home/builder