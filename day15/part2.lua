-- see if the file exists
function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end

-- split the string --
function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

-- computes the hash of the string --
function compute_hash(str)
    local current_hash = 0
    for i = 1, #str do
        local ascii_value = string.byte(str:sub(i,i),1)
        current_hash = current_hash + ascii_value
        current_hash = current_hash * 17
        current_hash = current_hash % 256
    end    
    return current_hash + 1
end


-- tests the functions above
local file = 'problem.txt'
local lines = lines_from(file)

local operations = mysplit(lines[1],',')
local hash_map = {}
for i = 1,256,1 
do 
   hash_map[i]={}
end
for _k,str in pairs(operations) do
    if string.find(str, "=") then
        -- update operation --
        local key_val = mysplit(str,'=')
        local key = key_val[1]
        local value = key_val[2]
        local new_value = true
        local hash_value = compute_hash(key)
        if next(hash_map[hash_value]) == nil then
            hash_map[hash_value][1] = key
            hash_map[hash_value][2] = value
        end
        for i = 1,#hash_map[hash_value]-1,2 do
            if hash_map[hash_value][i] == key then    
                new_value = false
                hash_map[hash_value][i+1] = value
            end
        end
        if new_value then
            hash_map[hash_value][#hash_map[hash_value]+1] = key
            hash_map[hash_value][#hash_map[hash_value]+1] = value
        end
        -- print("HASH MAP AT HASH "..hash_value.." IS")
        -- for i = 1,#hash_map[hash_value],1 do
        --     print(hash_map[hash_value][i])   
        -- end
    else
        if string.find(str, "-") then
            -- deletion operation --
            local key_val = mysplit(str,'-')
            local key = key_val[1]
            local hash_value = compute_hash(key)
            local appearence = 0
            for i = 1,#hash_map[hash_value]-1,2 do
                if hash_map[hash_value][i] == key then    
                    appearence = i
                end
            end
            if appearence~=0 then
                for i = appearence+2,#hash_map[hash_value],1 do
                    hash_map[hash_value][i-2]=hash_map[hash_value][i]
                end
                table.remove(hash_map[hash_value],#hash_map[hash_value])
                table.remove(hash_map[hash_value],#hash_map[hash_value])
            end
            -- print("HASH MAP AT HASH "..hash_value.." IS")
            -- for i = 1,#hash_map[hash_value],1 do
            --     print(hash_map[hash_value][i])   
            -- end
        else    
            print ("Error")
        end
    end
end

local total_lens_power = 0;
for i = 1,#hash_map,1 do 
    for j = 1,#hash_map[i]-1,2 do
        local name = hash_map[i][j]
        local box = i - 1
        local position = (j+1) // 2
        local focal_length = hash_map[i][j+1]

        local lens_power = (box + 1) * position * focal_length
        -- print("Lens: "..name.." Box: "..box.." Position: "..position.." Focal Len: "..focal_length.." --> "..lens_power)

        total_lens_power = total_lens_power + lens_power
    end
end

print(total_lens_power)

