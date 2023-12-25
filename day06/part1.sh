#!/bin/bash

# computes the score of the race
# compute_result TIME_HELD MAX_TIME
compute_result_output=0
function compute_result() {
    if [ $# -eq 2 ];
    then
        time_to_run=$(($2-$1))
        compute_result_output=$(($1*$time_to_run))
    else
        echo "Incorrect # of args for compute_results()"
    fi
}

# PARSING INPUT
linecounter=0
while read line; 
do
    tokens=$(echo $line | tr ";" "\n")
    counter=-1
    for tok in $tokens
    do
        if [ $counter -eq -1 ];
        then
            ((counter++))
        else
            num=$(($tok))
            if [ $linecounter -eq 0 ];
            then
                timing[$counter]=$num
            else
                best_result[$counter]=$num
            fi
            ((counter++))
        fi
    done
    ((linecounter++))
done

# SOLVING ROBLEM
total_good_results=1
i=0
j=0
for (( ; ; )); 
do
    if [ $i -eq $counter ];
    then
        break
    fi
    ith_good_results=0
    j=0
    for (( ; ; )); 
    do
        exitval=${timing[$i]} 
        if [ $j -eq $exitval ];
        then
            break
        fi
        compute_result $j ${timing[$i]}
        if [ $compute_result_output -gt ${best_result[$i]} ];
        then
            ((ith_good_results++))
        fi
        ((j++))
    done
    total_good_results=$(($ith_good_results*$total_good_results))
    ((i++))
done

# OUTPUT
echo "Result is: ${total_good_results}"