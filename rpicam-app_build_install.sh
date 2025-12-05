meson setup build \
    --buildtype=release \
    -Denable_libav=enabled \
    -Denable_drm=enabled \
    -Denable_egl=enabled \
    -Denable_qt=enabled \
    -Denable_opencv=disabled \
    -Denable_tflite=disabled

ninja -C build
sudo ninja -C build install
