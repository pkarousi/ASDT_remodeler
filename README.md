
~~~~~~~MANDATORY INSTALLATIONS~~~~~~~
1. Perl should be installed on any system running Windows OS.
2. "String::Approx" and "Sort::Fields" modules need to be installed. This can be done from the Command Prompt environment, using the following commands:
				cpan String::Approx
				cpan Sort::Fields

~~~~~~~~~~ASDT v2.1~~~~~~~~~~
ASDT_v2.1.pl requires two input files: A modified GenBank� file (.gb file) and a FASTQ (.fastq) file. 
ASDT_v2.1.pl and the two input files should be located in the same folder. A succesfull run can be done using the following command:

perl ASDT_v2.1.pl Modified_Genbank_file.gb FASTQ_file.fastq

The user will be asked to enter the name of the output folder. If the given name already exists, the user will be asked to overwritte the folder, or provide a new folder name.
Next, the user needs to provide the length of the keywords that will be used to inspect the existence of splice junction, as well as the number of mismatches allowed in the keywords.
The user will be asked to chose if the reads from the antisense strand are shown in reverse complement. 
Last, the user will be asked to proceed to intron analysis. For the next steps of this pipeline, intron analysis is not required.

After a succesfull run, the following text files will be produced:

1.Gene_Sequence --> Provides the sequence of the gene, as shown in the modified GenBank� file
2.Annotated_Transcript_Structure --> Provides the exons of each transcript of the gene, as shown in a GenBank� file. In a modified GenBank� file, each trancript comprises a single exon.
3.Exons --> Provides the coordinates of each exon on the gene, its numeric order as well as its sequence
4.Keywords --> Provides the keyword list used to inspect the existence of splice junctions.
5.All_Reads --> Provides all reads in which at least one keyword is found. Each read is listed only once.
6.Annotated_Transcripts --> Provides the transcripts of the gene, as shown in a GenBank� file. In a modified GenBank� file, each trancript comprises a single exon.
7.Single_Splice_Junctions --> Provides all the splice junctions detected in the FASTQ file, as well as their frequency (in reads number).
8.Unique_Reads --> Each read is listed only once, and all the splice junctions found in this read are shown.
9.Combined_Splice_Junctions --> Provides all splice junction combinations found, and the frequency of the detection.

~~~~~~~~~~ASDT remodeler~~~~~~~~~~
In order to run ASDT_remodeler.pl, ASDT_v2.1.pl output files are required. Moreover, the user needs to make a new file, starting from the 3.Exons file that is produced by ASDT_v.2.1.pl. The new Renaming_file needs to have an extra column next to the "Exon number" column, that will provide a new name for each exon, as prefered by the user.

A succesfull run can be done using the following command:

perl ASDT_remodeler.pl Renaming_file.txt ASDT_OUTPUT_FOLDER_NAME

The user will be asked to enter the name of the output folder. If the given name already exists, the user will be asked to overwritte the folder, or provide a new folder name.

After a succesfull run, the following text files will be produced:

4.Keywords_v2 --> Provides the keyword list used to inspect for splice junctions, after renaming the exons using the Renaming_file.
5.All_Reads_v2 --> Provides all reads in which at least one keyword is found,after renaming the exons using the Renaming_file. Each read may be listed only once.
6.Annotated_Transcripts_v2 --> Provides the transcripts of the gene, as shown in a GenBank� file,after renaming the exons using the Renaming_file. In a modified GenBank� file, each trancript comprises a single exon.
7.Single_Splice_Junctions_v2--> Provides all the splice junctions detected in the FASTQ file, as well as the frequency of the detection,after renaming the exons using the Renaming_file.
8.Unique_Reads_v2 --> Each read is listed only once, and all the splice junctions found in this read are shown. The exons have been renamed using the Renaming_file.
9.Combined_Splice_Junctions_v2_selected --> Provides combinations in which all splice junctions have been detected, and the frequency of the detection. The exons have been renamed using the Renaming_file.
9.Combined_Splice_Junctions_v2_nonselected --> Provides combinations in which not every splice junction has been detected, and the frequency of the detection. The exons have been renamed using the Renaming_file.
10.Selected_circular_combinations --> Provides the reads in which all splice junctions have been detected, and the frequency of the detection. All these combinations start and end in the same exon. The exons have been renamed using the Renaming_file.
11.Nonselected_circular_combinations --> Provides combinations in which not every splice junction has been detected, and the frequency of the detection. All these combinations start and end in the same exon. The exons have been renamed using the Renaming_file.
12.Circular_single_exon_combinations --> Provides single splice junctions between the same exon, and the frequency of the detection.
13.Circular_reads --> Provides reads from file 8, that start and end in the same exon.
14.Non_circular_reads --> Provides the rest reads from file 8, that don't start and end in the same exon.
