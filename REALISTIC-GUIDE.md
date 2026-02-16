# 🗺️ 真实场景还原指南

**目标：用 Roblox 还原真实的 65 路公交沿线场景**

本指南教你如何参考 Google Maps、Street View 等工具，制作接近真实的道路、车站和周边环境。

---

# 第一部分：地图参考工具

## 1.1 必备工具

| 工具 | 用途 | 链接 |
|------|------|------|
| **Google Maps** | 俯视图、路线规划 | maps.google.com |
| **Google Street View** | 街景实拍、建筑细节 | 在 Maps 里拖小黄人 |
| **Google Earth** | 3D 建筑、地形高度 | earth.google.com |
| **TfL Route Finder** | 65 路官方站点 | tfl.gov.uk/bus/route/65 |
| **OpenStreetMap** | 开源地图数据 | openstreetmap.org |

## 1.2 如何使用 Google Street View

### 步骤
```
1. 打开 Google Maps
2. 搜索目标地点（如 "Richmond Station"）
3. 点击右下角小黄人图标
4. 拖到地图上你想看的位置
5. 松开进入街景模式
6. 用鼠标拖动查看 360° 环境
7. 按方向键或点击箭头移动
```

### 需要观察的细节
- [ ] 道路宽度（几车道？）
- [ ] 人行道宽度和材质
- [ ] 路缘石高度和颜色
- [ ] 道路标线（实线、虚线、斑马线）
- [ ] 交通标志位置
- [ ] 红绿灯样式
- [ ] 公交站样式（候车亭类型）
- [ ] 周边建筑风格和颜色
- [ ] 路灯样式
- [ ] 树木和植被

## 1.3 测量实际距离

### 使用 Google Maps 测量
```
1. 右键点击起点
2. 选择 "测量距离"
3. 点击终点
4. 显示实际距离（米/英尺）
```

### Roblox 比例换算

| 真实世界 | Roblox (1:1) | 推荐比例 (1:5) |
|----------|--------------|----------------|
| 1 米 | 3.5 studs | 0.7 studs |
| 10 米 | 35 studs | 7 studs |
| 100 米 | 350 studs | 70 studs |
| 1 公里 | 3500 studs | 700 studs |

**推荐使用 1:5 比例**（真实但可玩）

---

# 第二部分：道路系统详解

## 2.1 英国道路标准

### 车道宽度
| 道路类型 | 真实宽度 | Roblox (1:5) |
|----------|----------|--------------|
| 普通车道 | 3.65m | 2.5 studs |
| 公交车道 | 3.5m | 2.5 studs |
| 自行车道 | 1.5m | 1 stud |
| 人行道 | 2-3m | 1.5-2 studs |

### 简化版道路参数
```lua
-- 单向两车道 + 人行道
local LANE_WIDTH = 3        -- 每车道宽度
local ROAD_WIDTH = 6        -- 双车道总宽
local PAVEMENT_WIDTH = 2    -- 人行道宽度
local CURB_HEIGHT = 0.15    -- 路缘石高度
local ROAD_THICKNESS = 0.3  -- 路面厚度
```

## 2.2 创建逼真道路的步骤

### Step 1: 基础路面

```lua
-- 创建一段道路
local function createRoadSegment(position, length, rotation)
    local segment = Instance.new("Model")
    segment.Name = "RoadSegment"
    
    -- 主路面（沥青）
    local asphalt = Instance.new("Part")
    asphalt.Name = "Asphalt"
    asphalt.Size = Vector3.new(ROAD_WIDTH, 0.3, length)
    asphalt.Position = position
    asphalt.Orientation = Vector3.new(0, rotation, 0)
    asphalt.Material = Enum.Material.Asphalt
    asphalt.Color = Color3.fromRGB(45, 45, 45)  -- 深灰色沥青
    asphalt.Anchored = true
    asphalt.Parent = segment
    
    return segment
end
```

### Step 2: 道路标线

```lua
-- 中线（白色虚线）
local function createCenterLine(roadPart, dashLength, gapLength)
    local roadLength = roadPart.Size.Z
    local lineGroup = Instance.new("Folder")
    lineGroup.Name = "CenterLines"
    lineGroup.Parent = roadPart.Parent
    
    local position = -roadLength/2
    while position < roadLength/2 do
        local dash = Instance.new("Part")
        dash.Name = "CenterDash"
        dash.Size = Vector3.new(0.15, 0.02, dashLength)  -- 15cm宽线
        dash.Position = roadPart.Position + Vector3.new(0, 0.16, position + dashLength/2)
        dash.Material = Enum.Material.SmoothPlastic
        dash.Color = Color3.fromRGB(255, 255, 255)  -- 白色
        dash.Anchored = true
        dash.Parent = lineGroup
        
        position = position + dashLength + gapLength
    end
end

-- 边线（黄色双实线 - 英国禁停标志）
local function createDoubleYellowLine(roadPart, side)
    local roadLength = roadPart.Size.Z
    local offset = (ROAD_WIDTH/2 - 0.3) * side  -- 靠近路缘
    
    for i = 1, 2 do
        local line = Instance.new("Part")
        line.Name = "YellowLine" .. i
        line.Size = Vector3.new(0.1, 0.02, roadLength)
        line.Position = roadPart.Position + Vector3.new(offset + (i-1)*0.15, 0.16, 0)
        line.Material = Enum.Material.SmoothPlastic
        line.Color = Color3.fromRGB(255, 200, 0)  -- 黄色
        line.Anchored = true
        line.Parent = roadPart.Parent
    end
end
```

### Step 3: 人行道和路缘石

```lua
-- 人行道
local function createPavement(roadPart, side)
    local roadLength = roadPart.Size.Z
    local offset = (ROAD_WIDTH/2 + PAVEMENT_WIDTH/2 + 0.1) * side
    
    -- 路缘石
    local curb = Instance.new("Part")
    curb.Name = "Curb"
    curb.Size = Vector3.new(0.2, CURB_HEIGHT + 0.1, roadLength)
    curb.Position = roadPart.Position + Vector3.new((ROAD_WIDTH/2 + 0.1) * side, 0.2, 0)
    curb.Material = Enum.Material.Concrete
    curb.Color = Color3.fromRGB(180, 180, 180)
    curb.Anchored = true
    curb.Parent = roadPart.Parent
    
    -- 人行道面
    local pavement = Instance.new("Part")
    pavement.Name = "Pavement"
    pavement.Size = Vector3.new(PAVEMENT_WIDTH, 0.2, roadLength)
    pavement.Position = roadPart.Position + Vector3.new(offset, 0.1, 0)
    pavement.Material = Enum.Material.Concrete
    pavement.Color = Color3.fromRGB(160, 160, 160)
    pavement.Anchored = true
    pavement.Parent = roadPart.Parent
end
```

## 2.3 斑马线（人行横道）

### 英国斑马线特点
- 黑白相间条纹
- 两端有 Belisha Beacon（黄色闪烁球灯）
- 锯齿形标线表示禁停区

