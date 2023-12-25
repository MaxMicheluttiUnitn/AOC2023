#include "stdio.h"
#include "stdlib.h"
#include "string.h"

typedef struct{
    int x;
    int y;
    int value;
} LocatedNum;

typedef struct LinkedList{
    LocatedNum data;
    struct LinkedList* next;
} LinkedList_t;

void print_list(LinkedList_t* l){
    if(l==NULL){
        printf("\n");
    }else{
        printf("[%d,%d] ",l->data.x,l->data.y);
        print_list(l->next);
    }
}

int accumulate_vals(LinkedList_t* t){
    if(t==NULL)
        return 0;
    return t->data.value + accumulate_vals(t->next);
}

void append(LinkedList_t* l, int x,int y, int value){
    if(l->next == NULL){
        l->next = malloc(sizeof(LinkedList_t));
        (l->next)->data.x = x;
        (l->next)->data.y = y;
        (l->next)->data.value = value;
        (l->next)->next = NULL;
    }else{
        append(l->next,x,y,value);
    }
}

int contains(LinkedList_t* l, int x,int y){
    if(l==NULL)
        return 0;
    if(l->data.x==x && l->data.y==y)
        return 1;
    return contains(l->next,x,y);
}

typedef struct{
    char ** input;
    int size;
} Problem;

Problem get_input(char * filename){
    Problem error = {NULL, 0};
    FILE* file = fopen(filename,"r");
    if(file == NULL)
        return error;
    char* buffer = malloc(sizeof(char)*200);
    char ** engine_matrix = NULL;
    fscanf(file,"%s",buffer);
    int line_len = strlen(buffer);
    engine_matrix = malloc(line_len*sizeof(char*));
    for(int i=0;i<line_len;i++)
        engine_matrix[i] = malloc(line_len*sizeof(char));
    strcpy(engine_matrix[0],buffer);
    int line_count = 1;
    while(!feof(file)){
        fscanf(file,"%s",buffer);
        strcpy(engine_matrix[line_count++],buffer);
    }
    // for(int i=0;i<line_len;i++){
    //     printf("%s\n",engine_matrix[i]);
    // }
    fclose(file);
    Problem success = {engine_matrix,line_len}; 
    return success;
}

int is_symbol(char c){
    if(c>='0' && c<= '9')
        return 0;
    if(c=='.')
        return 0;
    return 1;
}

int is_digit(char c){
    if(c>='0' && c<= '9')
        return 1;
    return 0;
}

int parse_num(int x,int y,Problem p){
    int res = p.input[x][y]-'0';
    y++;
    while(y<p.size && is_digit(p.input[x][y])){
        res *= 10;
        res += p.input[x][y]-'0';
        y++;
    }
    return res;
}

LocatedNum get_start(int x,int y,Problem p){
    while(y>0 && is_digit(p.input[x][y-1]))
        y--;
    LocatedNum res = {x,y,parse_num(x,y,p)};
    return  res;
}

void solve_problem(Problem p){
    LinkedList_t* list = NULL;
    for(int i=0; i<p.size;i++){
        for(int j=0;j<p.size;j++){
            if(is_symbol(p.input[i][j]) == 1){
                for(int x=-1;x<2;x++){
                    if((i+x)<0 || (i+x) >= p.size)
                        continue;
                    for(int y=-1;y<2;y++){
                        if((j+y)<0 || (j+y) >= p.size)
                            continue;
                        if(is_digit(p.input[i+x][j+y])){
                            LocatedNum num = get_start(i+x,j+y,p);
                            // printf("%d [%d, %d]\n",num.value,num.x,num.y);
                            if(list == NULL){
                                list = malloc(sizeof(LinkedList_t));
                                list->data.x = num.x;
                                list->data.y = num.y;
                                list->data.value = num.value;
                                list->next = NULL;
                            }else{
                                if(contains(list,num.x,num.y)==0)
                                    append(list,num.x,num.y,num.value);
                            }
                        }
                    }
                }
            }
        }
    }
    int sum = accumulate_vals(list);
    printf("%d\n",sum);
}

int main(int argc,char** argv){
    Problem problem = get_input("problem.txt");
    solve_problem(problem);
    return 0;
}