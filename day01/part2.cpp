#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int strlen(const char * str){
    int i = 0;
    while(str[i]!='\0')
        i++;
    return i;
}

std::pair<int,int> contains_substring(const char* str, const char* sub){
    std::pair<int,int> res = std::pair<int,int>(-1,-1);
    int str_len = strlen(str);
    int sub_len = strlen(sub);
    for(int str_id=0;str_id<str_len;str_id++){
        if(str[str_id] == sub[0] && (str_len-str_id>=sub_len)){
            bool match = true;
            for(int other_str_id = 0; (other_str_id < str_len - str_id) && (other_str_id < sub_len); other_str_id++){
                if(str[other_str_id+str_id] != sub[other_str_id]){
                    match = false;
                    break;
                }
            }
            if(match){
                if(res.first == -1)
                    res.first = str_id;
                res.second = str_id;
            }
        }
    }
    return res;
}

int main(){
    ifstream in("part1.txt");
    int total_calibration = 0;
    int i = 0;
    while(!in.eof()){
        int first_of_line = 0;
        int last_of_line = 0;
        int first_of_line_pos = 500;
        int last_of_line_pos = -1;
        bool first_found = false;
        char buffer[500];
        in>>buffer;
        buffer[499] = '\0';
        for(int str_id=0;str_id<500 && buffer[str_id]!='\0';str_id++){
            if (buffer[str_id] >= '0' && buffer[str_id] <= '9'){
                if(!first_found){
                    first_found = true;
                    first_of_line = buffer[str_id] - '0';
                    first_of_line_pos = str_id;
                }
                last_of_line = buffer[str_id] - '0';
                last_of_line_pos = str_id;
            }
        }
        string matches[9] = {"one","two","three","four","five","six","seven","eight","nine"};
        for(int j = 1; j <= 9; j++){
            int index = j-1;
            std::pair<int,int> jth_res = contains_substring(buffer,matches[index].c_str());
            if((jth_res.first >= 0) && jth_res.first < first_of_line_pos){
                first_of_line_pos = jth_res.first;
                first_of_line = j;
            }
            if((jth_res.second >= 0) &&jth_res.second > last_of_line_pos){
                last_of_line_pos = jth_res.second;
                last_of_line = j;
            }
        }
        cout<<"Calibration for line "<<i+1<<" is "<<first_of_line*10+last_of_line<<endl;
        i++;
        total_calibration+=first_of_line*10+last_of_line;
    }
    in.close();
    cout<<"Sum of calibrations is: "<<total_calibration<<endl;
    return 0;
}

