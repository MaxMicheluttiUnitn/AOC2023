f = open("problem.txt", "r")
input_directives = Vector{String}()
input_items = Vector{String}()
found_empty = false
for line in readlines(f)
    if line == ""
        global found_empty = true
        continue
    end
    if found_empty
        push!(input_items, line)
    else
        push!(input_directives, line)
    end
end
close(f)

# PARSING ITEMS
mutable struct Item
    x :: Int
    m :: Int
    a :: Int
    s :: Int
end
my_items = Vector{Item}()
for line in input_items
    next_item = Item(0,0,0,0)
    chopped = chop(line, head = 1, tail = 1)
    tokens = split(chopped,",")
    for token in tokens
        name,value = split(token,"=")
        if name == "x"
            next_item.x = parse(Int,value)
        elseif name == "m"
            next_item.m = parse(Int,value)
        elseif name == "a"
            next_item.a = parse(Int,value)
        elseif name == "s"
            next_item.s = parse(Int,value)
        end
    end
    push!(my_items,next_item)
end

# PARSING DIRECTIVES
mutable struct Condition
    is_lower :: Bool
    value :: Int
    var_to_test :: String
end

mutable struct IfThenElse
    condition :: Condition
    then_value :: String
    else_branch :: Vector{IfThenElse}
    else_value :: String
end

function getCondition(condition_string)
    result = Condition(true,0,"")
    if occursin("<",condition_string)
        result.is_lower = true
        var,constant = split(condition_string,"<")
        result.var_to_test = var
        result.value = parse(Int,constant)
    else
        result.is_lower = false
        var,constant = split(condition_string,">")
        result.var_to_test = var
        result.value = parse(Int,constant)
    end
    return result
end

function getIfThenElse(stringa)
    condition,rest = split(stringa,":",limit=2)
    my_condition = getCondition(condition)
    then_item,else_item = split(rest,",",limit=2)
    else_vector = Vector{IfThenElse}()
    else_string = ""
    if occursin(":",else_item)
        push!(else_vector,getIfThenElse(else_item))
    else
        else_string = else_item
    end
    return IfThenElse(my_condition,then_item,else_vector,else_string)
end

directive_dict = Dict{String,IfThenElse}()
for line in input_directives
    directive_name,directive_info = split(line,"{")
    directive_info = chop(directive_info,tail = 1)
    directive_ite = getIfThenElse(directive_info)
    directive_dict[directive_name] = directive_ite
end

# FOR EACH ITEM SEE IF IT IS ACCEPTED OR NOT
function evaluate_condition(condition,item)
    # println(condition)
    # println(item)
    if condition.is_lower
        if condition.var_to_test == "x"
            return item.x < condition.value
        elseif condition.var_to_test == "m"
            return item.m < condition.value
        elseif condition.var_to_test == "a"
            return item.a < condition.value
        else
            return item.s < condition.value
        end
    else
        if condition.var_to_test == "x"
            return item.x > condition.value
        elseif condition.var_to_test == "m"
            return item.m > condition.value
        elseif condition.var_to_test == "a"
            return item.a > condition.value
        else
            return item.s > condition.value
        end
    end
end

function isNotFinal(directive)
    if directive == "A"
        return false
    elseif directive == "R"
        return false
    else
        return true
    end
end


sum_of_accepted_items=0
for item in my_items
    # println(item)
    current_directive = "in"
    while isNotFinal(current_directive)
        execute_directive = directive_dict[current_directive]
        execution_still_going = true
        # println(execute_directive)
        while execution_still_going
            if evaluate_condition(execute_directive.condition,item)
                execution_still_going = false
                current_directive = execute_directive.then_value
            else
                if isempty(execute_directive.else_branch)
                    execution_still_going = false
                    current_directive = execute_directive.else_value
                else
                    execute_directive = execute_directive.else_branch[1]
                end
            end
        end 
        # println(current_directive)
    end
    if current_directive == "A" # ACCEPT
        # println(item)
        global sum_of_accepted_items += item.x
        global sum_of_accepted_items += item.m
        global sum_of_accepted_items += item.a
        global sum_of_accepted_items += item.s
    end
end
println(sum_of_accepted_items)