```lua
local function createZebraCrossing(position, roadWidth, rotation)
    local crossing = Instance.new("Model")
    crossing.Name = "ZebraCrossing"
    
    local STRIPE_WIDTH = 0.6   -- 条纹宽度 60cm
    local STRIPE_GAP = 0.6     -- 间隔 60cm
    local CROSSING_LENGTH = 2.5 -- 横道宽度
    
    local numStripes = math.floor(roadWidth / (STRIPE_WIDTH + STRIPE_GAP))
    
    for i = 1, numStripes do
        local stripe = Instance.new("Part")
        stripe.Name = "Stripe" .. i
        stripe.Size = Vector3.new(STRIPE_WIDTH, 0.02, CROSSING_LENGTH)
        local xOffset = -roadWidth/2 + (i - 0.5) * (STRIPE_WIDTH + STRIPE_GAP)
        stripe.Position = position + Vector3.new(xOffset, 0.16, 0)
        stripe.Orientation = Vector3.new(0, rotation, 0)
        stripe.Material = Enum.Material.SmoothPlastic
        stripe.Color = Color3.fromRGB(255, 255, 255)
        stripe.Anchored = true
        stripe.Parent = crossing
    end
    
    -- Belisha Beacon（黄色球灯）
    for _, side in ipairs({-1, 1}) do
        local pole = Instance.new("Part")
        pole.Name = "BeaconPole"
        pole.Size = Vector3.new(0.1, 2.5, 0.1)
        pole.Position = position + Vector3.new(side * (roadWidth/2 + 0.5), 1.25, 0)
        pole.Material = Enum.Material.Metal
        pole.Color = Color3.fromRGB(30, 30, 30)
        pole.Anchored = true
        pole.Parent = crossing
        
        local beacon = Instance.new("Part")
        beacon.Name = "Beacon"
        beacon.Shape = Enum.PartType.Ball
        beacon.Size = Vector3.new(0.5, 0.5, 0.5)
        beacon.Position = position + Vector3.new(side * (roadWidth/2 + 0.5), 2.6, 0)
        beacon.Material = Enum.Material.Neon
        beacon.Color = Color3.fromRGB(255, 200, 0)
        beacon.Anchored = true
        beacon.Parent = crossing
        
        -- 闪烁灯光
        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(255, 200, 0)
        light.Range = 8
        light.Brightness = 2
        light.Parent = beacon
    end
    
    crossing.Parent = workspace.Roads
    return crossing
end
```

## 2.4 坡道和斜坡

### 真实坡度参考
| 地点 | 坡度 | 备注 |
|------|------|------|
| 普通道路 | 0-3% | 基本平坦 |
| Richmond Hill | 5-8% | 明显上坡 |
| 桥梁引道 | 3-5% | 缓坡 |
| 停车场入口 | 10-15% | 陡坡 |

### 坡度换算
```
坡度 5% = 每前进 100m 上升 5m
         = 每前进 70 studs 上升 3.5 studs (1:5比例)
         = 角度约 2.86°
```

### 创建坡道

```lua
local function createSlopeRoad(startPos, endPos, length, gradient)
    -- gradient: 0.05 = 5% 坡度
    local heightDiff = length * gradient
    
    local road = Instance.new("Part")
    road.Name = "SlopeRoad"
    
    -- 计算倾斜角度
    local angle = math.deg(math.atan(gradient))
    
    road.Size = Vector3.new(ROAD_WIDTH, 0.3, length)
    road.Position = (startPos + endPos) / 2 + Vector3.new(0, heightDiff/2, 0)
    road.Orientation = Vector3.new(-angle, 0, 0)  -- X轴旋转实现倾斜
    road.Material = Enum.Material.Asphalt
    road.Color = Color3.fromRGB(45, 45, 45)
    road.Anchored = true
    road.Parent = workspace.Roads
    
    return road
end

-- 示例：创建 Richmond Hill 上坡路段
-- 从底部到顶部，长度 200 studs，坡度 6%
createSlopeRoad(
    Vector3.new(0, 0, 0),      -- 起点
    Vector3.new(0, 12, 200),   -- 终点（上升 12 studs）
    200,                        -- 长度
    0.06                        -- 6% 坡度
)
```

## 2.5 红绿灯系统

### 英国红绿灯特点
- 垂直排列：红-黄-绿
- 有时有行人按钮
- Pelican/Puffin 人行横道带灯

```lua
local function createTrafficLight(position, facing)
    local trafficLight = Instance.new("Model")
    trafficLight.Name = "TrafficLight"
    
    -- 灯杆
    local pole = Instance.new("Part")
    pole.Name = "Pole"
    pole.Size = Vector3.new(0.15, 4, 0.15)
    pole.Position = position + Vector3.new(0, 2, 0)
    pole.Material = Enum.Material.Metal
    pole.Color = Color3.fromRGB(50, 50, 50)
    pole.Anchored = true
    pole.Parent = trafficLight
    
    -- 灯箱
    local lightBox = Instance.new("Part")
    lightBox.Name = "LightBox"
    lightBox.Size = Vector3.new(0.4, 1.2, 0.3)
    lightBox.Position = position + Vector3.new(0, 4.3, 0)
    lightBox.Material = Enum.Material.Metal
    lightBox.Color = Color3.fromRGB(30, 30, 30)
    lightBox.Anchored = true
    lightBox.Parent = trafficLight
    
    -- 三个灯
    local lights = {
        {name = "Red", color = Color3.fromRGB(255, 0, 0), y = 4.7},
        {name = "Yellow", color = Color3.fromRGB(255, 200, 0), y = 4.3},
        {name = "Green", color = Color3.fromRGB(0, 255, 0), y = 3.9}
    }
    
    for _, lightData in ipairs(lights) do
        local light = Instance.new("Part")
        light.Name = lightData.name .. "Light"
        light.Shape = Enum.PartType.Cylinder
        light.Size = Vector3.new(0.1, 0.25, 0.25)
        light.Position = position + Vector3.new(0, lightData.y, 0.2)
        light.Orientation = Vector3.new(0, 0, 90)
        light.Material = Enum.Material.Neon
        light.Color = lightData.color
        light.Transparency = 0.5  -- 默认暗淡
        light.Anchored = true
        light.Parent = trafficLight
        
        -- 添加灯光效果
        local pointLight = Instance.new("PointLight")
        pointLight.Color = lightData.color
        pointLight.Range = 10
        pointLight.Brightness = 0  -- 默认关闭
        pointLight.Parent = light
    end
    
    trafficLight.Parent = workspace.TrafficLights
    return trafficLight
end

-- 红绿灯控制脚本
local function trafficLightController(trafficLight, greenTime, yellowTime, redTime)
    local redLight = trafficLight:FindFirstChild("RedLight")
    local yellowLight = trafficLight:FindFirstChild("YellowLight")
    local greenLight = trafficLight:FindFirstChild("GreenLight")
    
    local function setLight(light, on)
        light.Transparency = on and 0 or 0.7
        light:FindFirstChildOfClass("PointLight").Brightness = on and 2 or 0
    end
    
    while true do
        -- 绿灯
        setLight(redLight, false)
        setLight(yellowLight, false)
        setLight(greenLight, true)
        wait(greenTime)
        
        -- 黄灯
        setLight(greenLight, false)
        setLight(yellowLight, true)
        wait(yellowTime)
        
        -- 红灯
        setLight(yellowLight, false)
        setLight(redLight, true)
        wait(redTime)
        
        -- 红黄灯（英国特有，准备启动）
        setLight(yellowLight, true)
        wait(2)
    end
end
```

## 2.6 环岛 (Roundabout)

### 英国环岛特点
- 顺时针行驶（靠左行驶国家）
- 中心岛通常有植被或雕塑
- 多个出口标记清晰

