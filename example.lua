local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wawathegreat/WawaUi/main/WawaUI.lua"))()

local Window = Library.CreateWindow("WawaUI Example")

Window:SetTheme("Dark") -- OPTIONAL | Themes: "Dark", "White", "Midnight"

local Main = Window:AddTab(6031068426) -- Icon ID (OPTIONAL)

Main:AddToggle(
    "ESP", -- Title
    "Toggle player ESP.", -- Description (OPTIONAL)
    false, -- Default Value (OPTIONAL)
    function(Value)
        print(Value)
    end
)

Main:AddDropdown(
    "Theme", -- Title
    {
        "Dark",
        "White",
        "Midnight"
    }, -- Options
    function(Option)
        Window:SetTheme(Option)
    end
)

Main:AddSlider(
    "WalkSpeed", -- Title
    16, -- Minimum Value
    100, -- Maximum Value
    16, -- Default Value (OPTIONAL)
    function(Value)
        local Humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
)

local Visuals = Window:AddTab(6031094678) -- You can create as many tabs as you want.

Visuals:AddToggle(
    "FullBright",
    nil, -- Description (OPTIONAL)
    false,
    function(Value)
        print(Value)
    end
)

Visuals:AddSlider(
    "Brightness",
    0,
    10,
    2,
    function(Value)
        game:GetService("Lighting").Brightness = Value
    end
)

local Settings = Window:AddTab() -- Icon is OPTIONAL.

Settings:AddDropdown(
    "Choose Theme",
    {
        "Dark",
        "White",
        "Midnight"
    },
    function(Theme)
        Window:SetTheme(Theme)
    end
)

Settings:AddToggle(
    "Notifications",
    nil, -- Description (OPTIONAL)
    true,
    function(Value)
        print(Value)
    end
)

--[[

Create Window:
Library.CreateWindow("Title")

Themes:
Window:SetTheme("Dark")
Window:SetTheme("White")
Window:SetTheme("Midnight")

Create Tab:
Window:AddTab()
Window:AddTab(6031068426) -- Optional icon

Toggle:
Tab:AddToggle(Title, Description, DefaultValue, Callback)

Dropdown:
Tab:AddDropdown(Title, Options, Callback)

Slider:
Tab:AddSlider(Title, Min, Max, DefaultValue, Callback)

]]