#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main(){
    ifstream in("part1.txt");
    int total_calibration = 0;
    int i = 0;
    while(!in.eof()){
        int first_of_line = 0;
        int last_of_line = 0;
        bool first_found = false;
        string str;
        in>>str;
        for(auto it =str.begin();it!=str.end();it++){
            if ((*it) >= '0' && (*it) <= '9'){
                if(!first_found){
                    first_found = true;
                    first_of_line = (*it) - '0';
                }
                last_of_line = (*it) - '0';
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