```lua
local function createRoundabout(centerPosition, outerRadius, innerRadius, numExits)
    local roundabout = Instance.new("Model")
    roundabout.Name = "Roundabout"
    
    -- 中心岛（绿地）
    local centerIsland = Instance.new("Part")
    centerIsland.Name = "CenterIsland"
    centerIsland.Shape = Enum.PartType.Cylinder
    centerIsland.Size = Vector3.new(0.5, innerRadius * 2, innerRadius * 2)
    centerIsland.Position = centerPosition + Vector3.new(0, 0.25, 0)
    centerIsland.Orientation = Vector3.new(0, 0, 90)
    centerIsland.Material = Enum.Material.Grass
    centerIsland.Color = Color3.fromRGB(60, 120, 60)
    centerIsland.Anchored = true
    centerIsland.Parent = roundabout
    
    -- 环形道路（用多个扇形拼接）
    local segments = 32  -- 精度
    for i = 1, segments do
        local angle1 = (i - 1) / segments * math.pi * 2
        local angle2 = i / segments * math.pi * 2
        local midAngle = (angle1 + angle2) / 2
        
        local segmentLength = 2 * math.pi * (outerRadius - ROAD_WIDTH/2) / segments
        
        local segment = Instance.new("Part")
        segment.Name = "RoadSegment" .. i
        segment.Size = Vector3.new(ROAD_WIDTH, 0.3, segmentLength * 1.1)  -- 略微重叠
        
        local midRadius = (outerRadius + innerRadius) / 2
        local x = centerPosition.X + math.cos(midAngle) * midRadius
        local z = centerPosition.Z + math.sin(midAngle) * midRadius
        segment.Position = Vector3.new(x, centerPosition.Y + 0.15, z)
        segment.Orientation = Vector3.new(0, math.deg(midAngle) + 90, 0)
        
        segment.Material = Enum.Material.Asphalt
        segment.Color = Color3.fromRGB(45, 45, 45)
        segment.Anchored = true
        segment.Parent = roundabout
    end
    
    -- 中心装饰（小树或雕塑）
    local decoration = Instance.new("Part")
    decoration.Name = "Decoration"
    decoration.Shape = Enum.PartType.Ball
    decoration.Size = Vector3.new(2, 2, 2)
    decoration.Position = centerPosition + Vector3.new(0, 1.5, 0)
    decoration.Material = Enum.Material.Grass
    decoration.Color = Color3.fromRGB(40, 100, 40)
    decoration.Anchored = true
    decoration.Parent = roundabout
    
    roundabout.Parent = workspace.Roads
    return roundabout
end
```

## 2.7 桥梁

### 65 路经过的桥
- Richmond Bridge（泰晤士河）
- Kew Bridge 附近

```lua
local function createBridge(startPos, endPos, width, height)
    local bridge = Instance.new("Model")
    bridge.Name = "Bridge"
    
    local length = (endPos - startPos).Magnitude
    local midPoint = (startPos + endPos) / 2 + Vector3.new(0, height, 0)
    
    -- 桥面
    local deck = Instance.new("Part")
    deck.Name = "Deck"
    deck.Size = Vector3.new(width, 0.5, length)
    deck.CFrame = CFrame.lookAt(midPoint, endPos + Vector3.new(0, height, 0))
    deck.Material = Enum.Material.Concrete
    deck.Color = Color3.fromRGB(150, 150, 150)
    deck.Anchored = true
    deck.Parent = bridge
    
    -- 路面
    local roadSurface = Instance.new("Part")
    roadSurface.Name = "RoadSurface"
    roadSurface.Size = Vector3.new(ROAD_WIDTH, 0.3, length)
    roadSurface.Position = deck.Position + Vector3.new(0, 0.4, 0)
    roadSurface.Orientation = deck.Orientation
    roadSurface.Material = Enum.Material.Asphalt
    roadSurface.Color = Color3.fromRGB(45, 45, 45)
    roadSurface.Anchored = true
    roadSurface.Parent = bridge
    
    -- 护栏
    for _, side in ipairs({-1, 1}) do
        local railing = Instance.new("Part")
        railing.Name = "Railing"
        railing.Size = Vector3.new(0.1, 1.2, length)
        railing.Position = deck.Position + Vector3.new(side * (width/2 - 0.1), 1, 0)
        railing.Orientation = deck.Orientation
        railing.Material = Enum.Material.Metal
        railing.Color = Color3.fromRGB(40, 40, 40)
        railing.Anchored = true
        railing.Parent = bridge
    end
    
    -- 桥墩
    local numPiers = math.max(2, math.floor(length / 20))
    for i = 1, numPiers do
        local pierPos = startPos + (endPos - startPos) * (i / (numPiers + 1))
        
        local pier = Instance.new("Part")
        pier.Name = "Pier" .. i
        pier.Size = Vector3.new(2, height + 2, 3)
        pier.Position = pierPos + Vector3.new(0, height/2 - 1, 0)
        pier.Material = Enum.Material.Concrete
        pier.Color = Color3.fromRGB(140, 140, 140)
        pier.Anchored = true
        pier.Parent = bridge
    end
    
    -- 引桥（斜坡）
    local rampLength = height / 0.05  -- 5% 坡度
    
    -- 起点引桥
    local startRamp = Instance.new("Part")
    startRamp.Name = "StartRamp"
    startRamp.Size = Vector3.new(width, 0.5, rampLength)
    local rampAngle = math.deg(math.atan(height / rampLength))
    startRamp.CFrame = CFrame.new(startPos - Vector3.new(0, 0, rampLength/2)) 
                       * CFrame.Angles(math.rad(-rampAngle), 0, 0)
    startRamp.Position = startRamp.Position + Vector3.new(0, height/2, 0)
    startRamp.Material = Enum.Material.Concrete
    startRamp.Color = Color3.fromRGB(150, 150, 150)
    startRamp.Anchored = true
    startRamp.Parent = bridge
    
    bridge.Parent = workspace.Roads
    return bridge
end
```

## 2.8 隧道

