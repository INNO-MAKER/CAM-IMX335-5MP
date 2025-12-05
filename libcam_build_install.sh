meson setup build \
    --buildtype=release \
    -Dcam=disabled \
    -Dlc-compliance=disabled \
    -Dqcam=disabled \
    -Dtest=false \
    -Dv4l2=true \
    -Dpipelines=rpi/vc4,rpi/pisp \
    -Dipas=rpi/vc4,rpi/pisp\
    -Dgstreamer=enabled\
    -Dpycamera=enabled

ninja -C build
sudo ninja -C build install
sudo ldconfig
