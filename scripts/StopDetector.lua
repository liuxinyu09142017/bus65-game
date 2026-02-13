--[[
    StopDetector.lua
    公交站到站检测脚本
    
    放在 BusStop Model 里的 StopZone (透明 Part) 下面
    
    StopZone 设置：
    - Transparency = 1 (完全透明)
    - CanCollide = false (不阻挡)
    - Size = 大概 15, 5, 20 (能覆盖停车区域)
]]

local stopZone = script.Parent
local busStop = stopZone.Parent

-- 从 BusStop Model 的 Attribute 获取站点信息
local stopId = busStop:GetAttribute("StopId") or "unknown"
local stopName = busStop:GetAttribute("StopName") or "Unknown Stop"

print("✅ 站点检测器启动：" .. stopName)

-- 防止重复触发
local busInZone = false
local debounce = false

-- 检测巴士进站
stopZone.Touched:Connect(function(hit)
    if debounce then return end
    
    -- 检查是不是巴士的一部分
    local model = hit:FindFirstAncestorOfClass("Model")
    if not model then return end
    
    -- 检查模型里有没有 VehicleSeat（说明是车辆）
    local vehicleSeat = model:FindFirstChildOfClass("VehicleSeat", true)
    if not vehicleSeat then return end
    
    -- 已经在站内就不重复触发
    if busInZone then return end
    
    debounce = true
    busInZone = true
    
    -- 检测车速（只有接近停止才算到站）
    local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if primaryPart then
        local speed = primaryPart.AssemblyLinearVelocity.Magnitude
        
        if speed < 10 then  -- 速度小于 10 才算到站
            print("🚏 到站：" .. stopName)
            
            -- 触发到站事件（如果有）
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local busArrivedEvent = ReplicatedStorage:FindFirstChild("BusArrivedEvent")
            if busArrivedEvent then
                busArrivedEvent:Fire(stopId, stopName, model)
            end
            
            -- 更新 UI（通过 RemoteEvent 通知客户端）
            local updateUIEvent = ReplicatedStorage:FindFirstChild("UpdateStopUI")
            if updateUIEvent then
                -- 通知所有玩家
                updateUIEvent:FireAllClients(stopName, "arrived")
            end
        else
            print("🚌 经过：" .. stopName .. "（车速太快，没停站）")
        end
    end
    
    wait(0.5)
    debounce = false
end)

-- 检测巴士离站
stopZone.TouchEnded:Connect(function(hit)
    local model = hit:FindFirstAncestorOfClass("Model")
    if not model then return end
    
    local vehicleSeat = model:FindFirstChildOfClass("VehicleSeat", true)
    if not vehicleSeat then return end
    
    -- 延迟一下再重置，避免抖动
    wait(1)
    busInZone = false
    
    print("🚌 离开：" .. stopName)
    
    -- 通知 UI 更新到下一站
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local updateUIEvent = ReplicatedStorage:FindFirstChild("UpdateStopUI")
    if updateUIEvent then
        updateUIEvent:FireAllClients(stopName, "departed")
    end
end)