```lua
local function createTunnel(startPos, endPos, width, height)
    local tunnel = Instance.new("Model")
    tunnel.Name = "Tunnel"
    
    local length = (endPos - startPos).Magnitude
    local midPoint = (startPos + endPos) / 2
    local direction = (endPos - startPos).Unit
    
    -- 隧道顶部（半圆形用多个 Part 模拟）
    local archSegments = 8
    for i = 1, archSegments do
        local angle1 = (i - 1) / archSegments * math.pi
        local angle2 = i / archSegments * math.pi
        local midAngle = (angle1 + angle2) / 2
        
        local segmentHeight = height/2 * math.sin(midAngle)
        local segmentOffset = width/2 * math.cos(midAngle)
        
        local archPart = Instance.new("Part")
        archPart.Name = "Arch" .. i
        archPart.Size = Vector3.new(width/archSegments * 1.2, 0.5, length)
        archPart.Position = midPoint + Vector3.new(segmentOffset, height/2 + segmentHeight, 0)
        archPart.Orientation = Vector3.new(0, 0, math.deg(midAngle) - 90)
        archPart.Material = Enum.Material.Concrete
        archPart.Color = Color3.fromRGB(130, 130, 130)
        archPart.Anchored = true
        archPart.Parent = tunnel
    end
    
    -- 侧墙
    for _, side in ipairs({-1, 1}) do
        local wall = Instance.new("Part")
        wall.Name = "Wall"
        wall.Size = Vector3.new(0.5, height, length)
        wall.Position = midPoint + Vector3.new(side * width/2, height/2, 0)
        wall.Material = Enum.Material.Concrete
        wall.Color = Color3.fromRGB(120, 120, 120)
        wall.Anchored = true
        wall.Parent = tunnel
    end
    
    -- 路面
    local road = Instance.new("Part")
    road.Name = "Road"
    road.Size = Vector3.new(ROAD_WIDTH, 0.3, length)
    road.Position = midPoint + Vector3.new(0, 0.15, 0)
    road.Material = Enum.Material.Asphalt
    road.Color = Color3.fromRGB(45, 45, 45)
    road.Anchored = true
    road.Parent = tunnel
    
    -- 隧道灯光
    local numLights = math.floor(length / 10)
    for i = 1, numLights do
        local lightPos = startPos + direction * (i * length / (numLights + 1))
        
        local lightFixture = Instance.new("Part")
        lightFixture.Name = "Light" .. i
        lightFixture.Size = Vector3.new(0.3, 0.1, 0.6)
        lightFixture.Position = lightPos + Vector3.new(0, height - 0.2, 0)
        lightFixture.Material = Enum.Material.Neon
        lightFixture.Color = Color3.fromRGB(255, 250, 220)
        lightFixture.Anchored = true
        lightFixture.Parent = tunnel
        
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.fromRGB(255, 250, 220)
        pointLight.Range = 15
        pointLight.Brightness = 1.5
        pointLight.Parent = lightFixture
    end
    
    tunnel.Parent = workspace.Roads
    return tunnel
end
```

---

# 第三部分：公交车站详解

## 3.1 TfL 公交站类型

### 类型 A：简易站牌
```
只有一根杆子 + 红色圆盘
适用于：小站、郊区
```

### 类型 B：候车亭 (Shelter)
```
有顶棚 + 座位 + 时刻表
适用于：主要站点
```

### 类型 C：公交总站 (Bus Station)
```
多个停靠位 + 室内候车
适用于：起点/终点站
```

## 3.2 详细候车亭结构

### 真实 TfL 候车亭参数
```
总宽度: 2m
总深度: 1.5m
总高度: 2.5m
座位高度: 45cm
顶棚材质: 玻璃或金属
支柱: 通常 2 根
颜色: 深灰色金属框架
```

### 完整候车亭代码

```lua
local function createBusShelter(position, rotation)
    local shelter = Instance.new("Model")
    shelter.Name = "BusShelter"
    
    -- 参数
    local WIDTH = 4       -- 宽度
    local DEPTH = 2.5     -- 深度
    local HEIGHT = 3      -- 高度
    local ROOF_THICKNESS = 0.15
    
    -- 底座
    local base = Instance.new("Part")
    base.Name = "Base"
    base.Size = Vector3.new(WIDTH, 0.15, DEPTH)
    base.Position = position + Vector3.new(0, 0.075, 0)
    base.Material = Enum.Material.Concrete
    base.Color = Color3.fromRGB(100, 100, 100)
    base.Anchored = true
    base.Parent = shelter
    
    -- 后墙（玻璃）
    local backWall = Instance.new("Part")
    backWall.Name = "BackWall"
    backWall.Size = Vector3.new(WIDTH - 0.2, HEIGHT - 0.5, 0.1)
    backWall.Position = position + Vector3.new(0, HEIGHT/2 + 0.1, DEPTH/2 - 0.1)
    backWall.Material = Enum.Material.Glass
    backWall.Color = Color3.fromRGB(200, 220, 255)
    backWall.Transparency = 0.3
    backWall.Anchored = true
    backWall.Parent = shelter
    
    -- 侧墙 x2（玻璃）
    for _, side in ipairs({-1, 1}) do
        local sideWall = Instance.new("Part")
        sideWall.Name = "SideWall"
        sideWall.Size = Vector3.new(0.1, HEIGHT - 0.5, DEPTH * 0.6)
        sideWall.Position = position + Vector3.new(side * (WIDTH/2 - 0.1), HEIGHT/2 + 0.1, DEPTH * 0.15)
        sideWall.Material = Enum.Material.Glass
        sideWall.Color = Color3.fromRGB(200, 220, 255)
        sideWall.Transparency = 0.3
        sideWall.Anchored = true
        sideWall.Parent = shelter
    end
    
    -- 支柱 x2（金属）
    for _, side in ipairs({-1, 1}) do
        local pillar = Instance.new("Part")
        pillar.Name = "Pillar"
        pillar.Size = Vector3.new(0.1, HEIGHT, 0.1)
        pillar.Position = position + Vector3.new(side * (WIDTH/2 - 0.2), HEIGHT/2, -DEPTH/2 + 0.2)
        pillar.Material = Enum.Material.Metal
        pillar.Color = Color3.fromRGB(50, 50, 50)
        pillar.Anchored = true
        pillar.Parent = shelter
    end
    
    -- 顶棚
    local roof = Instance.new("Part")
    roof.Name = "Roof"
    roof.Size = Vector3.new(WIDTH + 0.3, ROOF_THICKNESS, DEPTH + 0.3)
    roof.Position = position + Vector3.new(0, HEIGHT + ROOF_THICKNESS/2, 0)
    roof.Material = Enum.Material.Metal
    roof.Color = Color3.fromRGB(60, 60, 60)
    roof.Anchored = true
    roof.Parent = shelter
    
    -- 顶棚玻璃
    local roofGlass = Instance.new("Part")
    roofGlass.Name = "RoofGlass"
    roofGlass.Size = Vector3.new(WIDTH - 0.4, 0.05, DEPTH - 0.4)
    roofGlass.Position = position + Vector3.new(0, HEIGHT - 0.05, 0)
    roofGlass.Material = Enum.Material.Glass
    roofGlass.Color = Color3.fromRGB(180, 200, 220)
    roofGlass.Transparency = 0.5
    roofGlass.Anchored = true
    roofGlass.Parent = shelter
    
    -- 座位
    local bench = Instance.new("Part")
    bench.Name = "Bench"
    bench.Size = Vector3.new(WIDTH - 0.6, 0.1, 0.4)
    bench.Position = position + Vector3.new(0, 0.5, DEPTH/2 - 0.4)
    bench.Material = Enum.Material.Wood
    bench.Color = Color3.fromRGB(139, 90, 43)
    bench.Anchored = true
    bench.Parent = shelter
    
    -- 座位支撑
    for _, xPos in ipairs({-WIDTH/3, 0, WIDTH/3}) do
        local support = Instance.new("Part")
        support.Name = "BenchSupport"
        support.Size = Vector3.new(0.1, 0.35, 0.3)
        support.Position = position + Vector3.new(xPos, 0.25, DEPTH/2 - 0.4)
        support.Material = Enum.Material.Metal
        support.Color = Color3.fromRGB(50, 50, 50)
        support.Anchored = true
        support.Parent = shelter
    end
    
    -- 时刻表/地图展示板
    local infoBoard = Instance.new("Part")
    infoBoard.Name = "InfoBoard"
    infoBoard.Size = Vector3.new(0.8, 1.2, 0.05)
    infoBoard.Position = position + Vector3.new(-WIDTH/4, 1.2, DEPTH/2 - 0.15)
    infoBoard.Material = Enum.Material.SmoothPlastic
    infoBoard.Color = Color3.fromRGB(255, 255, 255)
    infoBoard.Anchored = true
    infoBoard.Parent = shelter
    
    -- 应用旋转
    shelter:SetPrimaryPartCFrame(CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0))
    
    shelter.Parent = workspace.BusStops
    return shelter
end
```

