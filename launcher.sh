#! /bin/sh

# gross hack ! zoom forcefully unsets the global LD_LIBRARY_PATH
# assuming all libs are in ram already. on nvidia systems we need
# to make sure the GL libs are (pre)loaded before the mesa ones

if [ -e "/var/lib/snapd/lib/gl/xorg/nvidia_drv.so" ]; then
  NV_PATH="/var/lib/snapd/lib/gl"
  export LIBGL_DRIVERS_PATH="$NV_PATH/xorg"

  export LD_PRELOAD="$(ls -1 -f \
      $NV_PATH/tls/libnvidia-tls.so.* \
      $NV_PATH/libnvidia-glcore.so.* \
      $NV_PATH/libnvidia-glsi.so.* \
      $NV_PATH/libnvidia-eglcore.so.* \
      $NV_PATH/libnvidia-fatbinaryloader.so.* \
      $NV_PATH/libGLdispatch.so.* \
      $NV_PATH/libGL.so \
      $NV_PATH/libEGL.so \
      $NV_PATH/libGLESv1_CM.so \
      $NV_PATH/libGLESv2.so \
      $NV_PATH/libGLX.so \
      $NV_PATH/libOpenGL.so \
      $NV_PATH/libnvcuvid.so \
      $NV_PATH/libnvidia-cfg.so \
      $NV_PATH/libnvidia-compiler.so \
      $NV_PATH/libnvidia-egl-wayland.so.? \
      $NV_PATH/libnvidia-encode.so \
      $NV_PATH/libnvidia-fbc.so \
      $NV_PATH/libnvidia-ifr.so \
      $NV_PATH/libnvidia-ml.so \
      $NV_PATH/libnvidia-ptxjitcompiler.so.? \
      $NV_PATH/vdpau/libvdpau_nvidia.so | tr '\n' ' ') "
fi

exec $SNAP/zoom/ZoomLauncher "$@"
