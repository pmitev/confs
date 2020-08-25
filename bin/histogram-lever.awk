#!/bin/awk -f
# Calculate a histogram of data from 1st column of file
# histogram range is from xmin to xmax, bin width = dx
# only data in range xmin - xmax counted
BEGIN{ 
  if (!col) col= 1
  if (!min) min= 0
  if (!max) max= 4000
  if (!dx)  dx = 1.
}

{  
  nh = (max-min)/dx
  dx2= dx/2.; 
  m++; x= $(col)
  if( x >= min && x <= max ) {
    n++
    i= int((x - min+dx2)/dx) 
    h[i-1] = h[i-1] + abs( 1 + (((i-1)*dx+min+dx2) -x)/dx )
    h[i  ] = h[i  ] + abs( 1 - (((i  )*dx+min+dx2) -x)/dx )
    #print "#", x,i, abs( 1 + (((i-1)*dx+min+dx2) -x)/dx ), abs( 1 - (((i  )*dx+min+dx2) -x)/dx )
  }
}

END{
 print " #... histogram parameters: min= "min" max= "max" dx= "dx" nbins= "nh
 print " #... data points read "m" ; data points in range "n
  for( i = 0 ; i <= nh-1 ; i++) {
    x = xmin + i*dx + dx2
    printf("%10.4f\t%12.6f\t%12.6f\n",x,h[i],h[i]/n/dx)
  }
}

function abs ( x ) { return (x >= 0) ? x : -x }
