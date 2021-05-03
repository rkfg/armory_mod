local smallIconHeight = 64
local smallIconWidth = 128

GUIMarineBuyMenu.kOthersIconTexture = 'ui/menu/friends_icon.dds'
--
-- Checks if the mouse is over the passed in GUIItem and plays a sound if it has just moved over.
--
local function GetIsMouseOver(self, overItem)

    local mouseOver = GUIItemContainsPoint(overItem, Client.GetCursorPosScreen())
    if mouseOver and not self.mouseOverStates[overItem] then
        MarineBuy_OnMouseOver()
    end
    self.mouseOverStates[overItem] = mouseOver
    return mouseOver
    
end

local function GetSmallIconPixelCoordinates(itemTechId)

    if not gSmallIconIndex then
        gSmallIconIndex = {}
        gSmallIconIndex[kTechId.Axe] = 4
        gSmallIconIndex[kTechId.Pistol] = 3
        gSmallIconIndex[kTechId.Rifle] = 1
        gSmallIconIndex[kTechId.Shotgun] = 5
        gSmallIconIndex[kTechId.GrenadeLauncher] = 35
        gSmallIconIndex[kTechId.Flamethrower] = 6
        gSmallIconIndex[kTechId.HeavyMachineGun] = 50
        gSmallIconIndex[kTechId.Jetpack] = 24
        gSmallIconIndex[kTechId.Exosuit] = 26
        gSmallIconIndex[kTechId.Welder] = 10
        gSmallIconIndex[kTechId.LayMines] = 21
        gSmallIconIndex[kTechId.DualMinigunExosuit] = 26
        gSmallIconIndex[kTechId.UpgradeToDualMinigun] = 26
        gSmallIconIndex[kTechId.ClawRailgunExosuit] = 38
        gSmallIconIndex[kTechId.DualRailgunExosuit] = 38
        gSmallIconIndex[kTechId.UpgradeToDualRailgun] = 38
        
        gSmallIconIndex[kTechId.ClusterGrenade] = 42
        gSmallIconIndex[kTechId.GasGrenade] = 43
        gSmallIconIndex[kTechId.PulseGrenade] = 44
    
    end
    
    local index = gSmallIconIndex[itemTechId]
    if not index then
        index = 0
    end
    
    local y1 = index * smallIconHeight
    local y2 = (index + 1) * smallIconHeight
    
    return 0, y1, smallIconWidth, y2

end

