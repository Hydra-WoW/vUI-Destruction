local AddOn = ...
local vUI, GUI, Language, Media, Settings = vUIGlobal:get()

local Destruction = vUI:NewPlugin(AddOn)

if (vUI.UserClass ~= "WARLOCK") then
	return
end

local BackdraftName = GetSpellInfo(196406)
local ImmolateName = GetSpellInfo(157736)

local GetTime = GetTime
local format = format
local UnitAuraByName = UnitAuraByName
local Name, Count, Duration, Expiration, _

function Destruction:OnUpdate(elapsed)
	self.BackdraftRemaining = self.BackdraftRemaining - elapsed
	self.ImmolateRemaining = self.ImmolateRemaining - elapsed
	
	if (self.BackdraftRemaining > 0) then
		self.BackdraftBar:SetValue(self.BackdraftRemaining)
		self.BackdraftBar.Time:SetText(format("%.1fs", self.BackdraftRemaining))
	end
	
	if (self.ImmolateRemaining > 0) then
		self.ImmolateBar:SetValue(self.ImmolateRemaining)
		self.ImmolateBar.Time:SetText(format("%.1fs", self.ImmolateRemaining))
	end
	
	if ((0 > self.BackdraftRemaining) and (0 > self.ImmolateRemaining)) then
		self:SetScript("OnUpdate", nil)
	end
end

function Destruction:OnEvent(event, unit)
	if (unit == "player") then
		Name, _, Count, _, Duration, Expiration = UnitAuraByName("player", BackdraftName)
		
		if Expiration then
			self.BackdraftRemaining = Expiration - GetTime()
			self.BackdraftBar:SetMinMaxValues(0, Duration)
			self.BackdraftBar.Count:SetText(Count)
			self.BackdraftBar.Time:SetText(format("%.1fs", self.BackdraftRemaining))
			self:SetScript("OnUpdate", self.OnUpdate)
		else
			--self:SetScript("OnUpdate", nil)
			self.BackdraftBar:SetValue(0)
			self.BackdraftBar.Count:SetText("")
			self.BackdraftBar.Time:SetText("")
		end
	elseif (unit == "target") then
		Name, _, Count, _, Duration, Expiration = UnitDebuffByName("target", ImmolateName, "PLAYER")
		
		if Expiration then
			self.ImmolateRemaining = Expiration - GetTime()
			self.ImmolateBar:SetMinMaxValues(0, Duration)
			self.ImmolateBar.Time:SetText(format("%.1fs", self.ImmolateRemaining))
			self:SetScript("OnUpdate", self.OnUpdate)
		else
			--self:SetScript("OnUpdate", nil)
			self.ImmolateBar:SetValue(0)
			self.ImmolateBar.Time:SetText("")
		end
	end
end

