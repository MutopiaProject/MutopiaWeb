#!/bin/bash

# Useful docker commands
# docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
# chcon -Rt svirt_sandbox_file_t <directory>
# ls -lZ

# Determine lilypond version - check there is only one in *.ly
VERSION_STRING_COUNT=$(grep -h "\\version" *.ly | sort | uniq | wc -l)
if [ $VERSION_STRING_COUNT -ne 1 ]; then
    echo "Unable to determine LilyPond version"
    exit 1
fi

LILYPOND_VERSION=$(grep -h "\\version" *.ly | sort | uniq | sed -e 's/.*"\(.*\)".*/\1/')
DOCKER_IMAGE=mutopia/lilypond:$LILYPOND_VERSION

echo "Determined LilyPond version $LILYPOND_VERSION"

# Check if docker image exists
if [ "$(docker images -q $DOCKER_IMAGE)" == "" ]; then
    echo "Unable to find appropriate docker image"
    exit 2
fi


# TODO decide on Mutopia -c and/or Mutopia -f

# Compile in docker
docker run --rm -it -u $(id -u):$(id -g) -v $PWD:/mnt/music -it $DOCKER_IMAGE /bin/bash -c "mutopia-compile.sh /mnt/music/*.ly"

# Check paper sizes. Other sanity check from mutopia-combine?
# TODO

# Fix permissions
# TODO move fix to mutopia-compile.sh?
chmod 644 *.ps.gz

# Create RDF, combine and history
# TODO
Mutopia -r *.ly

# Fix lilypond version in RDF
# TODO proper fix
sed -i -e "s/<mp:lilypondVersion>2.18.2<\/mp:lilypondVersion>/<mp:lilypondVersion>$LILYPOND_VERSION<\/mp:lilypondVersion>/" *.rdf