## 3.3 TfL 站牌详细设计

```lua
local function createTfLBusStop(position, stopName, routes, rotation)
    local busStop = Instance.new("Model")
    busStop.Name = "BusStop_" .. stopName:gsub(" ", "_")
    
    -- 设置属性
    busStop:SetAttribute("StopId", stopName:lower():gsub(" ", "_"))
    busStop:SetAttribute("StopName", stopName)
    
    -- 站牌杆
    local pole = Instance.new("Part")
    pole.Name = "Pole"
    pole.Size = Vector3.new(0.12, 4, 0.12)
    pole.Position = position + Vector3.new(0, 2, 0)
    pole.Material = Enum.Material.Metal
    pole.Color = Color3.fromRGB(40, 40, 40)
    pole.Anchored = true
    pole.Parent = busStop
    
    -- TfL 红色圆盘（主标志）
    local roundel = Instance.new("Part")
    roundel.Name = "Roundel"
    roundel.Shape = Enum.PartType.Cylinder
    roundel.Size = Vector3.new(0.15, 0.9, 0.9)
    roundel.Position = position + Vector3.new(0, 4.2, 0)
    roundel.Orientation = Vector3.new(0, 0, 90)
    roundel.Material = Enum.Material.SmoothPlastic
    roundel.Color = Color3.fromRGB(220, 36, 31)  -- TfL 红
    roundel.Anchored = true
    roundel.Parent = busStop
    
    -- 白色横条（BUS STOP 文字背景）
    local whiteBar = Instance.new("Part")
    whiteBar.Name = "WhiteBar"
    whiteBar.Size = Vector3.new(0.02, 0.25, 0.6)
    whiteBar.Position = position + Vector3.new(0.08, 4.2, 0)
    whiteBar.Material = Enum.Material.SmoothPlastic
    whiteBar.Color = Color3.fromRGB(255, 255, 255)
    whiteBar.Anchored = true
    whiteBar.Parent = busStop
    
    -- 添加 "BUS STOP" 文字
    local busStopGui = Instance.new("SurfaceGui")
    busStopGui.Face = Enum.NormalId.Front
    busStopGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    busStopGui.PixelsPerStud = 100
    busStopGui.Parent = whiteBar
    
    local busStopText = Instance.new("TextLabel")
    busStopText.Size = UDim2.new(1, 0, 1, 0)
    busStopText.BackgroundTransparency = 1
    busStopText.Text = "BUS STOP"
    busStopText.TextColor3 = Color3.fromRGB(220, 36, 31)
    busStopText.TextScaled = true
    busStopText.Font = Enum.Font.GothamBold
    busStopText.Parent = busStopGui
    
    -- 路线信息板
    local routeBoard = Instance.new("Part")
    routeBoard.Name = "RouteBoard"
    routeBoard.Size = Vector3.new(0.05, 0.5, 0.5)
    routeBoard.Position = position + Vector3.new(0.08, 3.5, 0)
    routeBoard.Material = Enum.Material.SmoothPlastic
    routeBoard.Color = Color3.fromRGB(255, 255, 255)
    routeBoard.Anchored = true
    routeBoard.Parent = busStop
    
    -- 路线号码
    local routeGui = Instance.new("SurfaceGui")
    routeGui.Face = Enum.NormalId.Front
    routeGui.Parent = routeBoard
    
    local routeFrame = Instance.new("Frame")
    routeFrame.Size = UDim2.new(1, 0, 1, 0)
    routeFrame.BackgroundTransparency = 1
    routeFrame.Parent = routeGui
    
    -- 显示所有路线（最多显示3个）
    local routeList = type(routes) == "table" and routes or {routes}
    local numRoutes = math.min(#routeList, 3)
    
    for i, route in ipairs(routeList) do
        if i > 3 then break end
        
        local routeLabel = Instance.new("TextLabel")
        routeLabel.Size = UDim2.new(1, 0, 1/numRoutes, 0)
        routeLabel.Position = UDim2.new(0, 0, (i-1)/numRoutes, 0)
        routeLabel.BackgroundTransparency = 1
        routeLabel.Text = tostring(route)
        routeLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        routeLabel.TextScaled = true
        routeLabel.Font = Enum.Font.GothamBold
        routeLabel.Parent = routeFrame
    end
    
    -- 站名标签（小字）
    local nameBoard = Instance.new("Part")
    nameBoard.Name = "NameBoard"
    nameBoard.Size = Vector3.new(0.05, 0.25, 0.5)
    nameBoard.Position = position + Vector3.new(0.08, 3.1, 0)
    nameBoard.Material = Enum.Material.SmoothPlastic
    nameBoard.Color = Color3.fromRGB(255, 255, 255)
    nameBoard.Anchored = true
    nameBoard.Parent = busStop
    
    local nameGui = Instance.new("SurfaceGui")
    nameGui.Face = Enum.NormalId.Front
    nameGui.Parent = nameBoard
    
    local nameText = Instance.new("TextLabel")
    nameText.Size = UDim2.new(1, 0, 1, 0)
    nameText.BackgroundTransparency = 1
    nameText.Text = stopName
    nameText.TextColor3 = Color3.fromRGB(0, 0, 0)
    nameText.TextScaled = true
    nameText.Font = Enum.Font.Gotham
    nameText.Parent = nameGui
    
    -- 应用旋转
    busStop:SetPrimaryPartCFrame(CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0))
    
    busStop.Parent = workspace.BusStops
    return busStop
end

-- 使用示例
createTfLBusStop(
    Vector3.new(15, 0, 0),
    "Richmond",
    {"65", "371", "H22"},
    0
)
```

---

# 第四部分：周边环境详解

## 4.1 建筑类型参考

### 65 路沿线建筑风格

| 区域 | 主要风格 | 特点 |
|------|----------|------|
| Kingston | 现代商业 | 玻璃幕墙、购物中心 |
| Richmond | 维多利亚/乔治亚 | 红砖、白色窗框 |
| Kew | 住宅区 | 半独立式房屋、花园 |
| Brentford | 混合 | 新旧建筑并存 |
| Ealing | 商业 + 住宅 | 百货、公寓 |

## 4.2 维多利亚式建筑（Richmond 风格）

