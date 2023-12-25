con = file("problem.txt", "r")
counter = 0
nodes <- list()
while ( TRUE ) {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
        break
    }
    if(counter==0){
        directions=line
    }
    if(counter>1){
        split_at_eq = strsplit(line,"=")
        internal_counter=0
        current_node<-list()
        for (p_item in split_at_eq){
            for (item in p_item){
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
        nodes[[length(nodes)+1]]<-current_node
    }
    counter = counter + 1
}
close(con)

lastChar <- function(x){
  substr(x, nchar(x), nchar(x))
}

finishInA <- function(x){
  lastChar(x)=="A"
}

finishInZ  <- function(x){
  lastChar(x)=="Z"
}

reachedZs <- function(locs){
    res=TRUE
    for (elem in locs){
        if(!finishInZ(elem)){
            res=FALSE
        }
    }
    return (res)
}

cycleOnce <- function(loc,cycle_pattern,nodi,locazioni){
    current = which(locazioni==loc)
    x <- strsplit(cycle_pattern, "")[[1]]
    for(dir in x){
        if(dir=="L"){
            next_loc=nodes[[current]][[2]]
        }else{
            next_loc=nodes[[current]][[3]]
        }
        current=which(locazioni==next_loc)
    }
    return (nodi[[current]][[1]])    
}

locations<-list()

counter=0
for (row in nodes){
    locations<-append(locations,row[[1]])
}

start_locations<-Filter(finishInA,locations)

moves=0
cycle_len=nchar(directions)

good_indexes_paths<-list()
loop_indexes_path<-list()
paths<-list()

for(loc in start_locations){
    path<-list()
    good_ids<-list()
    loop_id=0
    counter=1
    path<-append(path,loc)
    next_loc = loc
    while(loop_id==0){
        counter=counter+1
        next_loc = cycleOnce(next_loc,directions,nodes,locations)
        if(next_loc %in% path){
            loop_id=which(path==next_loc)
        }else{
            path<-append(path,next_loc)
            if(finishInZ(next_loc)){
                good_ids<-append(good_ids,counter)
            }
        }
    }
    good_indexes_paths[[length(good_indexes_paths)+1]]<-good_ids
    paths[[length(paths)+1]]<-path
    loop_indexes_path<-append(loop_indexes_path,loop_id)
}

length_paths<-list()
length_loop_paths<-list()

for (id in {1:length(paths)}){
    length_paths[[id]]<-length(paths[[id]])
    length_loop_paths[[id]]<-(length_paths[[id]]-loop_indexes_path[[id]]+1)
}

# print(directions)

# print(paths)

# print(good_indexes_paths)

# print(loop_indexes_path)

# print(length_paths)

# print(length_loop_paths)

# quit()

current_alpha=good_indexes_paths[[1]][[1]]-1 
current_beta=length_loop_paths[[1]]

simulateNextCollision <- function(alpha1,beta1,alpha2,beta2){
    values1<-list()
    values2<-list()
    values1[[1]]=alpha1
    values2[[1]]=alpha2
    current1=alpha1
    current2=alpha2
    first_collision=0
    collider=0
    while(collider==0){
        # print("V1")
        # print(values1)
        # print("V2")
        # print(values2)
        if(current1 %in% values2){
            collider=1
            break
        }else if(current2 %in% values1){
            collider=2
            break
        }
        current1 = current1 + beta1;
        current2 = current2 + beta2;
        values1<-append(values1,current1)
        values2<-append(values2,current2)
        first_collision=first_collision+1
    }
    # print(collider)
    if (collider==1){
        return (alpha1 + (beta1 * first_collision))
    }else{
        return (alpha2 + (beta2 * first_collision))
    }
}

simulateNextCollisionNew <- function(alpha1,beta1,alpha2,beta2){
    alpha=alpha1-alpha2
    if (alpha==0){
        return (alpha1);
    }
    count = 0
    current = beta1*count + alpha
    while(current%%beta2!=0){
        current = beta1*count + alpha
        count = count + 1
    }
    return (current+alpha2)
}

findGCD <- function(a, b) {
  # If the second number is 0, return the first number
  if(b == 0) {
    return(a)
  } else {
    return(findGCD(b, a %% b))  # Recursion with reduced values
  }
}

gcd <- function(x,y){
    return (findGCD(x,y))
}

lcm <- function(x, y) {
# choose the greater number
    xy = x*y
    res=xy/gcd(x,y)
    return(res)
}

# for(id in {2:length(paths)}){
#     print("Iteration number")
#     print(id)
#     current_alpha=simulateNextCollision(current_alpha,current_beta,good_indexes_paths[[id]][[1]]-1,length_loop_paths[[id]])
#     current_beta=lcm(current_beta,length_loop_paths[[id]])
#     print(current_alpha)
#     print(current_beta)
# }

# print(current_alpha)


# SOLUTION IS CUSTOM FOR SPECIFIC CASE
current_alpha = good_indexes_paths[[1]][[1]]-1
print(current_alpha)
for(id in {2:length(paths)}){
    current_alpha=lcm(current_alpha,good_indexes_paths[[id]][[1]]-1)
    print(current_alpha)
}

print(cycle_len)

print(current_alpha*cycle_len)