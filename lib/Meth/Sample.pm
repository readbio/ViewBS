package Meth::Sample;
use strict;
use warnings;
use File::Basename;
use FindBin;
use Pod::Usage;
use Cwd qw(abs_path);

my %rec_geno_len;
my $SAMPLELIST = "sample_list";
sub new{
    my $class     = shift;
    return bless {}, $class;  # built in bless function
}

sub processArgvSampleCoverage{
   my ($class, $opts_sub) = @_;
   my @sample = @{$opts_sub->{sample}};
   if(join("", @sample) !~ /file:/){
        foreach my $sam(@sample){
             my ($meth_file, $sam_name) = split(/,/, $sam);
             push @{$opts_sub -> {$SAMPLELIST}}, $sam;
        }
   }else{
        if(@sample > 1){
            print "Only one --sample should be provided if you use a TEXT file to provide the sample information.\n";
            exit 0;
        }else{
            $sample[0] =~s/file://;
            open SAM, $sample[0] or die "$!: $sample[0]";
            while( my $line = <SAM>){
                next if $line =~ /#/;
                print "$line";
                chomp $line;
                my ($meth_file, $sam_name) = split(/\s+/, $line);
                if(!$sam_name || !$meth_file){
                    print "Sample information file should contain at least two collumns (methylation file and sample name). Please provide the correct sample information file\n";
                    exit 1;
                }
                if(!-e $meth_file){
                    print "File $meth_file not detected. Please check the sample information.\n";
                    exit 1; 
                }
                push @{$opts_sub -> {$SAMPLELIST}}, "$meth_file,$sam_name";
            }
        }
   }
}

sub processArgvSampleGenome{
   my ($class, $opts_sub) = @_;
   my @sample = @{$opts_sub->{sample}};
   if(join("", @sample) !~ /file:/){
	foreach my $sam(@sample){
	     my ($meth_file, $sam_name) = split(/,/, $sam);
	     push @{$opts_sub -> {$SAMPLELIST}}, $sam;
        }
   }else{
	if(@sample > 1){
	    print "Only one --sample should be provided if you use a TEXT file to provide the sample information.\n";
	    exit 0;
        }else{
	    $sample[0] =~s/file://;
	    open SAM, $sample[0] or die "$!";
	    while( my $line = <SAM>){
		next if $line =~ /#/;
		print "$line";
		chomp $line;
		my ($meth_file, $sam_name) = split(/\s+/, $line);
		push @{$opts_sub -> {$SAMPLELIST}}, "$meth_file,$sam_name";
            }
	}
   }  
}

sub processArgvSampleOverRegion{
   my ($class, $opts_sub) = @_;
   my @sample = @{$opts_sub->{sample}};
   if(join("", @sample) !~ /file:/){
	my $region = $opts_sub -> {region};
        foreach my $sam(@sample){
             my ($meth_file, $sam_name) = split(/,/, $sam);
             push @{$opts_sub -> {$SAMPLELIST}}, "$meth_file,$sam_name,$region";
        }
   }else{
        if(@sample > 1){
            print "Only one --sample should be provided if you use a TEXT file to provide the sample information.\n";
            exit 0;
        }else{
            $sample[0] =~s/file://;
            open SAM, $sample[0] or die "$!";
            while( my $line = <SAM>){
                next if ($line =~ /^#/ || $line =~ /^\s*\n/);
                print "$line";
                chomp $line;
                my ($meth_file, $legend, $tem_region) = split(/\s+/, $line);
		my $region = ($tem_region) ? $tem_region: $opts_sub -> {region};
                push @{$opts_sub -> {$SAMPLELIST}}, "$meth_file,$legend,$region";
            }
        }
   }
}

sub processArgvSampleOverMid{
   my ($class, $opts_sub) = @_;
   my @sample = @{$opts_sub->{sample}};
   if(join("", @sample) !~ /file:/){
        my $region = $opts_sub -> {region};
        foreach my $sam(@sample){
             my ($meth_file, $sam_name) = split(/,/, $sam);
             push @{$opts_sub -> {$SAMPLELIST}}, "$meth_file,$sam_name,$region";
        }
   }else{
        if(@sample > 1){
            print "Only one --sample should be provided if you use a TEXT file to provide the sample information.\n";
            exit 1; # The only universally recognized values for EXPR are 0 for success and 1 for error;
        }else{
            $sample[0] =~s/file://;
            open SAM, $sample[0] or die "$!";
            while( my $line = <SAM>){
                next if $line =~ /#/;
                print "$line";
                chomp $line;
                my ($meth_file, $legend, $tem_region) = split(/\s+/, $line);
                my $region = ($tem_region) ? $tem_region: $opts_sub -> {region};
                push @{$opts_sub -> {$SAMPLELIST}}, "$meth_file,$legend,$region";
            }
        }
   }
}


sub processArgvSampleOneRegion{
   my ($class, $opts_sub) = @_;
   my @sample = @{$opts_sub->{sample}};
   if(join("", @sample) !~ /file:/){
        my $region = $opts_sub -> {region};
        foreach my $sam(@sample){
             my ($meth_file, $sam_name) = split(/,/, $sam);
             push @{$opts_sub -> {$SAMPLELIST}}, "$sam,$region";
        }
   }else{
        if(@sample > 1){
            print "Only one --sample should be provided if you use a TEXT file to provide the sample information.\n";
            #The only universally recognized values for EXPR are 0 for success and 1 for error; 
            exit 1; 
        }else{
            $sample[0] =~s/file://;
            open SAM, $sample[0] or die "$!";
            while( my $line = <SAM>){
                next if $line =~ /#/;
                print "$line";
                chomp $line;
                my ($meth_file, $legend) = split(/\s+/, $line);
                my $region = $opts_sub -> {region};
                push @{$opts_sub -> {$SAMPLELIST}}, "$meth_file,$legend,$region";
            }
        }
   }
}

1;