function Destruction:CreateBars()
	self.BackdraftRemaining = 0
	self.ImmolateRemaining = 0
	
	-- Backdraft bar
	self.BackdraftBar = CreateFrame("StatusBar", nil, UIParent)
	self.BackdraftBar:SetStatusBarTexture(Media:GetTexture(Settings["ui-widget-texture"]))
	self.BackdraftBar:SetStatusBarColorHex("E0392B")
	self.BackdraftBar:SetScaledSize(Settings["unitframes-player-width"] - 2, 20)
	self.BackdraftBar:SetScaledPoint("BOTTOM", vUI.UnitFrames["player"].ClassPower, "TOP", 0, 0)
	self.BackdraftBar:SetMinMaxValues(0, 1)
	self.BackdraftBar:SetValue(0)
	
	self.BackdraftBar.BG = self.BackdraftBar:CreateTexture(nil, "ARTWORK")
	self.BackdraftBar.BG:SetAllPoints(self.BackdraftBar)
	self.BackdraftBar.BG:SetTexture(Media:GetTexture(Settings["ui-widget-texture"]))
	self.BackdraftBar.BG:SetVertexColorHex("E0392B")
	self.BackdraftBar.BG:SetAlpha(0.2)
	
	self.BackdraftBar.Count = self.BackdraftBar:CreateFontString(nil, "OVERLAY")
	self.BackdraftBar.Count:SetFontInfo(Settings["ui-widget-font"], Settings["ui-font-size"])
	self.BackdraftBar.Count:SetScaledPoint("LEFT", self.BackdraftBar, 3, 0)
	self.BackdraftBar.Count:SetJustifyH("LEFT")
	
	self.BackdraftBar.Time = self.BackdraftBar:CreateFontString(nil, "OVERLAY")
	self.BackdraftBar.Time:SetFontInfo(Settings["ui-widget-font"], Settings["ui-font-size"])
	self.BackdraftBar.Time:SetScaledPoint("RIGHT", self.BackdraftBar, -3, 0)
	self.BackdraftBar.Time:SetJustifyH("RIGHT")
	
	self.BackdraftBar.BG2 = self.BackdraftBar:CreateTexture(nil, "BORDER")
	self.BackdraftBar.BG2:SetScaledPoint("TOPLEFT", self.BackdraftBar, -1, 1)
	self.BackdraftBar.BG2:SetScaledPoint("BOTTOMRIGHT", self.BackdraftBar, 1, -1)
	self.BackdraftBar.BG2:SetTexture(Media:GetTexture("Blank"))
	self.BackdraftBar.BG2:SetVertexColor(0, 0, 0)
	
	-- Immolate bar
	self.ImmolateBar = CreateFrame("StatusBar", nil, UIParent)
	self.ImmolateBar:SetStatusBarTexture(Media:GetTexture(Settings["ui-widget-texture"]))
	self.ImmolateBar:SetStatusBarColorHex("FFA000")
	self.ImmolateBar:SetScaledSize(Settings["unitframes-player-width"] - 2, 20)
	self.ImmolateBar:SetScaledPoint("BOTTOM", self.BackdraftBar, "TOP", 0, 1)
	self.ImmolateBar:SetMinMaxValues(0, 1)
	self.ImmolateBar:SetValue(0)
	
	self.ImmolateBar.BG = self.ImmolateBar:CreateTexture(nil, "ARTWORK")
	self.ImmolateBar.BG:SetAllPoints(self.ImmolateBar)
	self.ImmolateBar.BG:SetTexture(Media:GetTexture(Settings["ui-widget-texture"]))
	self.ImmolateBar.BG:SetVertexColorHex("FFA000")
	self.ImmolateBar.BG:SetAlpha(0.2)
	
	self.ImmolateBar.Time = self.ImmolateBar:CreateFontString(nil, "OVERLAY")
	self.ImmolateBar.Time:SetFontInfo(Settings["ui-widget-font"], Settings["ui-font-size"])
	self.ImmolateBar.Time:SetScaledPoint("RIGHT", self.ImmolateBar, -3, 0)
	self.ImmolateBar.Time:SetJustifyH("RIGHT")
	
	self.ImmolateBar.BG2 = self.ImmolateBar:CreateTexture(nil, "BORDER")
	self.ImmolateBar.BG2:SetScaledPoint("TOPLEFT", self.ImmolateBar, -1, 1)
	self.ImmolateBar.BG2:SetScaledPoint("BOTTOMRIGHT", self.ImmolateBar, 1, -1)
	self.ImmolateBar.BG2:SetTexture(Media:GetTexture("Blank"))
	self.ImmolateBar.BG2:SetVertexColor(0, 0, 0)
	
	self.ImmolateBar.Refresh = CreateFrame("StatusBar", nil, self.ImmolateBar)
	self.ImmolateBar.Refresh:SetAllPoints(self.ImmolateBar)
	self.ImmolateBar.Refresh:SetMinMaxValues(0, 100)
	self.ImmolateBar.Refresh:SetValue(30)
	self.ImmolateBar.Refresh:SetFrameLevel(30)
	self.ImmolateBar.Refresh:SetFrameStrata("HIGH")
	self.ImmolateBar.Refresh:SetStatusBarTexture(Media:GetTexture(Settings["ui-widget-texture"]))
	self.ImmolateBar.Refresh:SetStatusBarColor(1, 1, 1, 0)
	
	self.ImmolateBar.RefreshSpark = self.ImmolateBar.Refresh:CreateTexture(nil, "OVERLAY")
	self.ImmolateBar.RefreshSpark:SetScaledSize(1, 20)
	self.ImmolateBar.RefreshSpark:SetScaledPoint("RIGHT", self.ImmolateBar.Refresh:GetStatusBarTexture(), 0, 0)
	self.ImmolateBar.RefreshSpark:SetColorTexture(0, 0, 0)
end

function Destruction:Load()
	self:CreateBars()
	self:RegisterEvent("UNIT_AURA")
	self:SetScript("OnEvent", self.OnEvent)
end