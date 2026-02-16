# 🏪 商店与建筑模板系统

**目标：创建可复用的连锁店、快餐店、咖啡店模板，在游戏中快速调用**

---

# 第一部分：模板系统架构

## 1.1 为什么需要模板？

```
❌ 不用模板：每个商店都要从零开始做
✅ 用模板：调用一行代码就能生成完整商店

-- 不用模板
local part1 = Instance.new("Part")
part1.Size = ...
-- 200 行代码...

-- 用模板
local Shops = require(game.ServerScriptService.ShopTemplates)
Shops.createTesco(Vector3.new(0, 0, 0))  -- 一行搞定！
```

## 1.2 模板存放位置

```
ServerScriptService
└── Templates (Folder)
    ├── ShopTemplates (ModuleScript)      -- 商店模板
    ├── RestaurantTemplates (ModuleScript) -- 餐厅模板
    ├── BuildingTemplates (ModuleScript)   -- 建筑模板
    └── StreetFurniture (ModuleScript)     -- 街道设施
```

## 1.3 基础模板结构

```lua
-- ShopTemplates (ModuleScript)
local ShopTemplates = {}

-- 私有函数（内部使用）
local function createBase(position, width, depth, height)
    -- 创建基础结构
end

-- 公开函数（外部调用）
function ShopTemplates.createTesco(position, rotation)
    -- 创建 Tesco 商店
end

function ShopTemplates.createCosta(position, rotation)
    -- 创建 Costa 咖啡
end

return ShopTemplates
```

---

# 第二部分：通用商店基础模板

## 2.1 创建基础模板 ModuleScript

**在 ServerScriptService 下创建：**

```lua
--[[
    ShopTemplates.lua
    商店模板库
    
    使用方法：
    local Shops = require(game.ServerScriptService.Templates.ShopTemplates)
    Shops.createTesco(Vector3.new(0, 0, 0), 0)
]]

local ShopTemplates = {}

-- ==================== 工具函数 ====================

-- 创建带文字的招牌
local function createSign(parent, position, size, bgColor, text, textColor, font)
    local sign = Instance.new("Part")
    sign.Name = "Sign"
    sign.Size = size
    sign.Position = position
    sign.Material = Enum.Material.SmoothPlastic
    sign.Color = bgColor
    sign.Anchored = true
    sign.Parent = parent
    
    local gui = Instance.new("SurfaceGui")
    gui.Face = Enum.NormalId.Front
    gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    gui.PixelsPerStud = 50
    gui.Parent = sign
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = textColor
    label.TextScaled = true
    label.Font = font or Enum.Font.GothamBold
    label.Parent = gui
    
    return sign
end

-- 创建玻璃橱窗
local function createShopWindow(parent, position, size)
    local window = Instance.new("Part")
    window.Name = "ShopWindow"
    window.Size = size
    window.Position = position
    window.Material = Enum.Material.Glass
    window.Color = Color3.fromRGB(200, 220, 240)
    window.Transparency = 0.2
    window.Anchored = true
    window.Parent = parent
    return window
end

-- 创建入口门
local function createDoor(parent, position, size, color)
    local door = Instance.new("Part")
    door.Name = "Door"
    door.Size = size
    door.Position = position
    door.Material = Enum.Material.Glass
    door.Color = color or Color3.fromRGB(100, 100, 100)
    door.Transparency = 0.3
    door.Anchored = true
    door.Parent = parent
    return door
end

-- ==================== 通用商店模板 ====================

--[[
    通用商店创建函数
    
    config = {
        name = "商店名",
        width = 10,
        depth = 8,
        height = 5,
        wallColor = Color3.fromRGB(255, 255, 255),
        signColor = Color3.fromRGB(0, 100, 200),
        signText = "SHOP",
        signTextColor = Color3.fromRGB(255, 255, 255),
        hasAwning = true,  -- 是否有遮阳棚
        awningColor = Color3.fromRGB(200, 50, 50),
    }
]]
function ShopTemplates.createGenericShop(position, rotation, config)
    local shop = Instance.new("Model")
    shop.Name = config.name or "GenericShop"
    
    local WIDTH = config.width or 10
    local DEPTH = config.depth or 8
    local HEIGHT = config.height or 5
    
    -- 主体建筑
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(WIDTH, HEIGHT, DEPTH)
    body.Position = position + Vector3.new(0, HEIGHT/2, 0)
    body.Material = Enum.Material.Concrete
    body.Color = config.wallColor or Color3.fromRGB(240, 240, 240)
    body.Anchored = true
    body.Parent = shop
    
    -- 设置 PrimaryPart
    shop.PrimaryPart = body
    
    -- 大玻璃橱窗
    createShopWindow(
        shop,
        position + Vector3.new(-WIDTH/4, 2, -DEPTH/2 - 0.05),
        Vector3.new(WIDTH/2 - 1, 3, 0.1)
    )
    
    -- 入口门（右侧）
    createDoor(
        shop,
        position + Vector3.new(WIDTH/4, 1.5, -DEPTH/2 - 0.05),
        Vector3.new(2, 2.8, 0.1),
        config.doorColor
    )
    
    -- 招牌
    createSign(
        shop,
        position + Vector3.new(0, HEIGHT - 0.6, -DEPTH/2 - 0.15),
        Vector3.new(WIDTH - 0.5, 1.2, 0.3),
        config.signColor or Color3.fromRGB(0, 100, 200),
        config.signText or config.name or "SHOP",
        config.signTextColor or Color3.fromRGB(255, 255, 255),
        config.signFont
    )
    
    -- 遮阳棚（可选）
    if config.hasAwning then
        local awning = Instance.new("Part")
        awning.Name = "Awning"
        awning.Size = Vector3.new(WIDTH, 0.1, 1.5)
        awning.Position = position + Vector3.new(0, HEIGHT - 1.8, -DEPTH/2 - 0.8)
        awning.Material = Enum.Material.Fabric
        awning.Color = config.awningColor or Color3.fromRGB(200, 50, 50)
        awning.Anchored = true
        awning.Parent = shop
        
        -- 遮阳棚支撑
        for _, xOff in ipairs({-WIDTH/2 + 0.3, WIDTH/2 - 0.3}) do
            local support = Instance.new("Part")
            support.Name = "AwningSupport"
            support.Size = Vector3.new(0.1, 0.1, 1.5)
            support.Position = position + Vector3.new(xOff, HEIGHT - 1.8, -DEPTH/2 - 0.8)
            support.Material = Enum.Material.Metal
            support.Color = Color3.fromRGB(60, 60, 60)
            support.Anchored = true
            support.Parent = shop
        end
    end
    
    -- 应用旋转
    if rotation and rotation ~= 0 then
        shop:SetPrimaryPartCFrame(
            CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0)
        )
    end
    
    shop.Parent = workspace.Buildings
    return shop
end

return ShopTemplates
```

---

# 第三部分：英国连锁超市模板

## 3.1 Tesco 超市

### 品牌参数
| 参数 | 值 |
|------|-----|
| 主色调 | 蓝色 #00539F |
| 辅助色 | 红色 #E2231A |
| 字体 | 粗体无衬线 |
| 特征 | 红蓝条纹、大型招牌 |

### Tesco Express（小型便利店）

