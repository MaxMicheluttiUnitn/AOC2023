con = file("problem.txt", "r")
counter = 0
nodes <- list()
while ( TRUE ) {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
        break
    }
    print(line)
    if(counter==0){
        directions=line
    }
    if(counter>1){
        split_at_eq = strsplit(line,"=")
        internal_counter=0
        current_node<-list()
        for (p_item in split_at_eq){
            for (item in p_item){
                print(item)
                if(internal_counter==0){
                    current_node<-append(current_node,trimws(item))
                }else{
                    split_at_comma = strsplit(item,",")
                    more_internal_counter = 0
                    for (p_comma_item in split_at_comma){
                        for(comma_item in p_comma_item){
                            if (more_internal_counter==0){
                                split_at_parenthesis=strsplit(comma_item,"[(]")
                                more_and_more_internal_counter=0
                                for (p_par_item in split_at_parenthesis){
                                    for(par_item in p_par_item){
                                        if(more_and_more_internal_counter>0){
                                            current_node<-append(current_node,par_item)
                                        }
                                        more_and_more_internal_counter=more_and_more_internal_counter+1
                                    }
                                }
                            }else{
                                split_at_parenthesis=strsplit(comma_item,"[)]")
                                more_and_more_internal_counter=0
                                for (p_par_item in split_at_parenthesis){
                                    for(par_item in p_par_item){
                                        if(more_and_more_internal_counter==0){
                                            current_node<-append(current_node,trimws(par_item))
                                        }
                                        more_and_more_internal_counter=more_and_more_internal_counter+1
                                    }   
                                }
                            }
                            more_internal_counter = more_internal_counter + 1
                        }
                    }
                }
                internal_counter = internal_counter + 1
            }
        }
        nodes<-append(nodes,current_node)
    }
    counter = counter + 1
}
close(con)


# print(directions)

# for (row in nodes){
#     print(row)
# }

current_location="AAA"
end_location="ZZZ"
moves=0

while(current_location!=end_location){
    x <- strsplit(directions, "")[[1]]
    for(dir in x){
        print(dir)
        moves=moves+1
        index=0
        counter=0
        for (row in nodes){
            counter=counter+1
            if ((counter%%3)==1){
                if(row==current_location){
                    index=counter
                    break
                }
            }
        }
        if(index==0){
            print("error location reached")
            break
        }
        print(nodes[[index]])
        if(dir=="L"){
            current_location=nodes[[index+1]]
        }else{
            current_location=nodes[[index+2]]
        }
    }
}

print(moves)