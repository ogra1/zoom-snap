#!/bin/sh

ZOOM_LOGS="$SNAP_USER_DATA/.zoom/logs"
LOGFILE="$ZOOM_LOGS/zoom-terminal.log"
UPSTREAM_LOGFILE="$ZOOM_LOGS/zoom_stdout_stderr.log"

mkdir -p $ZOOM_LOGS
mv -uf "$LOGFILE" "$LOGFILE.old" 2>/dev/null || true
mv -uf "$UPSTREAM_LOGFILE" "$UPSTREAM_LOGFILE.old" 2>/dev/null || true

if [ ! -n "$DISABLE_WAYLAND" ] && [ -n "$WAYLAND_DISPLAY" ]; then
  export QT_QPA_PLATFORM=wayland
else
  export QT_QPA_PLATFORM=xcb
  export XDG_SESSION_TYPE=""
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
    $SNAP/zoom/ZoomLauncher "$@" >> "$LOGFILE" 2>&1
fi
