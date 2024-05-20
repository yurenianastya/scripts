local blocks = {
    {{1, 1, 1, 1}}, -- I
    {{1, 1}, {1, 1}}, -- O
    {{1, 1, 1}, {0, 1, 0}}, -- T
    {{1, 1, 0}, {0, 1, 1}}, -- S
}

local grid = {}
local blockSize = 30
local gridWidth = 10
local gridHeight = 20
local currentBlock
local currentX, currentY
local fallSpeed = 1
local fallTimer = 0
local clearAnimation = {}
local sounds = {
    move = love.audio.newSource("move.mp3", "static"),
    rotate = love.audio.newSource("rotate.mp3", "static"),
    clear = love.audio.newSource("clear.mp3", "static")
}

function love.load()
    love.window.setMode(gridWidth * blockSize, gridHeight * blockSize)
    resetGame()
end

function resetGame()
    grid = {}
    for y = 1, gridHeight do
        grid[y] = {}
        for x = 1, gridWidth do
            grid[y][x] = 0
        end
    end
    spawnBlock()
end

function spawnBlock()
    currentBlock = blocks[love.math.random(#blocks)]
    currentX = math.floor(gridWidth / 2) - 1
    currentY = 0
end

function love.update(dt)
    fallTimer = fallTimer + dt
    for _, anim in ipairs(clearAnimation) do
        anim.timer = anim.timer + dt
    end
    clearAnimation = filter(clearAnimation, function(anim)
        return anim.timer < 0.5
    end)
    if fallTimer > fallSpeed then
        fallTimer = 0
        if not moveBlock(0, 1) then
            placeBlock()
            clearLines()
            spawnBlock()
            if not isPositionValid(currentBlock, currentX, currentY) then
                resetGame()
            end
        end
    end
end

function love.keypressed(key)
    if key == "left" then
        if moveBlock(-1, 0) then love.audio.play(sounds.move) end
    elseif key == "right" then
        if moveBlock(1, 0) then love.audio.play(sounds.move) end
    elseif key == "down" then
        if moveBlock(0, 1) then love.audio.play(sounds.move) end
    elseif key == "up" then
        rotateBlock()
        love.audio.play(sounds.rotate)
    elseif key == "s" then
        saveGame()
    elseif key == "l" then
        loadGame()
    end
end

function moveBlock(dx, dy)
    if isPositionValid(currentBlock, currentX + dx, currentY + dy) then
        currentX = currentX + dx
        currentY = currentY + dy
        return true
    end
    return false
end

function rotateBlock()
    local rotatedBlock = {}
    for x = 1, #currentBlock[1] do
        rotatedBlock[x] = {}
        for y = 1, #currentBlock do
            rotatedBlock[x][y] = currentBlock[#currentBlock - y + 1][x]
        end
    end
    if isPositionValid(rotatedBlock, currentX, currentY) then
        currentBlock = rotatedBlock
    end
end

function isPositionValid(block, posX, posY)
    for y = 1, #block do
        for x = 1, #block[y] do
            if block[y][x] ~= 0 then
                local newX = posX + x
                local newY = posY + y
                if newX < 1 or newX > gridWidth or newY < 1 or newY > gridHeight or grid[newY] and grid[newY][newX] ~= 0 then
                    return false
                end
            end
        end
    end
    return true
end

function placeBlock()
    for y = 1, #currentBlock do
        for x = 1, #currentBlock[y] do
            if currentBlock[y][x] ~= 0 then
                grid[currentY + y][currentX + x] = currentBlock[y][x]
            end
        end
    end
end

function clearLines()
    for y = gridHeight, 1, -1 do
        local fullLine = true
        for x = 1, gridWidth do
            if grid[y][x] == 0 then
                fullLine = false
                break
            end
        end
        if fullLine then
            table.insert(clearAnimation, {line = y, timer = 0})
            for removeY = y, 2, -1 do
                grid[removeY] = grid[removeY - 1]
            end
            grid[1] = {}
            for x = 1, gridWidth do
                grid[1][x] = 0
            end
        end
    end
    if #clearAnimation > 0 then
        love.audio.play(sounds.clear)
    end
end

function love.draw()
    for y = 1, gridHeight do
        for x = 1, gridWidth do
            if grid[y][x] ~= 0 then
                love.graphics.rectangle("fill", (x - 1) * blockSize, (y - 1) * blockSize, blockSize, blockSize)
            end
        end
    end

    for y = 1, #currentBlock do
        for x = 1, #currentBlock[y] do
            if currentBlock[y][x] ~= 0 then
                love.graphics.rectangle("fill", (currentX + x - 1) * blockSize, (currentY + y - 1) * blockSize, blockSize, blockSize)
            end
        end
    end

    for _, anim in ipairs(clearAnimation) do
        local alpha = 1 - anim.timer / 0.5
        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.rectangle("fill", 0, (anim.line - 1) * blockSize, gridWidth * blockSize, blockSize)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function saveGame()
    local saveData = {
        grid = grid,
        currentBlock = currentBlock,
        currentX = currentX,
        currentY = currentY,
        fallTimer = fallTimer
    }
    love.filesystem.write("savegame.lua", table.show(saveData, "savedata"))
end

function loadGame()
    local file = love.filesystem.load("savegame.lua")
    if file then
        file()
        grid = savedata.grid
        currentBlock = savedata.currentBlock
        currentX = savedata.currentX
        currentY = savedata.currentY
        fallTimer = savedata.fallTimer
    end
end

function table.show(t, name, indent)
    local cart     -- a container
    local autoref  -- for self references

    local function isemptytable(t) return next(t) == nil end

    local function basicSerialize (o)
      local so = tostring(o)
      if type(o) == "function" then
        local info = debug.getinfo(o, "S")
        -- info.name is nil because o is not a calling level
        if info.what == "C" then
          return string.format("%q", so .. ", C function")
        else 
          -- the information is defined through lines
          return string.format("%q", so .. ", defined in (" ..
              info.linedefined .. "-" .. info.lastlinedefined ..
              ")" .. info.source)
        end
      elseif type(o) == "number" or type(o) == "boolean" then
        return so
      else
        return string.format("%q", so)
      end
    end

    local function addtocart (value, name, indent, saved, field)
      indent = indent or ""
      saved = saved or {}
      field = field or name

      cart = cart .. indent .. field

      if type(value) ~= "table" then
        cart = cart .. " = " .. basicSerialize(value) .. ";\n"
      else
        if saved[value] then
          cart = cart .. " = {}; -- " .. saved[value] 
                      .. " (self reference)\n"
          autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
        else
          saved[value] = name
          -- If this is an empty table, simply add it and return
          if isemptytable(value) then
            cart = cart .. " = {};\n"
          else
            cart = cart .. " = {\n"
            for k, v in pairs(value) do
              k = basicSerialize(k)
              local fname = string.format("%s[%s]", name, k)
              field = string.format("[%s]", k)
              -- three spaces between levels
              addtocart(v, fname, indent .. "   ", saved, field)
            end
            cart = cart .. indent .. "};\n"
          end
        end
      end
    end

    name = name or "__unnamed__"
    if type(t) ~= "table" then
      return name .. " = " .. basicSerialize(t)
    end
    cart, autoref = "", ""
    addtocart(t, name, indent)
    return cart .. autoref
end

function filter(t, func)
    local newTable = {}
    for i, v in ipairs(t) do
        if func(v) then
            table.insert(newTable, v)
        end
    end
    return newTable
end
