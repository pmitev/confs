#!/usr/bin/awk -f
BEGIN{
  gnu="gnuplot -persist";
  getline;
  while($1~"#") {getline}

  printf"plot \""ARGV[1]"\"  w l lw 2 lt 1" |& gnu;
  for (i=3; i<=NF;i++) { 
    printf ",\"\" u 1:"i" w l lw 2 lt "i |& gnu;
  }

  print"" |& gnu;  
}

