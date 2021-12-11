lines = {}
for line in io.lines("day 9.txt") do
    lines[#lines + 1] = {}
    for i=1, #line do
        
        local len = #lines[#lines] + 1
        lines[#lines][len] = tonumber(line:sub(i,i))
    end
end
score_low = 0
low_points = {}
for i=1, #lines do
    for j=1, #lines[i] do
        local val = lines[i][j]
        if 
        (lines[i-1] == nil or lines[i-1][j] > val) and 
        (lines[i+1] == nil or lines[i+1][j] > val) and 
        (lines[i][j-1] == nil or lines[i][j-1] > val) and 
        (lines[i][j+1] == nil or lines[i][j+1] > val)
        then
            score_low = lines[i][j] + 1 + score_low
            low_points[#low_points + 1] = {i, j}
        end
    end
end
print(score_low)
basins = {}
for i, v in ipairs(low_points) do
    basins[i] = 0
    stack = {v}
    lines[v[1]][v[2]] = 9
    while #stack > 0 do
        curr_point = table.remove(stack)

        if 
        (
            lines[curr_point[1]-1] ~= nil and 
            lines[curr_point[1]-1][curr_point[2]] ~= nil and  
            lines[curr_point[1]-1][curr_point[2]] < 9
        ) then
            table.insert(stack, {curr_point[1]-1, curr_point[2]})
            lines[curr_point[1]-1][curr_point[2]] = 9
        end
        if 
        (
            lines[curr_point[1]+1] ~= nil and 
            lines[curr_point[1]+1][curr_point[2]] ~= nil and  
            lines[curr_point[1]+1][curr_point[2]] < 9
        ) then
            table.insert(stack, {curr_point[1]+1, curr_point[2]})
            lines[curr_point[1]+1][curr_point[2]] = 9
        end
        if 
        (
            lines[curr_point[1]][curr_point[2]-1] ~= nil and  
            lines[curr_point[1]][curr_point[2]-1] < 9
        ) then
            table.insert(stack, {curr_point[1], curr_point[2]-1})
            lines[curr_point[1]][curr_point[2]-1] = 9
        end
        if 
        (
            lines[curr_point[1]][curr_point[2]+1] ~= nil and  
            lines[curr_point[1]][curr_point[2]+1] < 9
        ) then
            table.insert(stack, {curr_point[1], curr_point[2]+1})
            lines[curr_point[1]][curr_point[2]+1] = 9
        end
        basins[i] = basins[i] + 1
    end
end

table.sort(basins)
print(basins[#basins] * basins[#basins - 1] * basins[#basins - 2])

