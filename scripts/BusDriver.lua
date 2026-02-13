--[[
    BusDriver.lua
    公交车驾驶脚本
    
    放在 VehicleSeat 下面
    用 WASD 控制
]]

local seat = script.Parent

-- 找到车身（往上找 Model，然后找 PrimaryPart）
local bus = seat:FindFirstAncestorOfClass("Model")
local body = bus and (bus.PrimaryPart or bus:FindFirstChildWhichIsA("BasePart"))

if not body then
    warn("找不到车身！请设置 Model 的 PrimaryPart")
    return
end

print("✅ 巴士驾驶脚本加载成功！")
print("🚌 用 WASD 控制方向")

-- ============ 参数设置（可以修改！）============
local MAX_SPEED = 45        -- 最大速度，改大跑更快
local TURN_SPEED = 2        -- 转向速度，改大转更快
local BRAKE_POWER = 30000   -- 刹车力度
-- =============================================

-- 创建移动力
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
bodyVelocity.Velocity = Vector3.new(0, 0, 0)
bodyVelocity.Parent = body

-- 创建转向力
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
bodyGyro.P = 5000
bodyGyro.D = 500
bodyGyro.Parent = body

-- 当前角度
local currentAngle = 0

-- 每帧更新
game:GetService("RunService").Heartbeat:Connect(function(dt)
    if seat.Occupant then
        local throttle = seat.Throttle  -- W/S 键，-1 到 1
        local steer = seat.Steer        -- A/D 键，-1 到 1
        
        -- === 前进/后退 ===
        if throttle ~= 0 then
            bodyVelocity.MaxForce = Vector3.new(BRAKE_POWER, 0, BRAKE_POWER)
            local direction = body.CFrame.LookVector
            bodyVelocity.Velocity = direction * throttle * MAX_SPEED
        else
            -- 松开油门，慢慢停下
            bodyVelocity.MaxForce = Vector3.new(BRAKE_POWER, 0, BRAKE_POWER)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- === 转向 ===
        -- 只有在移动时才能转向（像真车一样）
        if math.abs(throttle) > 0.1 then
            currentAngle = currentAngle - steer * TURN_SPEED
            bodyGyro.MaxTorque = Vector3.new(0, 50000, 0)
            bodyGyro.CFrame = CFrame.Angles(0, math.rad(currentAngle), 0)
        else
            bodyGyro.MaxTorque = Vector3.new(0, 10000, 0)  -- 停车时轻微锁定方向
        end
        
    else
        -- 没人开车时，停止所有力
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
    end
end)

-- 玩家下车时的处理
seat:GetPropertyChangedSignal("Occupant"):Connect(function()
    if seat.Occupant then
        print("🚌 司机上车了！")
    else
        print("🚌 司机下车了")
        -- 重置速度
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)
