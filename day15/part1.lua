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
    return current_hash
end


-- tests the functions above
local file = 'problem.txt'
local lines = lines_from(file)

local splitted = mysplit(lines[1],',')
local total_hashes = 0
for k,str in pairs(splitted) do
    total_hashes = total_hashes + compute_hash(str)
end
print(total_hashes)