function GUIMarineBuyMenu:_InitializeItemButtons()
    
    self.menu = GetGUIManager():CreateGraphicItem()
    self.menu:SetPosition(Vector( -GUIMarineBuyMenu.kMenuWidth - GUIMarineBuyMenu.kPadding, 0, 0))
    self.menu:SetTexture(GUIMarineBuyMenu.kContentBgTexture)
    self.menu:SetSize(Vector(GUIMarineBuyMenu.kMenuWidth, GUIMarineBuyMenu.kBackgroundHeight, 0))
    self.menu:SetTexturePixelCoordinates(0, 0, GUIMarineBuyMenu.kMenuWidth, GUIMarineBuyMenu.kBackgroundHeight)
    self.content:AddChild(self.menu)
    
    self.menuHeader = GetGUIManager():CreateGraphicItem()
    self.menuHeader:SetSize(Vector(GUIMarineBuyMenu.kMenuWidth, GUIMarineBuyMenu.kResourceDisplayHeight, 0))
    self.menuHeader:SetPosition(Vector(0, -GUIMarineBuyMenu.kResourceDisplayHeight, 0))
    self.menuHeader:SetTexture(GUIMarineBuyMenu.kContentBgBackTexture)
    self.menuHeader:SetTexturePixelCoordinates(0, 0, GUIMarineBuyMenu.kMenuWidth, GUIMarineBuyMenu.kResourceDisplayHeight)
    self.menu:AddChild(self.menuHeader) 
    
    self.menuHeaderTitle = GetGUIManager():CreateTextItem()
    self.menuHeaderTitle:SetFontName(GUIMarineBuyMenu.kFont)
    self.menuHeaderTitle:SetScale(GetScaledVector())
    GUIMakeFontScale(self.menuHeaderTitle)
    self.menuHeaderTitle:SetFontIsBold(true)
    self.menuHeaderTitle:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.menuHeaderTitle:SetTextAlignmentX(GUIItem.Align_Center)
    self.menuHeaderTitle:SetTextAlignmentY(GUIItem.Align_Center)
    self.menuHeaderTitle:SetColor(GUIMarineBuyMenu.kTextColor)
    self.menuHeaderTitle:SetText(Locale.ResolveString("BUY"))
    self.menuHeader:AddChild(self.menuHeaderTitle)
    
    self.itemButtons = { }
    
    local itemTechIdList = self.hostStructure:GetItemList(Client.GetLocalPlayer())
    local selectorPosX = -GUIMarineBuyMenu.kSelectorSize.x + GUIMarineBuyMenu.kPadding
    local fontScaleVector = GUIScale(Vector(0.8, 0.8, 0))
    
    for k, itemTechId in ipairs(itemTechIdList) do
    
        local graphicItem = GUIManager:CreateGraphicItem()
        graphicItem:SetSize(GUIMarineBuyMenu.kMenuIconSize)
        graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Top)
        graphicItem:SetPosition(Vector(-GUIMarineBuyMenu.kMenuIconSize.x/ 2, GUIMarineBuyMenu.kIconTopOffset + (GUIMarineBuyMenu.kMenuIconSize.y) * k - GUIMarineBuyMenu.kMenuIconSize.y, 0))
        graphicItem:SetTexture(kInventoryIconsTexture)
        graphicItem:SetTexturePixelCoordinates(GetSmallIconPixelCoordinates(itemTechId))
        
        local graphicItemActive = GUIManager:CreateGraphicItem()
        graphicItemActive:SetSize(GUIMarineBuyMenu.kSelectorSize)
        
        graphicItemActive:SetPosition(Vector(selectorPosX, -GUIMarineBuyMenu.kSelectorSize.y / 2, 0))
        graphicItemActive:SetAnchor(GUIItem.Right, GUIItem.Center)
        graphicItemActive:SetTexture(GUIMarineBuyMenu.kMenuSelectionTexture)
        graphicItemActive:SetIsVisible(false)
        
        graphicItem:AddChild(graphicItemActive)
        
        local costIcon = GUIManager:CreateGraphicItem()
        costIcon:SetSize(Vector(GUIMarineBuyMenu.kResourceIconWidth * 0.8, GUIMarineBuyMenu.kResourceIconHeight * 0.8, 0))
        costIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        costIcon:SetPosition(Vector(-GUIScale(32), -GUIMarineBuyMenu.kResourceIconHeight * 0.5, 0))
        costIcon:SetTexture(GUIMarineBuyMenu.kResourceIconTexture)
        costIcon:SetColor(GUIMarineBuyMenu.kTextColor)
        
        local selectedArrow = GUIManager:CreateGraphicItem()
        selectedArrow:SetSize(Vector(GUIMarineBuyMenu.kArrowWidth, GUIMarineBuyMenu.kArrowHeight, 0))
        selectedArrow:SetAnchor(GUIItem.Left, GUIItem.Center)
        selectedArrow:SetPosition(Vector(-GUIMarineBuyMenu.kArrowWidth - GUIMarineBuyMenu.kPadding, -GUIMarineBuyMenu.kArrowHeight * 0.5, 0))
        selectedArrow:SetTexture(GUIMarineBuyMenu.kArrowTexture)
        selectedArrow:SetColor(GUIMarineBuyMenu.kTextColor)
        selectedArrow:SetTextureCoordinates(GUIUnpackCoords(GUIMarineBuyMenu.kArrowTexCoords))
        selectedArrow:SetIsVisible(false)
        
        graphicItem:AddChild(selectedArrow) 
        
        local itemCost = GUIManager:CreateTextItem()
        itemCost:SetFontName(GUIMarineBuyMenu.kFont)
        itemCost:SetFontIsBold(true)
        itemCost:SetAnchor(GUIItem.Right, GUIItem.Center)
        itemCost:SetPosition(Vector(0, 0, 0))
        itemCost:SetTextAlignmentX(GUIItem.Align_Min)
        itemCost:SetTextAlignmentY(GUIItem.Align_Center)
        itemCost:SetScale(fontScaleVector)
        GUIMakeFontScale(itemCost)
        itemCost:SetColor(GUIMarineBuyMenu.kTextColor)
        itemCost:SetText(ToString(LookupTechData(itemTechId, kTechDataCostKey, 0)))
        
        costIcon:AddChild(itemCost)  

        local playerIcon = GUIManager:CreateGraphicItem()
        playerIcon:SetSize(Vector(GUIMarineBuyMenu.kResourceIconWidth * 0.8, GUIMarineBuyMenu.kResourceIconHeight * 0.8, 0))
        playerIcon:SetAnchor(GUIItem.Left, GUIItem.Bottom)
        playerIcon:SetPosition(Vector(0, -GUIMarineBuyMenu.kResourceIconHeight * 0.5, 0))
        playerIcon:SetTexture(GUIMarineBuyMenu.kOthersIconTexture)
        playerIcon:SetColor(GUIMarineBuyMenu.kTextColor)

        local otherWeapons = GUIManager:CreateTextItem()
        otherWeapons:SetFontName(GUIMarineBuyMenu.kFont)
        otherWeapons:SetFontIsBold(true)
        otherWeapons:SetAnchor(GUIItem.Right, GUIItem.Center)
        otherWeapons:SetPosition(Vector(GUIScale(4), 0, 0))
        otherWeapons:SetTextAlignmentX(GUIItem.Align_Min)
        otherWeapons:SetTextAlignmentY(GUIItem.Align_Center)
        otherWeapons:SetScale(fontScaleVector)
        GUIMakeFontScale(otherWeapons)
        otherWeapons:SetColor(GUIMarineBuyMenu.kTextColor)
        otherWeapons:SetText("0")

        graphicItem:AddChild(playerIcon)
        playerIcon:AddChild(otherWeapons)

        graphicItem:AddChild(costIcon)  
        
        self.menu:AddChild(graphicItem)
        table.insert(self.itemButtons, { Button = graphicItem, Highlight = graphicItemActive,
         TechId = itemTechId, Cost = itemCost, ResourceIcon = costIcon, Arrow = selectedArrow,
         OthersCount = otherWeapons, PlayerIcon = playerIcon } )
    
    end
    
    -- to prevent wrong display before the first update
    self:_UpdateItemButtons(0)

