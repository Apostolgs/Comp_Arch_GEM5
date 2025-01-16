# Αναφορά GEM5
### Αρχιτεκτονική Υπολογιστών
#### Αποστόλης Σταυρόπουλος 10177
#### apostolgs@ece.auth.gr

## Εισαγωγή

Θα χρησιμοποιηθεί έτοιμο Virtual Machine (VM) για την εκπόνηση της παρούσας εργασίας. Θα χρησιμοποιειθεί ο GEM5 προσομοιωτής για την εξαγωγή συμπερασμάτων από προσομοιώσεις benchmark.
Θα δοθούν αποτελέσματα προσομοιώσεων και επεξήγηση αυτών. Επιπλέον, θα δοθούν και όσα βοηθητικά scripts θα χρησιμοποιηθούν για αυτοματοποίηση και συλλογή αποτελεσμάτων.

## Πρώτο μέρος

Στο πρώτο μέρος θα γίνει προσομοίωση σε απλά προγράμματα. Αρχικά θα γίνει προσομοίωση σε έτοιμο πρόγραμμα hello_world. Έπειτα θα γραφτεί πρόγραμμα που κατασκευάζει σειρά Fibonacci
για έλεγχο.

### Προσομοίωση προγράμματος hello_world

Τύπος CPU : Minor
Συχνότητα Λειτουργίας : 2GHz
Βασικές Μονάδες :
- 1 CPU core
- 2 memory channels
- No memory ranks
Caches : 2 Levels
  L1:
    Instrucion Cache
    Data Cache
  L2
Μνήμη : 2GB

Επαλήθευση από Options.py/ config.ini / config.json / stats.txt

>system.cpu_cluster.cpus type=MinorCPU

>system.clk_domain clock=1000

>sim_seconds : 0.000035 Number of seconds simulated

>sim_insts : 5027 Number of instructions simulated

>host_inst_rate : 129251 Simulator instruction rate (inst/s)

>Total # of committed instructions : 5027 Number of instructions committed

>L2 accesses : 474 Number of overall (read+write) accesses

#### 1. Μοντέλα CPUs

Ο gem5 προσομοιωτής δίνει τη δυνατότητα επιλογής τύπων CPU. Οι τύποι που θα δούμε στη συνέχεια είναι AtomicSimpleCPU, MinorCPU, High-Performance In-Order (HPI) CPU.

- AtomicSimpleCPU
Είναι ένα απλό μοντέλο CPU το οποίο προέρχεται από το SimpleCPU και χρησιμοποιεί atomic memory accesses. Χρησιμοποιείται για απλές αναλύσεις χωρίς να μας ενδιαφέρει η ακριβής προσομοίωση ενός συστήματος. 
Είναι καλό για την επαλήθευση της λειτουργικότητας ενός προγράμματος, όχι για την ανάλυση της επίδοσης του.

