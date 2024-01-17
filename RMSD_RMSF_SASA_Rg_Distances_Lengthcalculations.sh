#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --gres=gpu:1
#SBATCH --job-name=bending
#SBATCH --out=bending.out
#SBATCH --error=bending.err
#SBATCH --mail-type=all
#SBATCH --mail-user=reza.kolasangiani@utah.edu
#SBATCH --account=bidone-gpu-np
#SBATCH --partition=bidone-gpu-np
#SBATCH --array=1-4%1

####### NOTE: change --gres=gpu:4 to --gres=gpu:2 (if on lonepeak change it to 8) (never use 3 or another higher odd number, performance is bad)
# Use gromacs
module purge
module load gcc/11.2.0-gpu openmpi/4.1.4 gromacs/2022.3-gpu



# Define an array of the directories to loop over
directories=(
    "1.AlphaVBeta3/forcepull_bothfc0_replica1"
    "1.AlphaVBeta3/forcepull_bothfc0_replica2"
    "1.AlphaVBeta3/forcepull_bothfc0_replica3"
    "1.AlphaVBeta3/forcepull_bothfc50_replica1"
    "1.AlphaVBeta3/forcepull_bothfc50_replica2"
    "1.AlphaVBeta3/forcepull_bothfc50_replica3"
    "1.Alpha2bBeta3/forcepull_bothfc0_replica1"
    "1.Alpha2bBeta3/forcepull_bothfc0_replica2"
    "1.Alpha2bBeta3/forcepull_bothfc0_replica3"
    "1.Alpha2bBeta3/forcepull_bothfc50_replica1"
    "1.Alpha2bBeta3/forcepull_bothfc50_replica2"
    "1.Alpha2bBeta3/forcepull_bothfc50_replica3"
    


)

