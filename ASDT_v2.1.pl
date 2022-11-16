#~~~Command: perl ASDT.pl Genbank.txt Fastq.txt~~~
#################################################################################################################################################################
print "\n\n~~~~~~~~~~ ALTERNATIVE SPLICE DETECTING TOOL ~~~~~~~~~~\n\n";                                                                       
print "Enter the name of the output directory\n"; #The user inserts the folder name of the output data.                                                                                                                                                                                                                                   
while ($folder= <STDIN>) 
{
	chomp $folder;
	
    if (-d $folder) 
    {
        print "Folder '$folder' already exists... Overwrite(Y/N)?";
        
        while ($overwrite= <STDIN>) 
        {
          chomp $overwrite;
        
            if ( $overwrite =~ m/^[Y]$/i)
            {
            	$rez = "./$folder";
              mkdir $rez unless -d $rez; # Check if directory exists. If it does not exist, it creates it. If it exists, the output data will be overwrited.                                                                                
              print "Folder '$folder' is overwrited.\n\n";
              last; 
            }
            
             elsif ( $overwrite =~ m/^[N]$/i)
            {                                                                               
              print "\nPlease select another name for the folder.\n";
              $folder= <STDIN>;
              chomp $folder;
              if (-d $folder)
              {
              	print "Folder '$folder' already exists... Overwrite(Y/N)?";
              }
              else
              {
              	$rez = "./$folder";
                mkdir $rez unless -d $rez; # Check if directory exists. If it does not exist, it creates it. If it exists, the output data will be overwrited.                                                                                
                print "Folder '$folder' is created.\n\n";
                last;
              }   
            }
            
            else
            {	                                                                                                                                               
    	        print "\nInvalid command...Overwrite(Y/N)?";                                                          
            }
        }
      last;                                                                                                                                                  
    } 
      	
 
    else 
    {
    	$rez = "./$folder";
      mkdir $rez unless -d $rez; # Check if directory exists. If it does not exist, it creates it. If it exists, the output data will be overwrited.                                                                                
      print "Folder '$folder' is created.\n\n";
      last;  
    }
}                                                                                                                                                                                                                                                                  
#################################################################################################################################################################

# Opens the output .txt files.  
open (INPUT,$ARGV[0]) or die("Cannot open INPUT!\n");   #INPUT file 1: GenBank file with the information regarding the gene(s) of interest.
open FILE0,">", "$rez/1.Gene_Sequence.txt" or die "Can't open 1.Gene_Sequence.txt\n";                          
open FILE1,">", "$rez/2.Annotated_Transcript_Structure.txt" or die "Can't open 2.Annotated_Transcript_Structure.txt\n";                                                                                       
open FILE2,">", "$rez/2out.txt" or die "Can't open FILE2\n";                                                                                       
open FILE3,">", "$rez/3.Exons.txt" or die "Can't open 3.Exons.txt\n";                                                                                       
open JUNK,">", "$rez/JUNK.txt" or die "Can't open JUNK\n";                                                                                      
open FILE4,">", "$rez/FILE4.txt" or die "Can't open FILE4\n";                                                                                      
open FILE5,">", "$rez/5out.txt" or die "Can't open FILE5\n";                                                                                       
open FILE6,">", "$rez/4.Keywords.txt" or die "Can't open 4.Keywords.txt\n";                                                                                       
open FILE7,">", "$rez/5.All_Reads.txt" or die "Can't open 5.All_Reads.txt\n";                                                                                       
open INFO,">", "$rez/6.Annotated_Transcripts.txt" or die "Can't open 6.Annotated_Transcripts.txt\n";                                                                                    
open (FASTQ,$ARGV[1]) or die("Cannot open FASTQ file!\n"); #INPUT file 2: FASTQ file containing the raw data of the RNA-seq experiment.
#$name=$ARGV[2];
#open (IN2,">$name");                          
################################################################################################################################################################# 

# Extracts information from GenBank file.
open FILE1,"+>", "$rez/2.Annotated_Transcript_Structure.txt" or die "Can't open 2.Annotated_Transcript_Structure.txt\n";
$seq='';
while (<INPUT>)                                                 
{
	if ($_=~/^(LOCUS .*)\n/) # Extracts the locus line.                                                                                                                     
	{                                                                                                                                                
		$locus=$1;                                                                                                                                     
		print FILE0 "$locus\n";#Prints Locus in 1.Gene_Sequence.txt                                                                                                                        
	}                                                                                                                                                
	                                                                                                                                                 
	if ($_=~/^(ACCESSION .*)\n/) # Extracts the accession number line.                                                                                                                   
	{	                                                                                                                                               
	$accession=$1;                                                                                                                                   
	print  FILE0 "$accession\n";#Prints the accession number in 1.Gene_Sequence.txt                                                                                                                      
	}                                                                                                                                                
	                                                                                                                                                 
	if ($_=~/^(SOURCE .*)\n/)  # Extracts the source line.                                                                                                                      
	{                                                                                                                                                
		$source=$1;                                                                                                                                    
		print FILE0 "$source\n";#Prints the source line in 1.Gene_Sequence.txt                                                                                                                        
	}                                                                                                                                                
                                                                                                                                                                 
	if ($_=~/ORIGIN.*\n/) # Extracts the sequence of the gene and transforms it in fasta format.                                                                                                                       
	{                                                                                                                                                
		 $next=<INPUT>;                                                                                                                                
		 while ($next!~m/\/\/\n/g)                                                                                                                     
		 {                                                                                                                                             
		 	$seq=$seq.$next;                                                                                                                             
		 	$seq=~s/ //g;                                                                                                                                
		 	$seq=~s/[0-9]//g;                                                                                                                            
			$seq=~s/\n//g;                                                                                                                               
			$next=<INPUT>;                                                                                                                               
		 }                                                                                                                                             
	}	                                                                                                                                               
}                                                                                                                                                  
close INPUT;	                                                                                                                                       
$fasta= uc($seq);                                                                                                                 
print FILE0 "~~~~~~~~~~ Gene Sequence ~~~~~~~~~~\n$fasta\n";  #Prints the gene sequence in fasta format in 1.Gene_Sequence.txt                                              
close FILE0;
################################################################################################################################################################# 
                                                                                                                                                 
