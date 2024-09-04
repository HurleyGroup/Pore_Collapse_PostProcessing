#!/bin/bash


#sed -i -e 's/X=6/X=69/g' input_try.m 

#matlab -batch "run('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Processing_Codes/input_try.m');exit;"


#sed -i -e 's/X=69/X=60/g' input_try.m

#matlab -batch "run('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Processing_Codes/input_try.m');exit;"

for n in {1..5};
do 
	echo $n
	new=$(($n+1))
	sed -i -e "s/X=$n/X=$new/g" input_try.m
        matlab -batch "run('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Processing_Codes/input_try.m');exit;"

done
