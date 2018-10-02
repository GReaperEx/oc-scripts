local robot = require("robot")

local xpos = {}
local xPosition = { x = 0, y = 0, z = 0 }
local xFacing = 0
local xPolicy = 0

xpos.getPosition = function()
    return xPosition.x, xPosition.y, xPosition.z
end

xpos.getFacing = function()
    return xFacing
end

xpos.getFacingS = function()
    local descr = {
        [0] = "north",
        [1] = "west",
        [2] = "south",
        [3] = "east"
    }
    return descr[xFacing]
end

xpos.getPolicy = function()
    return xPolicy
end

xpos.setPolicy = function(newPolicy)
    newPolicy = newPolicy or 0
    if type(newPolicy) ~= "number" or newPolicy < 0 then
        newPolicy = 0
    elseif newPolicy >= 2 then
        newPolicy = 1;
    end
    xPolicy = newPolicy
end

xpos.getPolicyS = function()
    local descr = {
        [0] = "wait",
        [1] = "swing"
    }
    return descr[xPolicy]
end

xpos.setPolicyS = function(newPolicyS)
    newPolicyS = newPolicyS or "w"
    local descrMap = {
        ["w"] = 0,
        ["wait"] = 0,
        ["s"] = 1,
        ["swing"] = 1
    }
    
    xpos.setPolicy(descrMap[string.lower(newPolicyS)])
end

xpos.forward = function()
    local moves = {
        [0] = { 0, -1 },
        [1] = { -1, 0 },
        [2] = { 0, 1 },
        [3] = { 1, 0 }
    }
    local actions = {
        [0] = function() os.sleep(1) end,
        [1] = function() robot.swing(); os.sleep(1) end
    }

    while not robot.forward() do
        actions[xPolicy]()
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
    local actions = {
        [0] = function() os.sleep(1) end,
        [1] = function() robot.turnAround(); robot.swing(); robot.turnAround(); os.sleep(1) end
    }

    while not robot.back() do
        actions[xPolicy]()
    end
    
    xPosition.x = xPosition.x + moves[xFacing][1]
    xPosition.z = xPosition.z + moves[xFacing][2]
end

xpos.up = function()
    local actions = {
        [0] = function() os.sleep(1) end,
        [1] = function() robot.swingUp(); os.sleep(1) end
    }
    
    while not robot.up() do
        actions[xPolicy]()
    end

    xPosition.y = xPosition.y + 1
end

xpos.down = function()
    local actions = {
        [0] = function() os.sleep(1) end,
        [1] = function() robot.swingDown(); os.sleep(1) end
    }
    
    while not robot.down() do
        actions[xPolicy]()
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

xpos.turnAround = function()
    robot.turnAround()

    xFacing = (xFacing + 2) % 4
end

return xpos

