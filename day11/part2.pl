
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

# print "Columns: ";
# for (my $i = 0; $i < $empty_columns_count; $i++){
#     print $empty_columns[$i];
#     print ", ";
# }
# print "\n";

#rows
my @empty_rows = ();
my $empty_rows_count = 0;
for (my $i = 0; $i < $rows; $i++){
    my $is_empty = 1;
    for (my $j = 0; $j < $rows; $j++){
        if($input[$i][$j] eq "#"){
            $is_empty = 0;
            last;
        }
    }
    if ($is_empty == 1){
        $empty_rows_count++;
        push (@empty_rows, $i)
    }
}

# print "Rows: ";
# for (my $i = 0; $i < $empty_rows_count; $i++){
#     print $empty_rows[$i];
#     print ", ";
# }
# print "\n";

# COMPTING STARS COORDS
my @star_coord = ();
my $stars = 0;
for (my $i = 0; $i < $rows; $i++){
    for (my $j = 0; $j < $rows; $j++){
        if($input[$i][$j] eq "#"){
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

my $expansion_value = 1000000;

my $sum_of_dist = 0;
for (my $i = 0; $i < $stars; $i++){
    for (my $j = $i+1; $j < $stars; $j++){
        my $manhattan_rows = 0;
        for (my $k = $star_coord[$i][0]; $k < $star_coord[$j][0]; $k++){
            if ( grep( /^$k$/, @empty_rows ) ) {
                $manhattan_rows = $manhattan_rows + $expansion_value;
            }else{
                $manhattan_rows = $manhattan_rows + 1;
            }
        }
        for (my $k = $star_coord[$j][0]; $k < $star_coord[$i][0]; $k++){
            if ( grep( /^$k$/, @empty_rows ) ) {
                $manhattan_rows = $manhattan_rows + $expansion_value;
            }else{
                $manhattan_rows = $manhattan_rows + 1;
            }
        }
        my $manhattan_columns = 0;
        for (my $k = $star_coord[$i][1]; $k < $star_coord[$j][1]; $k++){
            if ( grep( /^$k$/, @empty_columns ) ) {
                $manhattan_columns = $manhattan_columns + $expansion_value;
            }else{
                $manhattan_columns = $manhattan_columns + 1;
            }
        }
        for (my $k = $star_coord[$j][1]; $k < $star_coord[$i][1]; $k++){
            if ( grep( /^$k$/, @empty_columns ) ) {
                $manhattan_columns = $manhattan_columns + $expansion_value;
            }else{
                $manhattan_columns = $manhattan_columns + 1;
            }
        }
        my $manhattan_dist = $manhattan_rows + $manhattan_columns;
        # print $manhattan_dist;
        # print "\n";
        $sum_of_dist = $sum_of_dist + $manhattan_dist;
    }   
}

print $sum_of_dist;
print "\n";

close; 