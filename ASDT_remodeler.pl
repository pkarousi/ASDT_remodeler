#COMMAND: perl ASDT_remodeler.pl 3.Exons_1.txt ASDT_output_folder_name

#! user/bin/perl -w

print "Enter the name of the output folder:\n";

while ($f= <STDIN>) 
	{
		chomp $f;
	
    if (-d $f) 
			{
        print "Folder '$f' already exists... Overwrite its contents(Y/N)?";
        
        while ($ow= <STDIN>) 
					{
						chomp $ow;
        
           if ($ow =~ m/^[Y]$/i)
						{
							$loc = "./$f";
							mkdir $loc unless -d $loc;                                                                               
							print "Folder '$f' is overwrited.\n\n";
							last; 
						}
            
					elsif ($ow =~ m/^[N]$/i)
						{                                                                               
							print "\nSelect another name for the folder.\n";
							$f= <STDIN>;
							chomp $f;
							if (-d $f)
								{
              		print "Folder '$f' already exists... Overwrite its contents(Y/N)?";
								}
						else
							{
								$loc = "./$f";
								mkdir $loc unless -d $loc;                                                                                 
								print "Folder '$f' created.\n\n";
								last;
							}   
						}
            
     			else
      			{	                                                                                                                                               
							print "\nInvalid command...Overwrite contents(Y/N)?";                                                          
      			}
					}
					last;                                                                                                                                                  
			} 
      	
 
    else 
    	{
    		$loc = "./$f";
   			mkdir $loc unless -d $loc;                                                                                
   			print "Folder '$f' created.\n\n";
    		last;  
    	}
	}

use Data::Dumper qw(Dumper);

%letters=('\(1\)'=>'k', '\(2\)'=>'l', '\(3\)'=>'m', '\(4\)'=>'n', '\(5\)'=>'o', '\(6\)'=>'p', '\(7\)'=>'q','\(8\)'=>'r', '\(9\)'=>'s', '10'=> 'ten', '11'=>'eleven', '12'=>'twelve', '13'=>'thirteen','14'=>'fourteen', '15'=>'fifteen'); #used to make proper replacements.
%numbers= ('one'=>'1', 'two'=>'2', 'three'=>'3', 'four'=>'4', 'five'=>'5', 'six'=>'6', 'seven'=>'7', 'eight'=>'8', 'nine'=>'9');
%numblet= reverse %numbers;

$file1=$ARGV[0]; #input file for hash. This file is made manually by modifying 3.Exons.txt
$file7='3.Exons_v3.txt';
$infold=$ARGV[1];
open (INPUT1, "<$file1") || die "Couldn't open $file1\n";
open (OUTPUT1, ">", $file7);

while ($line2=<INPUT1>)
	
	{
	@rename = split(/\t/, $line2);
		
	$rename[2]=~s/$_/$letters{$_}/g for keys %letters;
	$rename[3]=~s/$_/$numblet{$_}/g for keys %numblet;
		
	print OUTPUT1 "$rename[0]\t$rename[1]\t$rename[2]\t$rename[3]\t$rename[4]";
	}
	
close INPUT1;
close OUTPUT1;

open (IN, "<$file7") || die "Couldn't open $file7\n";

while ($k=<IN>)	

	{
	
	if ($k=~/\w+\t\w+\t(.*)\t(.*)\t\w+/)
		{ 
		@exons{$1}=$2;
		}
	}
	
#print Dumper \%exons; #--> checks that hash has been created.

close IN;
unlink $file7; 


$file5='8.Unique_Reads.txt';
$file6='8.Unique_reads_v1.txt';

open (INPUT4, "<$infold/$file5") || die "Couldn't open $file5\n";
open (OUTPUT4, ">", "$loc/$file6");

