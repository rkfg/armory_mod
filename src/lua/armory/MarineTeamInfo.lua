local networkVars =
{
    numMinigunExos = "integer (0 to 30)",
    numRailgunExos = "integer (0 to 30)"
}

local old_MarineTeamInfo_OnCreate = MarineTeamInfo.OnCreate

function MarineTeamInfo:OnCreate()
    old_MarineTeamInfo_OnCreate(self)
    self.numMinigunExos = 0
    self.numRailgunExos = 0
end

if Server then

    local function _GetNumActiveExos()

        local exos = EntityListToTable(Shared.GetEntitiesWithClassname("Exo"))
        local activeCountMinigun = 0
        local activeCountRailgun = 0

        for i=1, #exos do
            local exo = exos[i]
            if exo and exo:isa("Exo") and GetIsUnitActive(exo) then
                if exo:GetHasMinigun() then
                    activeCountMinigun = activeCountMinigun + 1
                elseif exo:GetHasRailgun() then
                    activeCountRailgun = activeCountRailgun + 1
                end
            end
        end

        return activeCountMinigun, activeCountRailgun

    end

    local old_MarineTeamInfo_Reset = MarineTeamInfo.Reset
    function MarineTeamInfo:Reset()

        self.numMinigunExos = 0
        self.numRailgunExos = 0
        old_MarineTeamInfo_Reset(self)
    end

    local old_MarineTeamInfo_OnUpdate = MarineTeamInfo.OnUpdate
    function MarineTeamInfo:OnUpdate(deltaTime)
        local mini, rail = _GetNumActiveExos()

        old_MarineTeamInfo_OnUpdate(self, deltaTime)

        if self.numMinigunExos ~= mini or self.numRailgunExos ~= rail then
             self.numMinigunExos = mini
             self.numRailgunExos = rail
        end

    end

end

Shared.LinkClassToMap("MarineTeamInfo", MarineTeamInfo.kMapName, networkVars)
