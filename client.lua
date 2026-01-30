----------------------
--- Bad-ServerList ---
----------------------
AddEventHandler('playerSpawned', function()
	if not alreadySet then 
		TriggerServerEvent('Bad-ServerList:SetupImg')
		alreadySet = true;
	end 
end)
alreadySet = false;
nui = false;
pageSize = Config.PageSize;
pageCount = 1;
count = 0;
function mod(a, b)
    return a - (math.floor(a/b)*b)
end

curCount = 0;
Citizen.CreateThread(function()
	local key = Config.KeyCode;
	nui = false;
	local col = true;
	while true do 
		Wait(0);
		if IsControlPressed(0, key) then 
			if not nui then 
				local left = "";
				local right = "";
				col = true;
				local maxCount = 0;
				for id, ava in pairs(avatarss) do
					maxCount = maxCount + 1;
				end
				local counter = 0;
				local keys = {}
				for key, ava in pairs(avatarss) do 
					table.insert(keys, tonumber(key));
				end
				table.sort(keys);
				for key = 1, #keys do
					local id = tostring(keys[key]);
					local ava = avatarss[id];
					if (count < (pageSize * pageCount) and counter >= curCount) then 
						if (pingss[id] ~= nil and playerNames[id] ~= nil and discordNames[id] ~= nil) then 
							if col then 
								-- Left col 
								col = false;
								left = left .. '<tr class="player-box">' ..
							'<td><img src="' .. ava .. '" /></td>' ..
							'<td>' .. discordNames[id]:gsub("<", ""):gsub(">", "") .. '</td>' ..
							"<td>" .. playerNames[id]:gsub("<", ""):gsub(">", "") .. "</td>" .. 
							"<td>" .. id .. "</td>" ..
							"<td>" .. pingss[id] .. " ms</td>" ..
							"</tr>";
							else
								-- Right col 
								col = true;
								right = right .. '<tr class="player-box">' ..
							'<td><img src="' .. ava .. '" /></td>' ..
							'<td>' .. discordNames[id]:gsub("<", ""):gsub(">", "") .. '</td>' ..
							"<td>" .. playerNames[id]:gsub("<", ""):gsub(">", "") .. "</td>" .. 
							"<td>" .. id .. "</td>" ..
							"<td>" .. pingss[id] .. " ms</td>" ..
							"</tr>";
							end
							count = count + 1;
						end
					end 
					counter = counter + 1;
				end
				SendNUIMessage({
								addRowLeft = left,
								addRowRight = right,
								playerCount = maxCount .. " / " .. Config.MaxPlayers,
								page = "Page " .. pageCount,
								serverName = Config.ServerName
							})
				if (count >= maxCount) then 
					count = 0;
					pageCount = 1;
					col = true;
					curCount = 0;
				end
				if (count >= (pageSize * pageCount)) then 
					pageCount = pageCount + 1;
					curCount = (pageSize * pageCount) - pageSize;
					col = true;
				end
				SendNUIMessage({
					display = true;
				})
				
				nui = true
		        while nui do
		            Wait(0)
		            if(IsControlPressed(0, key) == false) then
		                nui = false
		                SendNUIMessage({
		                    display = false;
		                })
		                break
		            end
	        	end
	        end 
		end
	end
end)
avatarss = {}
pingss = {}
playerNames = {}
discordNames = {}

RegisterNetEvent('Bad-ServerList:Update', function(players, pings, avatarIDs, discords)
	playerNames, pingss, avatarss, discordNames = players, pings, avatarIDs, discords
end)