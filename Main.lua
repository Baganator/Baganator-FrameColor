local classicBorderFrames = {
  "BotLeftCorner", "BotRightCorner", "BottomBorder", "LeftBorder", "RightBorder",
  "TopRightCorner", "TopLeftCorner", "TopBorder"
}

local function DoTab(colors, frame)
  for _,texture in pairs({
    frame.Left,
    frame.Middle,
    frame.Right,
  }) do
    texture:SetDesaturation(colors.desaturation)
    texture:SetVertexColor(colors.tab.r,colors.tab.g,colors.tab.b)
  end
end

local skinners = {
  ButtonFrame = function(colors, frame)
    if frame.NineSlice then
      for _, texture in pairs({
        frame.NineSlice.TopEdge,
        frame.NineSlice.BottomEdge,
        frame.NineSlice.TopRightCorner,
        frame.NineSlice.TopLeftCorner,
        frame.NineSlice.RightEdge,
        frame.NineSlice.LeftEdge,
        frame.NineSlice.BottomRightCorner,
        frame.NineSlice.BottomLeftCorner,
      }) do
        texture:SetDesaturation(colors.desaturation)
        texture:SetVertexColor(colors.main.r,colors.main.g,colors.main.b,colors.main.a)
      end
    else
      for _, key in ipairs(classicBorderFrames) do
        local texture = frame[key]
        texture:SetDesaturation(colors.desaturation)
        texture:SetVertexColor(colors.main.r,colors.main.g,colors.main.b,colors.main.a)
      end
    end
    for _, texture in pairs({
      frame.Bg,
    }) do
      texture:SetDesaturation(colors.desaturation)
      texture:SetVertexColor(colors.bg.r,colors.bg.g,colors.bg.b,colors.bg.a)
    end
  end,
  TabButton = DoTab,
  TopTabButton = DoTab,
}

local function SkinFrame(colors, details)
  local func = skinners[details.regionType]
  if func then
    func(colors, details.region)
  end
end


local info = {
    moduleName = "Baganator",
    color1 = {
        name = "Main",
        desc = "",
    },
    color2 = {
        name = "Background",
        desc = "",
        hasAlpha = true,
    },
    color3 = {
        name = "Tabs",
        desc = "",
    },
}

local module = FrameColor_CreateSkinModule(info)

function module:OnEnable()
  if not self.registered then
    Baganator.API.Skins.RegisterListener(function(details) SkinFrame(self.colors, details) end)
    self.registered = true
  end
  self.colors = {
    main = self:GetColor1(),
    bg = self:GetColor2(),
    tab = self:GetColor3(),
    desaturation = 1,
  }
  self:Recolor()
  Baganator.Config.Set(Baganator.Config.Options.VIEW_ALPHA, self.colors.bg.a or 1)
end

function module:OnDisable()
  local default_color = {r=1,g=1,b=1,a=1}
  self.colors = {
    main = default_color,
    bg = default_color,
    tab = default_color,
    desaturation = 0,
  }
  self:Recolor()
  Baganator.Config.Set(Baganator.Config.Options.VIEW_ALPHA, self.colors.bg.a or 1)
end

function module:Recolor(colors)
  for _, details in ipairs(Baganator.API.Skins.GetAllFrames()) do
    SkinFrame(self.colors, details)
  end
end
