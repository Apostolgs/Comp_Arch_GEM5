#!/bin/bash

#run serially all specs with specified configurations and run read_results.sh


# | Παράμετρος 			| Configuration1 | Configuration2 | Configuration3 | Configuration4 | Configuration5 | Configuration6 |
# | l1d_cache_size (kB) 	| 64 | 32 | 32 | 32 | 32 | 32 |
# | l1i_cache_size (kB) 	| 128 | 64 | 64 | 64 | 64 | 64 |
# | l2_cache_size (kB) 		| 2048 | 4096 | 2048 | 2048 | 2048 | 2048 |
# | l1i_cache_assoc 		| 2 | 2 | 4 | 2 | 2 | 2 | 
# | l1d_cache_assoc 		| 2 | 2 | 4 | 2 | 2 | 2 |
# | l2_cache_assoc 		| 8 | 8 | 8 | 16 | 8 | 8 |
# | cacheline 			| 64 | 64 | 64 | 64 | 128 | 64 |
# | cpu_clock (GHz) 		| 2 | 2 | 2 | 2 | 2 | 3 |


# Configuration table as arrays
l1d_cache_sizes=(64 32 32 32 32 32)
l1i_cache_sizes=(128 64 64 64 64 64)
l2_cache_sizes=(2048 4096 2048 2048 2048 2048)
l1i_cache_assocs=(2 2 4 2 2 2)
l1d_cache_assocs=(2 2 4 2 2 2)
l2_cache_assocs=(8 8 8 16 8 8)
cachelines=(64 64 64 64 128 64)
cpu_clocks=(2 2 2 2 2 3)

# Run simulations for each configuration
for i in "${!l1d_cache_sizes[@]}"; do
    	# Extract configuration values
    	l1d_cache_size=${l1d_cache_sizes[i]}
    	l1i_cache_size=${l1i_cache_sizes[i]}
    	l2_cache_size=${l2_cache_sizes[i]}
    	l1i_cache_assoc=${l1i_cache_assocs[i]}
    	l1d_cache_assoc=${l1d_cache_assocs[i]}
	l2_cache_assoc=${l2_cache_assocs[i]}
    	cacheline=${cachelines[i]}
	cpu_clock=${cpu_clocks[i]}

	if [$l1d_cache_size + $l1i_cache_size > 256]; then
		echo "Total l1 memory cant exceed 256kB"
		exit 0
	fi

	if [$l2_cache_size > 4094]; then
		echo "l2 memory cant exceed 4MB"
		exit 0
	fi


	results_name=l1d${l1d_cache_size}_l1i${l1i_cache_size}_l2${l2_cache_size}_l1iassoc${l1i_cache_assoc}_l1iassoc${l1d_cache_assoc}_l2assoc${l2_cache_assoc}_cacheline${cacheline}_cpu_clock${cpu_clock}
	echo "Results will be saved to: $results_name"

	./build/ARM/gem5.opt -d spec_results/specbzip configs/example/se.py --cpu-type=MinorCPU --caches --l2cache --l1d_size=${l1d_cache_size}kB --l1i_size=${l1i_cache_size}kB \
	--l2_size=${l2_cache_size}kB --l1i_assoc=$l1i_cache_assoc --l1d_assoc=$l1d_cache_assoc --l2_assoc=$l2_cache_assoc --cacheline_size=$cacheline --cpu-clock=${cpu_clock}GHz \
	-c spec_cpu2006/401.bzip2/src/specbzip -o "spec_cpu2006/401.bzip2/data/input.program 10" -I 100000000
	wait
	./build/ARM/gem5.opt -d spec_results/specmcf configs/example/se.py --cpu-type=MinorCPU --caches --l2cache --l1d_size=${l1d_cache_size}kB --l1i_size=${l1i_cache_size}kB \
	--l2_size=${l2_cache_size}kB --l1i_assoc=$l1i_cache_assoc --l1d_assoc=$l1d_cache_assoc --l2_assoc=$l2_cache_assoc --cacheline_size=$cacheline --cpu-clock=${cpu_clock}GHz \
	-c spec_cpu2006/429.mcf/src/specmcf -o "spec_cpu2006/429.mcf/data/inp.in" -I 100000000
	wait
	./build/ARM/gem5.opt -d spec_results/spechmmer configs/example/se.py --cpu-type=MinorCPU --caches --l2cache --l1d_size=${l1d_cache_size}kB --l1i_size=${l1i_cache_size}kB \
	--l2_size=${l2_cache_size}kB --l1i_assoc=$l1i_cache_assoc --l1d_assoc=$l1d_cache_assoc --l2_assoc=$l2_cache_assoc --cacheline_size=$cacheline --cpu-clock=${cpu_clock}GHz \
	-c spec_cpu2006/456.hmmer/src/spechmmer -o "--fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 spec_cpu2006/456.hmmer/data/bombesin.hmm" -I 100000000
	wait
	./build/ARM/gem5.opt -d spec_results/specsjeng configs/example/se.py --cpu-type=MinorCPU --caches --l2cache --l1d_size=${l1d_cache_size}kB --l1i_size=${l1i_cache_size}kB \
	--l2_size=${l2_cache_size}kB --l1i_assoc=$l1i_cache_assoc --l1d_assoc=$l1d_cache_assoc --l2_assoc=$l2_cache_assoc --cacheline_size=$cacheline --cpu-clock=${cpu_clock}GHz \
	-c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt" -I 100000000
	wait
	./build/ARM/gem5.opt -d spec_results/speclibm configs/example/se.py --cpu-type=MinorCPU --caches --l2cache --l1d_size=${l1d_cache_size}kB --l1i_size=${l1i_cache_size}kB \
	--l2_size=${l2_cache_size}kB --l1i_assoc=$l1i_cache_assoc --l1d_assoc=$l1d_cache_assoc --l2_assoc=$l2_cache_assoc --cacheline_size=$cacheline --cpu-clock=${cpu_clock}GHz \
	-c spec_cpu2006/470.lbm/src/speclibm -o "20 spec_cpu2006/470.lbm/data/lbm.in 0 1 spec_cpu2006/470.lbm/data/100_100_130_cf_a.of" -I 100000000
	wait
	bash read_results.sh read_results.ini spec_results/results_$results_name.txt
	wait
done
