#!/usr/bin/octave -q
## -*- texinfo -*-
## Reads CHGCAR formated files and sums the elements
## Author: P.Mitev  2017.10.09
##

%Test for new Octave version
if (compare_versions(OCTAVE_VERSION(),"4.0.0","<") == "0" )  NEW= 0; else NEW=1; end


function [Structure]= read_CHGCAR(filename)

  #[label,scale,h,Ntypes,atlabels,typesN,nat,coordsys,positions,flags,fid]= read_POSCAR(filename);
  [Structure,fid]= read_POSCAR(filename);

  txt = fgetl(fid); # skip one line

  [tmp,tmpn]=fscanf (fid,"%e",3); Structure.nx=tmp(1); Structure.ny=tmp(2); Structure.nz=tmp(3); # get the grid dimension
  
  Structure.Dens= zeros(Structure.nx,Structure.ny,Structure.nz);

  Structure.Dens= reshape(fscanf (fid,"%e",Structure.nx*Structure.ny*Structure.nz) ,Structure.nx,Structure.ny,Structure.nz);

  fclose(fid);

  #Structure.Vol=  det(Structure.h);
  #Structure.Dens= Structure.Dens/Structure.Vol;

endfunction

function [Structure,fid]= read_POSCAR(filename)

  # Reading density file
  fid= fopen (filename);
  Structure.label= fgetl (fid); Structure.scale= fscanf (fid,"%e",1);
  Structure.h= Structure.scale*(fscanf (fid,"%e",[3,3]))'; txt = fgetl(fid); # finish the line
  Structure.Vol=  det(Structure.h);
  txt= fgetl(fid); att=txt; # get the atom line definition

  Structure.ver= 4;
  [nn,types]=sscanf(txt,"%s",30); # check if it is a label line or type definitions...
  if (!isdigit(nn(1)))
     Structure.ver= 5;
     Structure.atlabels= txt; txt= fgetl(fid);
  endif
  [Structure.typesN,Structure.Ntypes]=sscanf(txt,"%e",20);
  Structure.nat=0; for i=1:Structure.Ntypes; Structure.nat= Structure.nat+Structure.typesN(i); endfor

  do
    txt = fgetl(fid); # get line to check
    txt1= tolower(substr(txt,1,1));
  until ( txt1 == "d" || txt1 == "c" )

  Structure.coordsys = txt1;

  Structure.positions = zeros(Structure.nat,3);

  for i=1:Structure.nat
    Structure.positions(i,:) = fscanf(fid,"%e",[1,3]);
    txt = fgetl(fid);
    [lflags,nflags]= sscanf(txt,"%s",30);
    if (nflags == 3)
      Structure.flags(i,:)=lflags;
    else
      Structure.flags(i,:)="   ";
    endif
  endfor

endfunction


finp=argv(){1};
Struct = read_CHGCAR(finp);
printf("%.6f\n",sum(Struct.Dens(:))/Struct.nx/Struct.ny/Struct.nz)