```lua
function ShopTemplates.createTescoExpress(position, rotation)
    local shop = Instance.new("Model")
    shop.Name = "Tesco_Express"
    
    local WIDTH = 10
    local DEPTH = 8
    local HEIGHT = 4.5
    
    -- 品牌颜色
    local TESCO_BLUE = Color3.fromRGB(0, 83, 159)
    local TESCO_RED = Color3.fromRGB(226, 35, 26)
    local TESCO_WHITE = Color3.fromRGB(255, 255, 255)
    
    -- 主体（白色墙面）
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(WIDTH, HEIGHT, DEPTH)
    body.Position = position + Vector3.new(0, HEIGHT/2, 0)
    body.Material = Enum.Material.SmoothPlastic
    body.Color = TESCO_WHITE
    body.Anchored = true
    body.Parent = shop
    shop.PrimaryPart = body
    
    -- 蓝色顶部条带
    local blueStripe = Instance.new("Part")
    blueStripe.Name = "BlueStripe"
    blueStripe.Size = Vector3.new(WIDTH + 0.1, 0.8, DEPTH + 0.1)
    blueStripe.Position = position + Vector3.new(0, HEIGHT + 0.4, 0)
    blueStripe.Material = Enum.Material.SmoothPlastic
    blueStripe.Color = TESCO_BLUE
    blueStripe.Anchored = true
    blueStripe.Parent = shop
    
    -- Tesco 主招牌
    local mainSign = Instance.new("Part")
    mainSign.Name = "MainSign"
    mainSign.Size = Vector3.new(WIDTH - 1, 1.5, 0.3)
    mainSign.Position = position + Vector3.new(0, HEIGHT - 0.8, -DEPTH/2 - 0.2)
    mainSign.Material = Enum.Material.SmoothPlastic
    mainSign.Color = TESCO_BLUE
    mainSign.Anchored = true
    mainSign.Parent = shop
    
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    signGui.PixelsPerStud = 50
    signGui.Parent = mainSign
    
    -- Tesco logo 文字
    local logoFrame = Instance.new("Frame")
    logoFrame.Size = UDim2.new(1, 0, 1, 0)
    logoFrame.BackgroundTransparency = 1
    logoFrame.Parent = signGui
    
    local tescoText = Instance.new("TextLabel")
    tescoText.Size = UDim2.new(0.6, 0, 1, 0)
    tescoText.Position = UDim2.new(0, 0, 0, 0)
    tescoText.BackgroundTransparency = 1
    tescoText.Text = "Tesco"
    tescoText.TextColor3 = TESCO_WHITE
    tescoText.TextScaled = true
    tescoText.Font = Enum.Font.GothamBold
    tescoText.Parent = logoFrame
    
    local expressText = Instance.new("TextLabel")
    expressText.Size = UDim2.new(0.4, 0, 0.6, 0)
    expressText.Position = UDim2.new(0.58, 0, 0.2, 0)
    expressText.BackgroundTransparency = 1
    expressText.Text = "Express"
    expressText.TextColor3 = TESCO_RED
    expressText.TextScaled = true
    expressText.Font = Enum.Font.GothamBold
    expressText.Parent = logoFrame
    
    -- 红色条纹装饰（Tesco 特色）
    local redStripes = Instance.new("Part")
    redStripes.Name = "RedStripes"
    redStripes.Size = Vector3.new(WIDTH, 0.15, 0.05)
    redStripes.Position = position + Vector3.new(0, HEIGHT - 2.2, -DEPTH/2 - 0.05)
    redStripes.Material = Enum.Material.SmoothPlastic
    redStripes.Color = TESCO_RED
    redStripes.Anchored = true
    redStripes.Parent = shop
    
    -- 大玻璃橱窗
    local shopWindow = Instance.new("Part")
    shopWindow.Name = "ShopWindow"
    shopWindow.Size = Vector3.new(WIDTH - 2.5, 2.8, 0.1)
    shopWindow.Position = position + Vector3.new(-0.5, 1.6, -DEPTH/2 - 0.05)
    shopWindow.Material = Enum.Material.Glass
    shopWindow.Color = Color3.fromRGB(200, 220, 240)
    shopWindow.Transparency = 0.15
    shopWindow.Anchored = true
    shopWindow.Parent = shop
    
    -- 自动门
    local door = Instance.new("Part")
    door.Name = "AutoDoor"
    door.Size = Vector3.new(2, 2.8, 0.1)
    door.Position = position + Vector3.new(WIDTH/2 - 1.5, 1.6, -DEPTH/2 - 0.05)
    door.Material = Enum.Material.Glass
    door.Color = Color3.fromRGB(150, 150, 150)
    door.Transparency = 0.2
    door.Anchored = true
    door.Parent = shop
    
    -- 门上方的 "Express" 小标志
    local doorSign = Instance.new("Part")
    doorSign.Name = "DoorSign"
    doorSign.Size = Vector3.new(2, 0.4, 0.1)
    doorSign.Position = position + Vector3.new(WIDTH/2 - 1.5, 3.2, -DEPTH/2 - 0.1)
    doorSign.Material = Enum.Material.SmoothPlastic
    doorSign.Color = TESCO_RED
    doorSign.Anchored = true
    doorSign.Parent = shop
    
    -- ATM 机（Tesco Express 通常有）
    local atm = Instance.new("Part")
    atm.Name = "ATM"
    atm.Size = Vector3.new(0.8, 1.5, 0.4)
    atm.Position = position + Vector3.new(-WIDTH/2 + 0.6, 1, -DEPTH/2 - 0.25)
    atm.Material = Enum.Material.Metal
    atm.Color = Color3.fromRGB(50, 50, 50)
    atm.Anchored = true
    atm.Parent = shop
    
    -- 应用旋转
    if rotation and rotation ~= 0 then
        shop:SetPrimaryPartCFrame(
            CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0)
        )
    end
    
    shop.Parent = workspace.Buildings
    return shop
end
```

## 3.2 Sainsbury's 超市

### 品牌参数
| 参数 | 值 |
|------|-----|
| 主色调 | 橙色 #F06C00 |
| 字体颜色 | 橙色 |
| 背景 | 白色 |
| 特征 | 简洁橙色 logo |

