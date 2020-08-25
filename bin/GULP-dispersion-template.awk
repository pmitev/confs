#!/bin/awk -f
BEGIN{point=1; pi=3.14159265358979;
# PROVIDE the Reciprocal lattice vectors!!!  
# Use verb keyvord in the GULP input
  k1=1.92128;  k2=1.10925;  k3=0.00000;
  k4=0.00000;  k5=2.21850;  k6=0.00000;
  k7=0.00000;  k8=0.00000;  k9=1.19938;

  kn1=sqrt(k1**2 + k2**2 + k3**2)
  kn2=sqrt(k4**2 + k5**2 + k6**2)
  kn3=sqrt(k7**2 + k8**2 + k9**2)
}

#-------------------------------------------------------------------------

/#  Section number/ {Section=$5;}
/#  Start K point/ {kb1[Section]=$6*kn1; kb2[Section]=$7*kn2; kb3[Section]=$8*kn3}
/#  Final K point/ {ke1[Section]=$6*kn1; ke2[Section]=$7*kn2; ke3[Section]=$8*kn3}

$0 !~ /#/ {
  point=$1
  if(point == oldpoint) mod++; else mod=1
  freq[Section,mod,point]=$2
  oldpoint=point  
}

#-------------------------------------------------------------------------
END{
# print Section,mod,point
        
  for(s=1;s<=Section;s++){
    dd=sqrt((kb1[s]-ke1[s])**2 + (kb2[s]-ke2[s])**2 + (kb3[s]-ke3[s])**2)/point
   
    label[s]=sprintf("%3.1f,%3.1f,%3.1f",kb1[s],kb2[s],kb3[s]);
    labpos[s]=pos/pi
#   print "# Section "s" "pos/pi 
    for(p=1;p<=point;p++){
#     printf"%g",pos/pi 
      pos=pos+dd
      
      for(m=1;m<=mod;m++){
#       printf" %g",freq[s,m,p]/33.35641 
      } 

#     print "" 
    }
    pos=pos-dd
  }

  # GRACE output
  max=(pos-dd)/pi
  gracef="grace.agr"
  cmd= "date  +%Y.%m.%d"; (cmd | getline); date=$0; close(cmd)
  
  printf  "@timestamp def \""date"\"\n" > gracef; 
  printf  "@with g0\n" >> gracef;
  printf  "@title \"\"\n" >> gracef;
  printf  "@world xmin 0\n" >> gracef;
  printf  "@world xmax "max"\n" >> gracef;
  printf  "@view  ymin 0.25\n" >> gracef;
  printf  "@page size 842, 595\n" >> gracef;
  printf  "@autoscale onread yaxes\n" >> gracef;
  
  printf  "@xaxis label \"q\"\n" >> gracef;
  printf  "@yaxis label \"Frequency\"\n" >> gracef;

  printf  "@xaxis tick major grid on\n" >> gracef;
  printf  "@xaxis tick spec type both\n" >> gracef;

  printf  "@xaxis tick spec "Section"+1\n" >> gracef;
  printf  "@xaxis ticklabel angle 90\n" >> gracef;
  printf  "@xaxis ticklabel char size 0.75\n" >> gracef;
  for (s=1;s<=Section;s++){
    printf "@xaxis tick major %d,%g\n",s-1,labpos[s] >> gracef;
    printf "@xaxis ticklabel %d,\"(%3.1f,%3.1f,%3.1f)\"\n",s-1,kb1[s]/kn1,kb2[s]/kn2,kb3[s]/kn3 >> gracef;
  }
  printf "@xaxis tick major %d,%g\n",s-1,max >> gracef;
  printf "@xaxis ticklabel %d,\"(%3.1f,%3.1f,%3.1f)\"\n",s-1,ke1[s-1]/kn1,ke2[s-1]/kn2,ke3[s-1]/kn3 >> gracef;

  for(m=1;m<=mod;m++){
    printf "@target G0.S%d\n",m-1 >> gracef;
    printf "@type xy\n" >> gracef;
    pos=0
    for(s=1;s<=Section;s++){
      dd=sqrt((kb1[s]-ke1[s])**2 + (kb2[s]-ke2[s])**2 + (kb3[s]-ke3[s])**2)/point
 
      for(p=1;p<=point;p++){
        printf"  %g  %g\n",pos/pi,freq[s,m,p]/33.35641 >> gracef;
        pos=pos+dd
    
      } 
      pos=pos-dd # Start from the same point for the next section
    }
    printf "&\n" >> gracef;
  }
}

    

