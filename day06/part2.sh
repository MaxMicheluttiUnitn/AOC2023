#!/bin/bash

# computes the race distance by pressing the button for TIME_HELD milliseconds
# when given a time limit of MAX_TIME milliseconds for the race
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

# computes the square root of N
# sqrt N
sqrt_res=0
function sqrt(){
    float_to_int $(bc <<< "scale=0; sqrt($1)")
    sqrt_res=$float_to_int_res
}

# converts float to integer
# float_to_int FLOAT
float_to_int_res=0
function float_to_int() { 
  float_to_int_res=$(printf '%.0f' "$1")
}

# computes the advantage from the best_distance by pressing the button T seconds
# f_of_t T
f_of_t_res=0
function f_of_t(){
   if [ $# -eq 1 ];
    then
        x=$1
        minus_x_sq=$(($x*$x*-1))
        alpha_x=$(($timing*$x))
        minus_beta=$(($best_result*-1))
        f_of_t_res=$(($minus_x_sq+$alpha_x+$minus_beta))
    else
        echo "Incorrect # of args for f_of_t()"
    fi 
}

# PARSING INPUT
linecounter=0
timing=""
best_result=""
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
            if [ $linecounter -eq 0 ];
            then
                timing+=$tok
            else
                best_result+=$tok
            fi
            ((counter++))
        fi
    done
    ((linecounter++))
done
timing=$(($timing))
best_result=$(($best_result))

# t = TIME the button is held
# F(t) = -(t * t) + (timing * t) - best_result
# when F is positive, I win the race
# F is positive when
# x1 < t < x2
# where x1 and x2 are the zeros of F
# since F is a second degree function I can compute
# T = timing
# X = best_result
# x1 = [ T + sqrt( T * T - 4 * X ) ] / 2
# x2 = [ T - sqrt( T * T - 4 * X ) ] / 2
# so I win in [ x1 - x2 + 1 ] cases

# COMPUTING x1
delta=$(($timing*$timing-4*$best_result))
sqrt $delta
double_x1=$(($sqrt_res+$timing))
x1=$(($double_x1/2))

# If F(x1) is 0, shift by 1
f_of_t $x1
if [ $f_of_t_res -le 0 ];
then
    ((x1--))
fi

# COMPUTING x2
double_x2=$(($timing-$sqrt_res))
x2=$(($double_x2/2))

# If F(x2) is 0, shift by 1
f_of_t $x2
if [ $f_of_t_res -le 0 ];
then
    ((x2++))
fi

# result is size of gap between F's zeros
total_good_results=$(($x1-$x2+1))

# OUTPUT
echo "Result is: ${total_good_results}"