```lua
function ShopTemplates.createSainsburysLocal(position, rotation)
    local shop = Instance.new("Model")
    shop.Name = "Sainsburys_Local"
    
    local WIDTH = 10
    local DEPTH = 8
    local HEIGHT = 4.5
    
    -- 品牌颜色
    local SAINSBURYS_ORANGE = Color3.fromRGB(240, 108, 0)
    local SAINSBURYS_WHITE = Color3.fromRGB(255, 255, 255)
    
    -- 主体
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(WIDTH, HEIGHT, DEPTH)
    body.Position = position + Vector3.new(0, HEIGHT/2, 0)
    body.Material = Enum.Material.SmoothPlastic
    body.Color = SAINSBURYS_WHITE
    body.Anchored = true
    body.Parent = shop
    shop.PrimaryPart = body
    
    -- 橙色顶部装饰条
    local orangeStrip = Instance.new("Part")
    orangeStrip.Name = "OrangeStrip"
    orangeStrip.Size = Vector3.new(WIDTH + 0.1, 0.3, 0.1)
    orangeStrip.Position = position + Vector3.new(0, HEIGHT - 1.5, -DEPTH/2 - 0.1)
    orangeStrip.Material = Enum.Material.SmoothPlastic
    orangeStrip.Color = SAINSBURYS_ORANGE
    orangeStrip.Anchored = true
    orangeStrip.Parent = shop
    
    -- Sainsbury's 招牌
    local mainSign = Instance.new("Part")
    mainSign.Name = "MainSign"
    mainSign.Size = Vector3.new(WIDTH - 1, 1.2, 0.2)
    mainSign.Position = position + Vector3.new(0, HEIGHT - 0.7, -DEPTH/2 - 0.15)
    mainSign.Material = Enum.Material.SmoothPlastic
    mainSign.Color = SAINSBURYS_WHITE
    mainSign.Anchored = true
    mainSign.Parent = shop
    
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    signGui.PixelsPerStud = 50
    signGui.Parent = mainSign
    
    local logoFrame = Instance.new("Frame")
    logoFrame.Size = UDim2.new(1, 0, 1, 0)
    logoFrame.BackgroundTransparency = 1
    logoFrame.Parent = signGui
    
    -- Sainsbury's 文字
    local nameText = Instance.new("TextLabel")
    nameText.Size = UDim2.new(0.7, 0, 1, 0)
    nameText.Position = UDim2.new(0, 0, 0, 0)
    nameText.BackgroundTransparency = 1
    nameText.Text = "Sainsbury's"
    nameText.TextColor3 = SAINSBURYS_ORANGE
    nameText.TextScaled = true
    nameText.Font = Enum.Font.GothamBold
    nameText.Parent = logoFrame
    
    local localText = Instance.new("TextLabel")
    localText.Size = UDim2.new(0.3, 0, 0.6, 0)
    localText.Position = UDim2.new(0.68, 0, 0.2, 0)
    localText.BackgroundTransparency = 1
    localText.Text = "Local"
    localText.TextColor3 = SAINSBURYS_ORANGE
    localText.TextScaled = true
    localText.Font = Enum.Font.Gotham
    localText.Parent = logoFrame
    
    -- 橱窗和门（与 Tesco 类似结构）
    local shopWindow = Instance.new("Part")
    shopWindow.Name = "ShopWindow"
    shopWindow.Size = Vector3.new(WIDTH - 2.5, 2.8, 0.1)
    shopWindow.Position = position + Vector3.new(-0.5, 1.6, -DEPTH/2 - 0.05)
    shopWindow.Material = Enum.Material.Glass
    shopWindow.Color = Color3.fromRGB(200, 220, 240)
    shopWindow.Transparency = 0.15
    shopWindow.Anchored = true
    shopWindow.Parent = shop
    
    local door = Instance.new("Part")
    door.Name = "Door"
    door.Size = Vector3.new(2, 2.8, 0.1)
    door.Position = position + Vector3.new(WIDTH/2 - 1.5, 1.6, -DEPTH/2 - 0.05)
    door.Material = Enum.Material.Glass
    door.Color = Color3.fromRGB(150, 150, 150)
    door.Transparency = 0.2
    door.Anchored = true
    door.Parent = shop
    
    -- 应用旋转
    if rotation and rotation ~= 0 then
        shop:SetPrimaryPartCFrame(
            CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0)
        )
    end
    
    shop.Parent = workspace.Buildings
    return shop
end
```

## 3.3 M&S Simply Food

```lua
function ShopTemplates.createMSSimplyFood(position, rotation)
    local shop = Instance.new("Model")
    shop.Name = "MS_Simply_Food"
    
    local WIDTH = 12
    local DEPTH = 10
    local HEIGHT = 5
    
    -- 品牌颜色
    local MS_GREEN = Color3.fromRGB(0, 75, 35)
    local MS_BLACK = Color3.fromRGB(0, 0, 0)
    local MS_WHITE = Color3.fromRGB(255, 255, 255)
    
    -- 主体
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(WIDTH, HEIGHT, DEPTH)
    body.Position = position + Vector3.new(0, HEIGHT/2, 0)
    body.Material = Enum.Material.SmoothPlastic
    body.Color = MS_BLACK
    body.Anchored = true
    body.Parent = shop
    shop.PrimaryPart = body
    
    -- M&S 绿色主招牌
    local mainSign = Instance.new("Part")
    mainSign.Name = "MainSign"
    mainSign.Size = Vector3.new(WIDTH, 1.5, 0.3)
    mainSign.Position = position + Vector3.new(0, HEIGHT - 0.8, -DEPTH/2 - 0.2)
    mainSign.Material = Enum.Material.SmoothPlastic
    mainSign.Color = MS_GREEN
    mainSign.Anchored = true
    mainSign.Parent = shop
    
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    signGui.PixelsPerStud = 50
    signGui.Parent = mainSign
    
    local logoFrame = Instance.new("Frame")
    logoFrame.Size = UDim2.new(1, 0, 1, 0)
    logoFrame.BackgroundTransparency = 1
    logoFrame.Parent = signGui
    
    -- M&S logo
    local msText = Instance.new("TextLabel")
    msText.Size = UDim2.new(0.3, 0, 1, 0)
    msText.Position = UDim2.new(0.1, 0, 0, 0)
    msText.BackgroundTransparency = 1
    msText.Text = "M&S"
    msText.TextColor3 = MS_WHITE
    msText.TextScaled = true
    msText.Font = Enum.Font.GothamBold
    msText.Parent = logoFrame
    
    local simplyText = Instance.new("TextLabel")
    simplyText.Size = UDim2.new(0.5, 0, 0.6, 0)
    simplyText.Position = UDim2.new(0.4, 0, 0.2, 0)
    simplyText.BackgroundTransparency = 1
    simplyText.Text = "Simply Food"
    simplyText.TextColor3 = MS_WHITE
    simplyText.TextScaled = true
    simplyText.Font = Enum.Font.Gotham
    simplyText.Parent = logoFrame
    
    -- 大型玻璃幕墙
    local shopWindow = Instance.new("Part")
    shopWindow.Name = "ShopWindow"
    shopWindow.Size = Vector3.new(WIDTH - 0.5, 3.2, 0.1)
    shopWindow.Position = position + Vector3.new(0, 1.8, -DEPTH/2 - 0.05)
    shopWindow.Material = Enum.Material.Glass
    shopWindow.Color = Color3.fromRGB(180, 200, 220)
    shopWindow.Transparency = 0.1
    shopWindow.Anchored = true
    shopWindow.Parent = shop
    
    -- 应用旋转
    if rotation and rotation ~= 0 then
        shop:SetPrimaryPartCFrame(
            CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0)
        )
    end
    
    shop.Parent = workspace.Buildings
    return shop
end
```

---

# 第四部分：咖啡店模板

## 4.1 Costa Coffee

### 品牌参数
| 参数 | 值 |
|------|-----|
| 主色调 | 深红/褐红 #6E1C34 |
| 辅助色 | 奶油白 |
| 字体 | 手写风格 |
| 特征 | 咖啡杯 logo、温馨氛围 |

