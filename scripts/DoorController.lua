--[[
    DoorController.lua
    公交车门控制脚本
    
    放在 Bus Model 下面（和门同级）
    按 O 开门，按 C 关门
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local bus = script.Parent

-- 找到门（需要在巴士里有叫 FrontDoor 和 RearDoor 的 Part）
local frontDoor = bus:FindFirstChild("FrontDoor")
local rearDoor = bus:FindFirstChild("RearDoor")

-- ============ 参数设置 ============
local DOOR_OPEN_DISTANCE = 3    -- 门打开移动的距离
local DOOR_OPEN_TIME = 1        -- 开门动画时间（秒）
-- ==================================

-- 门的状态
local doorsOpen = false

-- 存储门的原始位置
local frontDoorClosed = frontDoor and frontDoor.CFrame
local rearDoorClosed = rearDoor and rearDoor.CFrame

-- 动画设置
local tweenInfo = TweenInfo.new(
    DOOR_OPEN_TIME,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

-- 开门函数
local function openDoors()
    if doorsOpen then return end
    doorsOpen = true
    print("🚪 开门")
    
    -- 前门
    if frontDoor then
        local openPos = frontDoorClosed * CFrame.new(DOOR_OPEN_DISTANCE, 0, 0)
        local tween = TweenService:Create(frontDoor, tweenInfo, {CFrame = openPos})
        tween:Play()
    end
    
    -- 后门
    if rearDoor then
        local openPos = rearDoorClosed * CFrame.new(DOOR_OPEN_DISTANCE, 0, 0)
        local tween = TweenService:Create(rearDoor, tweenInfo, {CFrame = openPos})
        tween:Play()
    end
end

-- 关门函数
local function closeDoors()
    if not doorsOpen then return end
    doorsOpen = false
    print("🚪 关门")
    
    -- 前门
    if frontDoor then
        local tween = TweenService:Create(frontDoor, tweenInfo, {CFrame = frontDoorClosed})
        tween:Play()
    end
    
    -- 后门
    if rearDoor then
        local tween = TweenService:Create(rearDoor, tweenInfo, {CFrame = rearDoorClosed})
        tween:Play()
    end
end

-- 键盘控制（这部分要放到 LocalScript 里，这里是示例）
--[[
    实际使用时，创建一个 LocalScript 放在 StarterPlayerScripts 里：
    
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    local OpenDoorsEvent = ReplicatedStorage:WaitForChild("OpenDoorsEvent")
    local CloseDoorsEvent = ReplicatedStorage:WaitForChild("CloseDoorsEvent")
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        if input.KeyCode == Enum.KeyCode.O then
            OpenDoorsEvent:FireServer()
        elseif input.KeyCode == Enum.KeyCode.C then
            CloseDoorsEvent:FireServer()
        end
    end)
]]

-- 提供接口给其他脚本调用
local DoorController = {
    open = openDoors,
    close = closeDoors,
    isOpen = function() return doorsOpen end
}

-- 如果有 RemoteEvent，监听它们
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local openEvent = ReplicatedStorage:FindFirstChild("OpenDoorsEvent")
local closeEvent = ReplicatedStorage:FindFirstChild("CloseDoorsEvent")

if openEvent then
    openEvent.OnServerEvent:Connect(openDoors)
end

if closeEvent then
    closeEvent.OnServerEvent:Connect(closeDoors)
end

print("✅ 车门控制脚本加载成功！")
print("🚪 按 O 开门，按 C 关门")

return DoorController