while (<INPUT4>) #substitutes '<--->' where possible

	{
		
	for ($i=20; $i>0; $i--) 
		
	{
		$_=~s/$i<--->$i/$i/g;
			
	}
		for ($k=20; $k>0; $k--)	
		{
					
			for ($j=10; $j>0; $j--)	
			{
						
			$_=~s/-$k\($j\)<--->$k\($j\)-/-$k\($j\)-/g;	
			$_=~s/-$k\($j\)<--->$k\($j\),$k\(\d\)-/-$k\($j\)-/g;	
			$_=~s/-$k\($j\),[$k\(\d\),]{0,}<--->$k\($j\)-/-$k\($j\)-/g;	
			$_=~s/-[$k\(\d\),]{0,}$k\($j\)<--->[$k\(\d\),]{0,}$k\($j\)-/-$k\($j\)-/g;	
			$_=~s/-[$k\(\d\),]{0,}$k\($j\)[,$k\(\d\)]{0,}<--->$k\($j\)-/-$k\($j\)-/g;
			$_=~s/-$k\($j\)<--->[$k\(\d\),]{0,}$k\($j\)[,$k\(\d\)]{0,}/-$k\($j\)/g;
			}
			
		}
	$_=~s/\,/\//g;	
	print OUTPUT4 $_;

	}
	
close INPUT4;
close OUTPUT4;
	
$file2='9.Combined_Splice_Junctions.txt';
$file3='9.Combined_Splice_Junctions_v1.txt';

open (INPUT2, "<$infold/$file2") || die "Couldn't open $file2\n";
open (OUTPUT2, ">", "$loc/$file3");

while (<INPUT2>) #substitutes '<--->' where possible
	{
		
	for ($i=20; $i>0; $i--) 
		
	{
	$_=~s/$i<--->$i/$i/g;
		
	}
		
	for ($k=20; $k>0; $k--)	
	{	
		for ($j=10; $j>0; $j--)
			{
						
			$_=~s/-$k\($j\)<--->$k\($j\)-/-$k\($j\)-/g;	
			$_=~s/-$k\($j\)<--->$k\($j\),$k\(\d\)-/-$k\($j\)-/g;	
			$_=~s/-$k\($j\),[$k\(\d\),]{0,}<--->$k\($j\)-/-$k\($j\)-/g;	
			$_=~s/-[$k\(\d\),]{0,}$k\($j\)<--->[$k\(\d\),]{0,}$k\($j\)-/-$k\($j\)-/g;	
			$_=~s/-[$k\(\d\),]{0,}$k\($j\)[,$k\(\d\)]{0,}<--->$k\($j\)-/-$k\($j\)-/g;
			$_=~s/-$k\($j\)<--->[$k\(\d\),]{0,}$k\($j\)[,$k\(\d\)]{0,}/-$k\($j\)/g;
			}
	}
		
$_=~s/\,/\//g;
print OUTPUT2 $_;
	}
	
close INPUT2;
close OUTPUT2;


$file4='9.Combined_Splice_Junctions_v1_2.txt'; #renames exons using hash from file 3.

open (INPUT3, "<", "$loc/$file3") || die "Couldn't open $file3\n";
open (OUTPUT3, ">", "$loc/$file4");

while ($line=<INPUT3>) 
	
	{ 
	@array_com_splices = split(/\t/, $line);#creates array with splices and freq
	$array_com_splices[0]=~s/$_/$letters{$_}/g for keys %letters;#changes values only in splices
	$array_com_splices[0]=~s/$_/$exons{$_}/g for keys %exons;
	$array_com_splices[0]=~s/$_/$numbers{$_}/g for keys %numbers;
		
	print OUTPUT3 "$array_com_splices[0]\t$array_com_splices[1]";#creates new file
	}
	
close INPUT3;
close OUTPUT3;

unlink "$loc/$file3"; 

$file8= '7.Single_Splice_Junctions.txt ';
$file9='7.Single Splice Junctions_v2.txt'; 

open (INPUT5, "<$infold/$file8") || die "Couldn't open $file8\n";
open (OUTPUT5, ">", "$loc/$file9");

while ($line3=<INPUT5>) #renames exons using hash from file 3.
	
	{ 	
	
	$line3=~s/\,/\//g;
	@array_splices = split(/\t/, $line3); #creates array with splices and freq
	$array_splices[0]=~s/$_/$letters{$_}/g for keys %letters; #changes values only in splices
	$array_splices[0]=~s/$_/$exons{$_}/g for keys %exons;
	$array_splices[0]=~s/$_/$numbers{$_}/g for keys %numbers;
		
	print OUTPUT5 "$array_splices[0]\t$array_splices[1]"; #creates new file
	
	}
close INPUT5;
close OUTPUT5;

$file22='8.Unique_reads_v2.txt';

open (INPUT6, "<", "$loc/$file6") || die "Couldn't open $file6\n";
open (OUTPUT6, ">", "$loc/$file22");

