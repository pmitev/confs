#!/usr/bin/awk -f
# Calculate a histogram of data from 1st column of file
# histogram range is from xmin to xmax, bin width = dx
# only data in range xmin - xmax counted
#
BEGIN{ 
  if (!col) col=1
  if (!min) min= 0
  if (!max) max= 4000
  if (!dx)  dx = 1.
  
  n= 0; m= 0;
}

{ 
  nh = (max-min)/dx 
  m++ ; x = $(col)
  if( x >= min && x <= max ) {
    n++
    i= int((x-min)/dx) + 1
    h[i] = h[i] + 1.0
  }
}

END{
 print " #... histogram parameters: min= "min" max= "max" dx= "dx" nbins= "nh
 print " #... data points read "m" ; data points in range "n
  x = min - dx/2.0
  for( i = 1 ; i <= nh ; i++) {
    x = x + dx
    printf("%10.4f\t%12.6f\t%12.6f\n",x,h[i],h[i]/n/dx)
  }
}