```lua
local function createVictorianBuilding(position, width, depth, floors, rotation)
    local building = Instance.new("Model")
    building.Name = "VictorianBuilding"
    
    local FLOOR_HEIGHT = 4
    local height = floors * FLOOR_HEIGHT
    
    -- 主体
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(width, height, depth)
    body.Position = position + Vector3.new(0, height/2, 0)
    body.Material = Enum.Material.Brick
    body.Color = Color3.fromRGB(180, 100, 80)  -- 红砖色
    body.Anchored = true
    body.Parent = building
    
    -- 窗户（每层多个）
    local windowsPerFloor = math.floor(width / 3)
    local windowWidth = 1.2
    local windowHeight = 2
    
    for floor = 1, floors do
        for w = 1, windowsPerFloor do
            local windowFrame = Instance.new("Part")
            windowFrame.Name = "WindowFrame"
            windowFrame.Size = Vector3.new(windowWidth + 0.2, windowHeight + 0.2, 0.15)
            
            local xOffset = -width/2 + (w - 0.5) * (width / windowsPerFloor)
            local yOffset = (floor - 0.5) * FLOOR_HEIGHT
            
            windowFrame.Position = position + Vector3.new(xOffset, yOffset, -depth/2 - 0.1)
            windowFrame.Material = Enum.Material.SmoothPlastic
            windowFrame.Color = Color3.fromRGB(240, 240, 240)  -- 白色窗框
            windowFrame.Anchored = true
            windowFrame.Parent = building
            
            -- 玻璃
            local glass = Instance.new("Part")
            glass.Name = "Glass"
            glass.Size = Vector3.new(windowWidth, windowHeight, 0.05)
            glass.Position = position + Vector3.new(xOffset, yOffset, -depth/2 - 0.15)
            glass.Material = Enum.Material.Glass
            glass.Color = Color3.fromRGB(150, 180, 220)
            glass.Transparency = 0.3
            glass.Anchored = true
            glass.Parent = building
        end
    end
    
    -- 门（一楼中间）
    local door = Instance.new("Part")
    door.Name = "Door"
    door.Size = Vector3.new(1.5, 2.8, 0.15)
    door.Position = position + Vector3.new(0, 1.4, -depth/2 - 0.1)
    door.Material = Enum.Material.Wood
    door.Color = Color3.fromRGB(60, 40, 30)
    door.Anchored = true
    door.Parent = building
    
    -- 门上方拱形装饰
    local doorArch = Instance.new("Part")
    doorArch.Name = "DoorArch"
    doorArch.Size = Vector3.new(2, 0.5, 0.3)
    doorArch.Position = position + Vector3.new(0, 3, -depth/2 - 0.1)
    doorArch.Material = Enum.Material.SmoothPlastic
    doorArch.Color = Color3.fromRGB(240, 240, 240)
    doorArch.Anchored = true
    doorArch.Parent = building
    
    -- 屋顶装饰线
    local cornice = Instance.new("Part")
    cornice.Name = "Cornice"
    cornice.Size = Vector3.new(width + 0.4, 0.3, depth + 0.4)
    cornice.Position = position + Vector3.new(0, height + 0.15, 0)
    cornice.Material = Enum.Material.SmoothPlastic
    cornice.Color = Color3.fromRGB(220, 220, 220)
    cornice.Anchored = true
    cornice.Parent = building
    
    -- 烟囱
    local chimney = Instance.new("Part")
    chimney.Name = "Chimney"
    chimney.Size = Vector3.new(1, 2, 1)
    chimney.Position = position + Vector3.new(width/3, height + 1.3, 0)
    chimney.Material = Enum.Material.Brick
    chimney.Color = Color3.fromRGB(160, 80, 60)
    chimney.Anchored = true
    chimney.Parent = building
    
    building:SetPrimaryPartCFrame(CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0))
    building.Parent = workspace.Buildings
    return building
end
```

## 4.3 现代商店（Kingston 风格）

```lua
local function createModernShop(position, width, depth, shopName, signColor, rotation)
    local shop = Instance.new("Model")
    shop.Name = "Shop_" .. shopName:gsub(" ", "_")
    
    local HEIGHT = 5
    
    -- 主体
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(width, HEIGHT, depth)
    body.Position = position + Vector3.new(0, HEIGHT/2, 0)
    body.Material = Enum.Material.Concrete
    body.Color = Color3.fromRGB(220, 220, 220)
    body.Anchored = true
    body.Parent = shop
    
    -- 大玻璃橱窗
    local shopWindow = Instance.new("Part")
    shopWindow.Name = "ShopWindow"
    shopWindow.Size = Vector3.new(width - 1, 3, 0.1)
    shopWindow.Position = position + Vector3.new(0, 2, -depth/2 - 0.1)
    shopWindow.Material = Enum.Material.Glass
    shopWindow.Color = Color3.fromRGB(180, 200, 220)
    shopWindow.Transparency = 0.2
    shopWindow.Anchored = true
    shopWindow.Parent = shop
    
    -- 招牌
    local sign = Instance.new("Part")
    sign.Name = "Sign"
    sign.Size = Vector3.new(width, 1, 0.2)
    sign.Position = position + Vector3.new(0, HEIGHT - 0.5, -depth/2 - 0.2)
    sign.Material = Enum.Material.SmoothPlastic
    sign.Color = signColor or Color3.fromRGB(0, 100, 200)
    sign.Anchored = true
    sign.Parent = shop
    
    -- 招牌文字
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.Parent = sign
    
    local signText = Instance.new("TextLabel")
    signText.Size = UDim2.new(1, 0, 1, 0)
    signText.BackgroundTransparency = 1
    signText.Text = shopName
    signText.TextColor3 = Color3.fromRGB(255, 255, 255)
    signText.TextScaled = true
    signText.Font = Enum.Font.GothamBold
    signText.Parent = signGui
    
    -- 入口门
    local entrance = Instance.new("Part")
    entrance.Name = "Entrance"
    entrance.Size = Vector3.new(2, 3, 0.1)
    entrance.Position = position + Vector3.new(width/3, 1.5, -depth/2 - 0.1)
    entrance.Material = Enum.Material.Glass
    entrance.Color = Color3.fromRGB(100, 100, 100)
    entrance.Transparency = 0.3
    entrance.Anchored = true
    entrance.Parent = shop
    
    shop.Parent = workspace.Buildings
    return shop
end

-- 使用示例：创建常见商店
createModernShop(Vector3.new(0, 0, 0), 10, 8, "Tesco Express", Color3.fromRGB(0, 86, 179), 0)
createModernShop(Vector3.new(12, 0, 0), 8, 8, "Costa Coffee", Color3.fromRGB(100, 30, 50), 0)
createModernShop(Vector3.new(22, 0, 0), 12, 8, "M&S", Color3.fromRGB(0, 50, 30), 0)
```

## 4.4 住宅（半独立式房屋）