```lua
function ShopTemplates.createCosta(position, rotation)
    local shop = Instance.new("Model")
    shop.Name = "Costa_Coffee"
    
    local WIDTH = 8
    local DEPTH = 7
    local HEIGHT = 4
    
    -- 品牌颜色
    local COSTA_RED = Color3.fromRGB(110, 28, 52)
    local COSTA_CREAM = Color3.fromRGB(245, 235, 220)
    local COSTA_WHITE = Color3.fromRGB(255, 255, 255)
    
    -- 主体
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(WIDTH, HEIGHT, DEPTH)
    body.Position = position + Vector3.new(0, HEIGHT/2, 0)
    body.Material = Enum.Material.Brick
    body.Color = COSTA_CREAM
    body.Anchored = true
    body.Parent = shop
    shop.PrimaryPart = body
    
    -- Costa 深红色招牌
    local mainSign = Instance.new("Part")
    mainSign.Name = "MainSign"
    mainSign.Size = Vector3.new(WIDTH - 0.5, 1.2, 0.25)
    mainSign.Position = position + Vector3.new(0, HEIGHT - 0.7, -DEPTH/2 - 0.2)
    mainSign.Material = Enum.Material.SmoothPlastic
    mainSign.Color = COSTA_RED
    mainSign.Anchored = true
    mainSign.Parent = shop
    
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    signGui.PixelsPerStud = 50
    signGui.Parent = mainSign
    
    local costaText = Instance.new("TextLabel")
    costaText.Size = UDim2.new(1, 0, 1, 0)
    costaText.BackgroundTransparency = 1
    costaText.Text = "Costa Coffee"
    costaText.TextColor3 = COSTA_WHITE
    costaText.TextScaled = true
    costaText.Font = Enum.Font.Merriweather  -- 接近 Costa 字体
    costaText.Parent = signGui
    
    -- 咖啡杯 logo（简化版 - 用圆形）
    local cupLogo = Instance.new("Part")
    cupLogo.Name = "CupLogo"
    cupLogo.Shape = Enum.PartType.Cylinder
    cupLogo.Size = Vector3.new(0.1, 0.8, 0.8)
    cupLogo.Position = position + Vector3.new(-WIDTH/2 + 1, HEIGHT - 0.7, -DEPTH/2 - 0.35)
    cupLogo.Orientation = Vector3.new(0, 0, 90)
    cupLogo.Material = Enum.Material.SmoothPlastic
    cupLogo.Color = COSTA_WHITE
    cupLogo.Anchored = true
    cupLogo.Parent = shop
    
    -- 大玻璃窗（咖啡店特色：让人看到里面）
    local shopWindow = Instance.new("Part")
    shopWindow.Name = "ShopWindow"
    shopWindow.Size = Vector3.new(WIDTH - 2, 2.5, 0.1)
    shopWindow.Position = position + Vector3.new(-0.5, 1.5, -DEPTH/2 - 0.05)
    shopWindow.Material = Enum.Material.Glass
    shopWindow.Color = Color3.fromRGB(220, 230, 240)
    shopWindow.Transparency = 0.15
    shopWindow.Anchored = true
    shopWindow.Parent = shop
    
    -- 入口门
    local door = Instance.new("Part")
    door.Name = "Door"
    door.Size = Vector3.new(1.5, 2.5, 0.1)
    door.Position = position + Vector3.new(WIDTH/2 - 1.2, 1.5, -DEPTH/2 - 0.05)
    door.Material = Enum.Material.Glass
    door.Color = Color3.fromRGB(160, 140, 130)
    door.Transparency = 0.2
    door.Anchored = true
    door.Parent = shop
    
    -- 遮阳棚（Costa 特色）
    local awning = Instance.new("Part")
    awning.Name = "Awning"
    awning.Size = Vector3.new(WIDTH - 0.5, 0.1, 1.2)
    awning.Position = position + Vector3.new(0, HEIGHT - 1.8, -DEPTH/2 - 0.65)
    awning.Material = Enum.Material.Fabric
    awning.Color = COSTA_RED
    awning.Anchored = true
    awning.Parent = shop
    
    -- 户外座位区（小桌椅）
    for i = 1, 2 do
        local table = Instance.new("Part")
        table.Name = "OutdoorTable" .. i
        table.Shape = Enum.PartType.Cylinder
        table.Size = Vector3.new(0.5, 0.6, 0.6)
        table.Position = position + Vector3.new(-WIDTH/4 + (i-1) * 2.5, 0.4, -DEPTH/2 - 2)
        table.Material = Enum.Material.Metal
        table.Color = Color3.fromRGB(70, 70, 70)
        table.Anchored = true
        table.Parent = shop
        
        -- 椅子
        for j = 1, 2 do
            local chair = Instance.new("Part")
            chair.Name = "Chair"
            chair.Size = Vector3.new(0.4, 0.5, 0.4)
            chair.Position = position + Vector3.new(
                -WIDTH/4 + (i-1) * 2.5 + (j == 1 and -0.5 or 0.5),
                0.25,
                -DEPTH/2 - 2
            )
            chair.Material = Enum.Material.Metal
            chair.Color = Color3.fromRGB(60, 60, 60)
            chair.Anchored = true
            chair.Parent = shop
        end
    end
    
    -- 应用旋转
    if rotation and rotation ~= 0 then
        shop:SetPrimaryPartCFrame(
            CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0)
        )
    end
    
    shop.Parent = workspace.Buildings
    return shop
end
```

## 4.2 Starbucks 星巴克

### 品牌参数
| 参数 | 值 |
|------|-----|
| 主色调 | 绿色 #00704A |
| 辅助色 | 白色、黑色 |
| 字体 | 简洁无衬线 |
| 特征 | 圆形绿色 logo |

