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

bool containsHash(String source){
    return source.contains('#');
}

class StringWrapper{
    String item;
    StringWrapper(this.item){}
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

    void unfold(){
        String copy_data = this.records_data;
        for (var i = 0; i < 4; i++) {
            this.records_data = this.records_data + "?" + copy_data;
        }
        this.sequences = [this.sequences,this.sequences,this.sequences,this.sequences,this.sequences].expand((x) => x).toList();
    }

    void print_it(){
        print(this.records_data);
        for(final e in this.sequences){
            print(e);
        }
    }

    int countHashes(int index){
        int res = 0;
        for(var j=0; j<index && j<this.records_data.length; j++){
            if(this.records_data[j] == "#"){
                res++;
            }
        }
        return res;
    }

    int count_possibilities(){
        return this.dp_possibilities();
    }

    int dp_possibilities(){
        /*
            This function is an adaptation of William Y.Feng
            solution from YouTube:

            https://youtu.be/veJvlIMjv94?si=cVDivOvyIhXsn-rR

            All credits for the algorithm idea go to him
        */
        this.records_data = "." + this.records_data + ".";
        this.sequences.add(0);
        int max_run = 0;
        for(int i=0; i<this.sequences.length;i++){
            if(max_run<this.sequences[i]+1){
                max_run = this.sequences[i]+1;
            }
        }
        int n = this.records_data.length;
        int m = this.sequences.length;

        var dp = new List.generate(n, (_) => 
                new List.generate(m, (_) => 
                    new List.filled(max_run, 0), 
                    growable: false), 
                growable: false);

        for(var i=0;i<n;i++){
            String x = this.records_data[i];
            for(var j=0;j<m;j++){
                for(var k=0; k<this.sequences[j]+1; k++){
                    if(i==0){
                        if(j!=0){
                            dp[i][j][k]=0;
                        }
                        else if(x=="#"){
                            if(k!=1){
                                dp[i][j][k]=0;
                            }else{
                                dp[i][j][k]=1;
                            }
                        }else if(x=="."){
                            if(k!=0){
                                dp[i][j][k]=0;
                            }else{
                                dp[i][j][k]=1;
                            }
                        }else if(x=="?"){
                            if(k>1){
                                dp[i][j][k]=0;
                            }else{
                                dp[i][j][k]=1;
                            }
                        }else{
                            print(x);
                        }
                    }else{
                    
                        int answer_dot = 0;

                        if(k!=0){
                            answer_dot = 0;
                        }else if(j>0){
                            // k is 0
                            answer_dot = dp[i-1][j-1][this.sequences[j-1]] + dp[i-1][j][0];
                        }else{
                            if(this.countHashes(i)==0){
                                answer_dot = 1;
                            }else{
                                answer_dot = 0;
                            }
                        }

                        int answer_pound = 0;
                        if(k==0){
                            answer_pound = 0;
                        }else{
                            answer_pound = dp[i-1][j][k-1];
                        }

                        if(x=="."){
                            dp[i][j][k] = answer_dot;
                        }else if(x=="#"){
                            dp[i][j][k] = answer_pound;
                        }else{
                            dp[i][j][k] = answer_pound + answer_dot;
                        }
                    }
                }
            }   
        }
        return dp[n-1][m-1][0];
    }

    int recursive_data_transform_and_check(StringWrapper data, List<int> residual, bool is_hashing, int hashes_left){
        // print(data.item);
        // print(residual);
        if(hashes_left<0 || data.item.length < (hashes_left+residual.length-1)){
            return 0;
        }
        if(data.item.length==0){
            if(residual.length==0 || (residual.length==1 && residual[0]==0)){
                return 1;
            }
            return 0;
        }
        if(data.item[0]=="#"){
            is_hashing = true;
            hashes_left -= 1;
            if(residual.length==0)
                return 0;
            if(residual[0]>0){
                residual[0]=residual[0]-1;
                data.item = data.item.substring(1);
                return this.recursive_data_transform_and_check(data,residual,is_hashing,hashes_left);
            }else{
                return 0;
            }
        }else if(data.item[0]=="."){
            if(residual.length>0 && residual[0]==0 && is_hashing){
                residual.removeAt(0);
                is_hashing = false;
            }
            if(residual.length>0 && residual[0]>0 && is_hashing){
                return 0;
            }
            data.item = data.item.substring(1);
            return this.recursive_data_transform_and_check(data,residual,is_hashing,hashes_left);
        }else{
            
            data.item = data.item.substring(1);
            StringWrapper left = new StringWrapper("#"+data.item);
            StringWrapper right = new StringWrapper("."+data.item);
            return this.recursive_data_transform_and_check(left,new List.from(residual),is_hashing,hashes_left) + this.recursive_data_transform_and_check(right,new List.from(residual),is_hashing,hashes_left);
        }
    }
}

void part2() {
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
    int id = 0;
    for(final record in input){
        record.unfold();
        id = id + 1;
        int possible = record.count_possibilities();
        print("Id: $id  Possible: $possible");
        sum = sum + possible;
    }
    return sum;
}