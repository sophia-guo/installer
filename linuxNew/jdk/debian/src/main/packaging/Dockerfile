FROM debian:buster

RUN dpkg --add-architecture ppc64el
# Combine apt-get update with apt-get install to prevent stale package indexes.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential \
        dpkg-cross crossbuild-essential-ppc64el crossbuild-essential-s390x \
 		debhelper sudo lsb-release reprepro gosu java-common libfontconfig1 libfreetype6 libxext6 libxi6 libxrender1 libxtst6 zlib1g \
 		tini wget binutils-powerpc64le-linux-gnu binutils-s390x-linux-gnu

# Create unprivileged user for building, see
# https://github.com/hexops/dockerfile#use-a-static-uid-and-gid
RUN groupadd -g 10001 builder
RUN useradd -m -d /home/builder -u 10000 -g 10001 builder
RUN wget -O /usr/powerpc64le-linux-gnu/lib/libz.so.1 https://ci.adoptopenjdk.net/view/Test_grinder/job/UploadFile/46/artifact/upload/libz.so.1
RUN wget -O /usr/powerpc64le-linux-gnu/lib/libasound.so.2 https://ci.adoptopenjdk.net/view/Test_grinder/job/UploadFile/48/artifact/upload/libasound.so.2
RUN wget -O /usr/powerpc64le-linux-gnu/lib/libfreetype.so.6 https://ci.adoptopenjdk.net/view/Test_grinder/job/UploadFile/48/artifact/upload/libfreetype.so.6
RUN wget -O /usr/powerpc64le-linux-gnu/lib/libX11.so.6 https://ci.adoptopenjdk.net/view/Test_grinder/job/UploadFile/48/artifact/upload/libX11.so.6
RUN wget -O /usr/powerpc64le-linux-gnu/lib/libXi.so.6 https://ci.adoptopenjdk.net/view/Test_grinder/job/UploadFile/48/artifact/upload/libXi.so.6
RUN wget -O /usr/powerpc64le-linux-gnu/lib/libXext.so.6 https://ci.adoptopenjdk.net/view/Test_grinder/job/UploadFile/48/artifact/upload/libXext.so.6
RUN wget -O /usr/powerpc64le-linux-gnu/lib/libXrender.so.1 https://ci.adoptopenjdk.net/view/Test_grinder/job/UploadFile/48/artifact/upload/libXrender.so.1
RUN wget -O /usr/powerpc64le-linux-gnu/lib/libXtst.so.6 https://ci.adoptopenjdk.net/view/Test_grinder/job/UploadFile/48/artifact/upload/libXtst.so.6

# Prepare entrypoint and build scripts
ADD entrypoint.sh /entrypoint.sh
RUN printf '#!/usr/bin/env bash\n\
set -euxo pipefail\n\
\n\
# Copy build scripts into a directory within the container. Avoids polluting the mounted\n\
# directory and permission errors.\n\
mkdir /home/builder/workspace\n\
cp -R /home/builder/build/generated/packaging /home/builder/workspace\n\
\n\

targets="ppc64el" \n\
#if [[ "$spec" =~ "temurin-8-jdk" ]]; then \n\
#    targets="amd64 ppc64el" \n\
#fi \n\
for target in $targets; do \n\
    # Build package and set distributions it supports.\n\
    cd /home/builder/workspace/packaging\n\
    set CONFIG_SITE=/etc/dpkg-cross/cross-config.${target}\n\
    set DEB_BUILD_OPTIONS=nocheck\n\
    ls /usr/powerpc64le-linux-gnu/lib\n\
    ls /usr/s390x-linux-gnu/lib\n\
    ls /lib/x86_64-linux-gnu\n\
    dpkg-buildpackage -us -uc -b --host-arch "$target" -Pcross,nocheck\n\
    changestool /home/builder/workspace/*.changes setdistribution $VERSIONS\n\
done;\n\

\n\
# Copy resulting files into mounted directory where artifacts should be placed.\n\
mv /home/builder/workspace/*.{deb,changes,buildinfo} /home/builder/out\n\
'\
>> /home/builder/build.sh
RUN chmod +x /home/builder/build.sh
RUN chmod 777 /home/builder/build.sh

ENTRYPOINT ["/usr/bin/tini", "--", "/bin/bash", "/entrypoint.sh" ]