```lua
function ShopTemplates.createStarbucks(position, rotation)
    local shop = Instance.new("Model")
    shop.Name = "Starbucks"
    
    local WIDTH = 9
    local DEPTH = 8
    local HEIGHT = 4.5
    
    -- 品牌颜色
    local STARBUCKS_GREEN = Color3.fromRGB(0, 112, 74)
    local STARBUCKS_WHITE = Color3.fromRGB(255, 255, 255)
    local STARBUCKS_BLACK = Color3.fromRGB(30, 30, 30)
    
    -- 主体（现代风格，深色）
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(WIDTH, HEIGHT, DEPTH)
    body.Position = position + Vector3.new(0, HEIGHT/2, 0)
    body.Material = Enum.Material.SmoothPlastic
    body.Color = STARBUCKS_BLACK
    body.Anchored = true
    body.Parent = shop
    shop.PrimaryPart = body
    
    -- 绿色圆形 logo（Starbucks 标志性）
    local logo = Instance.new("Part")
    logo.Name = "Logo"
    logo.Shape = Enum.PartType.Cylinder
    logo.Size = Vector3.new(0.15, 1.5, 1.5)
    logo.Position = position + Vector3.new(-WIDTH/3, HEIGHT - 1.2, -DEPTH/2 - 0.15)
    logo.Orientation = Vector3.new(0, 0, 90)
    logo.Material = Enum.Material.SmoothPlastic
    logo.Color = STARBUCKS_GREEN
    logo.Anchored = true
    logo.Parent = shop
    
    -- logo 内圈（白色）
    local logoInner = Instance.new("Part")
    logoInner.Name = "LogoInner"
    logoInner.Shape = Enum.PartType.Cylinder
    logoInner.Size = Vector3.new(0.05, 1.2, 1.2)
    logoInner.Position = position + Vector3.new(-WIDTH/3, HEIGHT - 1.2, -DEPTH/2 - 0.2)
    logoInner.Orientation = Vector3.new(0, 0, 90)
    logoInner.Material = Enum.Material.SmoothPlastic
    logoInner.Color = STARBUCKS_WHITE
    logoInner.Anchored = true
    logoInner.Parent = shop
    
    -- STARBUCKS 文字招牌
    local textSign = Instance.new("Part")
    textSign.Name = "TextSign"
    textSign.Size = Vector3.new(4, 0.8, 0.1)
    textSign.Position = position + Vector3.new(WIDTH/6, HEIGHT - 1.2, -DEPTH/2 - 0.1)
    textSign.Material = Enum.Material.SmoothPlastic
    textSign.Color = STARBUCKS_BLACK
    textSign.Anchored = true
    textSign.Parent = shop
    
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    signGui.PixelsPerStud = 80
    signGui.Parent = textSign
    
    local starbucksText = Instance.new("TextLabel")
    starbucksText.Size = UDim2.new(1, 0, 1, 0)
    starbucksText.BackgroundTransparency = 1
    starbucksText.Text = "STARBUCKS"
    starbucksText.TextColor3 = STARBUCKS_GREEN
    starbucksText.TextScaled = true
    starbucksText.Font = Enum.Font.GothamBold
    starbucksText.Parent = signGui
    
    -- 全玻璃幕墙（Starbucks 现代风格）
    local glassWall = Instance.new("Part")
    glassWall.Name = "GlassWall"
    glassWall.Size = Vector3.new(WIDTH - 0.2, 3, 0.1)
    glassWall.Position = position + Vector3.new(0, 1.7, -DEPTH/2 - 0.05)
    glassWall.Material = Enum.Material.Glass
    glassWall.Color = Color3.fromRGB(180, 200, 220)
    glassWall.Transparency = 0.1
    glassWall.Anchored = true
    glassWall.Parent = shop
    
    -- 玻璃门
    local door = Instance.new("Part")
    door.Name = "Door"
    door.Size = Vector3.new(2, 3, 0.1)
    door.Position = position + Vector3.new(0, 1.7, -DEPTH/2 - 0.06)
    door.Material = Enum.Material.Glass
    door.Color = Color3.fromRGB(100, 100, 100)
    door.Transparency = 0.15
    door.Anchored = true
    door.Parent = shop
    
    -- 门把手
    for _, xOff in ipairs({-0.6, 0.6}) do
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(0.05, 0.4, 0.05)
        handle.Position = position + Vector3.new(xOff, 1.5, -DEPTH/2 - 0.15)
        handle.Material = Enum.Material.Metal
        handle.Color = Color3.fromRGB(180, 160, 140)
        handle.Anchored = true
        handle.Parent = shop
    end
    
    -- 户外座位（高脚凳风格）
    for i = 1, 3 do
        local stool = Instance.new("Part")
        stool.Name = "Stool" .. i
        stool.Shape = Enum.PartType.Cylinder
        stool.Size = Vector3.new(0.4, 0.35, 0.35)
        stool.Position = position + Vector3.new(-WIDTH/2 + i * 2, 0.75, -DEPTH/2 - 1.5)
        stool.Material = Enum.Material.Wood
        stool.Color = Color3.fromRGB(80, 60, 40)
        stool.Anchored = true
        stool.Parent = shop
        
        local stoolLeg = Instance.new("Part")
        stoolLeg.Name = "StoolLeg"
        stoolLeg.Size = Vector3.new(0.1, 0.55, 0.1)
        stoolLeg.Position = position + Vector3.new(-WIDTH/2 + i * 2, 0.3, -DEPTH/2 - 1.5)
        stoolLeg.Material = Enum.Material.Metal
        stoolLeg.Color = Color3.fromRGB(50, 50, 50)
        stoolLeg.Anchored = true
        stoolLeg.Parent = shop
    end
    
    -- 窗边吧台
    local counterBar = Instance.new("Part")
    counterBar.Name = "CounterBar"
    counterBar.Size = Vector3.new(6, 0.1, 0.5)
    counterBar.Position = position + Vector3.new(0, 1.1, -DEPTH/2 - 1.5)
    counterBar.Material = Enum.Material.Wood
    counterBar.Color = Color3.fromRGB(60, 45, 30)
    counterBar.Anchored = true
    counterBar.Parent = shop
    
    -- 应用旋转
    if rotation and rotation ~= 0 then
        shop:SetPrimaryPartCFrame(
            CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0)
        )
    end
    
    shop.Parent = workspace.Buildings
    return shop
end
```

---

# 第五部分：快餐店模板

## 5.1 McDonald's 麦当劳

### 品牌参数
| 参数 | 值 |
|------|-----|
| 主色调 | 红色 #DA291C + 黄色 #FFC72C |
| 建筑色 | 棕色/米色 |
| 特征 | 金色拱门 M |

```lua
function ShopTemplates.createMcDonalds(position, rotation)
    local shop = Instance.new("Model")
    shop.Name = "McDonalds"
    
    local WIDTH = 15
    local DEPTH = 12
    local HEIGHT = 5
    
    -- 品牌颜色
    local MCD_RED = Color3.fromRGB(218, 41, 28)
    local MCD_YELLOW = Color3.fromRGB(255, 199, 44)
    local MCD_BROWN = Color3.fromRGB(100, 80, 60)
    local MCD_WHITE = Color3.fromRGB(255, 255, 255)
    
    -- 主体（米色/棕色）
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(WIDTH, HEIGHT, DEPTH)
    body.Position = position + Vector3.new(0, HEIGHT/2, 0)
    body.Material = Enum.Material.SmoothPlastic
    body.Color = Color3.fromRGB(230, 220, 200)
    body.Anchored = true
    body.Parent = shop
    shop.PrimaryPart = body
    
    -- 红色装饰条带
    local redStrip = Instance.new("Part")
    redStrip.Name = "RedStrip"
    redStrip.Size = Vector3.new(WIDTH + 0.1, 1, 0.1)
    redStrip.Position = position + Vector3.new(0, HEIGHT - 1.5, -DEPTH/2 - 0.1)
    redStrip.Material = Enum.Material.SmoothPlastic
    redStrip.Color = MCD_RED
    redStrip.Anchored = true
    redStrip.Parent = shop
    
    -- 金色拱门 M（用两个弯曲的部分）
    -- 简化版：用两个倾斜的 Part 组成 M
    local archHeight = 2.5
    local archWidth = 1.2
    
    -- 左拱门
    local archLeft = Instance.new("Part")
    archLeft.Name = "ArchLeft"
    archLeft.Size = Vector3.new(0.3, archHeight, 0.3)
    archLeft.Position = position + Vector3.new(-archWidth/2, HEIGHT + archHeight/2 - 0.5, -DEPTH/2 - 0.5)
    archLeft.Orientation = Vector3.new(0, 0, 15)
    archLeft.Material = Enum.Material.Neon
    archLeft.Color = MCD_YELLOW
    archLeft.Anchored = true
    archLeft.Parent = shop
    
    -- 右拱门
    local archRight = Instance.new("Part")
    archRight.Name = "ArchRight"
    archRight.Size = Vector3.new(0.3, archHeight, 0.3)
    archRight.Position = position + Vector3.new(archWidth/2, HEIGHT + archHeight/2 - 0.5, -DEPTH/2 - 0.5)
    archRight.Orientation = Vector3.new(0, 0, -15)
    archRight.Material = Enum.Material.Neon
    archRight.Color = MCD_YELLOW
    archRight.Anchored = true
    archRight.Parent = shop
    
    -- McDonald's 文字招牌
    local textSign = Instance.new("Part")
    textSign.Name = "TextSign"
    textSign.Size = Vector3.new(6, 0.8, 0.2)
    textSign.Position = position + Vector3.new(3, HEIGHT - 0.5, -DEPTH/2 - 0.15)
    textSign.Material = Enum.Material.SmoothPlastic
    textSign.Color = MCD_RED
    textSign.Anchored = true
    textSign.Parent = shop
    
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    signGui.PixelsPerStud = 50
    signGui.Parent = textSign
    
    local mcdText = Instance.new("TextLabel")
    mcdText.Size = UDim2.new(1, 0, 1, 0)
    mcdText.BackgroundTransparency = 1
    mcdText.Text = "McDonald's"
    mcdText.TextColor3 = MCD_YELLOW
    mcdText.TextScaled = true
    mcdText.Font = Enum.Font.GothamBold
    mcdText.Parent = signGui
    
    -- 大玻璃幕墙
    local glassWall = Instance.new("Part")
    glassWall.Name = "GlassWall"
    glassWall.Size = Vector3.new(WIDTH - 2, 3.5, 0.1)
    glassWall.Position = position + Vector3.new(0, 2, -DEPTH/2 - 0.05)
    glassWall.Material = Enum.Material.Glass
    glassWall.Color = Color3.fromRGB(200, 220, 240)
    glassWall.Transparency = 0.1
    glassWall.Anchored = true
    glassWall.Parent = shop
    
    -- 入口门（双开门）
    for _, xOff in ipairs({-1.2, 1.2}) do
        local door = Instance.new("Part")
        door.Name = "Door"
        door.Size = Vector3.new(1.5, 3, 0.1)
        door.Position = position + Vector3.new(xOff, 1.7, -DEPTH/2 - 0.06)
        door.Material = Enum.Material.Glass
        door.Color = Color3.fromRGB(120, 120, 120)
        door.Transparency = 0.2
        door.Anchored = true
        door.Parent = shop
    end
    
    -- Drive-Thru 窗口（麦当劳特色）
    local driveThruSign = Instance.new("Part")
    driveThruSign.Name = "DriveThruSign"
    driveThruSign.Size = Vector3.new(3, 0.6, 0.1)
    driveThruSign.Position = position + Vector3.new(WIDTH/2 - 0.1, 2.5, 0)
    driveThruSign.Orientation = Vector3.new(0, 90, 0)
    driveThruSign.Material = Enum.Material.SmoothPlastic
    driveThruSign.Color = MCD_YELLOW
    driveThruSign.Anchored = true
    driveThruSign.Parent = shop
    
    local dtGui = Instance.new("SurfaceGui")
    dtGui.Face = Enum.NormalId.Front
    dtGui.Parent = driveThruSign
    
    local dtText = Instance.new("TextLabel")
    dtText.Size = UDim2.new(1, 0, 1, 0)
    dtText.BackgroundTransparency = 1
    dtText.Text = "DRIVE THRU"
    dtText.TextColor3 = MCD_RED
    dtText.TextScaled = true
    dtText.Font = Enum.Font.GothamBold
    dtText.Parent = dtGui
    
    -- Drive-Thru 窗口
    local dtWindow = Instance.new("Part")
    dtWindow.Name = "DriveThruWindow"
    dtWindow.Size = Vector3.new(0.1, 1.5, 1.5)
    dtWindow.Position = position + Vector3.new(WIDTH/2 - 0.05, 1.5, -2)
    dtWindow.Material = Enum.Material.Glass
    dtWindow.Color = Color3.fromRGB(150, 180, 200)
    dtWindow.Transparency = 0.2
    dtWindow.Anchored = true
    dtWindow.Parent = shop
    
    -- 应用旋转
    if rotation and rotation ~= 0 then
        shop:SetPrimaryPartCFrame(
            CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0)
        )
    end
    
    shop.Parent = workspace.Buildings
    return shop
end
```

