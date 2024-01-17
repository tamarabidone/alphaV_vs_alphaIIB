#!/bin/bash
#SBATCH --time=00:20:00
#SBATCH --nodes=1
#SBATCH --mem=0
#SBATCH --job-name=hbonds
#SBATCH --out=hbonds_out
#SBATCH --error=hbonds_err
#SBATCH --mail-type=all
#SBATCH --mail-user=reza.kolasangiani@utah.edu
#SBATCH --account=owner-gpu-guest
#SBATCH --partition=notchpeak-gpu-guest
#SBATCH --exclusive 

####### NOTE: change --gres=gpu:4 to --gres=gpu:2 (if on lonepeak change it to 8) (never use 3 or another higher odd number, performance is bad)
# Use gromacs
module purge
module load gcc/11.2.0-gpu openmpi/4.1.4 gromacs/2022.3-gpu



 residue_pairs=(
#  "19 20:Betapropeller_thigh"
#  "32 33:E1_E2"
#  "25 32:Hybrid_E1"
#  "24 25:Psi_Hybrid"
#  "20 21:Thigh_Calf1"
#  "25 26:Hybrid_Betai"
#  "19 25:Betapropeller_Hybrid"
#  "26 19:BetaI_Betapropeller"
#  "21 22:Calf1_Calf2"
#  "19 20:Betapropeller_thigh"
#   "20 33:Thigh_E2"
#   "32 33:E1_E2"
#   "33 34:E2_E3" 
#   "34 35:E3_E4" 
#   "28 35:betatail_E4"
#   "24 32:Psi_E1"
    "41 42:headdomains_taildomains"
)



for dir in 1.Alpha2bBeta3 1.AlphaVBeta3; do
  for i in  forcepull_bothfc50_replica1 forcepull_bothfc50_replica2 forcepull_bothfc50_replica3 bending_bothfc0_replica1 bending_bothfc0_replica2 bending_bothfc0_replica3; do
    for pair in "${residue_pairs[@]}"; do
      res1=$(echo $pair | cut -d" " -f1)
      res2=$(echo $pair | cut -d" " -f2 | cut -d":" -f1)
      name=$(echo $pair | cut -d":" -f2)
      cd $dir/$i
      gmx_mpi hbond -f combineallnopbc3.xtc -s step8_pull.tpr -num ../../alpha2balphavhbonds/hbond_${dir}_${name}_$i.xvg -tu ns -n ../index.ndx <<EOF
$res1
$res2
EOF
      cd ../..

      cd alpha2balphavhbonds
      sed '1,25d' hbond_${dir}_${name}_$i.xvg > hbond1_${dir}_${name}_$i.xvg
      awk '{print $1,$2}' hbond1_${dir}_${name}_$i.xvg> hbond_${dir}_${name}_$i
      rm hbond1_${dir}_${name}_$i.xvg; rm hbond_${dir}_${name}_$i.xvg
      cd ..      


    done
  done
done



cd alpha2balphavhbonds

forcepull=("forcepull_bothfc50_replica1" "forcepull_bothfc50_replica2" "forcepull_bothfc50_replica3" "bending_bothfc0_replica1" "bending_bothfc0_replica2" "bending_bothfc0_replica3")
dirs=("1.Alpha2bBeta3" "1.AlphaVBeta3")
pairs=("headdomains_taildomains")

#pairs=("Betapropeller_thigh" "E1_E2" "Hybrid_E1" "Psi_Hybrid" "Thigh_Calf1" "Hybrid_Betai" "Betapropeller_Hybrid" "BetaI_Betapropeller" "Calf1_Calf2" "Thigh_E2" "E1_E2" "E2_E3" "E3_E4" "betatail_E4" "Psi_E1")


for pair in "${pairs[@]}"; do
  for ((replica=0; replica<3; replica++)); do
    hbonds=()
    for dir in "${dirs[@]}"; do
      forcepull_files=()
      for i in "${forcepull[@]}"; do
        forcepull_files+=("hbond_${dir}_${pair}_${i}")
      done
      paste "${forcepull_files[@]}" > "${dir}_${pair}_replica$((replica+1))"
      awk '{print $1,$2,$4}' "${dir}_${pair}_replica$((replica+1))" > "${dir}_${pair}_replica$((replica+1))_unb1"
      awk '{print $1,$8,$10}' "${dir}_${pair}_replica$((replica+1))" > "${dir}_${pair}_replica$((replica+1))_b1"
      awk '{sum=0; for(i=2; i<=NF; i++) sum+=$i; print $1, sum/(NF-1)}' "${dir}_${pair}_replica$((replica+1))_unb1" > "${dir}_${pair}_replica$((replica+1))_unb"
      awk '{sum=0; for(i=2; i<=NF; i++) sum+=$i; print $1, sum/(NF-1)}' "${dir}_${pair}_replica$((replica+1))_b1" > "${dir}_${pair}_replica$((replica+1))_b"
      rm "${dir}_${pair}_replica$((replica+1))_unb1"
      rm "${dir}_${pair}_replica$((replica+1))_b1"
      hbonds+=("${dir}_${pair}_replica$((replica+1))_unb ")
      hbonds+=("${dir}_${pair}_replica$((replica+1))_b")

    done
    paste "${hbonds[@]}" > "${pair}_replica$((replica+1))"
  done
done


cd ..













