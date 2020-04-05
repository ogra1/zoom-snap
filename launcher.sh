#! /bin/sh

# gross hack ! zoom forcefully unsets the global LD_LIBRARY_PATH
# assuming all libs are in ram already. on nvidia systems we need
# to make sure the GL libs are (pre)loaded before the mesa ones

NV_PATH="/var/lib/snapd/lib/gl"

if [ -e $NV_PATH/libnvidia-glcore.so* ]; then

  if [ -e $NV_PATH/tls/libnvidia-tls.so.* ]; then
         TLS="$(ls -1 -f $NV_PATH/tls/libnvidia-tls.so.*)"
  else
         TLS="$(ls -1 -f $NV_PATH/libnvidia-tls.so.*)"
  fi

  export LD_PRELOAD="$(ls -1 -f \
      $TLS \
      $NV_PATH/libnvidia-glcore.so.* \
      $NV_PATH/libGLdispatch.so* \
      $NV_PATH/libGL.so* \
      $NV_PATH/libOpenGL.so* \
      $NV_PATH/libGLX.so | tr '\n' ' ') "
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

# scale according to dpi
DPI="$(xrdb -query 2>/dev/null| grep dpi | sed 's/^.*\t//;s/\..*$//')"
if [ -n "$DPI" ]; then
  if [ "$DPI" -le 96 ]; then
          SCALE=""
  elif [ "$DPI" -le 120 ]; then
          SCALE=1.25
  elif [ "$DPI" -le 144 ]; then
          SCALE=1.5
  elif [ "$DPI" -le 192 ]; then
          SCALE=2
  elif [ "$DPI" -le 240 ]; then
          SCALE=2.5
  elif [ "$DPI" -le 288 ]; then
          SCALE=3
  elif [ "$DPI" -le 384 ]; then
          SCALE=4
  fi
fi

if [ -n "$SCALE" ]; then
  echo "$DPI dpi, using scale factor: $SCALE" >>"$LOGFILE" 2>&1
  export QT_SCALE_FACTOR="$SCALE"
fi

exec $SNAP/zoom/ZoomLauncher "$@" >> "$LOGFILE" 2>&1
