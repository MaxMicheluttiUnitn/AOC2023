#!/usr/bin/perl 

# define Strings

# Modules used 
use strict; 
use warnings; 

# Opening the file  
open(FH, "problem.txt") or die "File can't be opened"; 

# Reading the file till FH reaches EOF 
my @input = ();
my $rows = 0;
while(<FH>) 
{ 
    chop($_);
    my @list = split // , $_ ;
    push (@input, \@list);
    $rows = $rows + 1;
}

# EXPANDING UNIVERSE
# column
my @empty_columns = ();
my $empty_columns_count = 0;
for (my $i = 0; $i < $rows; $i++){
    my $is_empty = 1;
    for (my $j = 0; $j < $rows; $j++){
        if($input[$j][$i] eq "#"){
            $is_empty = 0;
            last;
        }
    }
    if ($is_empty == 1){
        $empty_columns_count++;
        push (@empty_columns, $i)
    }
}
my @expanded_universe_columns = ();
my $expanded_columns = $rows + $empty_columns_count;
for (my $i = 0; $i < $rows; $i++){
    my $expansion_index = 0;
    my @expanded_line = ();
    for (my $j = 0; $j < $rows; $j++){
        if(($expansion_index < $empty_columns_count) && ($j == $empty_columns[$expansion_index])){
            $expansion_index++;
            push (@expanded_line, $input[$i][$j]);
            $j--;
        }else{
            push (@expanded_line, $input[$i][$j]);
        }
    }
    push (@expanded_universe_columns, \@expanded_line);
}

#rows
my @empty_rows = ();
my $empty_rows_count = 0;
for (my $i = 0; $i < $rows; $i++){
    my $is_empty = 1;
    for (my $j = 0; $j < $expanded_columns; $j++){
        if($expanded_universe_columns[$i][$j] eq "#"){
            $is_empty = 0;
            last;
        }
    }
    if ($is_empty == 1){
        $empty_rows_count++;
        push (@empty_rows, $i)
    }
}

my @expanded_universe = ();
my $expanded_rows = $rows + $empty_rows_count;
my $expansion_index = 0;
for (my $i = 0; $i < $rows; $i++){
    my @expanded_line = ();
    for (my $j = 0; $j < $expanded_columns; $j++){   
        push (@expanded_line, $expanded_universe_columns[$i][$j]);
    }
    push (@expanded_universe, \@expanded_line);
    if(($expansion_index < $empty_rows_count) && ($i == $empty_rows[$expansion_index])){
        $expansion_index++;
        $i--;
    }
}

# for (my $i = 0; $i < $expanded_rows; $i++){
#     for (my $j = 0; $j < $expanded_columns; $j++){
#         print $expanded_universe[$i][$j];
#     }
#     print "\n";
# }


my @star_coord = ();
my $stars = 0;
for (my $i = 0; $i < $expanded_rows; $i++){
    for (my $j = 0; $j < $expanded_columns; $j++){
        if($expanded_universe[$i][$j] eq "#"){
            my @coord = ($i, $j);
            push (@star_coord, \@coord);
            $stars++;
        }
    }
}

# for (my $i = 0; $i < $stars; $i++){
#     print $star_coord[$i][0];
#     print ", ";
#     print $star_coord[$i][1];
#     print "\n";
# }

my $sum_of_dist = 0;
for (my $i = 0; $i < $stars; $i++){
    for (my $j = $i+1; $j < $stars; $j++){
        my $manhattan_dist = abs($star_coord[$i][0]-$star_coord[$j][0]) + abs($star_coord[$i][1]-$star_coord[$j][1]);
        # print $manhattan_dist;
        # print "\n";
        $sum_of_dist = $sum_of_dist + $manhattan_dist;
    }   
}

print $sum_of_dist;
print "\n";



my @expanded = ();
close; 