## 5.2 KFC 肯德基

### 品牌参数
| 参数 | 值 |
|------|-----|
| 主色调 | 红色 #E4002B |
| 辅助色 | 白色 |
| 特征 | Colonel Sanders 头像、红白条纹桶 |

```lua
function ShopTemplates.createKFC(position, rotation)
    local shop = Instance.new("Model")
    shop.Name = "KFC"
    
    local WIDTH = 12
    local DEPTH = 10
    local HEIGHT = 5
    
    -- 品牌颜色
    local KFC_RED = Color3.fromRGB(228, 0, 43)
    local KFC_WHITE = Color3.fromRGB(255, 255, 255)
    local KFC_BLACK = Color3.fromRGB(0, 0, 0)
    
    -- 主体
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(WIDTH, HEIGHT, DEPTH)
    body.Position = position + Vector3.new(0, HEIGHT/2, 0)
    body.Material = Enum.Material.SmoothPlastic
    body.Color = KFC_WHITE
    body.Anchored = true
    body.Parent = shop
    shop.PrimaryPart = body
    
    -- 红色顶部边框
    local redTop = Instance.new("Part")
    redTop.Name = "RedTop"
    redTop.Size = Vector3.new(WIDTH + 0.1, 0.5, DEPTH + 0.1)
    redTop.Position = position + Vector3.new(0, HEIGHT + 0.25, 0)
    redTop.Material = Enum.Material.SmoothPlastic
    redTop.Color = KFC_RED
    redTop.Anchored = true
    redTop.Parent = shop
    
    -- KFC 招牌（红底白字）
    local mainSign = Instance.new("Part")
    mainSign.Name = "MainSign"
    mainSign.Size = Vector3.new(WIDTH - 1, 1.5, 0.3)
    mainSign.Position = position + Vector3.new(0, HEIGHT - 0.8, -DEPTH/2 - 0.2)
    mainSign.Material = Enum.Material.SmoothPlastic
    mainSign.Color = KFC_RED
    mainSign.Anchored = true
    mainSign.Parent = shop
    
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    signGui.PixelsPerStud = 50
    signGui.Parent = mainSign
    
    local kfcText = Instance.new("TextLabel")
    kfcText.Size = UDim2.new(1, 0, 1, 0)
    kfcText.BackgroundTransparency = 1
    kfcText.Text = "KFC"
    kfcText.TextColor3 = KFC_WHITE
    kfcText.TextScaled = true
    kfcText.Font = Enum.Font.GothamBlack
    kfcText.Parent = signGui
    
    -- Colonel Sanders 头像（简化：圆形）
    local colonelLogo = Instance.new("Part")
    colonelLogo.Name = "ColonelLogo"
    colonelLogo.Shape = Enum.PartType.Cylinder
    colonelLogo.Size = Vector3.new(0.1, 1.2, 1.2)
    colonelLogo.Position = position + Vector3.new(WIDTH/2 - 1, HEIGHT - 0.8, -DEPTH/2 - 0.35)
    colonelLogo.Orientation = Vector3.new(0, 0, 90)
    colonelLogo.Material = Enum.Material.SmoothPlastic
    colonelLogo.Color = KFC_WHITE
    colonelLogo.Anchored = true
    colonelLogo.Parent = shop
    
    -- 红色边框
    local colonelRing = Instance.new("Part")
    colonelRing.Name = "ColonelRing"
    colonelRing.Shape = Enum.PartType.Cylinder
    colonelRing.Size = Vector3.new(0.05, 1.4, 1.4)
    colonelRing.Position = position + Vector3.new(WIDTH/2 - 1, HEIGHT - 0.8, -DEPTH/2 - 0.38)
    colonelRing.Orientation = Vector3.new(0, 0, 90)
    colonelRing.Material = Enum.Material.SmoothPlastic
    colonelRing.Color = KFC_RED
    colonelRing.Anchored = true
    colonelRing.Parent = shop
    
    -- 大玻璃橱窗
    local shopWindow = Instance.new("Part")
    shopWindow.Name = "ShopWindow"
    shopWindow.Size = Vector3.new(WIDTH - 2.5, 3, 0.1)
    shopWindow.Position = position + Vector3.new(-0.5, 1.8, -DEPTH/2 - 0.05)
    shopWindow.Material = Enum.Material.Glass
    shopWindow.Color = Color3.fromRGB(200, 220, 240)
    shopWindow.Transparency = 0.15
    shopWindow.Anchored = true
    shopWindow.Parent = shop
    
    -- 入口门
    local door = Instance.new("Part")
    door.Name = "Door"
    door.Size = Vector3.new(2.2, 3, 0.1)
    door.Position = position + Vector3.new(WIDTH/2 - 1.5, 1.8, -DEPTH/2 - 0.05)
    door.Material = Enum.Material.Glass
    door.Color = Color3.fromRGB(150, 150, 150)
    door.Transparency = 0.2
    door.Anchored = true
    door.Parent = shop
    
    -- 红白条纹装饰桶（KFC 特色，作为装饰）
    local bucketDecor = Instance.new("Part")
    bucketDecor.Name = "BucketDecor"
    bucketDecor.Shape = Enum.PartType.Cylinder
    bucketDecor.Size = Vector3.new(1.5, 1, 1)
    bucketDecor.Position = position + Vector3.new(-WIDTH/2 + 1, 1, -DEPTH/2 - 1)
    bucketDecor.Material = Enum.Material.SmoothPlastic
    bucketDecor.Color = KFC_RED
    bucketDecor.Anchored = true
    bucketDecor.Parent = shop
    
    -- 应用旋转
    if rotation and rotation ~= 0 then
        shop:SetPrimaryPartCFrame(
            CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0)
        )
    end
    
    shop.Parent = workspace.Buildings
    return shop
end
```

