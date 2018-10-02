local robot = require("robot")

local xpos = {}
local xPosition = { x = 0, y = 0, z = 0 }
local xFacing = 0

xpos.getPosition = function()
    return xPosition.x, xPosition.y, xPosition.z
end

xpos.getFacing = function()
    return xFacing
end

xpos.getFacingS = function()
    local dirs = {
        [0] = "north",
        [1] = "west",
        [2] = "south",
        [3] = "east"
    }
    return dirs[xFacing]
end

xpos.forward = function()
    local moves = {
        [0] = { 0, -1 },
        [1] = { -1, 0 },
        [2] = { 0, 1 },
        [3] = { 1, 0 }
    }

    while not robot.forward() do
        os.sleep(1)
    end
    
    xPosition.x = xPosition.x + moves[xFacing][1]
    xPosition.z = xPosition.z + moves[xFacing][2]
end

xpos.back = function()
    local moves = {
        [0] = { 0, 1 },
        [1] = { 1, 0 },
        [2] = { 0, -1 },
        [3] = { -1, 0 }
    }

    while not robot.back() do
        os.sleep(1)
    end
    
    xPosition.x = xPosition.x + moves[xFacing][1]
    xPosition.z = xPosition.z + moves[xFacing][2]
end

xpos.up = function()
    while not robot.up() do
        os.sleep(1)
    end

    xPosition.y = xPosition.y + 1
end

xpos.down = function()
    while not robot.down() do
        os.sleep(1)
    end

    xPosition.y = xPosition.y - 1
end

xpos.turnLeft = function()
    robot.turnLeft()

    xFacing = (xFacing + 1) % 4
end

xpos.turnRight = function()
    robot.turnRight()

    xFacing = (xFacing + 3) % 4
end

return xpos

