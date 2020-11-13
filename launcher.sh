#! /bin/sh

ZOOM_LOGS="$SNAP_USER_DATA/.zoom/logs"
LOGFILE="$ZOOM_LOGS/zoom-terminal.log"
UPSTREAM_LOGFILE="$ZOOM_LOGS/zoom_stdout_stderr.log"

mkdir -p $ZOOM_LOGS
mv -uf "$LOGFILE" "$LOGFILE.old" 2>/dev/null || true
mv -uf "$UPSTREAM_LOGFILE" "$UPSTREAM_LOGFILE.old" 2>/dev/null || true

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

if echo "$@" | grep -q "\-\-transcoding"; then
    LOGFILE="$ZOOM_LOGS/zoom-transcode.log"
    TR_PATH="--path=$SNAP_USER_DATA/Documents/Zoom/"
    last_opt=${@##* }
    case $last_opt in
        /*)
            TR_PATH="--path=$last_opt"
        ;;
        --path=*)
            TR_PATH="$last_opt"
        ;;
    esac
    exec $SNAP/zoom/zoom --transcoding "$TR_PATH" >> "$LOGFILE" 2>&1
else
    exec $SNAP/zoom/ZoomLauncher "$@" >> "$LOGFILE" 2>&1
fi