```lua
local function createSemiDetachedHouse(position, rotation)
    local house = Instance.new("Model")
    house.Name = "SemiDetachedHouse"
    
    local WIDTH = 8
    local DEPTH = 10
    local HEIGHT = 6
    
    -- 主体
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(WIDTH, HEIGHT, DEPTH)
    body.Position = position + Vector3.new(0, HEIGHT/2, 0)
    body.Material = Enum.Material.Brick
    body.Color = Color3.fromRGB(200, 180, 160)  -- 浅砖色
    body.Anchored = true
    body.Parent = house
    
    -- 屋顶（三角形用 WedgePart）
    local roofLeft = Instance.new("WedgePart")
    roofLeft.Name = "RoofLeft"
    roofLeft.Size = Vector3.new(DEPTH, 3, WIDTH/2 + 0.3)
    roofLeft.Position = position + Vector3.new(-WIDTH/4, HEIGHT + 1.5, 0)
    roofLeft.Orientation = Vector3.new(0, -90, 0)
    roofLeft.Material = Enum.Material.Slate
    roofLeft.Color = Color3.fromRGB(60, 60, 60)
    roofLeft.Anchored = true
    roofLeft.Parent = house
    
    local roofRight = Instance.new("WedgePart")
    roofRight.Name = "RoofRight"
    roofRight.Size = Vector3.new(DEPTH, 3, WIDTH/2 + 0.3)
    roofRight.Position = position + Vector3.new(WIDTH/4, HEIGHT + 1.5, 0)
    roofRight.Orientation = Vector3.new(0, 90, 0)
    roofRight.Material = Enum.Material.Slate
    roofRight.Color = Color3.fromRGB(60, 60, 60)
    roofRight.Anchored = true
    roofRight.Parent = house
    
    -- 门
    local door = Instance.new("Part")
    door.Name = "Door"
    door.Size = Vector3.new(1.2, 2.5, 0.1)
    door.Position = position + Vector3.new(-1.5, 1.25, -DEPTH/2 - 0.1)
    door.Material = Enum.Material.Wood
    door.Color = Color3.fromRGB(80, 50, 30)
    door.Anchored = true
    door.Parent = house
    
    -- 窗户（一楼和二楼各两个）
    local windowPositions = {
        {x = 1.5, y = 1.5},   -- 一楼右
        {x = -1.5, y = 4.5},  -- 二楼左
        {x = 1.5, y = 4.5},   -- 二楼右
    }
    
    for _, pos in ipairs(windowPositions) do
        local window = Instance.new("Part")
        window.Name = "Window"
        window.Size = Vector3.new(1.5, 1.8, 0.1)
        window.Position = position + Vector3.new(pos.x, pos.y, -DEPTH/2 - 0.1)
        window.Material = Enum.Material.Glass
        window.Color = Color3.fromRGB(180, 200, 220)
        window.Transparency = 0.3
        window.Anchored = true
        window.Parent = house
    end
    
    -- 前花园围栏
    local fence = Instance.new("Part")
    fence.Name = "Fence"
    fence.Size = Vector3.new(WIDTH + 2, 1, 0.1)
    fence.Position = position + Vector3.new(0, 0.5, -DEPTH/2 - 4)
    fence.Material = Enum.Material.Wood
    fence.Color = Color3.fromRGB(100, 70, 50)
    fence.Anchored = true
    fence.Parent = house
    
    -- 花园草地
    local garden = Instance.new("Part")
    garden.Name = "Garden"
    garden.Size = Vector3.new(WIDTH + 2, 0.1, 4)
    garden.Position = position + Vector3.new(0, 0.05, -DEPTH/2 - 2)
    garden.Material = Enum.Material.Grass
    garden.Color = Color3.fromRGB(60, 120, 60)
    garden.Anchored = true
    garden.Parent = house
    
    house.Parent = workspace.Buildings
    return house
end
```

## 4.5 公园和绿地

```lua
local function createPark(position, width, depth)
    local park = Instance.new("Model")
    park.Name = "Park"
    
    -- 草地
    local grass = Instance.new("Part")
    grass.Name = "Grass"
    grass.Size = Vector3.new(width, 0.2, depth)
    grass.Position = position + Vector3.new(0, 0.1, 0)
    grass.Material = Enum.Material.Grass
    grass.Color = Color3.fromRGB(70, 130, 70)
    grass.Anchored = true
    grass.Parent = park
    
    -- 小路（穿过公园）
    local path = Instance.new("Part")
    path.Name = "Path"
    path.Size = Vector3.new(2, 0.05, depth)
    path.Position = position + Vector3.new(0, 0.22, 0)
    path.Material = Enum.Material.Pavement
    path.Color = Color3.fromRGB(180, 160, 140)
    path.Anchored = true
    path.Parent = park
    
    -- 随机放置树木
    local numTrees = math.floor((width * depth) / 100)
    for i = 1, numTrees do
        local treeX = position.X + (math.random() - 0.5) * (width - 4)
        local treeZ = position.Z + (math.random() - 0.5) * (depth - 4)
        
        -- 避开小路
        if math.abs(treeX - position.X) > 2 then
            createTree(Vector3.new(treeX, 0, treeZ))
        end
    end
    
    -- 长椅
    local numBenches = 3
    for i = 1, numBenches do
        local benchPos = position + Vector3.new(
            3,
            0,
            -depth/2 + (i / (numBenches + 1)) * depth
        )
        createParkBench(benchPos, 90)
    end
    
    park.Parent = workspace.Environment
    return park
end

local function createTree(position)
    local tree = Instance.new("Model")
    tree.Name = "Tree"
    
    -- 树干
    local trunk = Instance.new("Part")
    trunk.Name = "Trunk"
    trunk.Shape = Enum.PartType.Cylinder
    trunk.Size = Vector3.new(3, 0.5, 0.5)
    trunk.Position = position + Vector3.new(0, 1.5, 0)
    trunk.Orientation = Vector3.new(0, 0, 90)
    trunk.Material = Enum.Material.Wood
    trunk.Color = Color3.fromRGB(90, 60, 40)
    trunk.Anchored = true
    trunk.Parent = tree
    
    -- 树冠（球形）
    local foliage = Instance.new("Part")
    foliage.Name = "Foliage"
    foliage.Shape = Enum.PartType.Ball
    foliage.Size = Vector3.new(4, 4, 4)
    foliage.Position = position + Vector3.new(0, 4.5, 0)
    foliage.Material = Enum.Material.Grass
    foliage.Color = Color3.fromRGB(50, 100, 50)
    foliage.Anchored = true
    foliage.Parent = tree
    
    tree.Parent = workspace.Environment
    return tree
end

local function createParkBench(position, rotation)
    local bench = Instance.new("Model")
    bench.Name = "ParkBench"
    
    -- 座面
    local seat = Instance.new("Part")
    seat.Name = "Seat"
    seat.Size = Vector3.new(2, 0.1, 0.5)
    seat.Position = position + Vector3.new(0, 0.5, 0)
    seat.Material = Enum.Material.Wood
    seat.Color = Color3.fromRGB(100, 70, 50)
    seat.Anchored = true
    seat.Parent = bench
    
    -- 靠背
    local back = Instance.new("Part")
    back.Name = "Back"
    back.Size = Vector3.new(2, 0.5, 0.1)
    back.Position = position + Vector3.new(0, 0.8, 0.25)
    back.Material = Enum.Material.Wood
    back.Color = Color3.fromRGB(100, 70, 50)
    back.Anchored = true
    back.Parent = bench
    
    -- 腿 x2
    for _, xOff in ipairs({-0.8, 0.8}) do
        local leg = Instance.new("Part")
        leg.Name = "Leg"
        leg.Size = Vector3.new(0.1, 0.5, 0.4)
        leg.Position = position + Vector3.new(xOff, 0.25, 0)
        leg.Material = Enum.Material.Metal
        leg.Color = Color3.fromRGB(50, 50, 50)
        leg.Anchored = true
        leg.Parent = bench
    end
    
    bench:SetPrimaryPartCFrame(CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0))
    bench.Parent = workspace.Environment
    return bench
end
```

## 4.6 路灯（英国风格）

