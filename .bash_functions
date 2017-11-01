#
# ~/.bash_functions
#

kaiconmaker ()
{
        sizes=(16 32 64 76 96 120 128 128 144 152 180 195 196 228 270 558);
        alls=(16 32 64)
        all=""
        for size in "${sizes[@]}"; do
                convert $1.png -resize ${size}x${size} $1-${size}.png;
        done
        for size in "${alls[@]}"; do
                all="$all $1-$size.png";
        done
        convert $all $1.ico
}