## 5.3 Greggs（英国特色）

### 品牌参数
| 参数 | 值 |
|------|-----|
| 主色调 | 橙色 #FF6600 + 蓝色 |
| 特征 | 面包店/快餐混合 |

```lua
function ShopTemplates.createGreggs(position, rotation)
    local shop = Instance.new("Model")
    shop.Name = "Greggs"
    
    local WIDTH = 8
    local DEPTH = 6
    local HEIGHT = 4
    
    -- 品牌颜色
    local GREGGS_ORANGE = Color3.fromRGB(255, 102, 0)
    local GREGGS_BLUE = Color3.fromRGB(0, 51, 102)
    local GREGGS_WHITE = Color3.fromRGB(255, 255, 255)
    
    -- 主体
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(WIDTH, HEIGHT, DEPTH)
    body.Position = position + Vector3.new(0, HEIGHT/2, 0)
    body.Material = Enum.Material.SmoothPlastic
    body.Color = GREGGS_WHITE
    body.Anchored = true
    body.Parent = shop
    shop.PrimaryPart = body
    
    -- 蓝色底部条带
    local blueStrip = Instance.new("Part")
    blueStrip.Name = "BlueStrip"
    blueStrip.Size = Vector3.new(WIDTH + 0.05, 0.5, 0.1)
    blueStrip.Position = position + Vector3.new(0, 0.25, -DEPTH/2 - 0.05)
    blueStrip.Material = Enum.Material.SmoothPlastic
    blueStrip.Color = GREGGS_BLUE
    blueStrip.Anchored = true
    blueStrip.Parent = shop
    
    -- Greggs 招牌（橙色）
    local mainSign = Instance.new("Part")
    mainSign.Name = "MainSign"
    mainSign.Size = Vector3.new(WIDTH - 0.5, 1, 0.2)
    mainSign.Position = position + Vector3.new(0, HEIGHT - 0.6, -DEPTH/2 - 0.15)
    mainSign.Material = Enum.Material.SmoothPlastic
    mainSign.Color = GREGGS_ORANGE
    mainSign.Anchored = true
    mainSign.Parent = shop
    
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    signGui.PixelsPerStud = 50
    signGui.Parent = mainSign
    
    local greggsText = Instance.new("TextLabel")
    greggsText.Size = UDim2.new(1, 0, 1, 0)
    greggsText.BackgroundTransparency = 1
    greggsText.Text = "Greggs"
    greggsText.TextColor3 = GREGGS_WHITE
    greggsText.TextScaled = true
    greggsText.Font = Enum.Font.GothamBold
    greggsText.Parent = signGui
    
    -- 橱窗（展示面包）
    local shopWindow = Instance.new("Part")
    shopWindow.Name = "ShopWindow"
    shopWindow.Size = Vector3.new(WIDTH - 2, 2.5, 0.1)
    shopWindow.Position = position + Vector3.new(-0.5, 1.5, -DEPTH/2 - 0.05)
    shopWindow.Material = Enum.Material.Glass
    shopWindow.Color = Color3.fromRGB(220, 230, 240)
    shopWindow.Transparency = 0.15
    shopWindow.Anchored = true
    shopWindow.Parent = shop
    
    -- 门
    local door = Instance.new("Part")
    door.Name = "Door"
    door.Size = Vector3.new(1.5, 2.5, 0.1)
    door.Position = position + Vector3.new(WIDTH/2 - 1, 1.5, -DEPTH/2 - 0.05)
    door.Material = Enum.Material.Glass
    door.Color = Color3.fromRGB(160, 160, 160)
    door.Transparency = 0.2
    door.Anchored = true
    door.Parent = shop
    
    -- 应用旋转
    if rotation and rotation ~= 0 then
        shop:SetPrimaryPartCFrame(
            CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0)
        )
    end
    
    shop.Parent = workspace.Buildings
    return shop
end
```

---

# 第六部分：其他常见店铺

## 6.1 Boots（药妆店）

```lua
function ShopTemplates.createBoots(position, rotation)
    return ShopTemplates.createGenericShop(position, rotation, {
        name = "Boots",
        width = 10,
        depth = 8,
        height = 5,
        wallColor = Color3.fromRGB(255, 255, 255),
        signColor = Color3.fromRGB(0, 60, 120),
        signText = "Boots",
        signTextColor = Color3.fromRGB(255, 255, 255),
        hasAwning = false
    })
end
```

## 6.2 WHSmith

```lua
function ShopTemplates.createWHSmith(position, rotation)
    return ShopTemplates.createGenericShop(position, rotation, {
        name = "WHSmith",
        width = 8,
        depth = 7,
        height = 4.5,
        wallColor = Color3.fromRGB(255, 255, 255),
        signColor = Color3.fromRGB(139, 0, 0),
        signText = "WHSmith",
        signTextColor = Color3.fromRGB(255, 255, 255),
        hasAwning = false
    })
end
```

## 6.3 Pret A Manger

```lua
function ShopTemplates.createPret(position, rotation)
    return ShopTemplates.createGenericShop(position, rotation, {
        name = "Pret_A_Manger",
        width = 9,
        depth = 8,
        height = 4.5,
        wallColor = Color3.fromRGB(50, 30, 20),
        signColor = Color3.fromRGB(120, 30, 40),
        signText = "Pret A Manger",
        signTextColor = Color3.fromRGB(255, 255, 255),
        hasAwning = true,
        awningColor = Color3.fromRGB(120, 30, 40)
    })
end
```

## 6.4 Subway