```lua
local function createStreetLamp(position, style)
    local lamp = Instance.new("Model")
    lamp.Name = "StreetLamp"
    
    style = style or "modern"  -- "modern" 或 "victorian"
    
    if style == "modern" then
        -- 现代路灯（弯曲灯杆）
        local pole = Instance.new("Part")
        pole.Name = "Pole"
        pole.Size = Vector3.new(0.15, 5, 0.15)
        pole.Position = position + Vector3.new(0, 2.5, 0)
        pole.Material = Enum.Material.Metal
        pole.Color = Color3.fromRGB(60, 60, 60)
        pole.Anchored = true
        pole.Parent = lamp
        
        local arm = Instance.new("Part")
        arm.Name = "Arm"
        arm.Size = Vector3.new(1.5, 0.1, 0.1)
        arm.Position = position + Vector3.new(0.75, 5, 0)
        arm.Material = Enum.Material.Metal
        arm.Color = Color3.fromRGB(60, 60, 60)
        arm.Anchored = true
        arm.Parent = lamp
        
        local lightHead = Instance.new("Part")
        lightHead.Name = "LightHead"
        lightHead.Size = Vector3.new(0.6, 0.15, 0.3)
        lightHead.Position = position + Vector3.new(1.5, 4.9, 0)
        lightHead.Material = Enum.Material.SmoothPlastic
        lightHead.Color = Color3.fromRGB(80, 80, 80)
        lightHead.Anchored = true
        lightHead.Parent = lamp
        
        -- 灯光
        local light = Instance.new("SpotLight")
        light.Angle = 120
        light.Range = 30
        light.Brightness = 2
        light.Color = Color3.fromRGB(255, 240, 200)
        light.Face = Enum.NormalId.Bottom
        light.Parent = lightHead
        
    else
        -- 维多利亚风格路灯
        local pole = Instance.new("Part")
        pole.Name = "Pole"
        pole.Size = Vector3.new(0.2, 4, 0.2)
        pole.Position = position + Vector3.new(0, 2, 0)
        pole.Material = Enum.Material.Metal
        pole.Color = Color3.fromRGB(30, 30, 30)
        pole.Anchored = true
        pole.Parent = lamp
        
        local lantern = Instance.new("Part")
        lantern.Name = "Lantern"
        lantern.Size = Vector3.new(0.5, 0.8, 0.5)
        lantern.Position = position + Vector3.new(0, 4.5, 0)
        lantern.Material = Enum.Material.Glass
        lantern.Color = Color3.fromRGB(255, 240, 200)
        lantern.Transparency = 0.3
        lantern.Anchored = true
        lantern.Parent = lamp
        
        local light = Instance.new("PointLight")
        light.Range = 25
        light.Brightness = 1.5
        light.Color = Color3.fromRGB(255, 220, 180)
        light.Parent = lantern
    end
    
    lamp.Parent = workspace.Environment
    return lamp
end
```

---

# 第五部分：场景整合

## 5.1 Richmond 站完整场景

```lua
-- Richmond 站完整场景创建脚本
local function createRichmondScene()
    local scene = Instance.new("Model")
    scene.Name = "Richmond_Scene"
    
    local BASE_POS = Vector3.new(0, 0, 0)
    
    -- 1. 主道路
    local mainRoad = createRoadSegment(BASE_POS, 200, 0)
    
    -- 2. Richmond Station 建筑
    createVictorianBuilding(
        BASE_POS + Vector3.new(30, 0, 20),
        40, 25, 3, 0
    )
    
    -- 3. 公交站
    local busStop = createTfLBusStop(
        BASE_POS + Vector3.new(10, 0, -5),
        "Richmond",
        {"65", "371", "H22"},
        0
    )
    createBusShelter(BASE_POS + Vector3.new(12, 0, -5), 0)
    
    -- 4. 人行横道
    createZebraCrossing(BASE_POS + Vector3.new(0, 0, -20), 6, 0)
    
    -- 5. 红绿灯
    createTrafficLight(BASE_POS + Vector3.new(-5, 0, -20), 0)
    createTrafficLight(BASE_POS + Vector3.new(5, 0, -20), 180)
    
    -- 6. 周边商店
    createModernShop(BASE_POS + Vector3.new(-25, 0, 15), 8, 8, "Costa", Color3.fromRGB(100, 30, 50), 180)
    createModernShop(BASE_POS + Vector3.new(-35, 0, 15), 10, 8, "Boots", Color3.fromRGB(0, 60, 120), 180)
    createModernShop(BASE_POS + Vector3.new(-47, 0, 15), 12, 8, "M&S Simply Food", Color3.fromRGB(0, 50, 30), 180)
    
    -- 7. 住宅区（远处）
    for i = 1, 4 do
        createSemiDetachedHouse(
            BASE_POS + Vector3.new(-60 + i * 15, 0, 50),
            0
        )
    end
    
    -- 8. 小公园
    createPark(BASE_POS + Vector3.new(50, 0, 50), 30, 20)
    
    -- 9. 路灯
    for z = -80, 80, 20 do
        createStreetLamp(BASE_POS + Vector3.new(-8, 0, z), "modern")
        createStreetLamp(BASE_POS + Vector3.new(8, 0, z), "modern")
    end
    
    -- 10. 装饰细节
    -- 垃圾桶、邮筒等可以从 Toolbox 获取
    
    scene.Parent = workspace
    return scene
end

-- 执行创建
createRichmondScene()
```

## 5.2 场景文件夹结构

```
Workspace
├── Roads
│   ├── RoadSegment_1
│   ├── RoadSegment_2
│   └── ...
├── BusStops
│   ├── BusStop_Richmond
│   └── BusStop_Kingston
├── Buildings
│   ├── Richmond_Station
│   ├── Shop_Costa
│   └── House_1
├── TrafficLights
│   ├── TrafficLight_1
│   └── ...
├── Environment
│   ├── Trees
│   ├── Benches
│   └── StreetLamps
└── Buses
    └── Bus65
```

---

# 第六部分：实战练习

## 练习 1：用 Street View 建 Richmond Station

1. 打开 Google Maps，搜索 "Richmond Station, London"
2. 进入 Street View
3. 观察并记录：
   - 建筑外观颜色
   - 窗户数量和样式
   - 入口位置和形状
   - 招牌样式

4. 在 Roblox 中还原

## 练习 2：建一条真实的道路

1. 用 Google Maps 测量 65 路某段道路长度
2. 换算成 Roblox 单位
3. 观察道路特征（车道数、标线、人行道）
4. 建造并添加细节

## 练习 3：完善一个公交站

1. 参考真实 TfL 公交站图片
2. 添加所有细节：
   - 候车亭
   - 站牌
   - 时刻表
   - 垃圾桶
   - 座位

---

# 附录：常用颜色参考

| 元素 | RGB 值 | 颜色 |
|------|--------|------|
| 沥青路面 | (45, 45, 45) | 深灰 |
| 人行道 | (160, 160, 160) | 浅灰 |
| 红砖 | (180, 100, 80) | 红棕 |
| TfL 红 | (220, 36, 31) | 鲜红 |
| 草地 | (70, 130, 70) | 绿色 |
| 白色标线 | (255, 255, 255) | 白色 |
| 黄色标线 | (255, 200, 0) | 黄色 |
| 木材 | (100, 70, 50) | 棕色 |
| 金属 | (60, 60, 60) | 深灰 |
| 玻璃 | (180, 200, 220) | 淡蓝 |

---

**继续学习：**
- YouTube 搜索 "Roblox realistic building"
- DevForum 搜索 "UK map" 或 "British style"
- 参考现有伦敦公交游戏的做法

祝你做出最棒的 65 路模拟游戏！🚌🇬🇧