![AtomicSimpleCPU](https://github.com/user-attachments/assets/9bbd5b24-8ddc-4fc3-9257-3c9125e3073b)
Εικόνα 1. Διάγραμμα AtomicSimpleCPU

- MinorCPU

Είναι ένα in-order μοντέλο επεξεργαστή με σταθερό pipeline, διαμορφώσιμα data structures και συμπεριφορά εκτέλεσης. Χρησιμοποιείται για την προσομοίωση μοντέλων επεξεργαστών με αυστηρά in-order executing behaviour. 
Είναι κατάλληλο για λειτουργική επαλήθευση προγράμματος αλλά και για ανάλυση επίδοσης. Είναι ένα framework για συσχέτιση μικρό-αρχιτεκτονικής με ένα δεδομένο επεξεργαστή με παρόμοιες δυνατότητες.

- HPI CPU

![image](https://github.com/user-attachments/assets/bd7ec5b9-855d-49b2-a0a1-86cebd70990b)
Εικόνα 2. HPI model

#### Gem5 simulation of Fibonacci program

Κατασκευάστηκε πρόγραμμα σε C το οποίο να εκτυπώνει τα στοιχεία της σειράς Fibonacci ως το index που ορίζει ο προγραμματιστής. 
Το πρόγραμμα προσομοιώθηκε στον gem5 με τύπους CPU MinorCPU και TimingSimpleCPU και με Options default, 3GHz και memory type DDR4_2400_8x8.

- MinorCPU
  
| Configuration | Simulation Time | cpi | 
| ---: | ---: | ---: |
| default | 0.000041 | 5.488686 |
| 3GHz | 0.000038 | 7.512373 |
| DDR4_2400_8x8 | 0.000040 | 5.286754 |

- TimingSimpleCPU

| Configuration | Simulation Time | cpi | 
| ---: | ---: | ---: |
| default | 0.000040 | 5.286754 |
| 3GHz | 0.000043 | - |
| DDR4_2400_8x8 | 0.000050  | - |

Από τα παραπάνω, φαίνεται πως στο MinorCPU μοντέλο, η αύξηση του CPU clock speed βελτίωσε το simulation time ωστόσο χειροτέρεψε το CPI. Αυτό είναι αναμενόμενο καθώς σε κάθε κύκλο ο επεξεργαστής έχει λιγότερο χρόνο για να εκτελέσει instructions. 
Συνεπώς, μειώθηκε η απόδοση του επεξεργαστή. Το TimingSimpleCPU βλέπουμε πως έχει γενικά χειρότερο χρόνο εκτέλεσης από το MinorCPU μοντέλο. Αυτό είναι λογικό καθώς το TimingSimpleCPU δεν είναι κατάλληλο για εξεταση επιδόσεων, αλλα για λειτουργική επαλήθευση.

## Δεύτερο Μέρος

Στο δεύτερο μέρος θα χρησιμοποιηθεί ο gem5 για simulation από διάφορα έτοιμα benchmarks. Ta benchmarks αυτά είναι

- 400.bzip2: Compression and decompression of Data entirely in Memory
- 429.mcf: Single-depot vehicle scheduling in public mass transportation. Integer Arithmetic
- 456.hmmer: Search a gene sequence database
- 458.sjeng: Artificial Intelligence (game tree search & pattern recognition)
- 470.lbm: Computational Fluid Dynamics, Lattice Boltzmann Method

Όλα τα runs έγιναν με instruction cap 100000000 ώστε να μήν παίρνουν οι εκτελέσεις υπερβολικά πολύ χρόνο.

### Αρχικές προσομοιώσεις των Benchmarks

Για την εξαγωγή των χαρακτηριστικών που μας ενδιαφέρουν κατασκευάζεται .ini αρχείο που λειτουργεί συμπληρωματικά με το read_results.sh script. To .ini αρχείο δίνεται παρακάτω.
```
[Benchmarks]
specbzip
spechmmer
speclibm
specmcf
specsjeng

[Parameters]
sim_seconds
system.cpu.cpi   
system.cpu.icache.overall_miss_rate::total
system.cpu.dcache.overall_miss_rate::total
system.l2.overall_miss_rate::total   

[Output]
benchmark_results.txt
```

Εκτελούνται τα benchmarks με default settings. Αρχικά τα default settings ορίζουν:
| Τύπος |	Τιμή |
| ---: | ---: |
| Μέγεθος L1 Instruction Cache	| 32kB	|
| Μέγεθος L1 Data Cache	| 64kB	|
| Μέγεθος L2 Cache	| 2MB	|
| Associativity L1 Instruction Cache	| 2	|
| Associativity L1 Data Cache	| 2	|
| Associativity L2 Cache	| 8	|
| Cache Line Size	| 64	|
| CPU clock | 2GHz |

Τα αποτελέσματα των benchmarks είναι:

| Benchmarks	| Sim_seconds(s) | Cpi | Icache_miss_rate |	Dcache_miss_rate |	L2_miss_rate | 
| ---: | ---: | ---: | ---: | ---: | ---: |
| specbzip	| 0.083982	|	1.679650	|	0.0077%	|	1.4798%	|	28.2163%	|
| spechmmer	| 0.059396	|	1.187917	|	0.0221%	|	0.1637%	|	7.7760%	|
| speclibm	| 0.174671	|	3.493415	|	0.0094%	|	6.092%	|	99.9944%	|
| speccmf	| 0.064955	|	1.299095	|	2.3612%	|	0.2108%	|	5.5046%	|
| specsjeng	| 0.513528	|	10.270554	|	0.0020%	|	12.1831%	|	99.9972%	|


Φαίνεται πως τα sim seconds είναι όλα <1 second. Ωστόσο φαίνεται πως για τα διάφορα benchmarks διαφέρουν κατά μία τάξη μεγέθους. 
Επιπλέον, φαίνεται correlation μεταξύ cpi και sim_seconds. Για τα miss rate, όπως είναι αναμενόμενο το instruction cache miss rate είναι μικρότερο από το data cache miss rate. 
Επιπλέον για ορισμένα benchmarks τα miss rate είναι κατά πολύ μεγαλύτερα. Αυτό οφείλεται στην ιδιαιτερότητα του κώδικα του κάθε benchmark. 
Το miss rate στην L2 είναι εξαιρετικά μεγάλο στα benchmarks με μεγάλο execution time. Στη συνέχεια δίνεται διάγραμμα για τα ποσοστά miss rate των διαφόρων cache.

![image](https://github.com/user-attachments/assets/304ababd-41bf-47fe-ac82-9d8f93ab492a)
Εικόνα 3. Cache Miss Rates

Στη συνέχεια θα επαναληφθούν οι εκτελέσεις των benchmarks με διαφορετικά settings. Ta settings αφορούν αλλαγή στο CPU clock από 2GHz σε 1GHz και 3GHz. 
Επιπλέον εξετάστηκε η αλλαγή του τύπου μνήμης από DDR3_1600_x64 σε DDR3_2133_8x8 για το benchmark speclibm με τα άλλα settings στις default τιμές του.

- 1GHz
  
| Benchmarks | Sim_seconds(s) | Cpi	| Icache_miss_rate	| Dcache_miss_rate	| L2_miss_rate |
| ---: | ---: | ---: | ---: | ---: | ---: |
| specbzip | 	0.161025	| 1.610247	| 0.0077%	| 1.4675%	| 28.2157% |
| spechmmer | 0.118530	| 1.185304	| 0.0221%	| 0.1629%	| 7.7747% |
| speclibm |	0.262327	| 2.623265	| 0.0094%	| 6.0971%	| 99.9944% |
| speccmf |	0.127942	| 1.279422	| 2.3627%	| 0.2108%	| 5.5046% |
| specsjeng | 0.704056	| 7.040561	| 0.0020%	| 12.1831%	| 99.9972% |

- 3GHz
  
| Benchmarks | Sim_seconds(s) | Cpi	| Icache_miss_rate	| Dcache_miss_rate	| L2_miss_rate |
| ---: | ---: | ---: | ---: | ---: | ---: |
| specbzip	| 0.058385	| 1.753291	| 0.0077%	| 1.4932%	| 28.2166% |
| spechmmer	| 0.039646	| 1.190581	| 0.0221%	| 0.1637%	| 7.7761% |
| speclibm	| 0.146433	| 4.397377	| 0.0094%	| 6.0972%	| 99.9944% |
| speccmf	| 0.043867	| 1.317329	| 2.3609%	| 0.2108%	| 5.5046% |
| specsjeng	| 0.449821	| 13.508136	| 0.0020%	| 12.1831%	| 99.9972% |

- speclibm με DDR3_2133_8x8
  
| Benchmarks | Sim_seconds(s) | Cpi	| Icache_miss_rate	| Dcache_miss_rate	| L2_miss_rate |
| ---: | ---: | ---: | ---: | ---: | ---: |
| speclibm | 0.171530 |	3.430593	| 0.0094%	| 6.0972%	| 99.9944% |

Από τα παραπάνω μπορούμε να πούμε πως το simulation time είναι ανάλογο του clock speed. To cpi είναι αντιστρόφως ανάλογο του clock speed. 
Τα miss rates για L1 instruction, data και L2 cache είναι ανεξάρτητα του clock speed. Τα παραπάνω είναι αναμενόμενα. 

### Design Exploration

Για την διευκολύνση του design exploration κατασκευάζεται script ωστε να αυτοματοποιηθεί η διαδικασία εκτέλεσης των workloads και συλλογής δεδομένων. Το παρακάτω bash script ορίζει πίνακες με τις τιμές για κάθε parameter και 
εκτελεί τις προσομειώσεις σε for loop. Κάθε επανάληψη παίρνει τιμές από τους πίνακες για τις παραμέτρους και στο τέλος κάθε επανάληψης τρέχει το read_results.sh. Επιπλέον για κάθε επανάληψη ελέγχονται οι συνθήκες για το μέγεθος των cache. 
Συγκεκριμένα, απαιτούμε το μέγεθος της L1 Cache να είναι μικρότερο των 256kB και της L2 Cache να είναι μικρότερο των 4ΜΒ. Εάν δεν ικανοποιούνται, τερματίζει το script.

```
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
```

Εξετάζονται τα παρακάτω configuration:

| Παράμετρος | Configuration1 | Configuration2 | Configuration3 | Configuration4 | Configuration5 | Configuration6 |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | 
| l1d_cache_size (kB) | 64 | 32 | 32 | 32 | 32 | 32 |
| l1i_cache_size (kB) | 128 | 64 | 64 | 64 | 64 | 64 |
| l2_cache_size (kB) | 2024 | 4096 | 2024 | 2024 | 2024 | 2024 |
| l1i_cache_assoc | 2 | 2 | 4 | 2 | 2 | 2 | 
| l1d_cache_assoc | 2 | 2 | 4 | 2 | 2 | 2 |
| l2_cache_assoc | 8 | 8 | 8 | 16 | 8 | 8 |
| cacheline | 64 | 64 | 64 | 64 | 128 | 64 |
| cpu_clock (GHz) | 2 | 2 | 2 | 2 | 2 | 3 |

Τα παραπάνω configurations επιλέχθηκαν, αλλάζοντας ένα στοιχείο τη φορά. Για παράδειγμα το μέγεθος της L1 cache (μαζί Instruction και Data cache). Η επιλογή των τιμών 
Προκύπτουν τα αποτελέσματα.
![image](https://github.com/user-attachments/assets/e2f0d76d-a396-473e-a0a3-30b1d3dce0c7)

Τα αποτελέσματα για διπλασιασμό των μεγεθών των caches ή του associativity αυτών φαίνεται πως δεν αλλάζουν σημαντικά. Η αύξηση του CPU clock speed οπώς είδαμε προηγουμένως χειροτέρεψε το CPI, ωστόσο μπορεί να βελτιώνει το runtime. 
Τη μεγαλύτερη επίδραση την είχε ο διπλασιασμός του Cacheline size. Αυτό είναι αναμενόμενο, καθώς διπλασιάσαμε τα chunks μνήμης που κάνει access ο επεξεργαστής. Τέλος, φαίνεται πως για τα διάφορα benchmarks οι αλλαγές στις παραμέτρους έχουν μεγαλύτερη επίδραση σε αύτα με μεγάλο CPI. Συμπεραίνουμε, πως για προγράμματα με χαμήλο, δηλαδή καλύτερο CPI, η αύξηση των παραμέτρων είναι κοστοβόρα.

## Σχέση κόστους απόδοσης

Με βάση όσα προηγήθηκαν μπορεί να εξαχθεί μία σχέση κόστους απόδοσης με ορίσματα τις παραμέτρους που εξερευνήθηκαν παραπάνω. Αρχικά ας οριστούν τα κόστη κάθε παραμέτρου. 

_Cost(L1 Cache) = k * L1 Cache Size + m * L1 associativity_

_Cost(L2 Cache) = n * L2 Cache Size + l * L2 associativity_

_Cost(Cacheline size) = j * Cacheline Size_

Ξέρουμε πως οι συντελεστές για την L1 cache είναι μεγαλύτεροι από τους αντίστοιχους της L2 cache, λόγω των διαφορών στη σχεδίαση των δύο επιπέδων cache. Το cacheline size είναι όπως είδαμε πολύ σημαντικό και μπορεί να βελτιώσει πολύ την απόδοση. Είναι επίσης και κοστοβόρο καθώς απαιτεί επιπλέον υλικό για την μετακίνηση μεγαλύτερων chunk δεδομένων. Επιπλέον αυτές οι μετακινήσεις επιβαρύνουν και την κατανάλωση ενέργειας και αυξάνουν την πολυπλοκότητα της σχεδίασης. Είδαμε πως για διαφορετικά benchmarks είχε διαφορές στην βελτίωση της απόδοσης. Αυτό έχει να κάνει με τις ιδιαιτερότητες κάθε προγράμματος. Όταν υπάρχουν πολλά cache misses και επιπλέον τα δεδομένα που θέλουμε να "πάμε" στον επεξεργαστή είναι μεγάλα (πχ. double float) θέλουμε μεγάλο μέγεθος cache. Για εφαρμογές με δεδομένα μικρού μεγέθους και μικρού αριθμού cache miss rate (πχ. specbzip benchmark), δεν αξίζει η αύξηση του μεγέθους cacheline.

Επιπλέον η επίδραση των παραμέτρων στην ταχύτητα και απόδοση του κυκλώματος μπορεί να μοντελοποιηθεί με παρόμοιο τρόπο.


_Performance(L1 Cache) = a * L1 Cache Size + b * L1 associativity_

_Performance(L2 Cache) = c * L2 Cache Size + d * L2 associativity_

_Performance(Cacheline size) = e * Cacheline Size_

Παρομοίως, ξέρουμε πως _a > c_ και _b > d_. Δηλαδή, οι αλλαγές στην L1 cache έχουν μεγαλύτερη επίδραση στην επίδοση του επεξεργαστή. Το ζήτημα για τον σχεδιαστή είναι ο προσδιορισμός της σχέσης των συντελεστών κόστους απόδοσης. Για διαφορετικά προβλήματα αλλάζει η σχέση αυτή. Παραδείγματος χάριν, για προβλήματα μικρού μεγέθους δεδομένων ο συντελεστής οι συντελεστές k και n υπερτερούν των a και c αντιστοιχα.

## Συμπεράσματα 

Εξετάστηκαν διάφορα προγράμματα στον προσομοιωτή gem5. Εξήχθησαν αποτελέσματα από τις προσομοιώσεις για εξαγωγή συμπερασμάτων. Κατασκευάστηκαν βοηθητικά scripts για αυτοματοποίηση της δουλείας.  
Εξετάστηκαν διάφορα configurations και η απόδοση αυτών. Τέλος, εξήχθησαν θεωρητικά συμπεράσματα με βάση τα αποτελέσματα των προσομοιώσεων.
