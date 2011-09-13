ERR=0
for F in $*; do {
	DIR=`dirname $F`
	PNG=`basename $F`

	if [ ! -e $F ]; then
		echo "Error: \"$F\" file not found.";
		ERR=1;
	else
		MIME=`file -b -i $F | cut -d';' -f1`
		if [ "$MIME" != "image/png" ]; then
			echo "Errot: \"$F\" file type '$MIME' not support.";
			ERR=1;
		fi
	fi
}; done;

if [ $ERR -eq 1 ] ; then exit -1; fi

SUM=0
for F in $*; do {
	DIR=`dirname $F`
	PNG=`basename $F`

	TMP=`mktemp -u `
	optipng --quiet -o7 -out $TMP $F
	SB=`du -b $F | cut -f1`
	SA=`du -b $TMP | cut -f1`
	SD=$(($SB-$SA))
	SUM=$(($SUM+$SD))
	echo $F: `du -b $F | cut -f1` \> `du -b $TMP | cut -f1` = $SD

	XPM=`echo -ne $PNG | sed 's/\....$/\.xpm/'`
	rm -f $DIR/$XPM && convert $TMP $DIR/$XPM
	sed -i 's/static char/const char/' $DIR/$XPM
	rm -f $TMP
}; done;
echo -e "\nTotal save $SUM bytes"
