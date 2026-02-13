# 📅 9天 Half Term 开发计划

**目标：** 完成 65 路公交模拟游戏，可以分享给朋友玩

---

## Day 1：熟悉 Roblox Studio ⏱️ 1小时

### 上午/下午 Session (45分钟)

**任务清单：**
- [ ] 打开 Roblox Studio，创建 Baseplate 项目
- [ ] 保存到 Roblox 云端，命名 "Bus65"
- [ ] 熟悉界面布局：
  - Explorer（左边，物体列表）
  - Properties（右边，属性面板）
  - Toolbox（模型库）
  - Output（输出/报错）

**练习操作：**
- [ ] Home → Part 放 5 个方块
- [ ] 用 Move 工具移动方块
- [ ] 用 Scale 工具改大小
- [ ] 用 Rotate 工具旋转
- [ ] 在 Properties 里改颜色 (BrickColor)
- [ ] 在 Properties 里改材质 (Material)
- [ ] 按 F 聚焦选中物体
- [ ] F5 进入游戏测试，F8 退出

### 晚上 Session (15分钟)

- [ ] 用方块搭一个简单房子
- [ ] 截图保存到 screenshots/ 文件夹
- [ ] 填写 PROGRESS.md Day 1

**今日成果：** 熟练使用 Studio 基础工具

---

## Day 2：获取并研究巴士模型 ⏱️ 1.5小时

### Session 1 (45分钟)

**任务清单：**
- [ ] View → Toolbox 打开工具箱
- [ ] 搜索并尝试不同巴士模型：
  - "London bus"
  - "Double decker bus"
  - "UK bus"
  - "Routemaster"
- [ ] 选择一个好看的模型插入
- [ ] 在 Explorer 里展开模型，研究结构

**学习要点：**
```
Model = 容器，装很多 Part
Part = 基本方块
MeshPart = 复杂3D形状
VehicleSeat = 驾驶座（如果有）
```

### Session 2 (45分钟)

- [ ] 如果模型没有驾驶座，手动添加 VehicleSeat
- [ ] 把 VehicleSeat 放到司机位置
- [ ] 设置 Model 的 PrimaryPart（选最大的车身）
- [ ] F5 测试：能不能坐上去？
- [ ] 研究 Croydon Bus 游戏里的巴士做参考

**今日成果：** 有一辆可以坐上去的巴士模型

---

## Day 3：让巴士动起来 ⏱️ 2小时 ⭐关键日

### Session 1 (60分钟) - 第一个脚本！

**任务清单：**
- [ ] 选中 VehicleSeat
- [ ] 右键 → Insert Object → Script
- [ ] 删除默认代码
- [ ] 写第一行代码：
```lua
print("巴士脚本加载成功！")
```
- [ ] F5 测试，在 Output 看到输出
- [ ] 理解：代码 = 给电脑的指令

### Session 2 (60分钟) - 驱动脚本

- [ ] 复制完整驱动脚本（见 scripts/BusDriver.lua）
- [ ] 粘贴到 Script 里
- [ ] F5 测试：WASD 能开吗？
- [ ] 调整参数：
  - `local speed = 40` → 改成 30 或 50 试试
  - 转向灵敏度
- [ ] 确保巴士不会乱翻

**脚本备份到：** `scripts/BusDriver.lua`

**今日成果：** 🎉 一辆能开的伦敦巴士！

---

## Day 4：建造第一条道路 ⏱️ 1.5小时

### Session 1 (45分钟)

**任务清单：**
- [ ] 删除默认的 Baseplate（或保留当地面）
- [ ] 创建道路 Part：
  ```
  Size: 14, 0.2, 200
  Material: Asphalt
  Color: 深灰 RGB(50,50,50)
  Position: 0, 0.1, 0
  ```
- [ ] Alt+拖动 复制延长道路
- [ ] 总共做 3-4 段，形成一条长路

### Session 2 (45分钟)

- [ ] 加人行道（道路两边）：
  ```
  Size: 4, 0.2, 200
  Material: Concrete
  Color: 浅灰
  ```
- [ ] 加道路标线（可选，用细长白色 Part）
- [ ] 测试：开巴士在路上跑一圈！
- [ ] 整理：把道路 Part 放进 "Roads" 文件夹

**今日成果：** 一条可以开车的马路

---

## Day 5：建造 Richmond 车站 ⏱️ 2小时 ⭐重点日

### Session 1 (60分钟) - 车站建筑

**参考：** Google 搜 "Richmond Station London" 图片

**任务清单：**
- [ ] 创建 Model 命名 "Richmond_Station"
- [ ] 建主建筑（红砖长方体）：
  ```
  Size: 60, 20, 30
  Material: Brick
  Color: 红砖色 RGB(180,120,100)
  ```
- [ ] 建入口拱门
- [ ] 加站名牌（Part + SurfaceGui + TextLabel）

### Session 2 (60分钟) - 公交站

