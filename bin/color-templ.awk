#!/usr/bin/awk -f
BEGIN{
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
  gsub(/WARNING|Warning|warning/,                         c[2]"&"cn)  # Warning
  gsub(/ERROR|Error|error/,                               c[0]"&"cn)  # Error
  gsub(/FAIL|Fail|fail|FAILED|Failed|failed/,             c[0]"&"cn)  # Failed
  gsub(/([0-9]{1,3}\.){3}[0-9]{1,3}/,                     c[2]"&"cn)  # IP4 address
  gsub(/([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}/,           c[4]"&"cn)  # MAC
  gsub(/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}/, c[6]"&"cn)  # e-mail
  gsub(/https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}([-a-zA-Z0-9()@:%_\+.~#?&//=]*)/, c[4]"&"cn)  # web address

  $0= gensub(/(^|[[ ]){1}(OK|Ok)([] ]|$){1}/,           "\\1"c[2]"\\2"cn"\\3",  "g") # OK - special case

  gsub(/[&@][A-Za-z_]+/,                                  c[3]"&"cn)  # @& 
  gsub(/^#SBATCH.*$/,                                     c[6]"&"cn)  # SBATCH
  gsub(/^#.*$/,                                           c[4]"&"cn)  # comment

  print $0
}



#$0= gensub(/([[ ]){1}(WARNING|warning|Warning)([]! ]){1}/, "\\1"c[2]"\\2"cn"\\3",  "g")