end

local statusToWeapon = {
    [kPlayerStatus.GrenadeLauncher] = kTechId.GrenadeLauncher,
    [kPlayerStatus.Rifle] = kTechId.Rifle,
    [kPlayerStatus.HeavyMachineGun] = kTechId.HeavyMachineGun,
    [kPlayerStatus.Flamethrower] = kTechId.Flamethrower,
    [kPlayerStatus.Shotgun] = kTechId.Shotgun,
}

function GUIMarineBuyMenu:_UpdateItemButtons(deltaTime)
    
    if self.itemButtons then
        local itemCounts = {}
        for _, playerInfo in ientitylist(Shared.GetEntitiesWithClassname("PlayerInfoEntity")) do
            for _, techId in ipairs(GetTechIdsFromBitMask(playerInfo.currentTech)) do
                if techId == kTechId.Mine then
                    techId = kTechId.LayMines
                end
                itemCounts[techId] = itemCounts[techId] and itemCounts[techId] + 1 or 1
            end
            local w = statusToWeapon[playerInfo.status]
            if w then
                itemCounts[w] = itemCounts[w] and itemCounts[w] + 1 or 1
            end
        end
        local teamInfo = GetTeamInfoEntity(kTeam1Index)
        if teamInfo then
            itemCounts[kTechId.DualMinigunExosuit] = teamInfo.numMinigunExos
            itemCounts[kTechId.DualRailgunExosuit] = teamInfo.numRailgunExos
        end
        for i, item in ipairs(self.itemButtons) do
        
            if GetIsMouseOver(self, item.Button) then
            
                item.Highlight:SetIsVisible(true)
                self.hoverItem = item.TechId
                
            else
                item.Highlight:SetIsVisible(false)
            end
            
            local useColor = Color(1, 1, 1, 1)
            
            -- set grey if not researched
            if not MarineBuy_IsResearched(item.TechId) then
                useColor = Color(0.75, 0.25, 0.25, 0.35)
            -- set red if can't afford
            elseif PlayerUI_GetPlayerResources() < MarineBuy_GetCosts(item.TechId) then
               useColor = Color(1, 0, 0, 1)
            -- set normal visible
            elseif MarineBuy_GetHas( item.TechId ) then
                useColor = Color(0.6, 0.6, 0.6, 0.5)
            else

                local newResearchedId = GetItemTechId( PlayerUI_GetRecentPurchaseable() )
                local newlyResearched = false 
                if type(newResearchedId) == "table" then
                    newlyResearched = table.icontains(newResearchedId, item.TechId)
                else
                    newlyResearched = newResearchedId == item.TechId
                end
                
                if newlyResearched then
                
                    local anim = math.cos(Shared.GetTime() * 9) * 0.4 + 0.6
                    useColor = Color(1, 1, anim, 1)
                    
                end
               
            end
            
            item.Button:SetColor(useColor)
            item.Highlight:SetColor(useColor)
            item.Cost:SetColor(useColor)
            item.ResourceIcon:SetColor(useColor)
            item.Arrow:SetIsVisible(self.selectedItem == item.TechId)
            item.OthersCount:SetText(tostring(itemCounts[item.TechId] or "0"))
        end
    end

end
