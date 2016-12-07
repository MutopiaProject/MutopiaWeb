#!/bin/bash

# Print usage if no parameters given
if [ ! -n "$1" ]; then
    echo "Usage: $0 <lilypond version>"
    exit 1
fi

LILYPOND_VERSION=$1
LILYPOND_PACKAGE=lilypond-$LILYPOND_VERSION-1.linux-64.sh
LILYPOND_PACKAGE_URL=http://download.linuxaudio.org/lilypond/binaries/linux-64/$LILYPOND_PACKAGE

# Check that Lilypond version exists
if ! curl --output /dev/null --silent --head --fail $LILYPOND_PACKAGE_URL ; then
    echo "Unable to retrieve $LILYPOND_PACKAGE_URL"
    exit 2
fi

docker build -t mutopia/lilypond:$LILYPOND_VERSION - << EOF
# CentOS dependencies
FROM centos:7
RUN yum install -y bzip2 dejavu-sans-fonts dejavu-serif-fonts

# Mutopia scripts
ADD https://raw.githubusercontent.com/MutopiaProject/MutopiaWeb/master/UsefulScripts/mutopia-compile.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/mutopia-compile.sh

# Lilypond binary
RUN curl -O $LILYPOND_PACKAGE_URL
RUN bash $LILYPOND_PACKAGE

# Environment variables
ENV LILYPOND_BIN /usr/local/bin/lilypond
ENV LILYPOND_VERSION $LILYPOND_VERSION
EOF