```lua
function ShopTemplates.createSubway(position, rotation)
    local shop = Instance.new("Model")
    shop.Name = "Subway"
    
    local WIDTH = 8
    local DEPTH = 7
    local HEIGHT = 4
    
    local SUBWAY_GREEN = Color3.fromRGB(0, 150, 57)
    local SUBWAY_YELLOW = Color3.fromRGB(255, 204, 0)
    local SUBWAY_WHITE = Color3.fromRGB(255, 255, 255)
    
    -- 主体
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(WIDTH, HEIGHT, DEPTH)
    body.Position = position + Vector3.new(0, HEIGHT/2, 0)
    body.Material = Enum.Material.SmoothPlastic
    body.Color = SUBWAY_WHITE
    body.Anchored = true
    body.Parent = shop
    shop.PrimaryPart = body
    
    -- 绿色招牌
    local mainSign = Instance.new("Part")
    mainSign.Name = "MainSign"
    mainSign.Size = Vector3.new(WIDTH - 0.5, 1.2, 0.25)
    mainSign.Position = position + Vector3.new(0, HEIGHT - 0.7, -DEPTH/2 - 0.2)
    mainSign.Material = Enum.Material.SmoothPlastic
    mainSign.Color = SUBWAY_GREEN
    mainSign.Anchored = true
    mainSign.Parent = shop
    
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    signGui.PixelsPerStud = 50
    signGui.Parent = mainSign
    
    local subwayText = Instance.new("TextLabel")
    subwayText.Size = UDim2.new(1, 0, 1, 0)
    subwayText.BackgroundTransparency = 1
    subwayText.Text = "SUBWAY"
    subwayText.TextColor3 = SUBWAY_YELLOW
    subwayText.TextScaled = true
    subwayText.Font = Enum.Font.GothamBold
    subwayText.Parent = signGui
    
    -- 黄绿箭头装饰
    local arrowsDecor = Instance.new("Part")
    arrowsDecor.Name = "ArrowsDecor"
    arrowsDecor.Size = Vector3.new(0.2, 0.6, 0.1)
    arrowsDecor.Position = position + Vector3.new(-WIDTH/2 + 0.8, HEIGHT - 0.7, -DEPTH/2 - 0.35)
    arrowsDecor.Material = Enum.Material.SmoothPlastic
    arrowsDecor.Color = SUBWAY_YELLOW
    arrowsDecor.Anchored = true
    arrowsDecor.Parent = shop
    
    -- 橱窗和门
    local shopWindow = Instance.new("Part")
    shopWindow.Name = "ShopWindow"
    shopWindow.Size = Vector3.new(WIDTH - 2, 2.5, 0.1)
    shopWindow.Position = position + Vector3.new(-0.5, 1.5, -DEPTH/2 - 0.05)
    shopWindow.Material = Enum.Material.Glass
    shopWindow.Color = Color3.fromRGB(200, 220, 240)
    shopWindow.Transparency = 0.15
    shopWindow.Anchored = true
    shopWindow.Parent = shop
    
    local door = Instance.new("Part")
    door.Name = "Door"
    door.Size = Vector3.new(1.5, 2.5, 0.1)
    door.Position = position + Vector3.new(WIDTH/2 - 1, 1.5, -DEPTH/2 - 0.05)
    door.Material = Enum.Material.Glass
    door.Color = Color3.fromRGB(150, 150, 150)
    door.Transparency = 0.2
    door.Anchored = true
    door.Parent = shop
    
    if rotation and rotation ~= 0 then
        shop:SetPrimaryPartCFrame(
            CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0)
        )
    end
    
    shop.Parent = workspace.Buildings
    return shop
end
```

---

# 第七部分：使用模板

## 7.1 设置模板模块

**步骤：**
1. 在 ServerScriptService 下创建 Folder `Templates`
2. 在 Templates 下创建 ModuleScript `ShopTemplates`
3. 复制上面所有代码到 ModuleScript
4. 确保最后有 `return ShopTemplates`

## 7.2 在脚本中调用

```lua
-- 在任意 Script 中使用
local ShopTemplates = require(game.ServerScriptService.Templates.ShopTemplates)

-- 创建各种商店
ShopTemplates.createTescoExpress(Vector3.new(0, 0, 0), 0)
ShopTemplates.createSainsburysLocal(Vector3.new(15, 0, 0), 0)
ShopTemplates.createCosta(Vector3.new(30, 0, 0), 0)
ShopTemplates.createStarbucks(Vector3.new(42, 0, 0), 0)
ShopTemplates.createMcDonalds(Vector3.new(55, 0, 0), 0)
ShopTemplates.createKFC(Vector3.new(75, 0, 0), 0)
ShopTemplates.createGreggs(Vector3.new(90, 0, 0), 0)

-- 使用通用模板创建自定义商店
ShopTemplates.createGenericShop(Vector3.new(100, 0, 0), 0, {
    name = "MyShop",
    width = 8,
    depth = 6,
    signColor = Color3.fromRGB(100, 50, 150),
    signText = "Custom Shop",
    hasAwning = true,
    awningColor = Color3.fromRGB(150, 100, 50)
})
```

## 7.3 创建商业街

```lua
-- 一键生成商业街
local function createHighStreet(startPos, direction, shops)
    local currentPos = startPos
    local spacing = 2  -- 商店间距
    
    for _, shopType in ipairs(shops) do
        local shopFunc = ShopTemplates["create" .. shopType]
        if shopFunc then
            local shop = shopFunc(currentPos, direction == "north" and 0 or 180)
            local shopWidth = shop.PrimaryPart.Size.X
            currentPos = currentPos + Vector3.new(shopWidth + spacing, 0, 0)
        end
    end
end

-- 示例：Richmond 商业街
createHighStreet(
    Vector3.new(-50, 0, 20),
    "south",
    {"Costa", "Boots", "Greggs", "TescoExpress", "Starbucks"}
)
```

---

# 第八部分：品牌颜色速查表

| 品牌 | 主色 | RGB | 辅助色 |
|------|------|-----|--------|
| **Tesco** | 蓝色 | (0, 83, 159) | 红 (226, 35, 26) |
| **Sainsbury's** | 橙色 | (240, 108, 0) | 白 |
| **M&S** | 绿色 | (0, 75, 35) | 黑 |
| **Costa** | 深红 | (110, 28, 52) | 奶油白 |
| **Starbucks** | 绿色 | (0, 112, 74) | 白/黑 |
| **McDonald's** | 红色 | (218, 41, 28) | 黄 (255, 199, 44) |
| **KFC** | 红色 | (228, 0, 43) | 白 |
| **Greggs** | 橙色 | (255, 102, 0) | 蓝 (0, 51, 102) |
| **Boots** | 蓝色 | (0, 60, 120) | 白 |
| **Subway** | 绿色 | (0, 150, 57) | 黄 (255, 204, 0) |
| **WHSmith** | 深红 | (139, 0, 0) | 白 |
| **Pret** | 深红 | (120, 30, 40) | 棕 |

---

# 第九部分：扩展模板

## 9.1 添加新品牌

```lua
-- 模板：添加新品牌的步骤
function ShopTemplates.createNewBrand(position, rotation)
    local shop = Instance.new("Model")
    shop.Name = "NewBrand"
    
    -- 1. 定义尺寸
    local WIDTH = 10
    local DEPTH = 8
    local HEIGHT = 5
    
    -- 2. 定义品牌颜色
    local BRAND_PRIMARY = Color3.fromRGB(?, ?, ?)
    local BRAND_SECONDARY = Color3.fromRGB(?, ?, ?)
    
    -- 3. 创建主体
    local body = Instance.new("Part")
    -- ... 设置属性 ...
    shop.PrimaryPart = body
    
    -- 4. 创建招牌
    -- ...
    
    -- 5. 创建窗户和门
    -- ...
    
    -- 6. 添加品牌特色元素
    -- ...
    
    -- 7. 应用旋转
    if rotation and rotation ~= 0 then
        shop:SetPrimaryPartCFrame(
            CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0)
        )
    end
    
    shop.Parent = workspace.Buildings
    return shop
end
```

## 9.2 从 Toolbox 导入增强

如果 Toolbox 有现成的好模型：

```lua
-- 方法：包装 Toolbox 模型
function ShopTemplates.createFromToolbox(position, rotation, modelName)
    -- 假设模型已存储在 ServerStorage
    local template = game.ServerStorage.ShopModels:FindFirstChild(modelName)
    if not template then
        warn("找不到模型: " .. modelName)
        return nil
    end
    
    local shop = template:Clone()
    shop:SetPrimaryPartCFrame(
        CFrame.new(position) * CFrame.Angles(0, math.rad(rotation or 0), 0)
    )
    shop.Parent = workspace.Buildings
    
    return shop
end
```

---

祝你创建出丰富多彩的 65 路沿线商业街！🏪🚌
