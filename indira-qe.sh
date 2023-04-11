#!/bin/bash

m=0
limit=10

if [ -z "$1" ]
then	
      echo "limit is $limit"
else
      limit=$1	
      echo "limit is now $limit"
fi


while [ "$m" -le "$limit" ]
do
alat=`echo "30+10*$m" | bc -l`
cat >scf.in<<EOF
------------------------------------------------------------------------------
# quantum espresso input-fragment from wxDragon

&control
 calculation = 'scf'
 restart_mode='from_scratch',
 prefix='GaAs',
 pseudo_dir = '.',
 outdir='.'
 tprnfor = .true., tstress=.true.
 /
&system
ibrav= 0, celldm(1)=10.86627, nat= 8, ntyp= 2
ecutwfc = $alart, ecutrho = 240.0,
 /
&electrons
mixing_mode = 'plain'
mixing_beta = 0.3
conv_thr =  1.0d-6
mixing_fixed_ns = 0
 /
CELL_PARAMETERS
  1.00000 0.00000 0.00000
  0.00000 1.00000 0.00000
  0.00000 0.00000 1.00000
ATOMIC_SPECIES
 Ga 69.720 Ga.UPF
 As 74.920 As.UPF
ATOMIC_POSITIONS {crystal}
 Ga 0.00000 0.00000 0.00000
 As 0.25000 0.25000 0.25000
 Ga 0.00000 0.50000 0.50000
 Ga 0.50000 0.00000 0.50000
 Ga 0.50000 0.50000 0.00000
 As 0.25000 0.75000 0.75000
 As 0.75000 0.25000 0.75000
 As 0.75000 0.75000 0.25000
K_POINTS {automatic}
$alat $alat $alat 0 0 0
----------------------------------------------------------------------------------------------------------
EOF

echo "Now the program will run with k_Points = $alat"
sleep 2
#pw.x < scf.in | tee scf.out
#te=`grep ! scf.out | tail -1 | awk '{print $5}'`
#echo "$alat  $te" >> etot.dat
#mv scf.in scf$m.in10
#mv scf.out scf$m.out

let m=$m+1
done
