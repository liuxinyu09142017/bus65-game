# 📅 9天详细开发计划（完整版 V2）

**整合了模板系统 + 真实场景还原 + 详细操作指导**

---

## 📚 配套文档

开始前，确保你有这些文档：

| 文档 | 内容 | 何时使用 |
|------|------|----------|
| **PLAN-DETAILED-V2.md** | 9天每日任务（本文档）| 每天跟着做 |
| **REALISTIC-GUIDE.md** | 道路、红绿灯、桥梁等真实场景 | Day 4-5 建地图时参考 |
| **TEMPLATES-GUIDE.md** | Tesco、Costa、麦当劳等商店模板 | Day 5-8 建商店时使用 |
| **scripts/** | 现成的 Lua 脚本 | Day 3、6、7 使用 |

---

## 📊 9天总览

| Day | 主题 | 核心技能 | 成果 |
|-----|------|----------|------|
| 1 | 熟悉 Studio | 界面、基础操作 | 能放方块、改属性 |
| 2 | 巴士模型 | Toolbox、Model 结构 | 有巴士可坐 |
| 3 | 驾驶脚本 ⭐ | Lua 基础、脚本 | 巴士能开！|
| 4 | 真实道路 | 参考地图、道路系统 | 逼真的马路 |
| 5 | Richmond 站 ⭐ | 建筑、模板系统 | 完整车站场景 |
| 6 | 游戏系统 | 到站检测、UI | 系统能运行 |
| 7 | 车门 + 商店 | 动画、模板调用 | 丰富的场景 |
| 8 | 完整路线 | 整合、优化 | 可玩的游戏 |
| 9 | 发布！🎉 | 测试、发布 | 分享给朋友 |

---

# Day 1：熟悉 Roblox Studio

## ⏰ 时间安排
| 时段 | 内容 | 时长 |
|------|------|------|
| Session 1 | 界面认识 | 30分钟 |
| Session 2 | 基础操作练习 | 30分钟 |
| Session 3 | 小作品挑战 | 20分钟 |

---

## Session 1：界面认识 (30分钟)

### 1.1 启动项目 (5分钟)
```
1. 打开 Roblox Studio
2. 点击 "New" → 选择 "Baseplate"
3. 等待加载完成
4. File → Save to Roblox As...
5. 名称填: Bus65
6. 点 Create
```

### 1.2 认识主界面 (10分钟)

```
┌────────────────────────────────────────────────────────────┐
│  菜单栏: File | Home | Model | Test | View | Plugins       │
├─────────┬──────────────────────────────────────┬───────────┤
│         │                                      │           │
│Explorer │           3D 视口                    │Properties │
│(层级树) │        （游戏世界）                  │  (属性)   │
│         │                                      │           │
├─────────┴──────────────────────────────────────┴───────────┤
│  Output (输出)  |  Command Bar (命令行)                     │
└────────────────────────────────────────────────────────────┘
```

**任务：找到每个区域**
- [ ] Explorer（左边）
- [ ] Properties（右边）
- [ ] 3D 视口（中间）
- [ ] Output（底部，View → Output）

### 1.3 认识 Explorer 结构 (10分钟)

```
Workspace          ← 游戏世界
├── Camera         
├── Terrain        
└── SpawnLocation  ← 出生点

ServerScriptService ← 服务器脚本
ReplicatedStorage   ← 共享存储
StarterGui          ← UI 模板
```

### 1.4 视角控制 (5分钟)

| 操作 | 方法 |
|------|------|
| 旋转视角 | 右键 + 鼠标移动 |
| 移动视角 | 右键 + WASD |
| 缩放 | 滚轮 |
| 聚焦 | 选中物体按 F |

---

## Session 2：基础操作练习 (30分钟)

### 2.1 放置和编辑 Part

```
1. Home → Part（放方块）
2. 工具栏选择：
   - Move (Ctrl+2)：移动
   - Scale (Ctrl+3)：缩放
   - Rotate (Ctrl+4)：旋转
```

### 2.2 修改属性

选中 Part，在 Properties 里改：
- **Name**: 改名字
- **BrickColor**: 改颜色
- **Material**: 改材质（Brick, Wood, Metal, Glass）
- **Size**: 改大小
- **Transparency**: 改透明度

### 2.3 常用快捷键

| 快捷键 | 功能 |
|--------|------|
| F5 | 运行测试 |
| F8 | 停止测试 |
| Ctrl+D | 复制 |
| Ctrl+G | 打组 |
| Alt+拖动 | 复制并移动 |

---

## Session 3：小作品挑战 (20分钟)

### 🏠 挑战：搭一个小房子

**要求：**
- 4 面墙（Brick 材质）
- 1 个屋顶（Wood 材质）
- 1 个门洞
- 1 个窗户（Glass 材质，透明）

**完成后截图保存！**

---

## ✅ Day 1 检查清单

- [ ] 熟悉界面布局
- [ ] 会放置和编辑 Part
- [ ] 会改颜色和材质
- [ ] 完成小房子
- [ ] 保存项目

---

# Day 2：获取并研究巴士模型

## ⏰ 时间安排
| 时段 | 内容 | 时长 |
|------|------|------|
| Session 1 | 找巴士模型 | 30分钟 |
| Session 2 | 研究结构 | 30分钟 |
| Session 3 | 设置驾驶座 | 30分钟 |

---

## Session 1：找巴士模型 (30分钟)

### 1.1 打开 Toolbox

```
View → Toolbox
```

### 1.2 搜索巴士

尝试这些关键词：
- `London bus`
- `Double decker`
- `UK bus`
- `Routemaster`
- `Bus chassis`（可能自带驱动）

### 1.3 选择标准

✅ 好模型：
- 外观好看（像伦敦红色双层巴士）
- 结构清晰（能在 Explorer 里看懂）
- 不要太复杂

❌ 避免：
- 零件太多太乱
- 缺少主车身
- 质量太低

### 1.4 插入并比较

```
1. 点击模型插入
2. 在 Explorer 里展开看结构
3. 试 3 个不同模型
4. 选最好的，删除其他
```

**记录你选的模型名字：** ________________

---

## Session 2：研究模型结构 (30分钟)

### 2.1 在 Explorer 展开模型

常见结构：
```
Bus (Model)
├── Body (车身 - 最大的 Part)
├── Wheel_FL (前左轮)
├── Wheel_FR (前右轮)
├── Wheel_RL (后左轮)
├── Wheel_RR (后右轮)
├── Door (门)
└── Seat (座位，可能没有)
```

### 2.2 认识零件类型

| 类型 | 图标 | 说明 |
|------|------|------|
| Part | 方块 | 基础形状 |
| MeshPart | 网格 | 复杂 3D 模型 |
| Model | 文件夹 | 容器 |
| VehicleSeat | 座位 | 驾驶座 |

### 2.3 找到主车身

- 通常是最大的 Part
- 名字可能是 Body、Chassis、Main
- **记住它的名字！**

---

## Session 3：设置驾驶座 (30分钟)

### 3.1 检查是否有驾驶座

在 Explorer 里找：
- VehicleSeat
- DriverSeat

**有吗？** □ 有 □ 没有

### 3.2 如果没有 - 添加驾驶座

```
1. 选中巴士 Model
2. 右键 → Insert Object → VehicleSeat
3. 用 Move 工具移到司机位置
   - 英国巴士司机在右边！
   - 放在车厢前部
```

### 3.3 设置 PrimaryPart

```
1. 在 Explorer 点击巴士 Model
2. 在 Properties 找 PrimaryPart
3. 点击属性框
4. 在 Explorer 点击主车身
```

### 3.4 测试

```
1. F5 运行
2. 走到巴士旁
3. 按 Y 上车
4. 能坐上去吗？
5. F8 退出
```

---

## ✅ Day 2 检查清单

- [ ] 找到好看的巴士模型
- [ ] 理解模型结构
- [ ] 有 VehicleSeat
- [ ] 设置了 PrimaryPart
- [ ] 测试能坐上去
- [ ] 保存项目

---

# Day 3：让巴士动起来 ⭐关键日

## ⏰ 时间安排
| 时段 | 内容 | 时长 |
|------|------|------|
| Session 1 | 第一个脚本 | 40分钟 |
| Session 2 | 驾驶脚本 | 50分钟 |
| Session 3 | 调试优化 | 30分钟 |

---

## Session 1：第一个脚本！(40分钟)

### 1.1 什么是脚本？

```
脚本 = 给电脑的指令清单

比如：
- 如果按 W，往前开
- 如果按 A，往左转
- 如果撞到站牌，显示"到站了"
```

### 1.2 创建脚本

```
1. 在 Explorer 找到 VehicleSeat
2. 右键 → Insert Object → Script
3. 双击 Script 打开编辑器
```

### 1.3 第一行代码

删除默认代码，写：

```lua
print("Hello! 巴士脚本启动了！")
```

**测试：**
- F5 运行
- 看 Output 面板
- 应该显示你写的文字！

### 1.4 理解基础语法

```lua
-- 这是注释，不会运行

-- 变量：存储数据
local speed = 50
local busName = "Bus 65"

-- 打印：显示信息
print("速度是: " .. speed)
print(busName)

-- 函数：一组指令
local function sayHello()
    print("Hello!")
end

sayHello()  -- 调用函数
```

---

## Session 2：驾驶脚本 (50分钟)

### 2.1 准备工作

**确保所有零件 Anchored = false：**
```
1. 选中巴士所有零件
2. Properties → Anchored → 取消勾选
```

### 2.2 复制驾驶脚本

**打开 VehicleSeat 下的 Script，粘贴：**

```lua
--[[
    巴士驾驶脚本
    WASD 控制
]]

local seat = script.Parent
local bus = seat:FindFirstAncestorOfClass("Model")
local body = bus and (bus.PrimaryPart or bus:FindFirstChildWhichIsA("BasePart"))

if not body then
    warn("⚠️ 找不到车身！设置 PrimaryPart")
    return
end

print("✅ 巴士准备好了！WASD 控制")

-- ====== 调整这里的参数 ======
local MAX_SPEED = 45      -- 速度（改大更快）
local TURN_SPEED = 2      -- 转向（改大更灵敏）
-- ============================

-- 创建移动力
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
bodyVelocity.Parent = body

-- 创建转向力
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
bodyGyro.P = 5000
bodyGyro.D = 500
bodyGyro.Parent = body

local currentAngle = 0

-- 每帧更新
game:GetService("RunService").Heartbeat:Connect(function()
    if seat.Occupant then
        local throttle = seat.Throttle  -- W/S
        local steer = seat.Steer        -- A/D
        
        -- 前进/后退
        if throttle ~= 0 then
            bodyVelocity.MaxForce = Vector3.new(30000, 0, 30000)
            bodyVelocity.Velocity = body.CFrame.LookVector * throttle * MAX_SPEED
        else
            bodyVelocity.MaxForce = Vector3.new(30000, 0, 30000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- 转向（只在移动时）
        if math.abs(throttle) > 0.1 then
            currentAngle = currentAngle - steer * TURN_SPEED
            bodyGyro.MaxTorque = Vector3.new(0, 50000, 0)
            bodyGyro.CFrame = CFrame.Angles(0, math.rad(currentAngle), 0)
        end
    else
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    end
end)
```

### 2.3 测试！

```
1. F5 运行
2. 上车
3. WASD 控制
4. 能动吗？！
```

### 2.4 常见问题

| 问题 | 解决 |
|------|------|
| 不动 | 检查 Anchored = false |
| 找不到车身 | 设置 PrimaryPart |
| 零件散开 | 需要焊接（见下方）|

### 2.5 焊接零件（如果散开）

在巴士 Model 下创建临时 Script：

```lua
local model = script.Parent
local primary = model.PrimaryPart

for _, part in model:GetDescendants() do
    if part:IsA("BasePart") and part ~= primary then
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = primary
        weld.Part1 = part
        weld.Parent = part
        part.Anchored = false
    end
end

print("✅ 焊接完成！")
script:Destroy()
```

运行一次后自动删除。

---

## Session 3：调试优化 (30分钟)

### 3.1 调整速度

在脚本里找：
```lua
local MAX_SPEED = 45      -- 太快改小，太慢改大
local TURN_SPEED = 2      -- 转向太灵敏改小
```

**推荐设置：**
| 风格 | MAX_SPEED | TURN_SPEED |
|------|-----------|------------|
| 真实公交 | 35 | 1.5 |
| 正常 | 45 | 2 |
| 快速 | 60 | 2.5 |

### 3.2 防翻车

如果容易翻：
- 降低车身高度
- 减小 TURN_SPEED
- 加重底部（增加 Density）

---

## ✅ Day 3 检查清单

- [ ] 写了第一行代码
- [ ] 巴士能前进后退
- [ ] 巴士能转向
- [ ] 调整了合适的速度
- [ ] 不翻车
- [ ] 保存项目

🎉 **里程碑：你有一辆能开的巴士了！**

---

# Day 4：建造真实道路 ⭐

## ⏰ 时间安排
| 时段 | 内容 | 时长 |
|------|------|------|
| Session 1 | 参考真实地图 | 30分钟 |
| Session 2 | 建造主道路 | 45分钟 |
| Session 3 | 道路细节 | 45分钟 |

---

## 📚 参考文档

**今天开始使用：** `REALISTIC-GUIDE.md`

重点章节：
- 第一部分：地图参考工具
- 第二部分：道路系统详解

---

## Session 1：参考真实地图 (30分钟)

### 1.1 打开 Google Maps

```
1. 浏览器打开 maps.google.com
2. 搜索 "Richmond Station, London"
3. 切换到卫星视图
```

### 1.2 进入 Street View

```
1. 点右下角小黄人
2. 拖到路上
3. 观察真实道路
```

### 1.3 需要观察的细节

📝 **记录这些信息：**

| 项目 | 观察结果 |
|------|----------|
| 道路几车道？ | |
| 有公交车道吗？ | |
| 人行道什么材质？ | |
| 有双黄线吗？ | |
| 斑马线什么样？ | |

### 1.4 测量距离

```
Google Maps:
1. 右键点击起点
2. 选择"测量距离"
3. 点击终点
4. 记录距离
```

**Roblox 换算（1:5 比例）：**
```
真实 10 米 = Roblox 7 studs
真实 100 米 = Roblox 70 studs
```

---

## Session 2：建造主道路 (45分钟)

### 2.1 创建文件夹结构

```
在 Workspace 下创建 Folders:
├── Roads
├── Buildings
├── BusStops
├── TrafficLights
└── Environment
```

### 2.2 道路参数

```lua
-- 英国道路标准（Roblox 1:5 比例）
LANE_WIDTH = 2.5        -- 车道宽度
ROAD_WIDTH = 6          -- 双车道
PAVEMENT_WIDTH = 2      -- 人行道
CURB_HEIGHT = 0.15      -- 路缘石高度
```

### 2.3 创建第一段道路

```
1. Home → Part
2. Properties:
   Name: Road_01
   Size: 6, 0.3, 100
   Position: 0, 0.15, 0
   Material: Asphalt
   Color: (45, 45, 45) 深灰
   Anchored: ✓

3. 拖进 Roads 文件夹
```

### 2.4 复制延长

```
1. 选中 Road_01
2. Alt + 拖动（向前）
3. 对齐边缘，不要有缝隙
4. 重复 3-4 次
```

### 2.5 创建道路脚本（可选）

**参考 REALISTIC-GUIDE.md 第 2.2 节的代码**

---

## Session 3：道路细节 (45分钟)

### 3.1 添加中线

```
Part:
Name: CenterLine
Size: 0.15, 0.02, 道路长度
Position: 道路中心，Y=0.32
Material: SmoothPlastic
Color: 白色 (255, 255, 255)
```

**虚线做法：**
- 创建短的 Part (Size: 0.15, 0.02, 2)
- 复制排列，间隔 2 studs

### 3.2 添加人行道

```
Part（左侧）:
Name: Pavement_L
Size: 2, 0.2, 道路长度
Position: 道路左边外侧
Material: Concrete
Color: (160, 160, 160)
```

### 3.3 添加路缘石

```
Part:
Name: Curb_L
Size: 0.2, 0.15, 道路长度
Position: 人行道和道路之间
Material: Concrete
Color: (180, 180, 180)
```

### 3.4 添加斑马线

**参考 REALISTIC-GUIDE.md 第 2.3 节**

```
1. 白色条纹（宽 0.6, 间隔 0.6）
2. 两端加黄色 Belisha Beacon 灯
```

### 3.5 测试驾驶

```
1. F5 运行
2. 把巴士开上道路
3. 检查：
   - 道路够宽？
   - 开起来顺畅？
   - 看起来真实？
```

---

## ✅ Day 4 检查清单

- [ ] 研究了真实地图
- [ ] 建了主道路
- [ ] 有中线
- [ ] 有人行道
- [ ] 有斑马线
- [ ] 巴士能在路上开
- [ ] 保存项目

---

# Day 5：Richmond 车站 + 商店 ⭐⭐

## ⏰ 时间安排
| 时段 | 内容 | 时长 |
|------|------|------|
| Session 1 | 参考 + 车站建筑 | 50分钟 |
| Session 2 | 公交站 | 40分钟 |
| Session 3 | 周边商店（用模板）| 50分钟 |

---

## 📚 参考文档

今天使用：
- **REALISTIC-GUIDE.md** - 车站建筑
- **TEMPLATES-GUIDE.md** - 商店模板 ⭐

---

## Session 1：参考 + 车站建筑 (50分钟)

### 1.1 搜索参考图

```
Google 图片搜索:
- "Richmond Station London exterior"
- "Richmond Station entrance"
```

**观察：**
- 红砖建筑
- 拱门入口
- 蓝色 National Rail 标志

### 1.2 创建车站 Model

```
1. 右键 Workspace → Insert Object → Model
2. Name: Richmond_Station
3. 拖进 Buildings 文件夹
```

### 1.3 建造主建筑

```
Part（主体）:
Name: MainBuilding
Size: 40, 12, 20
Position: (40, 6, 0)
Material: Brick
Color: (180, 100, 80) 红砖色
Anchored: ✓
放进 Richmond_Station
```

### 1.4 建造入口拱门

```
Part（左门框）:
Size: 4, 8, 2
Position: 左侧
Material: Brick

Part（右门框）:
同上，右侧

Part（门顶）:
连接两个门框顶部
```

### 1.5 添加站名牌

```
Part:
Name: StationSign
Size: 15, 2, 0.3
Position: 建筑顶部前方
Color: (0, 0, 130) 深蓝

添加 SurfaceGui + TextLabel:
Text: "RICHMOND"
TextColor3: 白色
Font: GothamBold
```

---

## Session 2：公交站 (40分钟)

### 2.1 创建公交站 Model

```
1. 创建 Model: BusStop_Richmond
2. 设置 Attributes:
   - StopId: "richmond"
   - StopName: "Richmond"
```

### 2.2 候车亭

**参考 REALISTIC-GUIDE.md 第 3.2 节**

基本结构：
```
候车亭:
├── 顶棚（玻璃）
├── 后墙（玻璃）
├── 柱子 x2（金属）
└── 座椅（木头）
```

### 2.3 TfL 站牌

```
站牌杆:
Size: 0.12, 4, 0.12
Material: Metal
Color: 深灰

红色圆盘:
Shape: Cylinder
Size: 0.15, 0.9, 0.9
Color: (220, 36, 31) TfL红

添加 SurfaceGui 写 "65"
```

### 2.4 到站检测区

```
Part:
Name: StopZone
Size: 15, 5, 20
Transparency: 1
CanCollide: false
Anchored: ✓
```

---

## Session 3：周边商店 - 使用模板！⭐ (50分钟)

### 3.1 设置模板系统

```
1. 在 ServerScriptService 下创建 Folder: Templates
2. 在 Templates 下创建 ModuleScript: ShopTemplates
3. 从 TEMPLATES-GUIDE.md 复制代码
```

### 3.2 创建商店生成脚本

在 ServerScriptService 下创建 Script:

```lua
-- RichmondShops.lua
local ShopTemplates = require(script.Parent.Templates.ShopTemplates)

-- 等待游戏加载
wait(2)

-- 创建商店街
local START_POS = Vector3.new(-30, 0, 30)

-- Costa 咖啡
ShopTemplates.createCosta(
    START_POS + Vector3.new(0, 0, 0), 
    180  -- 面向道路
)

-- Boots 药店
ShopTemplates.createBoots(
    START_POS + Vector3.new(12, 0, 0), 
    180
)

-- Greggs 面包店
ShopTemplates.createGreggs(
    START_POS + Vector3.new(24, 0, 0), 
    180
)

-- Tesco Express
ShopTemplates.createTescoExpress(
    START_POS + Vector3.new(36, 0, 0), 
    180
)

print("✅ Richmond 商店街创建完成！")
```

### 3.3 手动添加更多商店

如果想手动放置：

```lua
-- 在 Command Bar 里运行
local Shops = require(game.ServerScriptService.Templates.ShopTemplates)

-- 放一个 Starbucks
Shops.createStarbucks(Vector3.new(50, 0, 30), 180)

-- 放一个 McDonald's
Shops.createMcDonalds(Vector3.new(70, 0, 30), 180)
```

### 3.4 自定义商店

```lua
-- 创建你自己的商店
ShopTemplates.createGenericShop(Vector3.new(0, 0, 0), 0, {
    name = "MyShop",
    width = 8,
    depth = 6,
    signColor = Color3.fromRGB(100, 50, 150),
    signText = "我的商店",
    hasAwning = true,
    awningColor = Color3.fromRGB(150, 100, 50)
})
```

---

## ✅ Day 5 检查清单

- [ ] Richmond Station 建筑完成
- [ ] 公交站完成（候车亭 + 站牌）
- [ ] 设置了模板系统
- [ ] 至少 3 个商店（Costa、Boots、Greggs 等）
- [ ] 场景看起来真实
- [ ] 保存项目

---

# Day 6：游戏系统

## ⏰ 时间安排
| 时段 | 内容 | 时长 |
|------|------|------|
| Session 1 | 到站检测脚本 | 45分钟 |
| Session 2 | 司机 UI | 45分钟 |
| Session 3 | 测试完善 | 30分钟 |

---

## Session 1：到站检测脚本 (45分钟)

### 1.1 创建检测脚本

在 BusStop_Richmond 的 StopZone 下创建 Script:

```lua
--[[
    到站检测脚本
]]

local stopZone = script.Parent
local busStop = stopZone.Parent

local stopName = busStop:GetAttribute("StopName") or "Unknown"
local stopId = busStop:GetAttribute("StopId") or "unknown"

print("✅ 站点检测启动: " .. stopName)

local busInZone = false

stopZone.Touched:Connect(function(hit)
    if busInZone then return end
    
    -- 检查是不是巴士
    local model = hit:FindFirstAncestorOfClass("Model")
    if not model then return end
    
    local seat = model:FindFirstChildOfClass("VehicleSeat", true)
    if not seat then return end
    
    -- 是巴士！
    busInZone = true
    print("🚏 到站: " .. stopName)
    
    -- 通知 UI（后面会加）
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local event = ReplicatedStorage:FindFirstChild("BusArrivedEvent")
    if event then
        event:FireAllClients(stopName)
    end
    
    wait(3)
    busInZone = false
end)
```

### 1.2 创建 RemoteEvent

```
1. 在 ReplicatedStorage 下
2. Insert Object → RemoteEvent
3. Name: BusArrivedEvent
```

---

## Session 2：司机 UI (45分钟)

### 2.1 创建 ScreenGui

```
1. 在 StarterGui 下
2. Insert Object → ScreenGui
3. Name: DriverUI
```

### 2.2 创建信息框

```
在 DriverUI 下创建 Frame:
Name: InfoFrame
Size: {0.25, 0}, {0.12, 0}
Position: {0.375, 0}, {0.02, 0}
BackgroundColor3: (0, 50, 100)
BackgroundTransparency: 0.2
```

### 2.3 添加文字

```
在 InfoFrame 下创建 TextLabel:

下一站标签:
Name: NextStopLabel
Size: {1, 0}, {0.5, 0}
Position: {0, 0}, {0, 0}
Text: "下一站: Richmond"
TextColor3: 白色
TextScaled: ✓
BackgroundTransparency: 1
Font: GothamBold

路线标签:
Name: RouteLabel
Size: {1, 0}, {0.5, 0}
Position: {0, 0}, {0.5, 0}
Text: "65 → Ealing Broadway"
TextColor3: 黄色
TextScaled: ✓
BackgroundTransparency: 1
```

### 2.4 更新 UI 脚本

在 DriverUI 下创建 LocalScript:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage:WaitForChild("BusArrivedEvent")

local frame = script.Parent:WaitForChild("InfoFrame")
local nextStopLabel = frame:WaitForChild("NextStopLabel")

event.OnClientEvent:Connect(function(stopName)
    nextStopLabel.Text = "✅ 到达: " .. stopName
    wait(3)
    nextStopLabel.Text = "下一站: ???"
end)
```

---

## Session 3：测试完善 (30分钟)

### 3.1 完整测试

```
1. F5 运行
2. 上车
3. 开到 Richmond 站
4. 检查:
   - Output 显示到站？
   - UI 更新？
   - 开出去再开回来？
```

### 3.2 修复问题

常见问题：
| 问题 | 解决 |
|------|------|
| 检测不到 | 检查 StopZone 位置和大小 |
| UI 不更新 | 检查 RemoteEvent 名字 |

---

## ✅ Day 6 检查清单

- [ ] 到站检测工作
- [ ] UI 显示站点信息
- [ ] 测试完整流程
- [ ] 保存项目

---

# Day 7：车门系统 + 更多场景

## ⏰ 时间安排
| 时段 | 内容 | 时长 |
|------|------|------|
| Session 1 | 车门开关 | 50分钟 |
| Session 2 | 添加红绿灯 | 30分钟 |
| Session 3 | 添加更多商店 | 40分钟 |

---

## Session 1：车门开关 (50分钟)

### 1.1 在巴士里找到或创建门

```
如果有门：记住门的名字
如果没有：
1. 创建 Part
2. Name: FrontDoor
3. Size: (2, 2.5, 0.2)
4. 放在巴士前门位置
5. 拖进巴士 Model
```

### 1.2 创建 RemoteEvents

```
在 ReplicatedStorage 创建:
- RemoteEvent: OpenDoorsEvent
- RemoteEvent: CloseDoorsEvent
```

### 1.3 车门控制脚本

在巴士 Model 下创建 Script:

```lua
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local bus = script.Parent
local frontDoor = bus:FindFirstChild("FrontDoor")

if not frontDoor then
    warn("找不到门！")
    return
end

print("✅ 车门系统就绪")

local OPEN_DISTANCE = 2
local OPEN_TIME = 0.8
local doorOpen = false
local doorClosedCFrame = frontDoor.CFrame

local tweenInfo = TweenInfo.new(OPEN_TIME, Enum.EasingStyle.Quad)

local function openDoor()
    if doorOpen then return end
    doorOpen = true
    print("🚪 开门")
    
    local target = doorClosedCFrame * CFrame.new(OPEN_DISTANCE, 0, 0)
    local tween = TweenService:Create(frontDoor, tweenInfo, {CFrame = target})
    tween:Play()
end

local function closeDoor()
    if not doorOpen then return end
    doorOpen = false
    print("🚪 关门")
    
    local tween = TweenService:Create(frontDoor, tweenInfo, {CFrame = doorClosedCFrame})
    tween:Play()
end

ReplicatedStorage:WaitForChild("OpenDoorsEvent").OnServerEvent:Connect(openDoor)
ReplicatedStorage:WaitForChild("CloseDoorsEvent").OnServerEvent:Connect(closeDoor)
```

### 1.4 键盘控制

在 StarterPlayerScripts 下创建 LocalScript:

```lua
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local openEvent = ReplicatedStorage:WaitForChild("OpenDoorsEvent")
local closeEvent = ReplicatedStorage:WaitForChild("CloseDoorsEvent")

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.O then
        openEvent:FireServer()
    elseif input.KeyCode == Enum.KeyCode.C then
        closeEvent:FireServer()
    end
end)

print("🚪 O = 开门, C = 关门")
```

---

## Session 2：添加红绿灯 (30分钟)

### 2.1 创建红绿灯

**参考 REALISTIC-GUIDE.md 第 2.5 节**

```
在路口放置红绿灯:
1. 灯杆
2. 灯箱（红、黄、绿三个灯）
3. 添加控制脚本
```

### 2.2 简化版红绿灯

```lua
-- 在红绿灯 Model 下创建 Script

local lights = {
    red = script.Parent:WaitForChild("RedLight"),
    yellow = script.Parent:WaitForChild("YellowLight"),
    green = script.Parent:WaitForChild("GreenLight")
}

local function setLight(name)
    for lightName, light in pairs(lights) do
        light.Material = (lightName == name) 
            and Enum.Material.Neon 
            or Enum.Material.SmoothPlastic
    end
end

while true do
    setLight("green")
    wait(10)
    setLight("yellow")
    wait(3)
    setLight("red")
    wait(10)
end
```

---

## Session 3：添加更多商店 (40分钟)

### 3.1 使用模板添加

```lua
local Shops = require(game.ServerScriptService.Templates.ShopTemplates)

-- 在 Richmond 站另一侧
Shops.createMcDonalds(Vector3.new(50, 0, -30), 0)
Shops.createStarbucks(Vector3.new(70, 0, -30), 0)
Shops.createKFC(Vector3.new(90, 0, -30), 0)
```

### 3.2 添加住宅区

**参考 REALISTIC-GUIDE.md 第 4.4 节**

```lua
-- 在远处添加住宅
for i = 1, 4 do
    createSemiDetachedHouse(
        Vector3.new(-50 + i * 15, 0, 60),
        0
    )
end
```

### 3.3 添加装饰

从 Toolbox 搜索并添加：
- 路灯 (street light)
- 树 (tree)
- 长椅 (bench)
- 垃圾桶 (bin)

---

## ✅ Day 7 检查清单

- [ ] 车门能开关（O/C 键）
- [ ] 有红绿灯
- [ ] 添加了更多商店
- [ ] 场景更丰富
- [ ] 保存项目

---

# Day 8：完整路线 + 第二站点

## ⏰ 时间安排
| 时段 | 内容 | 时长 |
|------|------|------|
| Session 1 | Kingston 站 | 60分钟 |
| Session 2 | 连接道路 | 40分钟 |
| Session 3 | 完善测试 | 40分钟 |

---

## Session 1：Kingston 站 (60分钟)

### 1.1 复制 Richmond 站

```
1. 选中 BusStop_Richmond
2. Ctrl+D 复制
3. 重命名: BusStop_Kingston
4. 修改 Attributes:
   - StopId: "kingston"
   - StopName: "Kingston"
5. 移动到道路起点
```

### 1.2 修改站牌文字

找到站牌的 TextLabel，改成 "Kingston"

### 1.3 添加 Kingston 商店

```lua
local Shops = require(game.ServerScriptService.Templates.ShopTemplates)

local KINGSTON_POS = Vector3.new(-200, 0, 30)

Shops.createTescoExpress(KINGSTON_POS + Vector3.new(0, 0, 0), 180)
Shops.createSubway(KINGSTON_POS + Vector3.new(15, 0, 0), 180)
Shops.createBoots(KINGSTON_POS + Vector3.new(27, 0, 0), 180)
```

---

## Session 2：连接道路 (40分钟)

### 2.1 延长道路

从 Richmond 延长到 Kingston

### 2.2 添加弯道（可选）

让路线更有变化

### 2.3 添加路标

显示方向：
- "Kingston ←"
- "→ Ealing"

---

## Session 3：完善测试 (40分钟)

### 3.1 完整路线测试

```
1. 从 Kingston 出发
2. 开到 Richmond
3. 检查:
   - 两个站都检测到？
   - UI 正确更新？
   - 车门在两站都能用？
```

### 3.2 添加 NPC 乘客

```
1. Toolbox 搜 "NPC" 或 "passenger"
2. 放几个在车站等候
```

### 3.3 最后优化

- 调整光照（Lighting）
- 添加天空盒（Toolbox 搜 sky）
- 调整氛围

---

## ✅ Day 8 检查清单

- [ ] Kingston 站完成
- [ ] 道路连接两站
- [ ] 有 NPC 乘客
- [ ] 完整测试通过
- [ ] 场景美观
- [ ] 保存项目

---

# Day 9：发布和分享！🎉

## ⏰ 时间安排
| 时段 | 内容 | 时长 |
|------|------|------|
| Session 1 | 最终测试 | 40分钟 |
| Session 2 | 发布准备 | 40分钟 |
| Session 3 | 发布分享 | 40分钟 |

---

## Session 1：最终测试 (40分钟)

### 1.1 测试清单

```
□ 游戏启动正常
□ 能找到巴士
□ 能上车
□ WASD 控制正常
□ 从 Kingston 出发
□ 到站检测 √
□ 车门开关 √
□ 到达 Richmond √
□ UI 显示正确
□ 没有明显 bug
```

### 1.2 请家人测试

让爸爸妈妈玩一遍：
- 他们能找到怎么玩吗？
- 有什么困惑的地方？

### 1.3 修复问题

记录并修复发现的问题

---

## Session 2：发布准备 (40分钟)

### 2.1 游戏图标

```
1. 调整到好看的角度
2. View → Screenshot
3. 或用画图软件做
4. 大小: 512x512
```

### 2.2 游戏描述

```
🚌 London Bus 65 Simulator

开伦敦双层巴士，从 Kingston 到 Richmond！

🎮 控制:
- WASD: 驾驶
- O: 开门
- C: 关门

✨ 特色:
- 真实伦敦巴士
- 真实站点
- 到站提示
- 逼真商店（Costa、Tesco、麦当劳...）

Made by [你的名字], Age 12
Half Term 2026
```

### 2.3 截图

截 3-5 张好图：
1. 巴士全景
2. 驾驶视角
3. 车站
4. 商店街
5. 整体场景

---

## Session 3：发布分享！(40分钟)

### 3.1 发布到 Roblox

```
1. File → Publish to Roblox
2. 填写:
   - Name: London Bus 65 Simulator
   - Description: (上面的描述)
   - Genre: Town and City
3. Upload 图标和截图
4. 点 Create
```

### 3.2 设置为 Friends Only

```
1. 去 Roblox 网站
2. 找到你的游戏
3. Configure → Access
4. 选 Friends Only
5. Save
```

### 3.3 分享给朋友

```
1. 复制游戏链接
2. 发给朋友
3. 把他们加为 Roblox 好友
4. 让他们玩！
```

### 3.4 收集反馈

问朋友：
- 最喜欢什么？
- 什么需要改进？
- 想要什么新功能？

---

## ✅ Day 9 检查清单

- [ ] 最终测试通过
- [ ] 有游戏图标
- [ ] 有好的描述
- [ ] 发布到 Roblox
- [ ] 分享给朋友
- [ ] 收集反馈

---

# 🏆 恭喜完成！

## 你学会了：

✅ Roblox Studio 基础操作
✅ 使用 Toolbox 找模型
✅ 编写 Lua 脚本
✅ 参考真实地图建场景
✅ 使用模板系统
✅ 创建游戏系统
✅ 发布和分享游戏

## 你做出了：

🚌 一辆能开的伦敦双层巴士
🚏 两个真实的公交站点
🏪 多个连锁商店（Costa、Tesco、麦当劳...）
🚦 红绿灯系统
🚪 能开关的车门
📱 司机信息 UI

## 下一步：

- [ ] 添加更多站点
- [ ] 添加乘客上下车
- [ ] 添加计分系统
- [ ] 添加时刻表
- [ ] 完成整条 65 路！

---

**你现在是一个真正的 Roblox 游戏开发者了！继续创造吧！** 🎮🚀

---

# 附录：快速参考

## 控制键

| 按键 | 功能 |
|------|------|
| WASD | 驾驶 |
| O | 开门 |
| C | 关门 |
| Y | 上下车 |

## 常用颜色 RGB

| 元素 | RGB |
|------|-----|
| 沥青 | (45, 45, 45) |
| 人行道 | (160, 160, 160) |
| 红砖 | (180, 100, 80) |
| TfL 红 | (220, 36, 31) |
| 草地 | (70, 130, 70) |

## 品牌颜色

| 品牌 | 主色 RGB |
|------|----------|
| Tesco | (0, 83, 159) |
| Costa | (110, 28, 52) |
| McDonald's | (218, 41, 28) |
| Starbucks | (0, 112, 74) |

## 文档导航

- **基础操作** → Day 1-2
- **脚本编程** → Day 3, 6, 7
- **真实场景** → REALISTIC-GUIDE.md
- **商店模板** → TEMPLATES-GUIDE.md
- **脚本代码** → scripts/ 文件夹