- [ ] 创建 Model 命名 "BusStop_Richmond"
- [ ] 建站台平台
- [ ] 建候车亭（柱子 + 玻璃顶）
- [ ] 建 TfL 红色站牌
- [ ] 加 "65" 路线标识
- [ ] 加隐形检测区域 (StopZone)

**今日成果：** Richmond 站完成！

---

## Day 6：到站检测系统 ⏱️ 1.5小时 ⭐代码日

### Session 1 (45分钟)

**任务清单：**
- [ ] 选中 StopZone (透明Part)
- [ ] 添加 Script
- [ ] 写到站检测代码：
```lua
local zone = script.Parent
local stopName = "Richmond"

zone.Touched:Connect(function(hit)
    local bus = hit:FindFirstAncestor("Bus") 
    if bus then
        print("到站了: " .. stopName)
    end
end)
```
- [ ] F5 测试：开到站看 Output

### Session 2 (45分钟)

- [ ] 到站时显示 UI 提示
- [ ] 在 StarterGui 加 ScreenGui
- [ ] 加 TextLabel 显示 "下一站：XXX"
- [ ] 脚本控制文字变化

**脚本备份到：** `scripts/StopDetector.lua`

**今日成果：** 巴士知道自己到站了！

---

## Day 7：车门系统 ⏱️ 1.5小时

### Session 1 (45分钟)

**任务清单：**
- [ ] 在巴士模型里找到或创建门 Part
- [ ] 写开关门脚本：
```lua
local door = script.Parent
local open = false

local function toggleDoor()
    if open then
        -- 关门动画
        door.Position = door.Position - Vector3.new(2, 0, 0)
    else
        -- 开门动画
        door.Position = door.Position + Vector3.new(2, 0, 0)
    end
    open = not open
end
```

### Session 2 (45分钟)

- [ ] 键盘控制：O 开门，C 关门
- [ ] 用 TweenService 做平滑动画
- [ ] 测试：到站 → 开门 → 关门 → 开走

**脚本备份到：** `scripts/DoorController.lua`

**今日成果：** 巴士门能开关了！

---

## Day 8：第二个站点 + 完善 ⏱️ 2小时

### Session 1 (60分钟)

**任务清单：**
- [ ] 复制 Richmond 站的结构
- [ ] 修改成 Kingston（起点站）或 Kew Gardens
- [ ] 调整外观细节
- [ ] 连接道路

### Session 2 (60分钟)

- [ ] 加装饰：路灯、树、长椅（Toolbox 搜）
- [ ] 加 NPC 乘客（Toolbox 搜 "NPC"）
- [ ] 测试完整路线：Kingston → Richmond
- [ ] 调整、修 bug

**今日成果：** 两个站点 + 完整可玩路线！

---

## Day 9：测试、发布、分享！⏱️ 2小时 🎉

### Session 1 (45分钟) - 最终测试

**测试清单：**
- [ ] 完整玩一遍游戏
- [ ] 检查巴士操控
- [ ] 检查每个站点
- [ ] 检查车门
- [ ] 检查 UI
- [ ] 请家长试玩
- [ ] 记录并修复问题

### Session 2 (45分钟) - 准备发布

- [ ] 截 3-5 张游戏截图
- [ ] 做游戏图标（512x512）
- [ ] 写游戏描述
- [ ] File → Publish to Roblox
- [ ] 先设为 Private

### Session 3 (30分钟) - 分享给朋友！

**分享方法：**
1. Game Settings → Access → Friends Only
2. 把想玩的朋友加为 Roblox 好友
3. 发送游戏链接
4. 或者开 Private Server 邀请

**收集反馈：**
- 让 3-5 个朋友试玩
- 问：什么好玩？什么要改进？
- 记录反馈到 PROGRESS.md

**今日成果：** 🎉🎉🎉 游戏发布，朋友在玩！

---

## 📊 每日时间建议

| 时段 | 活动 | 时长 |
|------|------|------|
| 上午 | Session 1 | 45-60分钟 |
| 休息 | 吃饭/玩耍 | - |
| 下午 | Session 2 | 45-60分钟 |
| 晚上 | 整理/记录进度 | 15分钟 |

**总计：** 每天 1.5-2 小时，不要太累！

---

## 🆘 遇到问题怎么办

1. **先自己试 5 分钟**
2. **Google/YouTube 搜索**
3. **问指导者（爸爸/我）**
4. **DevForum 搜索**
5. **实在不行，跳过，明天再说**

---

## ✅ 完成标准

游戏达到这些标准就算成功：

- [ ] 有一辆能开的伦敦双层巴士
- [ ] 至少 2 个站点（Kingston、Richmond）
- [ ] 车门能开关
- [ ] 到站有提示
- [ ] 朋友能玩！

**额外加分：**
- [ ] 3个以上站点
- [ ] 有乘客 NPC
- [ ] 有计分系统
- [ ] 有背景音乐

---

Good luck! 🚌🎮
