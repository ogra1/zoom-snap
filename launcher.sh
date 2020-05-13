#! /bin/sh

ZOOM_LOGS="$SNAP_USER_DATA/.zoom/logs"
LOGFILE="$ZOOM_LOGS/zoom-terminal.log"

mkdir -p $ZOOM_LOGS
mv -uf "$LOGFILE" "$LOGFILE.old" 2>/dev/null || true

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

# fix mis-sized cursors by setting a sane default
CURSOR="$(xrdb -query | grep Xcursor.theme | sed 's/^.*\t//;s/\..*$//')"
export XCURSOR_PATH=$SNAP/usr/share/icons
if [ -e "$XCURSOR_PATH/$CURSOR" ]; then
  export XCURSOR_THEME=$CURSOR
else
  export XCURSOR_THEME=DMZ-Black
fi
echo "Cursor: $XCURSOR_THEME" >>"$LOGFILE" 2>&1

if [ -n "$SCALE" ]; then
  echo "$DPI dpi, using scale factor: $SCALE" >>"$LOGFILE" 2>&1
  export QT_SCALE_FACTOR="$SCALE"
fi

# make sure libssl is found
export OPENSSL_ENGINES="$SNAP/usr/lib/x86_64-linux-gnu/openssl-1.0.0"
export LD_PRELOAD="$SNAP/usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 $SNAP/usr/lib/x86_64-linux-gnu/libssl.so.1.0.0"

#exec $SNAP/zoom/qtdiag &

exec $SNAP/zoom/ZoomLauncher "$@" >> "$LOGFILE" 2>&1
