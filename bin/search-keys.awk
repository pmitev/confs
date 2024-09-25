#!/bin/awk -f
# search-keys.awk 'masterkey|wordending\>|\<wordbeginning' *.txt
BEGIN{
  keys= ARGV[1]; grepstr= keys;
  gsub("\\|","\\|",grepstr)
  print "##################################################################################"
  print "#",keys 
  print "##################################################################################"
  # print grepstr
  nkeys= split(keys,key,"|")
  for (i= 1; i <= ARGC-2; i++) ARGV[i]= ARGV[i+1]
  ARGC--
}

{
  for (i=1; i<=6; i++){
    if (match($0, key[i] )) m[i]++ 
  }
}


ENDFILE {
  if (m[1]) {
    print "\n============================================================================="
    printf( "%s : ",FILENAME)
    for (i=1;i<=nkeys; i++) printf ("%s: %g | ",key[i],m[i])
    print "\n============================================================================="
    cmd="grep --color=always \""grepstr"\" "FILENAME
    #print cmd
    system(cmd); close(cmd)
  }
  delete m
}
