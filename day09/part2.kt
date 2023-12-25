package aoc2023

import java.util.ArrayList
import java.io.File
import java.io.BufferedReader

class Problem(var sequences:ArrayList<Sequence> ){
    fun from_file(filename: String)= File(filename).forEachLine {
        var line_list=ArrayList<Int>();
        var split_line = it.split(" ");
        for(line in split_line){
            line_list.add(Integer.parseInt(line))
        }
        sequences.add(Sequence(line_list));
    }

    fun print(){
        for(line in this.sequences){
            print(line);
            print("\n");
        }
    }

    fun push(s:Sequence){
        this.sequences.add(s);
    }

    fun get_sequence(index:Int) : Sequence{
        return this.sequences.get(index)
    }

    fun get_len() : Int{
        return this.sequences.size
    }

    fun get_last() : Sequence{
        return this.sequences.get(this.sequences.size-1)
    }
}

class Sequence(var items:ArrayList<Int>){
    fun get_len() : Int{
        return this.items.size
    }

    fun print(){
        print("[")
        for(item in this.items){
            print(item);
            print(" ");
        }
        print("]")
    }

    fun push(item: Int){
        this.items.add(item);
    }

    fun differentiate() : Sequence{
        var i = 1
        var result = Sequence(ArrayList<Int>())
        while (i < this.get_len()) {
            result.push(this.items[i]-this.items[i-1])
            i++
        }
        return result;
    }

    fun is_zeros():Boolean{
        for (item in this.items){
            if(item!=0){
                return false;
            }
        }
        return true;
    }

    fun get_last():Int{
        return this.items.get(this.items.size-1)
    }

    fun get_first():Int{
        return this.items.get(0)
    }
}

fun main(args: Array<String>) {
    var p = Problem(ArrayList<Sequence>());
    p.from_file("problem.txt");
    var answer = 0;

    
    var i=0
    while(i < p.get_len()){
        var source = p.get_sequence(i);
        i++;
        var j=1
        var differentials = Problem(ArrayList<Sequence>())
        differentials.push(source);
        while(j < source.get_len()){
            j++;
            differentials.push(differentials.get_last().differentiate())
            if(differentials.get_last().is_zeros()){
                break;
            }
        }
        if (!differentials.get_last().is_zeros()){
            print("problem");
            print("\n");
        }else{
            var prediction=0
            j=differentials.get_len() - 1
            while(j >= 0){
                val first_of_line = differentials.get_sequence(j).get_first();
                prediction = first_of_line - prediction;
                j--;
            }
            answer += prediction;
            print(prediction);
            print("\n");
        }
    }
    print("Final answer is :")
    print(answer);
    print("\n");
}