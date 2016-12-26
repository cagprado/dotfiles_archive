# Those are some useful functions for bash, based on builtin commands or
# Slackware linux common applications. It also uses some aliases defined
# on 'common.bash' files.
ERROR="\033[31mError:\033[m"
WARN="\033[31mWarning:\033[m"

# Prints a help screen that remembers me the common mencoder filters
# options for different sources.
helpfilter()
{
	cat <<-EOF
	For NTSC DVD movies there are three kinds of source. Different
	filtering should be applied on each case.

		Progressive: (always 24000/1001 fps) and no interlacing pattern.
	-ofps 24000/1001 - vf CROP,SCALE

		Telecined: (or mixed Progressive/Telecined - there are some
	30000/1001 fps messages)
	-ofps 24000/1001 - vf CROP,SCALE,pullup,softskip

		Interlaced: (no fps message but the usual interlacing pattern)
	-vf CROP,SCALE,yadif=0|1

	Note that you must not change these filter sequences in order to
	get them to work.

	The common options for x264encopts are:
	threads=0:crf=19:bframes=8:b-adapt=2:direct=auto:me=umh:merange=24:partitions=all:rc-lookahead=60:ref=8:subme=9

	You can add tunes:
	
		Film:
	deblock=-1,-1:psy-rd=,0.15

	  Animation:
	{bframes +2:ref (double | 1)}:deblock=1,1:psy-rd=0.4,:aq-strength=0.6
	EOF
}

# Prints a help screen that remembers me how to print a ps/pdf file
# with some common options…
helpprint()
{
	cat <<-EOF
	To print ps file use lp command.
	Set the PRINTER environment and all will be good.
	* Page interval:
		-P x,y-z,k,l
		
		note: output pages, not logical ones (this is good)

	* Set even of odd:
		-o page-set=<even|odd>

	* Multiple pages:
		-o number-up=N

	* Reverse order:
		-o output-order=reverse

	* To fit in page
		-o fitplot
	EOF
}

# Removes all spaces from filenames
rmspaces()
{
  local NEWNAME
  for OLDNAME in "$@"; do
    NEWNAME=$(echo "$OLDNAME" | tr \  _)
    rename "$OLDNAME" "$NEWNAME" "$OLDNAME"
  done
}
