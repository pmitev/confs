#!/usr/bin/awk -f

$1=="&SUBSYS" {SUBSYS=1}
$1=="&END" && $2=="SUBSYS" {SUBSYS=0}


$1=="&CELL" {
  if (SUBSYS){
    getline; A=$2" "$3" "$4; h[1,1]=$2; h[1,2]=$3; h[1,3]=$4
    getline; B=$2" "$3" "$4; h[2,1]=$2; h[2,2]=$3; h[2,3]=$4
    getline; C=$2" "$3" "$4; h[3,1]=$2; h[3,2]=$3; h[3,3]=$4
  }
}

$1=="&COORD"{
  if (SUBSYS){
    while ($1 !="&END"){
      getline;
      if (NF==4) {i++;alabel[i]=$1; X[i]=$2; Y[i]=$3; Z[i]=$4;}
      if ($1=="SCALED" && $2=="T") scaledcoord=1
    }
  }
  natoms=i  
}

END{
  print natoms
  print "Lattice=\""A" "B" "C"\" Properties=species:S:1:pos:R:3 pbc=\"T T T\""
  for (i=1;i<=natoms;i++) {
    if (scaledcoord) {
      XX= X[i]*h[1,1]+Y[i]*h[2,1]+Z[i]*h[3,1]
      YY= X[i]*h[1,2]+Y[i]*h[2,2]+Z[i]*h[3,2]
      ZZ= X[i]*h[1,3]+Y[i]*h[2,3]+Z[i]*h[3,3]
      print alabel[i],XX,YY,ZZ
    }
    else print alabel[i],X[i],Y[i],Z[i]
  }
}