open (INPUT,$ARGV[0]);                                                                                                                             
$flag_m=1;                                                                                                                                         
$flag_misc=1;                                                                                                                                      
$flag_nc=1;  
# Prints in 2.Annotated_Transcript_Structure.txt the exon and intron coordinates on the gene, for every annotated transcript and their sequences.                                                                                                                                      
while (<INPUT>)                                                                                                                                    
{                                                                                                                                                  
	                                                                                                                                                 
	if($_=~/\s+mRNA\s+j\w{3}\((.+)\n/)  # Extracts lines with transcript coordinates                                                                         
	{                                                                                                                                                
		$exonum=$1;                                                                                                                                    
		$exonum=~s/,/\.\./g;                                                                                                                           
		$exonum=~s/\"//g;                                                                                                                              
		$exonum=~s/\(//g;                                                                                                                              
		$exonum=~s/\)//g;                                                                                                                                
		$next=<INPUT>;                                                                                                                                   
		while ($next!~m/\s+\/.*/g)                                                                                                                     
		{                                                                                                                                              
			$exon2=$next;                                                                                                                                 
			$exon2=~s/ //g;                                                                                                                              
			$exon2=~s/\,/\.\./g;                                                                                                                         
			$exon2=~s/\"//g;                                                                                                                             
			$exon2=~s/\)//g;                                                                                                                             
			$exon2=~s/\n//g;                                                                                                                             
			$exonum=$exonum.$exon2;                                                                                                                      
			$next=<INPUT>;                                                                                                                               
		}                                                                                                                                                
			print FILE1 "mRNA$flag_m\n";                                                                                                                 
			$exonum=~s/\.\./\,/g;                                                                                                                        
			@start_end=split(",",$exonum);                                                                                                               
			$exonum='';                                                                                                                                  
			$flag2=1;                                                                                                                                    
			$flag_m++;                                                                                                                                   
			                                                                                                                                             
				for ($i=0;$i<=$#start_end;$i+=2)                                                                                                           
				{	                                                                                                                                         
					print FILE1 "Exon$flag2\t";                                                                                                              
					$l=$start_end[$i+1]-$start_end[$i]+1;                                                                                                    
					$mRNA=substr($fasta,$start_end[$i]-1,$l);                                                                                                
					print FILE1 "$start_end[$i]\t$start_end[$i+1]\t$mRNA\n"; # Prints in 2.Annotated_Transcript_Structure.txt the exon coordinates on the gene and their sequence for every annotated transcript.                                                                                
				  $endnew=$start_end[$i+1]+1;                                                                                                              
					$startnew=$start_end[$i+2]-1;                                                                                                            
					$l2=$startnew-$endnew+1;                                                                                                                 
					$intron=substr($fasta,$endnew-1,$l2);                                                                                                      
					if ($startnew>0)                                                                                                                         
					{                                                                                                                                        
					 print FILE1 "Intron$flag2\t$endnew\t$startnew\t$intron\n"; # Prints in 2.Annotated_Transcript_Structure.txt the intron coordinates on the gene and their sequence for every annotated transcript.                                                                               
					}                                                                                                                                        
				  $flag2++;                                                                                                                                
				}                                                                                                                                          
				@start_end=();                                                                                                                             
	}                                                                                                                                                
	                                                                                                                                                 
	if($_=~/\s+misc_RNA\s+j\w{3}\((.+)\n/) # Extract lines with miscRNA transcript coordinates                                                                   
	{                                                                                                                                                
		$exonum=$1;                                                                                                                                    
		$exonum=~s/,/\.\./g;                                                                                                                           
		$exonum=~s/\"//g;                                                                                                                              
		$exonum=~s/\(//g;                                                                                                                              
		$exonum=~s/\)//g;                                                                                                                                
		$next=<INPUT>;                                                                                                                                   
		while ($next!~m/\s+\/.*/g)                                                                                                                     
		{                                                                                                                                              
			$exon2=$next;                                                                                                                                 
			$exon2=~s/ //g;                                                                                                                              
			$exon2=~s/\,/\.\./g;                                                                                                                         
			$exon2=~s/\"//g;                                                                                                                             
			$exon2=~s/\)//g;                                                                                                                             
			$exon2=~s/\n//g;                                                                                                                             
			$exonum=$exonum.$exon2;                                                                                                                      
			$next=<INPUT>;                                                                                                                               
		}                                                                                                                                                
			print FILE1 "misc_RNA$flag_misc\n";                                                                                                          
			$exonum=~s/\.\./\,/g;                                                                                                                        
			@start_end=split(",",$exonum);                                                                                                               
			$exonum='';                                                                                                                                  
			$flag2=1;                                                                                                                                    
			$flag_misc++;                                                                                                                                
				                                                                                                                                           
				for ($i=0;$i<=$#start_end;$i+=2)                                                                                                           
				{	                                                                                                                                         
					print FILE1 "Exon$flag2\t";                                                                                                              
					$l=$start_end[$i+1]-$start_end[$i]+1;                                                                                                    
					$mRNA=substr($fasta,$start_end[$i]-1,$l);                                                                                                
					print FILE1 "$start_end[$i]\t$start_end[$i+1]\t$mRNA\n";                                                                                 
					$endnew=$start_end[$i+1]+1;                                                                                                              
					$startnew=$start_end[$i+2]-1;                                                                                                            
					$l2=$startnew-$endnew+1;                                                                                                                 
					$intron=substr($fasta,$endnew-1,$l2);                                                                                                      
					if ($startnew>0)                                                                                                                         
					{                                                                                                                                        
					 print FILE1 "Intron$flag2\t$endnew\t$startnew\t$intron\n";                                                                               
					}                                                                                                                                        
					$flag2++;                                                                                                                                
				}                                                                                                                                          
				@start_end=();                                                                                                                             
	}                                                                                                                                                
	                                                                                                                                                 
	if($_=~/\s+ncRNA\s+j\w{3}\((.+)\n/) # Extract lines with ncRNA transcript coordinates                                                                        
	{                                                                                                                                                
		$exonum=$1;                                                                                                                                    
		$exonum=~s/,/\.\./g;                                                                                                                           
		$exonum=~s/\"//g;                                                                                                                              
		$exonum=~s/\(//g;                                                                                                                              
		$exonum=~s/\)//g;                                                                                                                                
		$next=<INPUT>;                                                                                                                                   
		while ($next!~m/\s+\/.*/g)                                                                                                                     
		{                                                                                                                                              
			$exon2=$next;                                                                                                                                 
			$exon2=~s/ //g;                                                                                                                              
			$exon2=~s/\,/\.\./g;                                                                                                                         
			$exon2=~s/\"//g;                                                                                                                             
			$exon2=~s/\)//g;                                                                                                                             
			$exon2=~s/\n//g;                                                                                                                             
			$exonum=$exonum.$exon2;                                                                                                                      
			$next=<INPUT>;                                                                                                                               
		}                                                                                                                                                
			print FILE1 "ncRNA$flag_nc\n";                                                                                                               
			$exonum=~s/\.\./\,/g;                                                                                                                        
			@start_end=split(",",$exonum);                                                                                                               
			$exonum='';                                                                                                                                  
			$flag2=1;                                                                                                                                    
			$flag_nc++;                                                                                                                                  
				                                                                                                                                           
				for ($i=0;$i<=$#start_end;$i+=2)                                                                                                           
				{	                                                                                                                                         
					print FILE1 "Exon$flag2\t";                                                                                                              
					$l=$start_end[$i+1]-$start_end[$i]+1;                                                                                                    
					$mRNA=substr($fasta,$start_end[$i]-1,$l);                                                                                                
					print FILE1 "$start_end[$i]\t$start_end[$i+1]\t$mRNA\n";                                                                                 
					$endnew=$start_end[$i+1]+1;                                                                                                              
					$startnew=$start_end[$i+2]-1;                                                                                                            
					$l2=$startnew-$endnew+1;                                                                                                                 
					$intron=substr($fasta,$endnew-1,$l2);                                                                                                      
					if ($startnew>0)                                                                                                                         
					{                                                                                                                                        
					 print FILE1 "Intron$flag2\t$endnew\t$startnew\t$intron\n";                                                                               
					}                                                                                                                                        
					$flag2++;                                                                                                                                
				}                                                                                                                                          
				@start_end=();                                                                                                                             
	}                                                                                                                                                
}                                                                                                                                                  
close INPUT;                                                                                                                                       
close FILE1;                                                                                                                                                                              
#################################################################################################################################################################  
                                                                                                                                                   
# Creates the list of all exon coordinates and their sequence, filtering out all double-records (exons that exist more than once), saving them in an array.                                                                 
open FILE1,"$rez/2.Annotated_Transcript_Structure.txt" or die "Can't open 2.Annotated_Transcript_Structure.txt\n";                                                                                                                                                      
use List::MoreUtils qw(uniq); #Uniq utility is used to filter out exons that appear more than once.                                                                                                                      
while (<FILE1>)                                                                                                                                    
{                                                                                                                                                  
	if ($_=~/^Exon\d+\t(\d+)\t(\d+)\t(\w+)/g)  # Matches the exon coordinates and their sequence.                                                                                                      
	{                                                                                                                                                
		$exon_start=$1;                                                                                                                                
		$exon_end=$2;                                                                                                                                  
		$exon=$3;                                                                                                                                                                                               
		push (@data,"$exon_start\t$exon_end\t$exon")                                                                                                   
	}                                                                                                                                                
}                                                                                                                                                  
@final= uniq @data; # Filters out all double-records.
                                                                                                                               
@final= sort{$a<=>$b} @final;                                                                                                                     
print FILE2 join("\n",@final,);                                                                                                                    
close FILE1;                                                                                                                                       
close FILE2;                                                                                                                                       
#################################################################################################################################################################  
                                                                                                                                                   
# Names all exons (1,2..n) depending on their location on the gene.
# If two or more exons have overlapping ends, then their number is the same and secondary numbering is applied inside parenthesis.(For example: Exon 3(1), 3(2), 3(n)).                                                                                                                           
# Data is printed in 3.Exons.txt as following: 1st column:Starting coordinate, 2nd column:Ending coordinate, 3rd column:Exon number, 4th column:Exon sequence. 
open FILE2,"$rez/2out.txt" or die "Can't open FILE2\n";                                                                                            
open JUNK,"+>", "$rez/JUNK.txt" or die "$0: can't create temporary file: $!\n";                                                                                                                            

@lines = <FILE2>;
use Sort::Fields;
@lines = fieldsort ['2n'], @lines; #Sort all exons based on their ending coordinate on the gene.                                                                                                                                
$flag=0;                                                                                                                                           
$count=0;                                                                                                                                          
                                                                                                                                                   
for($i = 0; $i<=$#lines;$i++)                                                                                                                      
{                                                                                                                                                  
	                                                                                                                                                 
	while($lines[$i+1]=~/^(\d+)\t(\d+)\t(\w+)/g)                                                                                                     
	{                                                                                                                                                
		$newdigit1=$1;                                                                                                                                 
		$newdigit2=$2;                                                                                                                                 
		$newexon=$3;                                                                                                                                   
		                                                                                                                                               
					while($lines[$i]=~/^(\d+)\t(\d+)\t(\w+)/g)                                                                                               
					{                                                                                                                                        
						$digit1=$1;                                                                                                                            
						$digit2=$2;                                                                                                                            
						$exon=$3;                                                                                                                              
								                                                                                                                                   
								if ($newdigit1>$digit2 and $count=0)                                                                                               
								{                                                                                                                                  
								 $flag++;                                                                                                                          
								 $count++;                                                                                                                         
								 print JUNK "$digit1\t$digit2\t$flag($count)\t$exon\n";                                                                           
								 $flag=$flag-1;                                                                                                                    
							  }                                                                                                                                  
						                                                                                                                                       
								elsif ($newdigit1>$digit2)                                                                                                         
							  {                                                                                                                                  
								 $flag++;                                                                                                                          
								 $count=0;                                                                                                                         
								 print JUNK "$digit1\t$digit2\t$flag($count)\t$exon\n";                                                                           
							  }                                                                                                                                  
							                                                                                                                                     
							  else                                                                                                                               
							  {                                                                                                                                  
								 $flag++;                                                                                                                          
								 $count++;                                                                                                                         
								 print JUNK "$digit1\t$digit2\t$flag($count)\t$exon\n";                                                                           
								 $flag=$flag-1;	                                                                                                                   
							  }		                                                                                                                               
					}                                                                                                                                        
	}                                                                                                                                                
                                                                                                                                                   
	if ($lines[$i+1]=~/^$/g)                                                                                                                         
	{                                                                                                                                                
		if($lines[$i]=~/^(\d+)\t(\d+)\t(\w+)/g)                                                                                                        
			{                                                                                                                                            
			 $d1=$1;                                                                                                                                     
			 $d2=$2;                                                                                                                                     
			 $e=$3;                                                                                                                                      
						if ($d1>$digit2)                                                                                                                       
						{	                                                                                                                                     
						 $flag++;                                                                                                                              
						 $count=0;                                                                                                                             
						 print JUNK "$d1\t$d2\t$flag($count)\t$e";                                                                                            
						}                                                                                                                                      
						else                                                                                                                                   
						{                                                                                                                                      
						 $flag++;                                                                                                                              
						 $count++;                                                                                                                             
						 print JUNK "$d1\t$d2\t$flag($count)\t$e";                                                                                            
						 $flag=$flag-1;	                                                                                                                       
						}	                                                                                                                                     
			}                                                                                                                                            
	}                                                                                                                                                
}                                                                                                                                                  
close JUNK;                                                                                                                                       
                                                                                                                                                   
open JUNK,"$rez/JUNK.txt" or die "Can't open JUNK\n";                                                                                           
@lines=<JUNK>;                                                                                                                                    
$first="$lines[0]";                                                                                                                                
$first=~ s/\(0\)//;                                                                                                                                
print FILE3 "Exon Start\tExon End\tExon number\tExon sequence\n";                                                                                  
print FILE3 $first;                                                                                                                                
                                                                                                                                                   
for($i =1; $i<=$#lines;$i++)                                                                                                                       
{                                                                                                                                                  
	  while ($lines[$i]=~/^(\d+)\t(\d+)\t(\d+)\((\d+)\)\t(\w+)/g)                                                                                    
	  {                                                                                                                                              
	   $n1=$1;                                                                                                                                       
	   $n2=$2;                                                                                                                                       
	   $exon=$3;                                                                                                                                     
	   $counter=$4;                                                                                                                                  
	   $seq=$5;                                                                                                                                      
	  	   while ($lines[$i-1]=~/^(\d+)\t(\d+)\t(\d+)\((\d+)\)\t(\w+)/g)                                                                             
	  	   {                                                                                                                                         
	  	   	$lastn1=$1;                                                                                                                              
	  	   	$lastn2=$2;                                                                                                                              
	  	   	$lastexon=$3;                                                                                                                            
	  	   	$lastcounter=$4;                                                                                                                         
	  	   	$lastseq=$5;                                                                                                                             
	  	   		if ($exon eq $lastexon)                                                                                                                
	  	   		{                                                                                                                                      
	  	   			$lastcounter++;                                                                                                                      
	  	   			$var="$n1\t$n2\t$exon($lastcounter)\t$seq\n";                                                                                        
	  	   			print FILE3 $var;                                                                                                                    
	  	   			$lastcounter='';                                                                                                                     
	  	   		}                                                                                                                                      
	  	   		else                                                                                                                                   
	  	   		{                                                                                                                                      
	  	   			$var1="$n1\t$n2\t$exon($counter)\t$seq\n";                                                                                           
	  	   			$var1=~ s/\(0\)//g;                                                                                                                  
	  	   			print FILE3 $var1;                                                                                                                   
	  	   		}                                                                                                                                      
	  	   }                                                                                                                                         
	  }                                                                                                                                              
}                                                                                                                                                  
close FILE2;                                                                                                                                       
close JUNK;                                                                                                                                       
close FILE3;                                                                                                                                       
unlink "$rez/JUNK.txt" or die "Could not delete JUNK.txt!\n";                                                                                                                                         
                                                                                                                                                   
#################################################################################################################################################################  
                                                                                                                                                   
# Creates keywords based on the exon sequences printed in 3.Exons.txt                                                                                                                                        
open FILE3, "$rez/3.Exons.txt" or die "Can't open 3.Exons.txt\n";                                                                                           
open FILE4,">", "$rez/FILE4.txt" or die "$0: can't create temporary file: $!\n";                                                                   
use List::Util qw(min);                                                                                                                            
while (<FILE3>)                                                                                                                                    
{                                                                                                                                                  
	if ($_=~/^\d+\t\d+\t\S+\t(\w+)/g)  # Calculates the length of the shorter exon.                                                                                                              
	{                                                                                                                                                
		$loe=length$1;                                                                                                                                 
		push(@loes,$loe);                                                                                                                              
	}                                                                                                                                                
}                                                                                                                                                  
$min= min(@loes);                                                                                                                                  
close FILE3;                                                                                                                                       
                                                                                                                                                   
open FILE3, "$rez/3.Exons.txt" or die "Can't open 3.Exons.txt\n";                                                                                           
print "Creating Keywords...\nNumber of nucleotides from each exon end that will be used to form the 5' part of all keywords(Minimum number:8)\n";                                                           
# The user should insert the length of the ending region of each exon that will form the keyword.                                                                                                                                                                                                                                  
while ($y= <STDIN>) # The input number must be a positive number, larger than the shorter exon and should not contain other characters than numbers.                                                                                                                                
{                                                                                                                                                  
	chomp $y;                                                                                                                                        
                                                                                                                                                   
 if ($y<=0)                                                                                                                                         
	{                                                                                                                                                
	 print "\n!!! WARNING: Incorrect number of bases. Please try again\n";                                                                           
	 print "Number of nucleotides from each exon end that will be used to form the 5' part of all keywords(Minimum number:8)\n";                                                                                          
	} 
	elsif ($y<8)                                                                                                                                         
	{                                                                                                                                                
	 print "\n!!! WARNING: The number of bases should be at least 8. Please try again\n";                                                                           
	 print "Number of nucleotides from each exon end that will be used to form the 5' part of all keywords(Minimum number:8)\n";                                                                                          
	}                                                                                                                                               
	elsif ($y>$min)                                                                                                                                       
  {                                                                                                                                                
	 print "\n!!! WARNING: Length of bases for keyword cannot be larger than an exon. Please try again\n";                                           
	 print "Number of nucleotides from each exon end that will be used to form the 5' part of all keywords(Minimum number:8)\n";                                                                                           
  }                                                                                                                                                
	elsif ($y!~ m/^\d+$/)                                                                                                                            
  {                                                                                                                                                
	 print "\n!!! WARNING: Length must be a number. Please try again\n";                                                                             
	 print "Number of nucleotides from each exon end that will be used to form the 5' part of all keywords(Minimum number:8)\n";                                                                              
  }                                                                                                                                                
  else                                                                                                                                             
  {                                                                                                                                               
  	last;                                                                                                                                          
  }                                                                                                                                                
}

print "Number of nucleotides from each exon start that will be used to form the 3' part of all keywords(Minimum number:8)\n";
# The user should insert the length of the starting region of each exon that will form the keyword.
while ($x= <STDIN>) # The input number must be a positive number, larger than the shorter exon and should not contain other characters than numbers.                                                                                                                            
{                                                                                                                                                  
	chomp $x;                                                                                                                                        
 if ($x<=0)                                                                                                                                         
	{                                                                                                                                                
	 print "\n!!! WARNING: Incorrect number of bases. Please try again\n";                                                                           
	 print "Number of nucleotides from each exon start that will be used to form the 3' part of all keywords(Minimum number:8)\n";                                                                                          
	}
	elsif ($x<8)                                                                                                                                         
	{                                                                                                                                                
	 print "\n!!! WARNING: The number of bases should be at least 8. Please try again\n";                                                                           
	 print "Number of nucleotides from each exon start that will be used to form the 3' part of all keywords(Minimum number:8)\n";                                                                                          
	}                                                                                                                                                
	elsif ($x>$min)                                                                                                                                       
  {                                                                                                                                                
	 print "\n!!! WARNING: Length of bases for keyword cannot be larger than an exon. Please try again\n";                                           
	 print "Number of nucleotides from each exon start that will be used to form the 3' part of all keywords(Minimum number:8)\n";                                                                                           
  }                                                                                                                                                
	elsif ($x!~ m/^\d+$/)                                                                                                                            
  {                                                                                                                                                
	 print "\n!!! WARNING: Length must be a number. Please try again\n";                                                                             
	 print "Number of nucleotides from each exon start that will be used to form the 3' part of all keywords(Minimum number:8)\n";                                                                              
  }                                                                                                                                                
  else                                                                                                                                             
  { 
  	print "Keywords are created.\n\n";                                                                                                                                               
  	last;                                                                                                                                          
  }                                                                                                                                                
}            
                                                                                                                                                  
$fullkeyword=$x+$y;                                                                                                                                
$quarter=$fullkeyword/4; 
                                                                                                                                  
while (<FILE3>)    # Creates keywords from the exons depending on the STDIN.                                                                                                                                
{                                                                                                                                                  
  if ($_=~/^\d+\t\d+\t(\S+)\t(\S{$y}).*(.{$x})/g)                                                                                                  
  {                                                                                                                                                
	 $exon=$1;                                                                                                                                       
	 $start=$2;                                                                                                                                      
	 $end=$3;                                                                                                                                        
	 push (@exon_numbers,$exon);                                                                                                                     
	 push (@exon_numbers1,$exon);                                                                                                                    
	 push (@array2,$start);                                                                                                                          
	 push (@array1,$end);
	 push (@kodikosy,$start);                                                                                                                          
	 push (@kodikosx,$end);                                                                                                                                                                                   
	}	                                                                                                                                               
}                                                                                                                                                  
$kodikosy="@kodikosy";
$kodikosx="@kodikosx";                                                                                                                                                   
$a=@array1;                                                                                                                                        
$m=$a-1;                                                                                                                                           
$b=@array2;                                                                                                                                        
$n=$b-1;                                                                                                                                           
$c=@exon_numbers;                                                                                                                                  
$o=$c-1;                                                                                                                                           
$d=@exon_numbers1;                                                                                                                                 
$r=@d-1;                                                                                                                                                                                                     
                                                                                                                                                                                                             
foreach $end (@array1)                                                                                                                             
{                                                                                                                                                  
	for($i=0; $i<=$n;$i++)                                                                                                                           
	{                                                                                                                                                                                                         
	 push (@table1,"$end$array2[$i]");                                                                                                               
	}                                                                                                                                                
}                                                                                                                                                  
                                                                                                                                                   
foreach $exon (@exon_numbers)                                                                                                                      
{                                                                                                                                                  
	for($i=0; $i<=$o;$i++)                                                                                                                           
	{                                                                                                                                                                                                         
	push (@table2,"$exon-$exon_numbers1[$i]");                                                                                                      
	}	                                                                                                                                               
}	                                                                                                                                                 
print FILE4 "$table1[$_]\t$table2[$_]\n" for 0 .. $#table1;                                                                                                                                                 
close FILE4;                                                                                                                                       
                                                                                                                                                   
open FILE4,"$rez/FILE4.txt" or die "Can't open FILE4\n";                                                                                           
print FILE5 "Keyword\tExon (donor splice site)\tExon (acceptor splice site)\tDirection\n";
                                                                                            
while (<FILE4>) # For each keyword, it creates the reverse complement keyword and merges all keywords in one file.                                                                                                                                   
{                                                                                                                                                  
	if ($_=~/^(\w+)\t(\S+)\-(\S+)/)                                                                                                                  
	{                                                                                                                                                
		$seq=$1;
		$revcom = reverse $seq;                                                                                                                         
	  $revcom =~ tr/ACGT/TGCA/;                                                                                                                                       
		$exon1=$2;                                                                                                                                     
		$exon2=$3;                                                                                                                                                                                              
		  
		  if ($exon2>$exon1)                                                                                                                           
			{                                                                                                                                            
			 push(@for_records,"$seq\t$exon1\t$exon2\tSense\n");
			 push(@rev_records,"$revcom\t$exon1\t$exon2\tAntisense\n");                                                                                                  
			}                                                                                                                                            
	}                                                                                                                                                
} 
print FILE5 @for_records;
print FILE5 @rev_records;                                                                                                                                             
close FILE3;                                                                                                                                       
close FILE4;                                                                                                                                                                                                                                                                              
unlink "$rez/FILE4.txt" or die "Could not delete FILE4.txt!\n";                                                                                                                                                
#################################################################################################################################################################  
                                                                                                                                                   
# Filters all double records in keywords. If a keyword is found more than once, the exon numbers that characterize it are merged.                                                                                                                                       
use List::MoreUtils qw(uniq);                                                                                                                      
open FILE5,"$rez/5out.txt" or die "Can't open FILE5\n";                                                                                            
                                                                                                                                                   
@lines=<FILE5>;                                                                                                                                    
foreach $lines (@lines)                                                                                                                            
{                                                                                                                                                  
	if ($lines=~/(\w+)\t(\S+)\t(\S+)\t(\w+)/g)                                                                                                       
	{                                                                                                                                                
		$keyword=$1;                                                                                                                                   
		$exon1=$2;                                                                                                                                     
		$exon2=$3;                                                                                                                                     
		$dir=$4;                                                                                                                                       
		push(@keywords,$keyword);                                                                                                                      
		push(@exons1,$exon1);                                                                                                                          
		push(@exons2,$exon2);                                                                                                                          
		push(@dirs,$dir);                                                                                                                              
		push (@extra, "$exon1\t$exon2\t$dir");                                                                                                         
	}                                                                                                                                                
}                                                                                                                                                  
print FILE6 "Keyword\tExon (donor splice site)\tExon (acceptor splice site)\tStrand\n";                                                                                            
@array= uniq(@keywords);                                                                                                                           
foreach $array (@array)                                                                                                                            
{                                                                                                                                                  
	@array1='';                                                                                                                                      
	@array2='';                                                                                                                                      
	@array3='';                                                                                                                                      
	$q='';                                                                                                                                           
	print FILE6 $array;                                                                                                                              
	for ($i=0;$i<=$#lines;$i++)                                                                                                                      
	{                                                                                                                                                
		if ($array eq $keywords[$i])                                                                                                                   
		{                                                                                                                                              
			push(@array1,$exons1[$i]);                                                                                                                                                                                                                                                   
			push(@array2,$exons2[$i]);                                                                                                                                                                                                                                                   
			push(@array3,$dirs[$i]);                                                                                                                           
		}                                                                                                                                              
	}
	
	@array1= uniq @array1;
	@array2= uniq @array2;
	$a1="@array1";                                                                                                                               
	$a1=~ s/ /,/g;                                                                                                                               
	$a1=~ s/,//;
	$a2="@array2";                                                                                                                               
	$a2=~ s/ /,/g;                                                                                                                               
	$a2=~ s/,//;
	$q= shift @array3;                                                                                                                           
	$q="@array3";                                                                                                                                
	$q=~ s/ //g;                                                                                                                                 
	$t=@array3[0];                                                                                                                                                
	print FILE6 "\t$a1\t$a2\t$t\n";                                                                                                                  
}	                                                                                                                                                 
close FILE5;                                                                                                                                       
close FILE6;
unlink "$rez/2out.txt" or die "Could not delete 2out.txt!\n";
unlink "$rez/5out.txt" or die "Could not delete 5out.txt!\n";                                                                                                                                                
                                                                                                                                                   
#################################################################################################################################################################  
 
$quarter=round($quarter); # Subroutine algorithm is at the end of this perl script.                                                                                                             
print "Maximum number of mismatches that will be accepted for every keyword match (Minimum number:0 - Maximum number:$quarter)\n";            
# The input number of mismatches should not be <0, bigger than 1/4 of the keyword length and also should not contain other characters than numbers.

while ($in= <STDIN>)                                                                                                                               
{                                                                                                                                                  
	chomp $in;                                                                                                                                       
                                                                                                                                                   
  if ($in<0)                                                                                                                                        
	{                                                                                                                                                
   print "\n\n!!! WARNING: Incorrect number of mismatches. Please try again\n\n";                                                                      
	 print "Maximum number of mismatches that will be accepted for every keyword match (Minimum number:0 - Maximum number:$quarter)\n";         
	}                                                                                                                                                
	elsif ($in!~ m/^\d+$/)                                                                                                                           
  {                                                                                                                                                
	 print "\n\n!!! WARNING: Input must be a number. Please try again\n\n";                                                                              
	 print "Maximum number of mismatches that will be accepted for every keyword match (Minimum number:0 - Maximum number:$quarter)\n";         
  }                                                                                                                                                
	elsif ($in>$quarter)                                                                                                                                       
  {                                                                                                                                                
	 print "\n\n!!! WARNING: The number of mismatched applied cannot exceed the length of the keywords. Please try again\n\n";                           
	 print "Maximum number of mismatches that will be accepted for every keyword match (Minimum number:0 - Maximum number:$quarter)\n";                                                                  
	}                                                                                                                                               
  else                                                                                                                                             
  {                                                                                                                                                
   last;                                                                                                                                          
  }                                                                                                                                                
}

print "Should all antisense fastq reads and their matching keywords be printed as in Sense strand (Y/N)?";
while ($revcom_reads= <STDIN>) #User should type 'Y' or 'N' in order to proceed to keyword assembly or not.                                                                                                                           
{                                                                                                                                                  
	chomp $revcom_reads;                                                                                                                                      
	if ($revcom_reads =~ m/^[Y]$/i)                                                                                                                       
	{ 
	 print "Searching keywords in FASTQ file . . .\n";                                                                                                                                               
   last;                                                                                                                                           
  }
  elsif ($revcom_reads =~ m/^[N]$/i)
  {
   print "Searching keywords in FASTQ file . . .\n";
   last;
  }                                                                                                                                                 
  else                                                                                                                                             
  {                                                                                                                                                
  	print "\n\nInvalid command...Should all antisense fastq reads and their matching keywords be printed as in Sense strand (Y/N)?";                                                          
  }                                                                                                                                                
}

# Matches each keyword in FASTQ file.                                                                                                                                    
open FILE6,"$rez/4.Keywords.txt" or die "Can't open 4.Keywords.txt\n";                                                                                            
use String::Approx qw(amatch); # PERL module that enables search with mismatches.                                                                                                                                         
while (<FILE6>)
{
	if ($_=~/(\w+)\t(\S+)\t(\S+)\t(\w+)/)
	{
		$key=$1;
		$exon1=$2;
		$exon2=$3;
		$direction=$4;                                                                                                                                                                                                                                                                           
    push (@kleidia,$key);                                                                                                                             
    push (@e1,$exon1);                                                                                                                                
    push (@e2,$exon2);                                                                                                                                
    push (@dir,$direction);                                                                                                                           
    push (@records,"$key\t$exon1\t$exon2\t$direction\n");   # Matches the keywords with the exons and their strand (Sense or Antisense) located in 4.Keywords.txt and puts them in array.
    if ($direction eq "Sense")
		{ 
			push(@forkeys,$key);
			push(@forjunctions,"$exon1-$exon2");
			push(@forstarts,$exon1);
			push(@forends,$exon2);
	  }
	  if ($direction eq "Antisense")
		{ 
			push(@revkeys,$key);
			push(@revjunctions,"$exon1-$exon2");
			push(@revstarts,$exon1);
			push(@revends,$exon2);
	  }
			                                                                                           
  }
}
close FILE6;
@lines=<FASTQ>;
# For each 4-line record in FASTQ file, it puts the read ID (1st line) in one array, and the sequencing read (4th line) in another array.                                                                                                                                                  
for ($i=0;$i<=$#lines;$i=$i+4) 
{
	chomp $lines[$i];
	chomp $lines[$i+1];
	push(@fastq_ids,$lines[$i]);
	push(@fastq_reads,$lines[$i+1]);
}
close FASTQ;

# For each keyword, searches all the sequencing reads from FASTQ file. If it finds match, prints in 5.All_Reads.txt the following:
# 1st column: Read ID
# 2nd column: Keyword 
# 3rd column: Exon that forms the 5'region of the keyword
# 4th column: Exon that forms the 3'region of the keyword 
# 5th column: FOR or REV (if keyword if forward or reverse complement)
# 6th column: Sequencing Read that matches keyword.                                                                                                                                                                                                                     

for ($j=0;$j<=$#fastq_reads;$j++)
{                                                                                                                                                 
	 for ($i=0;$i<=$#kleidia;$i++)                                                                                                                   
	 {                                                                                                                                               		
		 if (amatch($kleidia[$i],[$in],$fastq_reads[$j]))                                                                                                     
		 { 
		 	chomp $records[$i];
		 	chomp $dir[$i];
		 	   if ($dir[$i] eq "Sense")
		 	   {
		 	   	push(@for_results,"$fastq_ids[$j]\t$records[$i]\t$fastq_reads[$j]\n");                                                                                                                                       
		     }
		     if ($dir[$i] eq "Antisense")
		     {
		     		if ($revcom_reads =~ m/^[N]$/i)
		     		{
		     			push(@rev_results,"$fastq_ids[$j]\t$records[$i]\t$fastq_reads[$j]\n");
		     		}
		     		else
		     		{
		     			$reverse_key= reverse $kleidia[$i];
       			  $reverse_key=~ tr/ACGT/TGCA/;
       			  $reverse_read= reverse $fastq_reads[$j];
       			  $reverse_read=~ tr/ACGT/TGCA/;
       			  push(@rev_results,"$fastq_ids[$j]\t$reverse_key\t$e1[$i]\t$e2[$i]\t$dir[$i]\t$reverse_read\n");	
		     		}	
		     }	                                                                                                
		 }                                                                                                                                        
	 }	                                                                                                                                                                                                                                                                                      
}                                                                                                                                                                                                                                                                                         
use Sort::Fields; # Sorts the reads based on the exon numbers of the keyword. Also prints the reverse complement of the read sequence for reverse complement keywords.                                                                                                                                 
@all_results = (@for_results,@rev_results);
@for_results = fieldsort ['3n','4n',5],@for_results;
@rev_results = fieldsort ['3n','4n',5],@rev_results;
@all_results = fieldsort ['3n','4n',-5],@all_results;                                                                                                                                        
print FILE7 "Read ID\tKeyword\tExon (donor splice site)\tExon (acceptor splice site)\tStrand\tSequence\n";
print FILE7 @all_results;
close FILE7;                                                                                                                                                   
#################################################################################################################################################################                                                                                                                                                     
# Creates the 6.Annotated_Transcripts.txt file.                                                                                                                               
open FILE1,"$rez/2.Annotated_Transcript_Structure.txt" or die "Can't open 2.Annotated_Transcript_Structure.txt\n";                                                                                            
open FILE3,"$rez/3.Exons.txt" or die "Can't open 3.Exons.txt\n";                                                                                            
                                                                                                                                                   
while (<FILE3>)  # From 3.Exons.txt extracts the exon coordinates and the exon names.                                                                                                                                  
{                                                                                                                                                  
	if ($_=~/^(\d+\t\d+)\t(\S+)\t\w+/g)                                                                                                              
	{                                                                                                                                                
	 $variable1=$1;                                                                                                                                  
	 $coding1=$2;                                                                                                                                    
	 push(@passwords,$variable1);                                                                                                                    
	 push(@codings1,$coding1);                                                                                                                       
	}                                                                                                                                                
}   
                                                                                                                                               
while (<FILE1>)                                                                                                                                 
{                                                                                                                                                  
	if ($_=~/^(mRNA\d+|misc_RNA\d+|ncRNA\d+)/)                                                                                                       
	{                                                                                                                                                                                                         
	 $variable3=$1;                                                                                                                                  
	 push(@messengerRNAs,$variable3);                                                                                                                
	 $wanted="@findings";                                                                                                                            
	 $wanted=~ s/ /\-/g;                                                                                                                             
	 $wanted=~ s/^.//g;                                                                                                                              
	 @findings='';                                                                                                                                   
	 push(@finalized,$wanted);                                                                                                                       
	}                                                                                                                                                
	                                                                                                                                                 
	while ($_=~/^Exon(\d+)\t(\d+\t\d+)\t(\w+)/g)                                                                                                     
	{                                                                                                                                                
	  $coding2=$1;                                                                                                                                   
	  $variable2=$2;                                                                                                                                 
	  $fasta2=$3;                                                                                                                                    
	  for ($j=0;$j<=$#passwords;$j++)                                                                                                                
	  {                                                                                                                                              
			if ($passwords[$j] eq $variable2)                                                                                                            
			{                                                                                                                                            
			 push(@findings,$codings1[$j]);                                                                                                              
			}                                                                                                                                            
		}                                                                                                                                              
	}                                                                                                                                                
}                                                                                                                                                  
                                                                                                                                                   
$wanted="@findings";                                                                                                                               
$wanted=~ s/ /\-/g;                                                                                                                                
$wanted=~ s/^.//g;                                                                                                                                 
@findings='';                                                                                                                                      
push(@finalized,$wanted);                                                                                                                          
shift @finalized;                                                                                                                                                                                                                                                                                                                                                                                                                                       
print INFO "Annotated transcript\tSplice junction combination\n";  #Prints all annotated transcripts and their exons with the numbers ASDT has gave them.                                                                                                          
for ($i=0;$i<=$#finalized;$i++)                                                                                                                    
{                                                                                                                                                  
	print INFO "$messengerRNAs[$i]\t$finalized[$i]\n";                                                                                               
}                                                                                                                                                  
close FILE1;                                                                                                                                       
close FILE3;                                                                                                                                                                                                                                                                                                                                                                          
close INFO;                                                                                                                                                                                                  
#################################################################################################################################################################  
# Creates the 7.Single_Splice_Junctions.txt file.                                                                                                                 
open FILE7,"$rez/5.All_Reads.txt" or die "Can't open 5.All_Reads.txt\n";                                                                                                                                                
open INFO2,">", "$rez/7.Single_Splice_Junctions.txt" or die "Can't open 7.Single_Splice_Junctions.txt\n";                                                                                        
                                                                                                                                                   
@lines=<FILE7>;                                                                                                                                    
for ($i=0;$i<=$#lines;$i++) #From 5.All_Reads.txt it extracts all exon pairs whose keywords were matched for splicing events.                                                                                                                    
{                                                                                                                                                  
	if ($lines[$i]=~/.*\t\w+\t(\S+\t\S+)\t\w+\t\w+/g)                                                                                              
	{                                                                                                                                                
	 $B=$1;                                                                                                                                          
	 push(@database,$B);                                                                                                                             
	}                                                                                                                                                
}                                                                                                                                                  
                                                                                                                                                   
use List::MoreUtils qw(uniq);                                                                                                                      
@info= uniq @database;  # FIlters out all records that appear more than once.                                                                                                                     
print INFO2 "Splice junction\tFrequency\n";                                                                                                                                                                                                                                                                                                                                                          
foreach $info (@info) # For each exon pair it searches 5.All_Reads.txt and counts the number this exon pair is found.                                                                                                                              
{                                                                                                                                                  
 $count=0;                                                                                                                                         
 for ($i=0;$i<=$#lines;$i++)                                                                                                                       
 {                                                                                                                                                 
	 if ($lines[$i]=~/.*\t\w+\t(\S+\t\S+)\t\w+\t\w+/)                                                                                              
	 {                                                                                                                                               
		 $W=$1;                                                                                                                                        
		 if ( $info eq $W)                                                                                                                             
		 {                                                                                                                                             
			 $count++;                                                                                                                                   
		 }                                                                                                                                             
	 }                                                                                                                                               
 }                                                                                                                                                 
	$info=~ s/\t/-/;                                                                                                                                 
	print INFO2 "$info\t$count\n";  #Prints in 7.Single_Splice_Junctions.txt all splice junctions and the frequency of each splice junction.                                                                                                                 
}        
                                                                                                                                          
close FILE7;                                                                                                                                       
close INFO2;                                                                                                                                                
#################################################################################################################################################################                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    open AS1,">", "$rez/Combined splice junctions (not filtered).txt" or die "Can't open Combined splice junctions (not filtered).txt\n";
    print "Detection of splice junction combinations for every sequencing read is in process . . .\n";                                                                                   
                                                                                                                                                   
    use String::Approx qw(amatch);                                                                                                                                                                                                                                                                       
     print AS1 "Read ID\tSplice junction combination\tStrand\tSequence\n";                                                                                                                                              
	   for ($j=0;$j<=$#all_results;$j++) #For each sequencing read in 5.All_Reads.txt it tests if another keyword matches.                                                                                                                   
	   {
	   	     if ($all_results[$j]=~/(.*)\t\w+\t\S+\t\S+\t(\w+)\t(\w+)/)
	   	     {
	   	     	$id=$1;
	   	     	$strand=$2;
	   	     	$string=$3;                                                                                                                                                                                                                                                                                  
	            $variant='';
	            if ($strand eq "Sense")
	            {                                                                                                                                    
	               for ($i=0;$i<=$#forkeys;$i++)                                                                                                                   
	               {                                                                                                                                              
	   	             if (amatch($forkeys[$i],[$in],$string))                                                                                                  
	   	             {                                                                                                                                            
	   	               $variant="$variant"."$forjunctions[$i]<--->";                                                                                              
	   	             }                                                                                                                                            
	               }                                                                                                                                              
	                                                                                                                                                
                 $variant=~ s/ //g;
                 $variant= substr($variant,0,-5);                                                                                                                                                                                                                                                                                                                                                                             
                 print AS1 "$id\t$variant\tSense\t$string\n";
              }
              if ($strand eq "Antisense")
	            {                                                                                                                                    
	                if ($revcom_reads =~ m/^[Y]$/i)
	                {
	                	    for ($i=0;$i<=$#forkeys;$i++)                                                                                                                   
	                      {                                                                                                                                              
	   	                    if (amatch($forkeys[$i],[$in],$string))                                                                                                  
	   	                    {                                                                                                                                            
	   	                      $variant="$variant"."$forjunctions[$i]<--->";                                                                                              
	   	                    }                                                                                                                                            
	                      }                                                                                                                                                                                                                                                                              
                        $variant=~ s/ //g;
                        $variant= substr($variant,0,-5);                                                                                                                                                                                                                                                                                                                                                                             
                        print AS1 "$id\t$variant\tAntiSense\t$string\n";
                  }
                  else
                  {
	                      for ($i=0;$i<=$#revkeys;$i++)                                                                                                                   
	                      {                                                                                                                                              
	   	                    if (amatch($revkeys[$i],[$in],$string))                                                                                                  
	   	                    {                                                                                                                                            
	   	                      $variant="$variant"."$revjunctions[$i]<--->";                                                                                              
	   	                    }                                                                                                                                            
	                      }                                                                                                                                                                                                                                                                              
                        $variant=~ s/ //g;
                        $variant= substr($variant,0,-5);                                                                                                                                                                                                                                                                                                                                                                         
                        print AS1 "$id\t$variant\tAntisense\t$string\n";
                  }
              }                                                                                                                         
	          }  
	   }                                                                                                                                                
     close AS1;                                                                                                                                         
                        
   	 open AS1, "$rez/Combined splice junctions (not filtered).txt" or die "Can't open Combined splice junctions (not filtered).txt\n";                        
   	 open AS2,">", "$rez/AS2.txt" or die "Can't open AS2.txt\n";                                                                              
   	 open AS3,">", "$rez/8.Unique_Reads.txt" or die "Can't open 8.Unique_Reads.txt\n";                                                                 
   	 @lines=<AS1>;                                                                                                                                
   	 for ($i=0;$i<=$#lines;$i++) #Filters out records with unsuccessful keyword assembly.                                                                                                                  
   	 {                                                                                                                                             
   		 if($lines[$i]=~ m/<--->/)                                                                                                                      
   		 {                                                                                                                                           
   		  print AS2 $lines[$i];                                                                                                                      
   		 }                                                                                                                                           
   	 }                                                                                                                                             
   		close AS2; 
   		                                                                                                                                  
   		print AS3 "Read ID\tSplice junction combination\tStrand\tSequence\n";                                                                                                                                              
   		open AS2, "$rez/AS2.txt" or die "Can't open AS2.txt\n";                                                                                 
   		%seen=();                                                                                                                                    
   		@flds;                                                                                                                                       
   		while (<AS2>)                                                                                                                                
   		{                                                                                                                                            
   		 @flds=split /\t/; 
   		 $_=~ s/ //g;                                                                                                                          
   		 push(@multiple_files,$_) if !$seen{$flds[0]}++;                                                                                                         
   		}                                                                                                                                            
   		close AS1;                                                                                                                                   
   		close AS2;
   		unlink "$rez/Combined splice junctions (not filtered).txt" or die "Could not delete Combined splice junctions (not filtered).txt!\n";                                                                             
      unlink "$rez/AS2.txt" or die "Could not delete AS2.txt!\n"; 
   		foreach $multiple_file (@multiple_files)
   		{                                                                                                                                                                                                                                                                      
   		  if ($multiple_file=~/.*\t(\S+)\t\w+\t\w+/)
   		  {
   		  	$multiple_rec=$1;
   		  	push(@multiple_recs,$multiple_rec);
   		  }
   		}
   		
   		for($v=0;$v<=$#multiple_recs;$v++)
   		{
   			
	        $flag=0;
	        @juns= split('<--->',$multiple_recs[$v]);
	        @multistarts='';
	        @multiends='';     
	             foreach $jun (@juns)
	             {
	             	if ($jun=~/(\S+)\-(\S+)/)
	             	{
	             		$multistart=$1;
	             		$multiend=$2;
	             		push(@multistarts,$multistart);
	             		push(@multiends,$multiend);
	              }
	             }
	             
	             for ($j=2;$j<=$#multistarts;$j++)
	             { 
	             	if ($multiends[$j-1] > $multistarts[$j])
	             	{
	             		$flag++;
	             	}
	             }
	             
	             if ($flag>0)
	             {
	             }
	             else
	             {
	             	chomp $multiple_files[$v];
	             	print AS3 "$multiple_files[$v]\n";
	             }
	    }
	    
	    close AS3;
#################################################################################################################################################################                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
# Creates the 9.Combined_Splice_Junctions.txt file.  
	    open AS3, "$rez/8.Unique_Reads.txt" or die "Can't open 8.Unique_Reads.txt\n"; 
	    open INFO3,">", "$rez/9.Combined_Splice_Junctions.txt" or die "Can't open 9.Combined_Splice_Junctions.txt\n";	
	    print INFO3 "Splice junction combination\tFrequency\n";
	    use List::MoreUtils qw(uniq);
	    while (<AS3>)
      {
	     if ($_=~/\.*\t(\S+)\t\w+\t\w+/)
	     {
		    $multiple_event=$1;
		    push(@multiple_events,$multiple_event);
	     }
      }
	    @uniq_multiple_events= uniq @multiple_events;
	   
	    for ($i=0;$i<=$#uniq_multiple_events;$i++)
      {
	      $multiple_count=0;
	       for ($j=0;$j<=$#multiple_events;$j++)
         {
         	if ($uniq_multiple_events[$i] eq $multiple_events[$j])
         	{
         		$multiple_count++;
         	}
         }
  
         print INFO3 "$uniq_multiple_events[$i]\t$multiple_count\n";  #Prints in 9.Combined_Splice_Junctions.txt all splice junction combinations and the frequency of each combination.
      }
      
      close AS3;
      close INFO3;
   		print "Detection of splice junction combinations for every sequencing read is complete.\n";                                                                                                                                                                                                                                                                                                                                                                                                             
#################################################################################################################################################################  
print "\n~~~~~~ Alternative Splicing Detection is complete ~~~~~~\n\nProceed to intron analysis (Y/N)?\n";                                                             
while ($in1= <STDIN>)  #User should type 'Y' or 'N' in order to proceed to intronic region analysis or not.                                                                                                                          
{                                                                                                                                                  
	  chomp $in1;                                                                                                                                      
	  if ($in1 =~ m/^[Y]$/i)                                                                                                                       
	  {                                                                                                                                                
     last;                                                                                                                                           
    }
    elsif ($in1 =~ m/^[N]$/i)
    {
     last;
    }                                                                                                                                                
    else                                                                                                                                             
    {                                                                                                                                                
    	print "\n\nInvalid command...Proceed to intron analysis (Y/N)?\n";                                                          
    }                                                                                                                                                
}
 
 if ($in1 =~ m/^[Y]$/i)                                                                                                                             
{
       
       open FILE1, "$rez/2.Annotated_Transcript_Structure.txt" or die "Can't open 2.Annotated_Transcript_Structure.txt\n";
       open INTRON1,">", "$rez/8.Introns.txt" or die "Can't open 8.Introns.txt\n";
       open INTRON2,">", "$rez/Intronic reads.txt" or die "Can't open Intronic reads.txt\n";
       open INTRON3,">", "$rez/Prediction of exons-Exon extensions-Intron Retentions.txt" or die "Can't open Prediction of exons-Exon extensions-Intron Retentions.txt\n";
       
       print INTRON1 "Intron Number\tIntron Start\tIntron End\tIntron Sequence\n";
       while (<FILE1>)                                                                                                                                    
       {                                                                                                                                                  
       	if ($_=~/^Intron\d+\t(\d+)\t(\d+)\t(\w+)/g) #Opens 2.Annotated_Transcript_Structure.txt and matches all lines with Intron information                                                                                                      
       	{                                                                                                                                                
       		$intron_start=$1;                                                                                                                                
       		$intron_end=$2;                                                                                                                                  
       		$intronseq=$3;
       		push (@intron_records,"$intron_start\t$intron_end\t$intronseq"); #Each element of the array contains the starting and ending coordinates as well as the sequence of each intron.                                                                                                 
       	}                                                                                                                                                
       }                                                                                                                                                  
       @final_introns= uniq @intron_records;     #Filters out all introns that appear more than once.                                                                                                                           
       @final_introns= sort{$a<=>$b} @final_introns;
       $flagin=0;                                                                                                                      
       for ($i=0;$i<=$#final_introns;$i++)
       {
       	$flagin++;
       	print INTRON1 "Intron$flagin\t$final_introns[$i]\n"; #Prints the list of introns in 11.Introns.txt
       }
       close FILE1;
       close INTRON1;
       
       open INTRON1, "$rez/8.Introns.txt" or die "Can't open 8.Introns.txt\n";
       use List::Util qw(min);
       while (<INTRON1>)                                                                                                                                    
       {                                                                                                                                                  
       	if ($_=~/^(Intron\d+)\t\d+\t\d+\t(\w+)/g)                                                                                                        
       	{
       		$intron_id=$1;
       		$intron_seq=$2;
       		$loi=length$intron_seq;
       		push(@intron_ids,$intron_id);
       		push(@intron_seqs,$intron_seq);
       		push(@lois,$loi);
       	}
       }
       $minlength= min(@lois);
       close INTRON1;
#################################################################################################################################################################  
# INTRON_ANALYSIS
       print "Number of nucleotides for each intronic keyword\n";
     while ($sp= <STDIN>)                                                                                                                                
     {                                                                                                                                                  
       	chomp $sp;                                                                                                                                        
                                                                                                                                                          
        if ($sp<=0)                                                                                                                                         
       	{                                                                                                                                                
       	 print "\n!!! WARNING: Incorrect number of bases. Please try again\n";                                                                           
       	 print "Number of nucleotides for each intronic keyword\n";                                                                                          
       	}                                                                                                                                                
       	elsif ($sp>$minlength)                                                                                                                                       
         {                                                                                                                                                
       	 print "\n!!! WARNING: The number of bases cannot exceed the length of an intron. Please try again\n";                                           
       	 print "Number of nucleotides for each intronic keyword\n";                                                                                           
         }                                                                                                                                                
       	elsif ($sp!~ m/^\d+$/)                                                                                                                            
         {                                                                                                                                                
       	 print "\n!!! WARNING: Length must be a number. Please try again\n";                                                                             
       	 print "Number of nucleotides for each intronic keyword\n";                                                                              
         }                                                                                                                                                
         else                                                                                                                                             
         {                                                                                                                                                
         	last;                                                                                                                                          
         }                                                                                                                                                
     }
       
       print "Step of each overlap between consecutive intronic keywords(For no overlap insert:$sp)\n";
     while ($r= <STDIN>)                                                                                                                                
     {                                                                                                                                                  
       	chomp $r;                                                                                                                                        
                                                                                                                                                          
        if ($r<0)                                                                                                                                         
       	{                                                                                                                                                
       	 print "\n!!! WARNING: Incorrect number of bases. Please try again\n";                                                                           
       	 print "Step of each overlap between consecutive intronic keywords(For no overlap insert:$sp)\n";                                                                                          
       	}                                                                                                                                                
       	elsif ($r>$sp)                                                                                                                                       
         {                                                                                                                                                
       	 print "\n!!! WARNING: The step of the overlap cannot be larger than the number of bases forming each keyword. Please try again\n";                                           
       	 print "Step of each overlap between consecutive intronic keywords(For no overlap insert:$sp)\n";                                                                                           
         }                                                                                                                                                
       	elsif ($r!~ m/^\d+$/)                                                                                                                            
         {                                                                                                                                                
       	 print "\n!!! WARNING: The step of the overlap must be a number. Please try again\n";                                                                             
       	 print "Step of each overlap between consecutive intronic keywords(For no overlap insert:$sp)\n";                                                                              
         }                                                                                                                                                
         else                                                                                                                                             
         {                                                                                                                                                
         	last;                                                                                                                                          
         }                                                                                                                                                
     }
       
       print "Minimum number of nucleotides that will be accepted for the last keyword\n";
     while ($lastcode= <STDIN>)                                                                                                                                
     {                                                                                                                                                  
       	chomp $lastcode;                                                                                                                                        
                                                                                                                                                          
        if ($lastcode<0)                                                                                                                                         
       	{                                                                                                                                                
       	 print "\n!!! WARNING: Incorrect number of bases. Please try again\n";                                                                           
       	 print "Minimum number of nucleotides that will be accepted for the last keyword\n";                                                                                          
       	}                                                                                                                                                
       	elsif ($lastcode>$sp)                                                                                                                                       
         {                                                                                                                                                
       	 print "\n!!! WARNING: The last keyword cannot be larger than the number of bases forming each keyword. Please try again\n";                                           
       	 print "Minimum number of nucleotides that will be accepted for the last keyword\n";                                                                                           
         }                                                                                                                                                
       	elsif ($lastcode!~ m/^\d+$/)                                                                                                                            
         {                                                                                                                                                
       	 print "\n!!! WARNING: The number of bases in the last keyword must be a number. Please try again\n";                                                                             
       	 print "Minimum number of nucleotides that will be accepted for the last keyword\n";                                                                              
         }                                                                                                                                                
         else                                                                                                                                             
         { 
         	print "Intron analysis is in process . . .\n";                                                                                                                                               
         	last;                                                                                                                                          
         }                                                                                                                                                
     }
       
     use List::MoreUtils qw(uniq);
     for ($i=0;$i<=$#intron_ids;$i++)
     {
       	print INTRON2 "$intron_ids[$i]\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
       	@keywords='';
       	@reverse_keywords='';
       	$first_key='';
       	$first_revkey='';
       							for ($k=0;$k<length($intron_seqs[$i]);$k+=$r)
       									{
       										$keyword=substr($intron_seqs[$i],$k,$sp);
       										$reverse_keyword= reverse $keyword;
       							      $reverse_keyword=~ tr/ACGT/TGCA/;
       										if (length$keyword >= $lastcode)
       										{
       											push(@keywords,$keyword);
       											push(@reverse_keywords,$reverse_keyword);
       										}
       									}
       									$first_key = shift @keywords;
       									$first_revkey= shift @reverse_keywords;
       									
       									for ($k=0;$k<=$#keywords;$k++)
       			            {
       										$flag=0;
       										@array='';
       	      						$alter='';
       	      						@intronic='';
       						        
       						        for ($v=0;$v<=$#fastq_reads;$v++)
       				          	{
       				          					if ($fastq_reads[$v] =~ /$keywords[$k]/)
       				          					{
       				          						$flag++;
       						          			 	push(@array,"$flag. $fastq_ids[$v]\tSense\t$fastq_reads[$v]\n");
       						          			 	push(@intronic,"$fastq_ids[$v]\tSense\t$fastq_reads[$v]\n");
       						          			}
       						          			
       						          			if ($fastq_reads[$v] =~ /$reverse_keywords[$k]/)                                                                                             
       						          			{
       						          				if ($revcom_reads =~ m/^[N]$/i)
       						          				{
       						          					$flag++;
       						          			 	  push(@array,"$flag. $fastq_ids[$v]\tAntiSense\t$fastq_reads[$v]\n");
       						          			 	  push(@intronic,"$fastq_ids[$v]\tAntiSense\t$fastq_reads[$v]\n");
       						          				}
       						          				elsif ($revcom_reads =~ m/^[Y]$/i)
       						          				{
       						          					$flag++;
       															  $alter=reverse$fastq_reads[$v];
       															  $alter=~ tr/ACGT/TGCA/;
       															  push(@array,"$flag. $fastq_ids[$v]\tAntisense\t$alter\n");
       															  push(@intronic,"$fastq_ids[$v]\tAntisense\t$alter\n");
       						          				}	                                                                                                                                                                                                                     
       						          			}
       						        }
       						          @intronic= uniq @intronic;
       						          @summary=(@summary,@intronic);
       						          @uniq_array= uniq @array;
       						          $new_flag=@uniq_array-1;
       						        	$record="Keyword: $keywords[$k]\tFrequency: $new_flag\n@uniq_array";
       		  								$record=~ s/ @/@/g;
       						        	print INTRON2 $record;
       						      }
       						     print INTRON2 "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n\n";
     }
    close INTRON2;
    unlink "$rez/Intronic reads.txt" or die "Could not delete Intronic reads.txt!\n";
#################################################################################################################################################################  
# EXON DETECT
                 open FILE3,"$rez/3.Exons.txt" or die "Can't open 3.Exons.txt\n"; 
                 while (<FILE3>)                                                                                                                                    
                 {                                                                                                                                                  
                 	 if ($_=~/\d+\t\d+\t\S+\t(\w+)/)                                                                                                    
                 	 {                                                                                                                                                
                 		$exwnio=$1;
                 		push(@exwnia,$exwnio);                                                                                                   
                 	 }                                                                                                                                                
                 } 
                 close FILE3;

       use String::Approx qw(amatch);          
       use List::MoreUtils qw(uniq);
       @summary= uniq @summary;
       print INTRON3 "~~~~~ Sequencing reads that predict novel exons/exon extensions/intron retentions ~~~~~\n\n";  
       if ($revcom_reads =~ m/^[Y]$/i)
      {
          for ($i=0;$i<=$#forkeys;$i++)
          {
          	$flag=0;
          	$a=substr($forkeys[$i],0,$y);
          	$b=substr($forkeys[$i],-$x);

       	            for ($j=0;$j<=$#summary;$j++)
       		          {
       		        
       		  	        if ($summary[$j]=~ /$a/ and $summary[$j]=~ /$b/)
       		  	        {
       		  		         chomp $summary[$j];
       		  		         $result_a = index($summary[$j],$a);
       	                 $result_b = index($summary[$j],$b);
       		  		         $merged="$a$b";
       		  		         if ($result_b > $result_a)
       		  		         {
       		  		             if ($summary[$j]!~ m/$merged/)   
       		  		             {  	
	                             push(@exon_records,"$summary[$j]\n");   
       		  		             }
       		  		         }
       		  	        }
       		          }
       		          
       		     @preds= uniq @exon_records;
       		     if ($#preds > 0)
       		     {
       		     	$outtitle="Predicted $#preds sequencing reads between exons: Exon $forstarts[$i] --> Matching keyword:$a ~~~~~ Exon $forends[$i] --> Matching keyword:$b\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
       		     	push(@outtitles,$outtitle);
       		     	#print INTRON3 "Predicted $#preds sequencing reads between exons: Exon $forstarts[$i] --> Matching keyword:$a ~~~~~ Exon $forends[$i] --> Matching keyword:$b\n";
       		     	#print INTRON3 "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
       		     	for ($k=0;$k<=$#preds;$k++)
       		     	{
       		     		if ($preds[$k]=~/$a(.*)$b/)
                   {
                   	chomp $preds[$k];
                   	$prediction=$1;
                   	$check1=substr($prediction,0,$y);
										$check2=substr($prediction,-$x);
                   	    if ($kodikosy !~/$check1/ and $kodikosx !~/$check2/)
	                           {
       		    	              $flag++;
       		    	              push(@finaloutput,"$flag.Record in Fastq: $preds[$k]\n$flag.Predicted Exon/Exon Extension/Intron Retention: $prediction\n\n");
       		     	              #print INTRON3 "$flag.Record in Fastq: $preds[$k]\n";
       		     	              #print INTRON3 "$flag.Predicted Exon/Exon Extension/Intron Retention: $prediction\n\n"; 
       		     	             }     
	                 }
	                          
       	                     
       	                         
	                 
       		     	}
       		     	            $augment=scalar(@finaloutput);
       	                     if ($augment<=0)
       		     	             { 	   
       	                     } 
       	                     else
       		     	             {
       		     	             	print INTRON3 "Predicted $augment sequencing reads between exons: Exon $forstarts[$i] --> Matching keyword:$a ~~~~~ Exon $forends[$i] --> Matching keyword:$b\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
       		     	              print INTRON3 "@finaloutput";
       	                      print INTRON3 "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n";
       	                     } 
       	                     @finaloutput=();
       		     	  
       		     	  
               } 
       		     @exon_records='';
       		     @preds='';
          } 
      }
       		        
      elsif ($revcom_reads =~ m/^[N]$/i)
      {
       	   for ($i=0;$i<=$#forkeys;$i++)
           {
           	$flag=0;
          	$a=substr($forkeys[$i],0,$y);
          	$b=substr($forkeys[$i],-$x);
          	$c=substr($revkeys[$i],-$y); 
            $d=substr($revkeys[$i],0,$x);	       	 
       		   
       		         for ($j=0;$j<=$#summary;$j++)
       		         { 
       		         	    	 
       		        	 if ($summary[$j]!~ /AntiSense/)
       		           {
       		           	        if ($summary[$j]=~ /$a/ and $summary[$j]=~ /$b/)
       		  	                {
       		  		                 chomp $summary[$j];
       		  		                 $result_a = index($summary[$j],$a);
       	                         $result_b = index($summary[$j],$b);
       		  		                 $merged="$a$b";
       		  		                 if ($result_b > $result_a)
       		  		                 {
       		  		                     if ($summary[$j]!~ m/$merged/)   
       		  		                     {  	
	                                     push(@exon_records,"$summary[$j]\n");   
       		  		                     }
       		  		                 }
       		  	                }
       		  	       }
       		  	       
       		  	       elsif ($summary[$j]=~ m/AntiSense/)
       		  	       {
       		  	       	         if ($summary[$j]=~ /$c/ and $summary[$j]=~ /$d/)
       		  	                {
       		  		                 chomp $summary[$j];
       		  		                 $result_c = index($summary[$j],$c);
       	                         $result_d = index($summary[$j],$d);
       		  		                 $merged="$d$c";
       		  		                 if ($result_c > $result_d)
       		  		                 {
       		  		                     if ($summary[$j]!~ m/$merged/)   
       		  		                     {  	
	                                     push(@exon_records,"$summary[$j]\n");  
       		  		                     }
       		  		                 }
       		  	                }
       		  	       }
       		         } 
       		     
       		     
              @preds= uniq @exon_records;
       		    if ($#preds > 0)
       		    {
       		    	$outtitle="Predicted $#preds sequencing reads between exons: Exon $forstarts[$i] --> Matching keyword:(Sense:$a - Antisense:$d) ~~~~~ Exon $forends[$i] --> Matching keyword:(Sense:$b - Antisense:$c)\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
       		    	#print INTRON3 "Predicted $#preds sequencing reads between exons: Exon $forstarts[$i] --> Matching keyword:(Sense:$a - Antisense:$d) ~~~~~ Exon $forends[$i] --> Matching keyword:(Sense:$b - Antisense:$c)\n";
       		      #print INTRON3 "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
       		    	 for ($k=0;$k<=$#preds;$k++)
       		    	 {
       		    		
       		    		  if ($preds[$k]!~ /AntiSense/)
       		    		  {
       		    		       if ($preds[$k]=~/$a(.*)$b/)
                         {
                         	 chomp $preds[$k];
	                         $prediction=$1;
	                         $check1=substr($prediction,0,$y);
										       $check2=substr($prediction,-$x);
                   	         if ($kodikosy !~/$check1/ and $kodikosx !~/$check2/)
	                           {
	                           	 $flag++;
	                           	 push(@finaloutput,"$flag.Record in Fastq: $preds[$k]\n$flag.Predicted Exon/Exon Extension/Intron Retention: $prediction\n\n");
       		    	               #print INTRON3 "$flag.Record in Fastq: $preds[$k]\n";
       		    	               #print INTRON3 "$flag.Predicted Exon/Exon Extension/Intron Retention: $prediction\n\n";
       		     	             }
       		    	           
	                       }
       		    	    }
       		    	    
       		    	    elsif ($preds[$k]=~ /AntiSense/)
       		    	    {
       		    		       if ($preds[$k]=~/$d(.*)$c/)
                         {
                         	chomp $preds[$k];
                         	$prediction=$1;
                         	$check1=substr($prediction,0,$y);
										      $check2=substr($prediction,-$x);
                   	       if ($kodikosy !~/$check1/ and $kodikosx !~/$check2/)
	                         { 
	                            	$flag++;
	                            	push(@finaloutput,"$flag.Record in Fastq: $preds[$k]\n$flag.Predicted Exon/Exon Extension/Intron Retention: $prediction\n\n");
	                              #print INTRON3 "Exon $revstarts[$i] --> Matching keyword:$d ~~~~~~~~~~ Exon $revends[$i] --> Matching keyword:$c\n";
       		    	                #print INTRON3 "$flag.Record in Fastq: $preds[$k]\n";
       		    	                #print INTRON3 "$flag.Predicted Exon/Exon Extension/Intron Retention: $prediction\n\n";
       		     	           }
       		    	          
	                       }
	                  }	
       	            
                 }
                 $augment=scalar(@finaloutput);
                 if ($augment<=0)
       		     	 { 	   
       	         }
       		     	 else            
       		     	 {
       		     	  print INTRON3 "Predicted $augment sequencing reads between exons: Exon $forstarts[$i] --> Matching keyword:(Sense:$a - Antisense:$d) ~~~~~ Exon $forends[$i] --> Matching keyword:(Sense:$b - Antisense:$c)\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
       		     	  print INTRON3 "@finaloutput";
       	          print INTRON3 "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n";
       	         } 
       	                     @finaloutput=();    
              }
              
       		    @exon_records='';
       		    @preds='';
       		 }
      }

       close INTRON3;
       print "Intron analysis is complete!\n";
}

elsif ($in1 =~ m/^[N]$/i)                                                                                                                                             
{                                                                                                                                                  
	print "Intron analysis was cancelled.\n";	                                                                                                                       
}

print "\n\n~~~~~~~~~~ RUN IS COMPLETE ~~~~~~~~~~\n";
################################################################################################################################################################# 
#Subroutine
sub round{

$any=$_[0];
$be=int($any);
$yn=$any-$be;
 if ($yn==0)
 {
	$fn=$any;
 }
 
 elsif ($yn<0.5)
 {
 	$fn=$be;
 }
 
 else 
 {
 	$fn=$be+1;
 }

 return $fn;
}
############################################################~~~ END ~~~##########################################################################################