while ($line4=<INPUT6>) #renames exons using hash from file 3.
	
	{
	@array_unique_reads = split(/\t/, $line4);
		
	$array_unique_reads[1]=~s/$_/$letters{$_}/g for keys %letters;
	$array_unique_reads[1]=~s/$_/$exons{$_}/g for keys %exons;
	$array_unique_reads[1]=~s/$_/$numbers{$_}/g for keys %numbers;
		
	print OUTPUT6 "$array_unique_reads[0]\t$array_unique_reads[1]\t$array_unique_reads[2]\t$array_unique_reads[3]";
	}
	
close INPUT6;
close OUTPUT6;

unlink "$loc/$file6";

$filex='13.Circular_reads.txt'; 
$filey='14.Non_circular_reads.txt';

open (INPUTX, "<", "$loc/$file22");
open (OUTPUTX, ">", "$loc/$filex");
open (OUTPUTY, ">", "$loc/$filey");

while ($line8=<INPUTX>) #selects unique reads starting and ending on the same exon

	{
		@a=split(/\t/, $line8);
		@b=split('-', $a[1]);

		$position= index("$b[-1]", "$b[0]");
		$position1= index("$b[0]", "$b[-1]");
				
		if ($position>=0)
		{
		$line8=~s/$b[-1]/$b[0]/;
		print OUTPUTX $line8;
		}
				
		elsif ($position1>=0)
		{ 
		$line8=~s/$b[0]/$b[-1]/;
		print OUTPUTX $line8;
		}
		
		else
		{
		print OUTPUTY $line8;
		}
	
	}

close INPUTX;
close OUTPUTX;
close OUTPUTY;


$file18='9.Combined_Splice_Junctions_v1_3_selected.txt';
$file19='9.Combined_Splice_Junctions_v1_3_nonselected.txt';

open (INPUT7, "<", "$loc/$file4") || die "Couldn't open $file4\n";
open (OUTPUT7, ">>", "$loc/$file18");
open (OUTPUT8, ">>", "$loc/$file19");

$firstline=<INPUT7>;

print OUTPUT8 $firstline;
print OUTPUT7 $firstline;

while (<INPUT7>) #select lines not containing arrows.

	{ 
	
		if ($_!~m/<--->/)
		{
		print OUTPUT7 $_;
		}
		
		else
		{ 
		print OUTPUT8 $_;
		}
		
	}	
	
close INPUT7;
close OUTPUT7;
close OUTPUT8;

unlink "$loc/$file4";

$file10='6.Annotated_Transcripts.txt';
$file11='6.Annotated_Transcripts_v2.txt';

open (INPUT8, "<", "$infold/$file10") || die "Couldn't open $file10\n";
open (OUTPUT9, ">", "$loc/$file11");

while ($line5=<INPUT8>) #renames exons using hash from file 3.

	{
	@annoated_transcripts = split(/\t/, $line5);
		
	$annoated_transcripts[1]=~s/$_/$letters{$_}/g for keys %letters;
	$annoated_transcripts[1]=~s/$_/$exons{$_}/g for keys %exons;
	$annoated_transcripts[1]=~s/$_/$numbers{$_}/g for keys %numbers;
		
	print OUTPUT9 "$annoated_transcripts[0]\t$annoated_transcripts[1]";
	}
	
close INPUT8;
close OUTPUT9;
	
$file12='4.Keywords.txt';
$file13='4.Keywords_v2.txt';

open (INPUT9, "<", "$infold/$file12") || die "Couldn't open $file12\n";
open (OUTPUT10, ">", "$loc/$file13");

while ($line6=<INPUT9>) #renames exons using hash from file 3.

	{
		
	$line6=~s/\,/\//g;
	@keywords = split(/\t/, $line6);
	
	$keywords[1]=~s/$_/$letters{$_}/g for keys %letters;
	$keywords[1]=~s/$_/$exons{$_}/g for keys %exons;
	$keywords[1]=~s/$_/$numbers{$_}/g for keys %numbers;
		
	$keywords[2]=~s/$_/$letters{$_}/g for keys %letters;
	$keywords[2]=~s/$_/$exons{$_}/g for keys %exons;
	$keywords[2]=~s/$_/$numbers{$_}/g for keys %numbers;
	
	print OUTPUT10 "$keywords[0]\t$keywords[1]-$keywords[2]\t$keywords[3]";;
	
	}
	
