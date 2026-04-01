--[[
    ONYX UI LIBRARY (LUAU EDITION)
    A high-fidelity, animated UI library for Roblox.
    
    Features:
    - Key System
    - Draggable UI
    - Tabs & Sections
    - Toggles, Sliders, Dropdowns, Buttons
    - Notifications
    - Keybinds
    - Context Menus
]]

local Onyx = {}
Onyx.__index = Onyx

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Utility Functions
local function Tween(obj, time, goal)
    local tween = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal)
    tween:Play()
    return tween
end

function Onyx:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, Onyx)
    self.Name = config.Name or "Onyx Hub"
    self.Accent = config.Accent or Color3.fromRGB(244, 181, 209)
    self.Key = config.Key or "onyx-dev"
    self.Tabs = {}
    self.ActiveTab = nil
    
    local InitMain -- Forward declaration
    
    -- Main UI Container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = self.Name
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    self.Gui = ScreenGui

    -- Key System
    local function CreateKeySystem()
        local KeyFrame = Instance.new("Frame")
        KeyFrame.Size = UDim2.new(0, 320, 0, 240)
        KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -120)
        KeyFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
        KeyFrame.BorderSizePixel = 0
        KeyFrame.Parent = ScreenGui
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 20)
        UICorner.Parent = KeyFrame
        
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = self.Accent
        UIStroke.Transparency = 0.7
        UIStroke.Thickness = 1.5
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = KeyFrame

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 60)
        Title.BackgroundTransparency = 1
        Title.Text = "ONYX HUB"
        Title.TextColor3 = self.Accent
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 24
        Title.Parent = KeyFrame
        
        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(0.8, 0, 0, 40)
        Input.Position = UDim2.new(0.1, 0, 0.4, 0)
        Input.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        Input.TextColor3 = Color3.fromRGB(255, 255, 255)
        Input.PlaceholderText = "Enter Key..."
        Input.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        Input.Text = ""
        Input.Font = Enum.Font.Gotham
        Input.TextSize = 14
        Input.Parent = KeyFrame
        
        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 8)
        InputCorner.Parent = Input

        local Submit = Instance.new("TextButton")
        Submit.Size = UDim2.new(0.8, 0, 0, 40)
        Submit.Position = UDim2.new(0.1, 0, 0.65, 0)
        Submit.BackgroundColor3 = self.Accent
        Submit.Text = "Check Key"
        Submit.TextColor3 = Color3.fromRGB(13, 13, 13)
        Submit.Font = Enum.Font.GothamBold
        Submit.TextSize = 14
        Submit.AutoButtonColor = false
        Submit.Parent = KeyFrame
        
        local SubmitCorner = Instance.new("UICorner")
        SubmitCorner.CornerRadius = UDim.new(0, 8)
        SubmitCorner.Parent = Submit
        
        Submit.MouseButton1Click:Connect(function()
            if Input.Text == self.Key then
                -- Success Animation
                Tween(Submit, 0.3, {BackgroundColor3 = Color3.fromRGB(100, 255, 100)})
                Submit.Text = "Access Granted"
                
                task.wait(0.5)
                
                -- Animation out
                Tween(KeyFrame, 0.6, {Position = UDim2.new(0.5, -160, 0.5, 200), BackgroundTransparency = 1})
                for _, child in pairs(KeyFrame:GetChildren()) do
                    if child:IsA("GuiObject") then
                        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                            Tween(child, 0.4, {TextTransparency = 1, BackgroundTransparency = 1})
                        else
                            Tween(child, 0.4, {BackgroundTransparency = 1})
                        end
                    elseif child:IsA("UIStroke") then
                        Tween(child, 0.4, {Transparency = 1})
                    end
                end
                task.wait(0.6)
                KeyFrame:Destroy()
                -- Trigger Main UI Entry Animation
                Tween(self.Main, 0.8, {Size = UDim2.new(0, 600, 0, 400), Position = UDim2.new(0.5, -300, 0.5, -200)})
            else
                self:Notify("Access Denied", "Invalid key provided.")
                -- Error Animation
                Tween(Submit, 0.1, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)})
                task.delay(0.5, function()
                    Tween(Submit, 0.3, {BackgroundColor3 = self.Accent})
                end)
                
                -- Shake animation
                local originalPos = KeyFrame.Position
                for i = 1, 6 do
                    Tween(KeyFrame, 0.05, {Position = originalPos + UDim2.new(0, (i % 2 == 0 and 5 or -5), 0, 0)}).Completed:Wait()
                end
                Tween(KeyFrame, 0.05, {Position = originalPos})
            end
        end)
    end

    self:InitMain()
    CreateKeySystem()
    return self
