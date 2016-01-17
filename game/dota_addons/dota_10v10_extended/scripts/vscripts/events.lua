---------------------------------------------------------------------------
-- Event: OnEntityKilled
---------------------------------------------------------------------------
function CMegaDotaGameMode:OnEntityKilled( event )
	
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( event.entindex_attacker )
	local heroTeam = hero:GetTeam()
	local extraTime = 0
	local respawnTime = 0	

	if killedUnit:IsRealHero() then
		self.allSpawned = true
		
		--print("Hero has been killed")	

		--Add extra time if killed by Necro Ult
		if hero:IsRealHero() == true then
			if event.entindex_inflictor ~= nil then
				local inflictor_index = event.entindex_inflictor
				if inflictor_index ~= nil then
					local ability = EntIndexToHScript( event.entindex_inflictor )
					if ability ~= nil then
						if ability:GetAbilityName() ~= nil then
							if ability:GetAbilityName() == "necrolyte_reapers_scythe" then
								--print("Killed by Necro Ult")
								killedUnit:SetBuyBackDisabledByReapersScythe(true);
								extraTime = 20
							end
						end
					end
				end
			end
		end
			
		if killedUnit:GetRespawnTime() > 10 then
			--print("Hero has long respawn time")
			if killedUnit:IsReincarnating() == true then
				--print("Set time for Wraith King respawn disabled")
				return nil
			end
		end		
		
		CMegaDotaGameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )			
	end

end

function CMegaDotaGameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
	--print("Setting time for respawn")
	local respawnTime = killedUnit:GetLevel() * 2

	killedUnit:SetTimeUntilRespawn( respawnTime + extraTime )
end


