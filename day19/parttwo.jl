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

# PERFORM RANGE COMPIUTATION
mutable struct Range
    start_index :: Int
    end_index :: Int
end

mutable struct ItemRange
    x :: Range
    m :: Range
    a :: Range
    s :: Range
end

function is_range_valid(r)
    if r.x.start_index > r.x.end_index
        return false
    elseif r.m.start_index > r.m.end_index
        return false
    elseif r.m.start_index > r.m.end_index
        return false
    elseif r.m.start_index > r.m.end_index
        return false
    else
        return true
    end
end

function clone_range(r)
    return ItemRange(
        Range(r.x.start_index,r.x.end_index),
        Range(r.m.start_index,r.m.end_index),
        Range(r.a.start_index,r.a.end_index),
        Range(r.s.start_index,r.s.end_index))
end

function split_condition_true(condition,item_range)
    # println(condition)
    # println(item)
    cloned_range = clone_range(item_range)
    if condition.is_lower
        if condition.var_to_test == "x"
            cloned_range.x.end_index = condition.value -1
        elseif condition.var_to_test == "m"
            cloned_range.m.end_index = condition.value - 1
        elseif condition.var_to_test == "a"
            cloned_range.a.end_index = condition.value - 1
        else
            cloned_range.s.end_index = condition.value - 1
        end
    else
        if condition.var_to_test == "x"
            cloned_range.x.start_index = condition.value + 1
        elseif condition.var_to_test == "m"
            cloned_range.m.start_index = condition.value + 1
        elseif condition.var_to_test == "a"
            cloned_range.a.start_index = condition.value + 1
        else
            cloned_range.s.start_index = condition.value + 1
        end
    end
    return cloned_range
end

function split_condition_false(condition,item_range)
    # println(condition)
    # println(item)
    cloned_range = clone_range(item_range)
    if condition.is_lower
        if condition.var_to_test == "x"
            cloned_range.x.start_index = condition.value
        elseif condition.var_to_test == "m"
            cloned_range.m.start_index = condition.value
        elseif condition.var_to_test == "a"
            cloned_range.a.start_index = condition.value
        else
            cloned_range.s.start_index = condition.value
        end
    else
        if condition.var_to_test == "x"
            cloned_range.x.end_index = condition.value
        elseif condition.var_to_test == "m"
            cloned_range.m.end_index = condition.value
        elseif condition.var_to_test == "a"
            cloned_range.a.end_index = condition.value
        else
            cloned_range.s.end_index = condition.value
        end
    end
    return cloned_range
end

function range_product(r)
    prod::Int64 = 1
    if is_range_valid(r)
        var_x_size = r.x.end_index - r.x.start_index + 1 
        var_m_size = r.m.end_index - r.m.start_index + 1 
        var_a_size = r.a.end_index - r.a.start_index + 1 
        var_s_size = r.s.end_index - r.s.start_index + 1 
        return prod * var_x_size * var_m_size * var_a_size * var_s_size
    else
        return prod - 1
    end
end

function rangeVisit(current_directive, current_range)
    # println(current_directive)
    if current_directive == "A"
        # println(current_range)
        # println(range_product(current_range))
        return range_product(current_range)
    elseif current_directive == "R"
        return 0
    end
    execute_directive = directive_dict[current_directive]
    execution_still_going = true
    current_value::Int64 = 0
    # println(execute_directive)
    while execution_still_going
        # println(execute_directive.condition)
        # println(current_range)
        true_range = split_condition_true(execute_directive.condition, current_range)
        # println(true_range)
        false_range = split_condition_false(execute_directive.condition, current_range)
        # println(false_range)
        if is_range_valid(true_range)
            current_value = current_value + rangeVisit(execute_directive.then_value, true_range)
        end
        if is_range_valid(false_range)
            if isempty(execute_directive.else_branch)
                execution_still_going = false
                current_value = current_value + rangeVisit(execute_directive.else_value, false_range)
            else
                execute_directive = execute_directive.else_branch[1]
                current_range = false_range
            end
        else
            execution_still_going = false
        end
    end 
    return current_value
end

sum_of_accepted_ranges::Int64=rangeVisit("in", ItemRange(Range(1,4000),Range(1,4000),Range(1,4000),Range(1,4000)))

println(sum_of_accepted_ranges)