end

function Onyx:InitMain()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = self.Gui
    self.Main = MainFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 20)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = self.Accent
    UIStroke.Transparency = 0.8
    UIStroke.Thickness = 1.5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = MainFrame

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    self.Sidebar = Sidebar
    
    local SidebarLine = Instance.new("Frame")
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, 0, 0, 0)
    SidebarLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SidebarLine.BackgroundTransparency = 0.95
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Parent = Sidebar

    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(1, 0, 0, 60)
    Logo.Position = UDim2.new(0, 20, 0, 0)
    Logo.BackgroundTransparency = 1
    Logo.Text = "ONYX"
    Logo.TextColor3 = self.Accent
    Logo.Font = Enum.Font.GothamBlack
    Logo.TextSize = 24
    Logo.TextXAlignment = Enum.TextXAlignment.Left
    Logo.Parent = Sidebar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -20, 1, -120)
    TabContainer.Position = UDim2.new(0, 10, 0, 70)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = Sidebar
    self.TabContainer = TabContainer

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabContainer

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -180, 1, 0)
    ContentArea.Position = UDim2.new(0, 180, 0, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    self.ContentArea = ContentArea

    -- Draggable
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function Onyx:CreateTab(name)
    local Window = self -- Capture Window instance
    local Tab = {}
    Tab.Name = name
    Tab.Active = false
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = name:upper()
    TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 12
    TabButton.AutoButtonColor = false
    TabButton.Parent = Window.TabContainer

    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 8)
    TabButtonCorner.Parent = TabButton

    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Size = UDim2.new(1, 0, 1, -50)
    TabFrame.Position = UDim2.new(0, 0, 0, 50)
    TabFrame.BackgroundTransparency = 1
    TabFrame.BorderSizePixel = 0
    TabFrame.ScrollBarThickness = 2
    TabFrame.ScrollBarImageColor3 = Window.Accent
    TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabFrame.Visible = false
    TabFrame.Parent = Window.ContentArea

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 20)
    TabPadding.PaddingRight = UDim.new(0, 20)
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.Parent = TabFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabFrame

    function Tab:Activate()
        if not Window or not Window.Tabs then return end
        for _, t in pairs(Window.Tabs) do
            if t.TabFrame then t.TabFrame.Visible = false end
            if t.TabButton then
                Tween(t.TabButton, 0.3, {TextColor3 = Color3.fromRGB(150, 150, 150), BackgroundTransparency = 1})
            end
        end
        if TabFrame then TabFrame.Visible = true end
        if TabButton then
            Tween(TabButton, 0.3, {TextColor3 = Window.Accent, BackgroundTransparency = 0.9})
            TabButton.BackgroundColor3 = Window.Accent
        end
    end

    TabButton.MouseButton1Click:Connect(function()
        Tab:Activate()
    end)

    Tab.TabButton = TabButton
    Tab.TabFrame = TabFrame
    table.insert(Window.Tabs, Tab)

    if #Window.Tabs == 1 then
        Tab:Activate()
    end

    -- Component Creation
    function Tab:CreateSection(label)
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Size = UDim2.new(1, 0, 0, 25)
        SectionFrame.BackgroundTransparency = 1
        SectionFrame.Parent = TabFrame

        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Size = UDim2.new(0, 0, 1, 0)
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.Text = label:upper()
        SectionLabel.TextColor3 = Window.Accent
        SectionLabel.Font = Enum.Font.GothamBold
        SectionLabel.TextSize = 10
        SectionLabel.TextTransparency = 0.3
        SectionLabel.AutomaticSize = Enum.AutomaticSize.X
        SectionLabel.Parent = SectionFrame

        local Line = Instance.new("Frame")
        Line.Size = UDim2.new(1, -SectionLabel.Size.X.Offset - 10, 0, 1)
        Line.Position = UDim2.new(0, SectionLabel.Size.X.Offset + 10, 0.5, 0)
        Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Line.BackgroundTransparency = 0.95
        Line.BorderSizePixel = 0
        Line.Parent = SectionFrame
    end

    function Tab:CreateButton(config)
        local Name = config.Name or "Button"
        local Callback = config.Callback or function() end
        local SettingsCallback = config.Settings or nil

        local ButtonFrame = Instance.new("TextButton")
        ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ButtonFrame.BackgroundTransparency = 0.5
        ButtonFrame.Text = ""
        ButtonFrame.AutoButtonColor = false
        ButtonFrame.Parent = TabFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = ButtonFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -10, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Name
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ButtonFrame

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 16, 0, 16)
        Icon.Position = UDim2.new(1, -26, 0.5, -8)
        Icon.BackgroundTransparency = 1
        Icon.Image = "rbxassetid://6031094678" -- Simple arrow icon
        Icon.ImageColor3 = Window.Accent
        Icon.Parent = ButtonFrame

        ButtonFrame.MouseEnter:Connect(function()
            Tween(ButtonFrame, 0.3, {BackgroundTransparency = 0.3, BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
        end)

        ButtonFrame.MouseLeave:Connect(function()
            Tween(ButtonFrame, 0.3, {BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(20, 20, 20)})
        end)

        ButtonFrame.MouseButton1Click:Connect(function()
            Tween(ButtonFrame, 0.1, {Size = UDim2.new(1, -5, 0, 32)}):Completed:Connect(function()
                Tween(ButtonFrame, 0.1, {Size = UDim2.new(1, 0, 0, 35)})
            end)
            Callback()
        end)

        -- Context Menu (Right Click)
        if SettingsCallback then
            ButtonFrame.MouseButton2Click:Connect(function()
                local ContextMenu = Instance.new("Frame")
                ContextMenu.Size = UDim2.new(0, 120, 0, 0)
                ContextMenu.Position = UDim2.new(0, UserInputService:GetMouseLocation().X - Window.Main.AbsolutePosition.X, 0, UserInputService:GetMouseLocation().Y - Window.Main.AbsolutePosition.Y - 36)
                ContextMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                ContextMenu.BorderSizePixel = 0
                ContextMenu.ZIndex = 100
                ContextMenu.Parent = Window.Main

                local ContextCorner = Instance.new("UICorner")
                ContextCorner.CornerRadius = UDim.new(0, 8)
                ContextCorner.Parent = ContextMenu

                local ContextStroke = Instance.new("UIStroke")
                ContextStroke.Color = Window.Accent
                ContextStroke.Transparency = 0.8
                ContextStroke.Parent = ContextMenu

                local ContextBtn = Instance.new("TextButton")
                ContextBtn.Size = UDim2.new(1, 0, 0, 30)
                ContextBtn.BackgroundTransparency = 1
                ContextBtn.Text = "Settings"
                ContextBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                ContextBtn.Font = Enum.Font.Gotham
                ContextBtn.TextSize = 12
                ContextBtn.ZIndex = 101
                ContextBtn.Parent = ContextMenu

                Tween(ContextMenu, 0.3, {Size = UDim2.new(0, 120, 0, 30)})

                ContextBtn.MouseButton1Click:Connect(function()
                    SettingsCallback()
                    ContextMenu:Destroy()
                end)

                -- Close when clicking away
                local connection
                connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        ContextMenu:Destroy()
                        connection:Disconnect()
                    end
                end)
            end)
        end
    end

    function Tab:CreateKeybind(config)
        local Name = config.Name or "Keybind"
        local Default = config.Default or Enum.KeyCode.F
        local Callback = config.Callback or function() end
        local CurrentKey = Default

        local KeybindFrame = Instance.new("Frame")
        KeybindFrame.Size = UDim2.new(1, 0, 0, 35)
        KeybindFrame.BackgroundTransparency = 1
        KeybindFrame.Parent = TabFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 5, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Name
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = KeybindFrame

        local BindButton = Instance.new("TextButton")
        BindButton.Size = UDim2.new(0, 50, 0, 25)
        BindButton.Position = UDim2.new(1, -55, 0.5, -12)
        BindButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        BindButton.Text = CurrentKey.Name
        BindButton.TextColor3 = Window.Accent
        BindButton.Font = Enum.Font.GothamBold
        BindButton.TextSize = 12
        BindButton.AutoButtonColor = false
        BindButton.Parent = KeybindFrame

        local BindCorner = Instance.new("UICorner")
        BindCorner.CornerRadius = UDim.new(0, 6)
        BindCorner.Parent = BindButton

        local listening = false
        BindButton.MouseButton1Click:Connect(function()
            listening = true
            BindButton.Text = "..."
        end)

        UserInputService.InputBegan:Connect(function(input)
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                CurrentKey = input.KeyCode
                BindButton.Text = CurrentKey.Name
                listening = false
            elseif not listening and input.KeyCode == CurrentKey then
                Callback()
            end
        end)
    end

    function Tab:CreateToggle(config)
        local Name = config.Name or "Toggle"
        local Default = config.Default or false
        local Callback = config.Callback or function() end
        local Enabled = Default

        local ToggleFrame = Instance.new("TextButton")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
        ToggleFrame.BackgroundTransparency = 1
        ToggleFrame.Text = ""
        ToggleFrame.AutoButtonColor = false
        ToggleFrame.Parent = TabFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.Position = UDim2.new(0, 5, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Name
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

        local Switch = Instance.new("Frame")
        Switch.Size = UDim2.new(0, 35, 0, 18)
        Switch.Position = UDim2.new(1, -40, 0.5, -9)
        Switch.BackgroundColor3 = Enabled and Window.Accent or Color3.fromRGB(30, 30, 30)
        Switch.BorderSizePixel = 0
        Switch.Parent = ToggleFrame

        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = Switch

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 12, 0, 12)
        Circle.Position = UDim2.new(0, Enabled and 20 or 3, 0.5, -6)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.BorderSizePixel = 0
        Circle.Parent = Switch

        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = Circle

        ToggleFrame.MouseButton1Click:Connect(function()
            Enabled = not Enabled
            Tween(Switch, 0.3, {BackgroundColor3 = Enabled and Window.Accent or Color3.fromRGB(30, 30, 30)})
            Tween(Circle, 0.3, {Position = UDim2.new(0, Enabled and 20 or 3, 0.5, -6)})
            Callback(Enabled)
        end)
    end

    function Tab:CreateSlider(config)
        local Name = config.Name or "Slider"
        local Min = config.Min or 0
        local Max = config.Max or 100
        local Default = config.Default or 50
        local Callback = config.Callback or function() end
        local Value = Default

        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 45)
        SliderFrame.BackgroundTransparency = 1
        SliderFrame.Parent = TabFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.Position = UDim2.new(0, 5, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Name
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = SliderFrame

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0, 40, 0, 20)
        ValueLabel.Position = UDim2.new(1, -45, 0, 0)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(Value)
        ValueLabel.TextColor3 = Window.Accent
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextSize = 12
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderFrame

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(1, -10, 0, 4)
        Bar.Position = UDim2.new(0, 5, 0, 30)
        Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Bar.BorderSizePixel = 0
        Bar.Parent = SliderFrame

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
        Fill.BackgroundColor3 = Window.Accent
        Fill.BorderSizePixel = 0
        Fill.Parent = Bar

        local function Update(input)
            local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Value = math.floor(Min + (Max - Min) * pos)
            ValueLabel.Text = tostring(Value)
            Tween(Fill, 0.1, {Size = UDim2.new(pos, 0, 1, 0)})
            Callback(Value)
        end

        local dragging = false
        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                Update(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                Update(input)
            end
        end)
    end

    function Tab:CreateDropdown(config)
        local Name = config.Name or "Dropdown"
        local Options = config.Options or {}
        local Default = config.Default or Options[1]
        local Callback = config.Callback or function() end
        local Selected = Default
        local IsOpen = false

        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = UDim2.new(1, 0, 0, 60)
        DropdownFrame.BackgroundTransparency = 1
        DropdownFrame.Parent = TabFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.Position = UDim2.new(0, 5, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Name
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = DropdownFrame

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -10, 0, 30)
        Button.Position = UDim2.new(0, 5, 0, 25)
        Button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        Button.Text = Selected
        Button.TextColor3 = Color3.fromRGB(150, 150, 150)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 12
        Button.AutoButtonColor = false
        Button.Parent = DropdownFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button

        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
        ButtonStroke.Transparency = 0.95
        ButtonStroke.Parent = Button

        local List = Instance.new("Frame")
        List.Size = UDim2.new(1, 0, 0, 0)
        List.Position = UDim2.new(0, 0, 1, 5)
        List.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        List.BorderSizePixel = 0
        List.ClipsDescendants = true
        List.Visible = false
        List.ZIndex = 10
        List.Parent = Button

        local ListCorner = Instance.new("UICorner")
        ListCorner.CornerRadius = UDim.new(0, 6)
        ListCorner.Parent = List

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Padding = UDim.new(0, 2)
        ListLayout.Parent = List

        local function ToggleDropdown()
            IsOpen = not IsOpen
            List.Visible = true
            local targetSize = IsOpen and UDim2.new(1, 0, 0, #Options * 30 + 5) or UDim2.new(1, 0, 0, 0)
            Tween(List, 0.3, {Size = targetSize}).Completed:Connect(function()
                if not IsOpen then List.Visible = false end
            end)
            Tween(ButtonStroke, 0.3, {Transparency = IsOpen and 0.8 or 0.95, Color = IsOpen and Window.Accent or Color3.fromRGB(255, 255, 255)})
        end

        Button.MouseButton1Click:Connect(ToggleDropdown)

        for _, opt in pairs(Options) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Size = UDim2.new(1, 0, 0, 30)
            OptBtn.BackgroundTransparency = 1
            OptBtn.Text = opt
            OptBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            OptBtn.Font = Enum.Font.Gotham
            OptBtn.TextSize = 12
            OptBtn.ZIndex = 11
            OptBtn.Parent = List

            OptBtn.MouseButton1Click:Connect(function()
                Selected = opt
                Button.Text = opt
                ToggleDropdown()
                Callback(opt)
            end)
        end
    end

    function Tab:CreateTextBox(config)
        local Name = config.Name or "TextBox"
        local Placeholder = config.Placeholder or "Type here..."
        local Callback = config.Callback or function() end

        local TextBoxFrame = Instance.new("Frame")
        TextBoxFrame.Size = UDim2.new(1, 0, 0, 60)
        TextBoxFrame.BackgroundTransparency = 1
        TextBoxFrame.Parent = TabFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.Position = UDim2.new(0, 5, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Name
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = TextBoxFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1, -10, 0, 30)
        Input.Position = UDim2.new(0, 5, 0, 25)
        Input.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        Input.TextColor3 = Color3.fromRGB(255, 255, 255)
        Input.PlaceholderText = Placeholder
        Input.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        Input.Text = ""
        Input.Font = Enum.Font.Gotham
        Input.TextSize = 12
        Input.Parent = TextBoxFrame

        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 6)
        InputCorner.Parent = Input

        local InputStroke = Instance.new("UIStroke")
        InputStroke.Color = Color3.fromRGB(255, 255, 255)
        InputStroke.Transparency = 0.95
        InputStroke.Parent = Input

        Input.FocusLost:Connect(function(enterPressed)
            Callback(Input.Text, enterPressed)
        end)

        Input.Focused:Connect(function()
            Tween(InputStroke, 0.3, {Transparency = 0.8, Color = Window.Accent})
        end)

        Input.FocusLost:Connect(function()
            Tween(InputStroke, 0.3, {Transparency = 0.95, Color = Color3.fromRGB(255, 255, 255)})
        end)
    end

    function Tab:CreateLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = TabFrame
        return Label
    end

    function Tab:CreateParagraph(title, content)
        local ParagraphFrame = Instance.new("Frame")
        ParagraphFrame.Size = UDim2.new(1, 0, 0, 0)
        ParagraphFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ParagraphFrame.BackgroundTransparency = 0.8
        ParagraphFrame.AutomaticSize = Enum.AutomaticSize.Y
        ParagraphFrame.Parent = TabFrame

        local ParagraphCorner = Instance.new("UICorner")
        ParagraphCorner.CornerRadius = UDim.new(0, 8)
        ParagraphCorner.Parent = ParagraphFrame

        local ParagraphPadding = Instance.new("UIPadding")
        ParagraphPadding.PaddingBottom = UDim.new(0, 10)
        ParagraphPadding.PaddingLeft = UDim.new(0, 10)
        ParagraphPadding.PaddingRight = UDim.new(0, 10)
        ParagraphPadding.PaddingTop = UDim.new(0, 10)
        ParagraphPadding.Parent = ParagraphFrame

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 20)
        Title.BackgroundTransparency = 1
        Title.Text = title:upper()
        Title.TextColor3 = Window.Accent
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 11
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = ParagraphFrame

        local Content = Instance.new("TextLabel")
        Content.Size = UDim2.new(1, 0, 0, 0)
        Content.Position = UDim2.new(0, 0, 0, 25)
        Content.BackgroundTransparency = 1
        Content.Text = content
        Content.TextColor3 = Color3.fromRGB(150, 150, 150)
        Content.Font = Enum.Font.Gotham
        Content.TextSize = 12
        Content.TextXAlignment = Enum.TextXAlignment.Left
        Content.TextWrapped = true
        Content.AutomaticSize = Enum.AutomaticSize.Y
        Content.Parent = ParagraphFrame
    end

    return Tab
end

function Onyx:Notify(title, content)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0, 280, 0, 60)
    Notification.Position = UDim2.new(1, 20, 1, -80)
    Notification.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    Notification.BorderSizePixel = 0
    Notification.Parent = self.Gui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Notification

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = self.Accent
    UIStroke.Transparency = 0.8
    UIStroke.Parent = Notification

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 25)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = title:upper()
    Title.TextColor3 = self.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Notification

    local Content = Instance.new("TextLabel")
    Content.Size = UDim2.new(1, -20, 0, 25)
    Content.Position = UDim2.new(0, 10, 0, 25)
    Content.BackgroundTransparency = 1
    Content.Text = content
    Content.TextColor3 = Color3.fromRGB(150, 150, 150)
    Content.Font = Enum.Font.Gotham
    Content.TextSize = 11
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.Parent = Notification

    Tween(Notification, 0.5, {Position = UDim2.new(1, -300, 1, -80)})
    task.delay(3, function()
        Tween(Notification, 0.5, {Position = UDim2.new(1, 20, 1, -80)})
        task.wait(0.5)
        Notification:Destroy()
    end)
end

return Onyx