# Loop over the directories and perform the commands
for directory in "${directories[@]}"; do
    cd "$directory"
    echo -e "3\n3" | gmx_mpi rms -s step8_pull.tpr -f combineallnopbc3.xtc -o ../../Alpha2bbeta3alphavbeta3comparison/rmsd_"${directory//\//_}".xvg -tu ns
    echo -e "3" | gmx_mpi rmsf -f combineallnopbc3.xtc -s step8_pull.tpr -res -o ../../Alpha2bbeta3alphavbeta3comparison/rmsf_"${directory//\//_}".xvg
    echo -e "1" |  gmx_mpi sasa -s step8_pull.tpr -f combineallnopbc3.xtc -o ../../Alpha2bbeta3alphavbeta3comparison/sasa_"${directory//\//_}".xvg
    echo -e "3" | gmx_mpi gyrate -s step8_pull.tpr -f combineallnopbc3.xtc -o ../../Alpha2bbeta3alphavbeta3comparison/rg_"${directory//\//_}".xvg 
   


      gmx_mpi distance -n ../pull.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group Transmembrane_helix  plus cog of group Headgroup_residues ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_Transmembrane_helix_Headgroup_residues_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group betaI plus cog of group betap ' -oall ../../Alpha2bbeta3alphavbeta3comparison/Alpha2bbeta3alphavbeta3comparison/distance/distance_betai_Betap_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group betaI plus cog of group Hybrid ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_betai_Hybrid_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group Thigh plus cog of group Calf1 ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_Thigh_Calf1_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group Betap plus cog of group Thigh ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_Betapropeller_thigh_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group Betap plus cog of group Hybrid ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_Betapropeller_Hybrid_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group Calf2 plus cog of group Calf1 ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_Calf1_Calf2_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group Psi plus cog of group Hybrid ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_Psi_Hybrid_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group E1_4 plus cog of group betatail ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_E1_4_betatail_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group Psi plus cog of group E1_4 ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_Psi_E1_4_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group Psi plus cog of group E1 ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_Psi_E1_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group E1 plus cog of group E2 ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_E1_E2_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group E2 plus cog of group E3 ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_E2_E3_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group E3 plus cog of group E4 ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_E3_E4_${directory//\//_}.xvg
      gmx_mpi distance -n ../index.ndx -f combineallnopbc3.xtc -s step8_pull.tpr -select 'cog of group E4 plus cog of group betatail ' -oall ../../Alpha2bbeta3alphavbeta3comparison/distance/distance_E4_betatail_${directory//\//_}.xvg





 cd ../..
done


    

cd Alpha2bbeta3alphavbeta3comparison
cd distance


forcepull=("forcepull_bothfc0_replica1" "forcepull_bothfc0_replica2" "forcepull_bothfc0_replica3" "forcepull_bothfc50_replica1" "forcepull_bothfc50_replica2" "forcepull_bothfc50_replica3")
dirs=("1.Alpha2bBeta3" "1.AlphaVBeta3")
pairs=( "Transmembrane_helix_Headgroup_residues" "Betapropeller_thigh" "Psi_Hybrid" "Thigh_Calf1" "betai_Hybrid" "Betapropeller_Hybrid" "betai_Betap" "Calf1_Calf2" "E1_4_betatail" "Psi_E1_4" "Psi_E1" "E1_E2" "E2_E3" "E3_E4" "E4_betatail")


for pair in "${pairs[@]}"; do
  for ((replica=0; replica<3; replica++)); do
    distance=()
    for dir in "${dirs[@]}"; do
      forcepull_files=()
      for i in "${forcepull[@]}"; do
        forcepull_files+=("distance_${pair}_${dir}_${i}.xvg")
      done
      paste "${forcepull_files[@]}" > "1.${pair}_${dir}_replica$((replica+1))"
      sed '1,17d' "1.${pair}_${dir}_replica$((replica+1))" > "${pair}_${dir}_replica$((replica+1))new"
      rm  "1.${pair}_${dir}_replica$((replica+1))"
      awk '{print $1,$2,$4,$6,$8,$10,$12}' "${pair}_${dir}_replica$((replica+1))new"> "${pair}_${dir}_replica$((replica+1))new2"
      awk '{sum=($2 + $3 + $4) / 3; sum2= ($5 + $6+ $7)/3; print $1, sum,sum2}' "${pair}_${dir}_replica$((replica+1))new2"> "${pair}_${dir}_replica$((replica+1))new3"
      rm "${pair}_${dir}_replica$((replica+1))new2"


done
done
done

# calculating the length of alpha chain 
     
      for dir in "${dirs[@]}"; do
      input_files=("Calf1_Calf2_${dir}_replica3new3" "Thigh_Calf1_${dir}_replica3new3" "Betapropeller_thigh_${dir}_replica3new3")
      output_file="${dir}_alphachain_length"

      paste "${input_files[@]}" | awk '{sum = $2 + $5 + $8; sum2 = $3 + $6 + $9; print $1, sum, sum2}' > "${output_file}"

done




# calculating the length of alpha chain head
     
      for dir in "${dirs[@]}"; do
      input_files=("Betapropeller_thigh_${dir}_replica3new3")
      output_file="${dir}_alphachainhead_length"
      output2_file="00average_${dir}_betachainhead_length"


      paste "${input_files[@]}" | awk '{sum = $2 + $5 + $8; sum2 = $3 + $6 + $9; print $1, sum, sum2}' > "${output_file}"
      awk '{ total1 += $2;total2 += $3;  count++ } END { print total1/count,total2/count}' "${output_file}" > "${output2_file}"

done



# calculating the length of alpha chain leg
     
      for dir in "${dirs[@]}"; do
      input_files=("Calf1_Calf2_${dir}_replica3new3" "Thigh_Calf1_${dir}_replica3new3")
      output_file="${dir}_alphachainleg_length"
      output2_file="00average_${dir}_betachainhead_length"


      paste "${input_files[@]}" | awk '{sum = $2 + $5; sum2 = $3 + $6 ; print $1, sum, sum2}' > "${output_file}"
      awk '{ total1 += $2;total2 += $3;  count++ } END { print total1/count,total2/count}' "${output_file}" > "${output2_file}"

done




# calculating the length of beta chain 

      for dir in "${dirs[@]}"; do
      input_files=("Betai_Hybrid_${dir}_replica3new3" "Psi_Hybrid_${dir}_replica3new3" "Psi_E1_${dir}_replica3new3" "E1_E2_${dir}_replica3new3" "E2_E3_${dir}_replica3new3" "E3_E4_${dir}_replica3new3" "E4_betatail_${dir}_replica3new3")
      output_file="${dir}_betachain_length"

      paste "${input_files[@]}" | awk '{sum = $2 + $5 + $8+$11 +$14 +$17+$20; sum2 = $3 + $6 + $9+ $12+ $15+ $18+ $21; print $1, sum, sum2}' > "${output_file}"

done

# calculating the length of beta chain leg

      for dir in "${dirs[@]}"; do
      input_files=("E1_E2_${dir}_replica3new3" "E2_E3_${dir}_replica3new3" "E3_E4_${dir}_replica3new3" "E4_betatail_${dir}_replica3new3")
      output_file="${dir}_betachainleg_length"
      output2_file="00average_${dir}_betachainhead_length"


      paste "${input_files[@]}" | awk '{sum = $2 + $5 + $8+$11 +$14; sum2 = $3 + $6 + $9+ $12+ $15; print $1, sum, sum2}' > "${output_file}"
      awk '{ total1 += $2;total2 += $3;  count++ } END { print total1/count,total2/count}' "${output_file}" > "${output2_file}"

done

# calculating the length of beta chain head

      for dir in "${dirs[@]}"; do
      input_files=("Betai_Hybrid_${dir}_replica3new3" "Psi_Hybrid_${dir}_replica3new3" "Psi_E1_${dir}_replica3new3")
      output_file="${dir}_betachainhead_length"
      output2_file="00average_${dir}_betachainhead_length"

      paste "${input_files[@]}" | awk '{sum = $2 + $5 + $8; sum2 = $3 + $6 + $9; print $1, sum, sum2}' > "${output_file}"
      awk '{ total1 += $2;total2 += $3;  count++ } END { print total1/count,total2/count}' "${output_file}" > "${output2_file}"

done





# calculating the extension for each column 

forcepull=("forcepull_bothfc0_replica1" "forcepull_bothfc0_replica2" "forcepull_bothfc0_replica3" "forcepull_bothfc50_replica1" "forcepull_bothfc50_replica2" "forcepull_bothfc50_replica3")
dirs=("1.Alpha2bBeta3" "1.AlphaVBeta3")
pairs=( "Transmembrane_helix_Headgroup_residues" "Betapropeller_thigh" "Psi_Hybrid" "Thigh_Calf1" "betai_Hybrid" "Betapropeller_Hybrid" "betai_Betap" "Calf1_Calf2" "E1_4_betatail" "Psi_E1_4" "Psi_E1" "E1_E2" "E2_E3" "E3_E4" "E4_betatail")


for pair in "${pairs[@]}"; do
  for ((replica=0; replica<3; replica++)); do
    distance=()
    for dir in "${dirs[@]}"; do


awk '{if(NR==1) start1=$2; if($2-start1>0) val1=$2;if($2-start1<=0) val1=$2; if(NR==1) start2=$4;\
if($4-start2>0) val2=$4;if($4-start2<=0) val2=$4;if(NR==1) start3=$6; if($6-start3>0) val3=$6;if($6-start3<=0) val3=$6;\
if(NR==1) start4=$8; if($8-start4>0) val4=$8;if($8-start4<=0) val4=$8; if(NR==1) start5=$10; if($10-start5>0) val5=$10;if($10-start5<=0) val5=$10;\
if(NR==1) start6=$12; if($12-start6>0) val6=$12;if($12-start6<=0) val6=$12; print $1,val1-start1,$1, val2-start2,$1,val3-start3,$1,val4-start4,$1,val5-start5,$1,val6-start6};\
' "${pair}_${dir}_replica$((replica+1))new" > "${pair}_${dir}_replica$((replica+1))"




awk '{print $1,$2,$4,$6}' "${pair}_${dir}_replica$((replica+1))" > "${pair}_${dir}_replica$((replica+1))_new1"
awk '{print $1,$8,$10,$12}' "${pair}_${dir}_replica$((replica+1))" > "${pair}_${dir}_replica$((replica+1))_force1"
awk '{sum=0; for(i=2; i<=NF; i++) sum+=$i; print $1, sum/(NF-1)}' "${pair}_${dir}_replica$((replica+1))_new1" > "${dir}_${pair}_replica$((replica+1))_zero"
awk '{sum=0; for(i=2; i<=NF; i++) sum+=$i; print $1, sum/(NF-1)}' "${pair}_${dir}_replica$((replica+1))_force1" > "${dir}_${pair}_replica$((replica+1))_force"
rm "${pair}_${dir}_replica$((replica+1))_new1"
rm "${pair}_${dir}_replica$((replica+1))_force1"
distance+=("${pair}_${dir}_replica$((replica+1))_zero ")
distance+=("${pair}_${dir}_replica$((replica+1))_force")


   



    done
  done
done
























  
cd Alpha2bbeta3alphavbeta3comparison

for directory in "${directories[@]}"; do
  sed '1,18d' "rmsd_${directory//\//_}.xvg" > "rmsd_${directory//\//_}"
  rm "rmsd_${directory//\//_}.xvg"
done

 cd .. 


cd Alpha2bbeta3alphavbeta3comparison

for directory in "${directories[@]}"; do
  sed '1,17d' "rmsf_${directory//\//_}.xvg" > "rmsf_${directory//\//_}"
  rm "rmsf_${directory//\//_}.xvg"
done

 cd .. 



cd Alpha2bbeta3alphavbeta3comparison

for directory in "${directories[@]}"; do

sed '1,24d' "sasa_${directory//\//_}.xvg" > "sasa_${directory//\//_}"
  rm "sasa_${directory//\//_}.xvg"

done 

cd .. 


cd Alpha2bbeta3alphavbeta3comparison

for directory in "${directories[@]}"; do

sed '1,27d' "rg_${directory//\//_}.xvg" > "rg_${directory//\//_}"
  rm "rg_${directory//\//_}.xvg"

done 

cd .. 





cd Alpha2bbeta3alphavbeta3comparison

paste rmsd_1.Alpha2bBeta3_forcepull_bothfc0_replica1 rmsd_1.Alpha2bBeta3_forcepull_bothfc0_replica2 rmsd_1.Alpha2bBeta3_forcepull_bothfc0_replica3 rmsd_1.AlphaVBeta3_forcepull_bothfc0_replica1 rmsd_1.AlphaVBeta3_forcepull_bothfc0_replica2 rmsd_1.AlphaVBeta3_forcepull_bothfc0_replica3 > rmsd_0
paste rmsd_1.Alpha2bBeta3_forcepull_bothfc50_replica1 rmsd_1.Alpha2bBeta3_forcepull_bothfc50_replica2 rmsd_1.Alpha2bBeta3_forcepull_bothfc50_replica3 rmsd_1.AlphaVBeta3_forcepull_bothfc50_replica1 rmsd_1.AlphaVBeta3_forcepull_bothfc50_replica2 rmsd_1.AlphaVBeta3_forcepull_bothfc50_replica3  > rmsd_83

awk '{print $1,$2,$4,$6,$8,$10,$12}' rmsd_0>rmsd0_final
awk '{print $1,$2,$4,$6,$8,$10,$12}' rmsd_83>rmsd83_final

rm rmsd_0 
rm rmsd_83

awk '{ printf("%s ", $1); for(i=2; i<=NF; i+=3) { sum=0; for(j=i; j<i+3; j++) sum+=$j; printf("%.2f ", sum/3) } printf("\n") }' rmsd0_final>average_rmsd0_final
awk '{ printf("%s ", $1); for(i=2; i<=NF; i+=3) { sum=0; for(j=i; j<i+3; j++) sum+=$j; printf("%.2f ", sum/3) } printf("\n") }' rmsd83_final>average_rmsd83_final


rm rmsd0_final
rm rmsd0_final

cd ..


cd Alpha2bbeta3alphavbeta3comparison

paste rmsf_1.Alpha2bBeta3_forcepull_bothfc0_replica1 rmsf_1.Alpha2bBeta3_forcepull_bothfc0_replica2 rmsf_1.Alpha2bBeta3_forcepull_bothfc0_replica3 rmsf_1.AlphaVBeta3_forcepull_bothfc0_replica1 rmsf_1.AlphaVBeta3_forcepull_bothfc0_replica2 rmsf_1.AlphaVBeta3_forcepull_bothfc0_replica3  > rmsf_0
paste rmsf_1.Alpha2bBeta3_forcepull_bothfc50_replica1 rmsf_1.Alpha2bBeta3_forcepull_bothfc50_replica2 rmsf_1.Alpha2bBeta3_forcepull_bothfc50_replica3 rmsf_1.AlphaVBeta3_forcepull_bothfc50_replica1 rmsf_1.AlphaVBeta3_forcepull_bothfc50_replica2 rmsf_1.AlphaVBeta3_forcepull_bothfc50_replica3   > rmsf_83

awk '{print $1,$2,$4,$6,$8,$10,$12}' rmsf_0>rmsf0_final
awk '{print $1,$2,$4,$6,$8,$10,$12}' rmsf_83>rmsf83_final
rm rmsf_0;rm rmsf_83


awk '{ printf("%s ", $1); for(i=2; i<=NF; i+=3) { sum=0; for(j=i; j<i+3; j++) sum+=$j; printf("%.2f ", sum/3) } printf("\n") }' rmsf0_final>average_rmsf0_final
awk '{ printf("%s ", $1); for(i=2; i<=NF; i+=3) { sum=0; for(j=i; j<i+3; j++) sum+=$j; printf("%.2f ", sum/3) } printf("\n") }' rmsf83_final>average_rmsf83_final

rm rmsf0_final
rm rmsf0_final


cd ..



cd Alpha2bbeta3alphavbeta3comparison



paste sasa_1.Alpha2bBeta3_forcepull_bothfc0_replica1 sasa_1.Alpha2bBeta3_forcepull_bothfc0_replica2 sasa_1.Alpha2bBeta3_forcepull_bothfc0_replica3 sasa_1.AlphaVBeta3_forcepull_bothfc0_replica1 sasa_1.AlphaVBeta3_forcepull_bothfc0_replica2 sasa_1.AlphaVBeta3_forcepull_bothfc0_replica3  > sasa_0
paste sasa_1.Alpha2bBeta3_forcepull_bothfc50_replica1 sasa_1.Alpha2bBeta3_forcepull_bothfc50_replica2 sasa_1.Alpha2bBeta3_forcepull_bothfc50_replica3 sasa_1.AlphaVBeta3_forcepull_bothfc50_replica1 sasa_1.AlphaVBeta3_forcepull_bothfc50_replica2 sasa_1.AlphaVBeta3_forcepull_bothfc50_replica3  > sasa_83


awk '{print $1,$2,$4,$6,$8,$10,$12}' sasa_0>sasa0_final
awk '{print $1,$2,$4,$6,$8,$10,$12}' sasa_83>sasa83_final
rm sasa_0; rm sasa_83

awk '{ for(i=2; i<=NF; i++) { sum[i] += $i } } END { for(i=2; i<=NF; i++) { printf("%.2f ", sum[i]/NR) } printf("\n") }' sasa0_final>average1_sasa0_final
awk '{ for(i=2; i<=NF; i++) { sum[i] += $i } } END { for(i=2; i<=NF; i++) { printf("%.2f ", sum[i]/NR) } printf("\n") }' sasa83_final>average1_sasa83_final
rm sasa0_final; rm sasa83_final

awk '{ for(i=1; i<=NF; i+=3) { sum=0; for(j=i; j<i+3; j++) sum+=$j; printf("%.2f ", sum/3) } printf("\n") }' average1_sasa0_final> average_sasa0_final
awk '{ for(i=1; i<=NF; i+=3) { sum=0; for(j=i; j<i+3; j++) sum+=$j; printf("%.2f ", sum/3) } printf("\n") }' average1_sasa83_final> average_sasa83_final
rm average1_sasa0_final;rm average1_sasa83_final



cd ..




cd Alpha2bbeta3alphavbeta3comparison


paste rg_1.Alpha2bBeta3_forcepull_bothfc0_replica1 rg_1.Alpha2bBeta3_forcepull_bothfc0_replica2 rg_1.Alpha2bBeta3_forcepull_bothfc0_replica3 rg_1.AlphaVBeta3_forcepull_bothfc0_replica1 rg_1.AlphaVBeta3_forcepull_bothfc0_replica2 rg_1.AlphaVBeta3_forcepull_bothfc0_replica3   > rg_0
paste rg_1.Alpha2bBeta3_forcepull_bothfc50_replica1 rg_1.Alpha2bBeta3_forcepull_bothfc50_replica2 rg_1.Alpha2bBeta3_forcepull_bothfc50_replica3 rg_1.AlphaVBeta3_forcepull_bothfc50_replica1 rg_1.AlphaVBeta3_forcepull_bothfc50_replica2 rg_1.AlphaVBeta3_forcepull_bothfc50_replica3   > rg_83

awk '{print $1,$2,$7,$12,$17,$22,$27}' rg_0>rg0_final
awk '{print $1,$2,$7,$12,$17,$22,$27}' rg_83>rg83_final

rm rg_0 
rm rg_83

awk '{ printf("%s ", $1); for(i=2; i<=NF; i+=3) { sum=0; for(j=i; j<i+3; j++) sum+=$j; printf("%.2f ", sum/3) } printf("\n") }' rg0_final>average_rg0_final
awk '{ printf("%s ", $1); for(i=2; i<=NF; i+=3) { sum=0; for(j=i; j<i+3; j++) sum+=$j; printf("%.2f ", sum/3) } printf("\n") }' rg83_final>average_rg83_final


rm rg0_final
rm rg0_final


cd ..














