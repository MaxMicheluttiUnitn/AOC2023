import 'dart:async';
import 'dart:io';
import 'dart:collection';

String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
}

bool areListsEqual(var list1, var list2) {
    // check if both are lists
    if(!(list1 is List && list2 is List)
        // check if both have same length
        || list1.length!=list2.length) {
        return false;
    }
     
    // check if elements are equal
    for(int i=0;i<list1.length;i++) {
        if(list1[i]!=list2[i]) {
            return false;
        }
    }
     
    return true;
}


bool containsQuestionMark(String source){
    return source.contains('?');
}

int firstInstanceOfQuestionMark(String source){
    return source.indexOf('?');
}

bool is_good_sequence(String sequence,List<int> seq){
    // print(sequence);
    List<int> actual_seq = <int>[];
    bool counting_hash = false;
    int hash_counter = 0;
    while(sequence!=""){
        if(counting_hash && sequence[0]=="#"){
            hash_counter = hash_counter + 1;
        }else if(counting_hash && sequence[0]!="#"){
            actual_seq.add(hash_counter);
            hash_counter = 0;
            counting_hash = false;
        }else if(!counting_hash && sequence[0]=="#"){
            counting_hash = true;
            hash_counter = 1;
        }else{

        }
        sequence = sequence.substring(1);
    }
    if(counting_hash){
        actual_seq.add(hash_counter);
    }
    return areListsEqual(seq,actual_seq);
}

class SpringRecord{
    String records_data = "";
    List<int> sequences = <int>[];

    SpringRecord(String line){
        List<String> parts = line.split(' ');
        this.records_data = parts[0];
        List<String> numbers = parts[1].split(',');
        for(final n in numbers){
            this.sequences.add(int.parse(n));
        }
    }

    void print_it(){
        print(this.records_data);
        for(final e in this.sequences){
            print(e);
        }
    }

    int count_possibilities(){
        return this.recursive_data_transform_and_check(this.records_data);
    }

    int recursive_data_transform_and_check(String data){
        if(containsQuestionMark(data)){
            int question_mark_index = firstInstanceOfQuestionMark(data);
            String left = replaceCharAt(data,question_mark_index,".");
            String right = replaceCharAt(data,question_mark_index,"#");
            return this.recursive_data_transform_and_check(right) + this.recursive_data_transform_and_check(left);
        }else{
            if(is_good_sequence(data,this.sequences)){
                return 1;
            }else{
                return 0;
            }
        }
    }
}

void part1() {
  File('problem.txt').readAsString().then((String contents) {
    List<String> lines = contents.split('\n');
    List<SpringRecord> input = <SpringRecord>[];
    for(final line in lines){
        input.add(new SpringRecord(line));
    }
    int result = solve_part1(input);
    print("Result is $result");
  });
}

int solve_part1(List<SpringRecord> input){
    int sum = 0;
    for(final record in input){
        // record.print_it();
        sum = sum + record.count_possibilities();
    }
    return sum;
}