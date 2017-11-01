#
# ~/.bash_functions
#

# Screencast
## record the screen with a webcam overlay
###
screencast() {
  ## filename with timestamp
  screencap=kscreen-$(date -Iseconds).mkv

  ## record screen, webcam, and audio
  ffmpeg \
    -f x11grab \ # screen grab
      -video_size 3840x2160 \
      -i :0.0 \
    -f v4l2 \ # webcam grab
      -framerate 30 \
      -i /dev/video0 \
    -f alsa \ # audio grab
      -ac 2 \
      -itsoffset 0.4 \ # offset audio to align with video
      -i pulse \
    -filter_complex \ # overlay webcam in top right
      "[0:v]setpts=PTS-STARTPTS[bg]; \
       [1:v]setpts=PTS-STARTPTS[fg]; \
       [bg][fg]overlay=W-w-10:10,format=yuv420p[out]" \
    -map "[out]" \
    -map 2:a \
    -c:v libx264 \ # convert to x.264 (fastest method)
      -preset veryfast \
      -g 30 \ # ensure 1 keyframe/second
    -c:a aac \
      -b:a 160k \
      -ar 44100 \
    /home/kevin/Documents/screencaps/$screencap

  ## auto open vlc
  if [[ $open_vlc="true"]]; do
    vlc /home/kevin/Documents/screencaps/$screencap
  done
}

# Giffit
## create a gif from a video
###
giffit() {
  # optionally trim video
  #ffmpeg -y -ss 30 -t 3 -i $1 -vf fps=10,scale=320:-1:flags=lanczos,palettegen /tmp/palette.png

  # create color palette
  ffmpeg -y -i $1 -vf fps=10,scale=320:-1:flags=lanczos,palettegen /tmp/palette.png

  # create gif
  ffmpeg -i $1 -i /tmp/palette.png -filter_complex "fps=10,scale=800:-1:flags=lanczos[x];[x][1:v]paletteuse" $1.gif
}

# FaviGen
## converts a large icon into different sized optimized png's and an .ico file
###
favigen() {
  ## output resolutions
  png_resolutions="16 32 64 76 96 120 128 128 144 152 180 195 196 228 270 558"
  ico_resolutions="16 32 64"

  for last; do true; done
  for res in $png_resolutions; do
    convert $last -resize ${res}x${res}\! favicon-${res}.png
    optipng favicon-${res}.png -out favicon-${res}.png
  done

  for res in $ico_resolutions; do
    f=$f" favicon-${res}.png"
  done

  convert $f favicon.ico
}
