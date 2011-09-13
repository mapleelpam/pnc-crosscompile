#!/bin/bash

function check_file()
{
	F=$1
	shift
	if [ ! -f $F ]; then
		echo "Not a regular file or file not found !"
		exit -1
	fi

	MIME=`file -bi $F | cut -d';' -f1`

	for ARG in $*
	do
		if [[ "$MIME" == "$ARG" ]]; then
			return 1
		fi
	done
	echo "File \"$F\" has wrong type '$MIME' !"
	exit -1
}

function myhelp()
{
	echo -ne \
	"\nUsage: $0 [before script] [after script] [xz tarball]\n\n" \
	"\tex: $0 before.sh after.sh mypackage.tar.xz\n\n"
	exit 0
}

# Main()
if [ $((BASH_ARGC)) != 3 ]; then
	myhelp
fi

check_file $1 'application/x-shellscript' 'text/x-shellscript'
check_file $2 'application/x-shellscript' 'text/x-shellscript'
check_file $3 'application/x-xz'

OUTF=$3.sh
BASEDIR=`dirname $0`

case $ARCH in
i*86) XZ=$BASEDIR/../libexec/xz.i386 ;;
x86_64) XZ=$BASEDIR/../libexec/xz.x86_64 ;;
*) printf '%s: no xz binary for architecture: "%s"\n' $(basename $0) $ARCH; exit 2 ;;
esac


echo -ne>$OUTF
cat $BASEDIR/xzexe.tmpl | while read LINE
do
	if [ "$LINE" == "@@SHELL_BEFORE@@" ]; then
		tail -n +2 $1 >> $OUTF
	elif [ "$LINE" == "@@SHELL_AFTER@@" ]; then
		tail -n +2 $2 >> $OUTF
	else
		echo "$LINE" >> $OUTF
	fi
done

XZ_START=`wc -l $OUTF | cut -d' ' -f1`
sed -i "s/@@XZ_START@@/$XZ_START/" $OUTF

XZ_SIZE=`wc -l $XZ | cut -d' ' -f1`
sed -i "s/@@XZ_SIZE@@/$XZ_SIZE/" $OUTF
cat $XZ >> $OUTF
echo "##XZ_TARBALL_START##" >> $OUTF

cat $3 >> $OUTF

chmod +x $OUTF
exit 0
