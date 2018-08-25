local frame = CreateFrame("Frame");

function eventHandler(self, event, ...)
 if ( HasLoadedCUFProfiles() ) then
  local groupSize = GetNumGroupMembers();
  if IsInGroup() and groupSize > 1 then
   local name, instanceType, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo();
   if ( not name ) then
    -- We're in an unknown zone, abort for safety
    return;
   end
   
   local isPvP = instanceType == "arena" or instanceType == "pvp";
   local spec = GetSpecialization();

   -- Correct the group size to profile values
   if groupSize > 3 then
    if groupSize <= 5 then groupSize = 5 else
     if groupSize <= 10 then groupSize = 10 else
      if groupSize <= 15 then groupSize = 15 else
       if groupSize <= 25 then groupSize = 25 else
        if groupSize <= 40 then groupSize = 40 end 
       end
      end
     end
    end
   end
   
   -- Loop through all profiles and check if any of them match
   for i=1, GetNumRaidProfiles() do
     -- Get the profile name
     local profile = GetRaidProfileName(i);
	 
     if GetRaidProfileOption(profile, "autoActivate".. groupSize .."Players") then
      -- Group size is OK!
	  if spec == GetRaidProfileOption(profile, "autoActivateSpec"..spec) then
	   -- Spec OK!
	   if isPvP == GetRaidProfileOption(profile, "autoActivatePvP") then
	    -- PvP OK
		
		-- Everything seems to match! Activate the profile
	    CompactUnitFrameProfiles_ActivateRaidProfile(profile);
	   end
	  end
	 end
   end
  end
 end
end

-- Set the event handler and register the events we need to listen to:
frame:SetScript("OnEvent", eventHandler);
frame:RegisterEvent("GROUP_ROSTER_UPDATE"); -- Someone left or joined
frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED"); -- Player changed spec
frame:RegisterEvent("PLAYER_ENTERING_WORLD"); -- Player loaded into zone