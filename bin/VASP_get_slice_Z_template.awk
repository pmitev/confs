#!/usr/bin/awk -f
BEGIN{
  Zslice=40 
  margin=0 # extra margin around the cell
  plotfile="ps-plot-Z.gnu"
  
  getline < ARGV[1]; title =$0
  getline < ARGV[1]; scale =$0

  getline < ARGV[1]; h1=$1; h2=$2; h3=$3;
  getline < ARGV[1]; h4=$1; h5=$2; h6=$3;
  getline < ARGV[1]; h7=$1; h8=$2; h9=$3;
 
  getline < ARGV[1];
   for (i=1;i<=NF;i++){ type[i]=$i;natoms += $i}

  for (i=1;i<=natoms+2;i++) {
    getline < ARGV[1];
    ax[i]= $1; ay[i]= $2; az[i]= $3
  }

  getline < ARGV[1]; x_grid=$1; y_grid=$2; z_grid=$3; print > "/dev/stderr"

  x=0;y=1;z=1
  while ((getline < ARGV[1]) >0 ){
    for (i=1;i<=NF;i++){
      x++
      if (x > x_grid) {x=1; y++}
      if (y > y_grid) {y=1; z++}
      if (z > z_grid) {z=1; }
      grid[x,y,z]=$i
    }
    
  }

  dx=sqrt(h1**2 + h2**2 + h3**2)/x_grid
  dy=sqrt(h4**2 + h5**2 + h6**2)/y_grid
  dz=sqrt(h7**2 + h8**2 + h9**2)/z_grid
  
  printf "" > "dens.dat"
  
  for (x=1-margin;x<=x_grid+margin;x++){
    for (y=1-margin;y<=y_grid+margin;y++){
      
      xg=x%x_grid; 
      if(xg==0) xg=x_grid; 
      if(xg<0) xg=x_grid+xg
      
      yg=y%y_grid; 
      if(yg==0) yg=y_grid; 
      if(yg<0) yg=y_grid+yg
      
      xx=x*h1 + y*h4 + z*h7
      yy=x*h2 + y*h5 + z*h8
      zz=x*h3 + y*h6 + z*h9
      printf "%f %f %f\n",xx,yy,grid[xg,yg,Zslice] >> "dens.dat"
    }
  }

  print "#!/usr/bin/gnuplot -persist" > plotfile
  print "set noclabel" >> plotfile
  print "set mapping cartesian" >> plotfile
  print "set nohidden3d" >> plotfile
  print "set locale \"C\"" >> plotfile
  print "#---------------------------------------------------" >> plotfile
  print "set dgrid3d   "x_grid","y_grid",16" >> plotfile
  print "set nosurface; set nokey; set nolabel; set noxtics; set noytics" >> plotfile
  print "set size 2,2; set size ratio -1; set contour" >> plotfile
  print "#---------------------------------------------------" >> plotfile
  print "set term postscript eps enhanced color dashed" >> plotfile
  print "set output \"out.ps\"" >> plotfile
  print "set origin -0.5,0.0" >> plotfile
  print "set multiplot" >> plotfile
  print "set view 0,0" >> plotfile
  print "" >> plotfile
  print "set border 31 lw 1.5" >> plotfile
  print "set cntrparam levels incremental -5.0, 1.0,-1.00" >> plotfile
  print "splot \"dens.dat\" w l lt 3 lw 2" >> plotfile
  print "set noborder" >> plotfile
  print "" >> plotfile
  print "set cntrparam levels incremental 1.0, 1.0, 7.0" >> plotfile
  print "splot \"dens.dat\" w l lt 1 lw 2" >> plotfile
  print "" >> plotfile
  print "set cntrparam levels discrete 0.00" >> plotfile
  print "splot \"dens.dat\" w l lt 5 lw 2" >> plotfile
  print "" >> plotfile
  print "set nomultiplot" >> plotfile
  print "set output" >> plotfile
  print "" >> plotfile
  print "!sed -i -e 's/LT2 { PL \\[2 dl 3 dl\\] 0 0 1 DL } def/LT2 { PL \\[12 dl 8 dl\\] 0 0 1 DL } def/' out.ps" >> plotfile
  print "!sed -i -e 's/LT4 { PL \\[5 dl 2 dl 1 dl 2 dl\\] 0 1 1 DL } def/LT4 { PL \\[12 dl 4 dl 1 dl 4 dl\\] 0 1 1 DL } def/' out.ps" >> plotfile
  print "!gv out.ps" >> plotfile
  print "" >> plotfile
  print "" >> plotfile

  close(plotfile);
  cmd="chmod u+x "plotfile"; .//"plotfile; system(cmd); close(cmd);
}


