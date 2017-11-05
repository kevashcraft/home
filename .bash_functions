#
# ~/.bash_functions
#

# Screencast
## record the screen with a webcam overlay
## opens audacity for audio improvements
## trims beginning and ending 10 seconds from video
###
screencast() {
  ## unmute microphone
  amixer set Capture cap

  ## record screen, webcam, and audio
  ffmpeg \
    -y \
    -f x11grab `# screen grab` \
      -video_size 3840x2160 \
      -i :0.0 \
    -f v4l2 `# webcam grab` \
      -framerate 30 \
      -i /dev/video0 \
    -f alsa `# audio grab` \
      -ac 2 \
      -itsoffset 0.4 `# offset audio to align with video` \
      -i pulse \
    -filter_complex `# overlay webcam in top right` \
      "[0:v]setpts=PTS-STARTPTS[bg]; \
       [1:v]setpts=PTS-STARTPTS[fg]; \
       [bg][fg]overlay=W-w-10:10,format=yuv420p[out]" \
    -map "[out]" \
    -map 2:a \
    -c:v libx264 \
      -preset veryfast \
      -g 30 `# ensure 1 keyframe/second` \
    -c:a aac \
      -b:a 160k \
      -ar 44100 \
    /home/kevin/Documents/screencaps/current.mkv

  if [[ -z $1 ]]; then out=recent; else out=$1; fi

  if [[ -z $skip_audacity ]]; then
    audacity Documents/screencaps/current.mkv

    ffmpeg \
      -y \
      -i Documents/screencaps/current.mkv \
      -itsoffset 0.5 \
      -i Documents/screencaps/current.aac \
      -c:v copy \
      -c:a aac \
      -map 0:v:0 \
      -map 1:a:0 \
      Documents/screencaps/combined.mkv
  else
    cp Documents/screencaps/current.mkv Documents/screencaps/combined.mkv
  fi

  ## extracted from http://www.ffmpeg-archive.org/Trying-to-cut-5-sec-of-beginning-and-ending-of-mp4-files-td4674116.html
  ## get total seconds, convert to timestamp
  SECS_FLOAT=`ffprobe -i Documents/screencaps/combined.mkv -show_entries format=duration -v quiet -of csv="p=0"`
  SECS=${SECS_FLOAT%.*}
  SECS_TOTAL=$((SECS-22))
  SECS_H=$((SECS_TOTAL/3600))
  SECS_M=$(((SECS_TOTAL%3600)/60))
  SECS_S=$((SECS_TOTAL%60))

  TT=`printf "%02d:%02d:%02d\n" $SECS_H $SECS_M $SECS_S`

  ## trim beginning and end of video
  ffmpeg \
    -y \
    -ss 12 \
    -t $TT \
    -i Documents/screencaps/combined.mkv \
    -c:v copy \
    -c:a copy \
    Documents/screencaps/$out.mkv

  ## auto open vlc
  if [[ $open_vlc == "true" ]]; then
    vlc Documents/screencaps/$out.mkv
  fi
}
alias sc='screencast'

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
