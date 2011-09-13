{
	while (	match($0,/const char .*\[\]/) ) {
		print "extern " substr( $0,RSTART, RLENGTH) ";"
		$0 = substr( $0, RSTART + RLENGTH)
	}
}
