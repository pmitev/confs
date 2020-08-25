#!/usr/bin/awk -f
BEGIN{
  nARGC= ARGC; ARGC=1

  c[0]= "\033[97;41m" # white-red
  c[1]= "\033[31;1m"  # red
  c[2]= "\033[32;1m"  # green
  c[3]= "\033[33;1m"  # yellow
  c[4]= "\033[34;1m"  # blue
  c[5]= "\033[35;1m"  # magenta
  c[6]= "\033[36;1m"  # cyan
  c[7]= "\033[93;41m" # yellow-red
  cn=   "\033[0m"     # reset
}

{
  for (i=1; i< nARGC; i++ ){
    ci= ARGV[i]+0 # color index
    m= ARGV[i]    # match string
    sub(ci,"",m)  # remove color index
    gsub(m, c[ci]"&"cn)  # inser color codes
  }
  print $0
}
