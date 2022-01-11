##### Activate the biocode environment#####
eval "$(conda shell.bash hook)"
conda activate biostar

#Remove the id of multifasta file ; take specific Row=5000 :  
grep -v ">" raw_contigs_SRS011271.fa > Seq_SRS.txt
grep -v ">" raw_contigs_MSM6J2LT.fa  > Seq_MSM.txt
grep -v ">" raw_contigs_HMP2.fa  > Seq_HMP.txt


##### Activate the biocode environment#####
eval "$(conda shell.bash hook)"
#conda activate deep
#python Script_New_idea.py
