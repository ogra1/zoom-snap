#! /bin/sh

# gross hack ! zoom forcefully unsets the global LD_LIBRARY_PATH
# assuming all libs are in ram already. on nvidia systems we need
# to make sure the GL libs are (pre)loaded before the mesa ones

NV_PATH="/var/lib/snapd/lib/gl"

if [ -e $NV_PATH/libnvidia-glcore.so* ]; then
  export LIBGL_DRIVERS_PATH="$NV_PATH/xorg"

  if [ -e $NV_PATH/tls/libnvidia-tls.so.* ]; then
         TLS="$(ls -1 -f $NV_PATH/tls/libnvidia-tls.so.*)"
  else
         TLS="$(ls -1 -f $NV_PATH/libnvidia-tls.so.*)"
  fi

  export LD_PRELOAD="$(ls -1 -f \
      $TLS \
      $NV_PATH/libnvidia-glcore.so.* \
      $NV_PATH/libnvidia-glsi.so.* \
      $NV_PATH/libnvidia-eglcore.so.* \
      $NV_PATH/libnvidia-fatbinaryloader.so.* \
      $NV_PATH/libGLdispatch.so.* \
      $NV_PATH/libGL.so \
      $NV_PATH/libGLESv1_CM.so \
      $NV_PATH/libGLESv2.so \
      $NV_PATH/libGLX.so \
      $NV_PATH/libOpenGL.so \
      $NV_PATH/libnvcuvid.so \
      $NV_PATH/libnvidia-cfg.so \
      $NV_PATH/libnvidia-compiler.so* \
      $NV_PATH/libnvidia-encode.so \
      $NV_PATH/libnvidia-fbc.so \
      $NV_PATH/libnvidia-ifr.so \
      $NV_PATH/libnvidia-ml.so \
      $NV_PATH/libnvidia-ptxjitcompiler.so.? \
      $NV_PATH/vdpau/libvdpau_nvidia.so | tr '\n' ' ') "
fi

ZOOM_LOGS="$SNAP_USER_DATA/.zoom/logs"
LOGFILE="$ZOOM_LOGS/zoom-terminal.log"

mkdir -p $ZOOM_LOGS
mv -uf "$LOGFILE" "$LOGFILE.old" 2>/dev/null || true

# collect info about nvidia setup
if [ "$(ls -A $NV_PATH)" ]; then
    echo -n "Nvidia version: " >"$LOGFILE"
    if [ -e /var/lib/snapd/lib/gl/ld.so.conf ]; then
    	cat /var/lib/snapd/lib/gl/ld.so.conf | sed 's/^.*\///' | uniq >>"$LOGFILE" 2>&1 || true
        echo "----------" >>"$LOGFILE"
    fi
    find /var/lib/snapd/lib/gl >>"$LOGFILE" 2>&1 || true
    echo "" >>"$LOGFILE"
fi

exec $SNAP/zoom/ZoomLauncher "$@" >> "$LOGFILE" 2>&1