close INPUT9;
close OUTPUT10;

$file14='5.All_reads.txt';
$file15='5.All_reads_v2.txt'; 

open (INPUT10, "<", "$infold/$file14") || die "Couldn't open $file14\n";
open (OUTPUT11, ">", "$loc/$file15");

while ($line7=<INPUT10>) #renames exons using hash from file 3.
 
	{
		
	$line7=~s/\,/\//g;
		
	@all_reads = split(/\t/, $line7);
		
	$all_reads[2]=~s/$_/$letters{$_}/g for keys %letters;
	$all_reads[2]=~s/$_/$exons{$_}/g for keys %exons;
	$all_reads[2]=~s/$_/$numbers{$_}/g for keys %numbers;
		
	$all_reads[3]=~s/$_/$letters{$_}/g for keys %letters;
	$all_reads[3]=~s/$_/$exons{$_}/g for keys %exons;
	$all_reads[3]=~s/$_/$numbers{$_}/g for keys %numbers;
		
	print OUTPUT11 "$all_reads[0]\t$all_reads[1]\t$all_reads[2]-$all_reads[3]\t$all_reads[4]\t$all_reads[5]";
		
	}
	
close INPUT10;
close OUTPUT11;

$file16="10.Selected_circular_combinations.txt";
$file24="9.Combined_Splice_Junctions_v2_selected.txt";

open (INPUT11, "<", "$loc/$file18") || die "Couldn't open $file18\n";
open (OUTPUT12, ">", "$loc/$file16");
open (OUTPUT16, ">", "$loc/$file24");

while ($line8=<INPUT11>) #selects lines without arrows starting and ending on the same exon.

	{
		
	@a=split(/\t/, $line8);
	@b=split('-', $a[0]);

	$position= index("$b[-1]", "$b[0]");
	$position1= index("$b[0]", "$b[-1]");
				
		if ($position>=0)
		
		{
		$line8=~s/$b[-1]/$b[0]/;
		print OUTPUT12 $line8;
		}
				
		elsif ($position1>=0)
		
		{ 
		$line8=~s/$b[0]/$b[-1]/;
		print OUTPUT12 $line8;
		}
	
		else 
		
		{
		print OUTPUT16 $line8;
		}
	}

close INPUT11;
close OUTPUT12;
close OUTPUT16;

unlink  "$loc/$file18";

$file17="11.Nonselected_circular_combinations.txt";
$file23="9.Combined_Splice_Junctions_v2_nonselected.txt";

open (INPUT12, "<", "$loc/$file19") || die "Couldn't open $file19\n";
open (OUTPUT13, ">", "$loc/$file17");
open (OUTPUT17, ">", "$loc/$file23");

while ($line9=<INPUT12>) #selects lines with arrows starting and ending on the same exon.

	{
	@c = split(/\t/, $line9);
	@d=split('-', $c[0]);

	$position2= index("$d[-1]", "$d[0]");
	$position3= index("$d[0]", "$d[-1]");
		
		
	if ($position2>=0)
	
		{
		$line9=~s/$d[-1]/$d[0]/;
		print OUTPUT13 $line9;
		}
				
	elsif ($position3>=0)
	
		{ 
		$line9=~s/$d[0]/$d[-1]/;
		print OUTPUT13 $line9;
		}
		
	else 
	
		{
		print OUTPUT17 $line9;
		}
	}

close INPUT12;
close OUTPUT13;
close OUTPUT17;

unlink "$loc/$file19";

$file20='12.Circular_single_exon_combinations.txt';

open (INPUT13, "<", "$loc/$file9") || die "Couldn't open $file9\n";
open (OUTPUT14, ">", "$loc/$file20");

while (<INPUT13>) #selects single splice junctions starting and ending on the same exon.

	{
		
	@e=split(/\t/, $_);
	@f=split('-', $e[0]);

	$position4= index("$f[-1]", "$f[0]");
	$position5= index("$f[0]", "$f[-1]");
		
		
	if ($position4>=0)
	
		{			
		print OUTPUT14 $_;
		}
				
	elsif ($position5>=0)
	
		{ 			
		print OUTPUT14 $_;
		}
				
	}

close INPUT13;
close OUTPUT14;