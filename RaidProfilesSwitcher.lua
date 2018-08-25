local frame = CreateFrame("Frame");

function eventHandler(self, event, ...)
 if ( HasLoadedCUFProfiles() ) then
  local groupSize = GetNumGroupMembers();
  if IsInGroup() then
   local name, instanceType = GetInstanceInfo();
   if ( not name ) then
    -- We're in an unknown zone, abort for safety
    return;
   end
   
   local isPvP = instanceType == "arena" or instanceType == "pvp" or C_PvP.IsWarModeDesired();
   local spec = GetSpecialization();

   -- Correct the group size to profile values
   if groupSize == 1 then groupSize = 2
    elseif groupSize <= 3 then  
    elseif groupSize <= 5 then groupSize = 5
    elseif groupSize <= 10 then groupSize = 10 
    elseif groupSize <= 15 then groupSize = 15 
    elseif groupSize <= 25 then groupSize = 25 
    elseif groupSize <= 40 then groupSize = 40
   end
   
   -- Loop through all profiles and check if any of them match
   for i=1, GetNumRaidProfiles() do
    -- Get the profile name
    local profile = GetRaidProfileName(i);
	
    if GetRaidProfileOption(profile, "autoActivate".. groupSize .."Players") 
	 and GetRaidProfileOption(profile, "autoActivateSpec"..spec) 
	 and isPvP == GetRaidProfileOption(profile, "autoActivatePvP") 
	 then
      -- Everything seems to match! Activate the profile
      CompactUnitFrameProfiles_ActivateRaidProfile(profile);
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