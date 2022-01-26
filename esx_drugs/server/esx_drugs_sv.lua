ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingCoke    = {}
local PlayersTransformingCoke  = {}
local PlayersHarvestingMeth    = {}
local PlayersTransformingMeth  = {}
local PlayersHarvestingWeed    = {}
local PlayersTransformingWeed  = {}
local PlayersTransformingWeedIndica  = {}
local PlayersHarvestingOpium   = {}
local PlayersTransformingOpium = {}
local PlayersHarvestingCrack   = {}
local PlayersTransformingCrack = {}
local Zones = {
	CokeField =			{x = 1581.45, y = 2919.33, z = 57.11, name = 'plantacja kokainy',		sprite = 501,	color = 40}, -- ZMIENIONE
	CokeProcessing =	{x = -528.96, y = -1797.16, z = 21.61, name = 'przerobka lisci kokainy',	sprite = 478,	color = 40}, -- ZMIENIONE

	MethField =			{x = 2860.32, y = 1451.22, z = 24.57, name = 'laboratorium metamfetaminy',		sprite = 499,	color = 26}, -- ZMIENIONE
	MethProcessing =	{x = -80.3, y = 369.45, z = 112.46, name = 'kruszenie metamfetaminy',	sprite = 499,	color = 26}, -- ZMIENIONE
	
	WeedField =			{x = 2221.76, y = 5577.46, z = 53.83, name = 'plantacja marihuany',		sprite = 496,	color = 52}, -- ZMIENIONE
    --WeedField2 =		{x = -112.510, y = 1910.096, z = 197.031, name = 'plantacja marihuany',		sprite = 496,	color = 52}, -- ZMIENIONE
	WeedProcessing =	{x = -1911.31, y = 1388.63, z = 218.99, name = 'suszenie marihuany',	sprite = 496,	color = 52}, -- ZMIENIONE
	
	OpiumField =		{x = 3288.84, y = 5180.93, z = 18.54, name = 'pole opium',		sprite = 496,	color = 52}, -- ZMIENIONE
	OpiumProcessing =	{x = 3064.26, y = 2219.42, z = 3.03, name = 'przerobka opium',	sprite = 51,	color = 60}, -- ZMIENIONE

	CrackField =		{x = 980.14, y = -2194.55, z = -100.58, name = 'pole crack',		sprite = 496,	color = 52}, -- ZMIENIONE
	CrackProcessing =	{x = 1244.88, y = -2572.18, z = -100.05, name = 'przerobka crack',	sprite = 51,	color = 60}, -- ZMIENIONE

	XanaxField =			{x = 1218.95, y = 1905.52, z = 77.94, name = 'plantacja xanax',		sprite = 501,	color = 40}, -- ZMIENIONE
	XanaxProcessing =	{x = 1558.59, y = 2178.87, z = 78.9, name = 'przerobka lisci xanax',	sprite = 478,	color = 40}, -- ZMIENIONE

	AmfaField =			{x = 3534.81, y = 2585.57, z = 8.0, name = 'laboratorium amfy',		sprite = 499,	color = 26}, -- ZMIENIONE
	AmfaProcessing =	{x = 2894.88, y = 4369.31, z = 50.74, name = 'kruszenie amfy',	sprite = 499,	color = 26}, -- ZMIENIONE
	
	MorfinaField =			{x = 2221.76, y = 5577.46, z = 53.83, name = 'plantacja morfiny',		sprite = 496,	color = 52}, -- ZMIENIONE
	MorfinaProcessing =	{x = -1911.31, y = 1388.63, z = 218.99, name = 'suszenie morfiny',	sprite = 496,	color = 52}, -- ZMIENIONE
	
	ExtazyField =		{x = 1958.73, y = 5187.39, z = 47.42, name = 'pole extazy',		sprite = 496,	color = 52}, -- ZMIENIONE
	ExtazyProcessing =	{x = -3219.67, y = 1138.0, z = 5.7, name = 'przerobka extazy',	sprite = 51,	color = 60}, -- ZMIENIONE

	KodeinaField =		{x = 852.71, y = -504.01, z = 57.8, name = 'pole kodeiny',		sprite = 496,	color = 52}, -- ZMIENIONE
	KodeinaProcessing =	{x = 896.79, y = -2533.87, z = 28.33, name = 'przerobka kodeiny',	sprite = 51,	color = 60}, -- ZMIENIONE

}
local realtrigger = 'BxhqkXd4GKnn'

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('sandy_drugs:refreshdrugs')
AddEventHandler('sandy_drugs:refreshdrugs', function()
	local _source = source
	TriggerClientEvent('sandy_drugs:setplayerdrugs', _source, Zones)
end)

RegisterServerEvent('sandy_drugs:gettrigger')
AddEventHandler('sandy_drugs:gettrigger', function()
	local _source = source
	TriggerClientEvent('sandy_drugs:settrigger', _source, realtrigger)
end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

--coke
local function HarvestCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingCoke[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local coke = xPlayer.getInventoryItem('coke')

			if coke.limit ~= -1 and coke.count >= coke.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_coke'))
			else
				xPlayer.addInventoryItem('coke', 1)
				HarvestCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestCoke')
AddEventHandler('esx_veryfunstuff:startHarvestCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestCoke(_source)

end)

local function TransformCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local cokeQuantity = xPlayer.getInventoryItem('coke').count
			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif cokeQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_coke'))
			else
				xPlayer.removeInventoryItem('coke', 3)
				xPlayer.addInventoryItem('coke_pooch', 1)
			
				TransformCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformCoke')
AddEventHandler('esx_veryfunstuff:startTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformCoke(_source)

end)

--meth
local function HarvestMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end
	
	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local meth = xPlayer.getInventoryItem('meth')

			if meth.limit ~= -1 and meth.count >= meth.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_meth'))
			else
				xPlayer.addInventoryItem('meth', 1)
				HarvestMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestMeth')
AddEventHandler('esx_veryfunstuff:startHarvestMeth', function()

	local _source = source

	PlayersHarvestingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestMeth(_source)

end)

local function TransformMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local methQuantity = xPlayer.getInventoryItem('meth').count
			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif methQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_meth'))
			else
				xPlayer.removeInventoryItem('meth', 3)
				xPlayer.addInventoryItem('meth_pooch', 1)
				
				TransformMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformMeth')
AddEventHandler('esx_veryfunstuff:startTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformMeth(_source)

end)

RegisterServerEvent('esx_veryfunstuff:stopTransformMeth')
AddEventHandler('esx_veryfunstuff:stopTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = false

end)

--weed
local function HarvestWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingWeed[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local weed = xPlayer.getInventoryItem('weed')

			if weed.limit ~= -1 and weed.count >= weed.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_weed'))
			else
				xPlayer.addInventoryItem('weed', 1)
				HarvestWeed(source)
			end

		end
	end)
end

local function HarvestWeed2(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingWeed[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local weed = xPlayer.getInventoryItem('weedindica')

			if weed.limit ~= -1 and weed.count >= weed.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_weed'))
			else
				xPlayer.addInventoryItem('weedindica', 1)
				HarvestWeed2(source)
			end

		end
	end)
end


RegisterServerEvent('esx_veryfunstuff:startHarvestWeed')
AddEventHandler('esx_veryfunstuff:startHarvestWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestWeed(_source)

end)

RegisterServerEvent('esx_veryfunstuff:startHarvestWeed2')
AddEventHandler('esx_veryfunstuff:startHarvestWeed2', function()

	local _source = source

	PlayersHarvestingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestWeed2(_source)

end)

local function TransformWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			local weedQuantity = xPlayer.getInventoryItem('weed').count
			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif weedQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_weed'))
			else
				xPlayer.removeInventoryItem('weed', 3)
				xPlayer.addInventoryItem('weed_pooch', 1)
				
				TransformWeed(source)
			end

		end
	end)
end

local function TransformWeedIndica(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingWeedIndica[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			local weedQuantity = xPlayer.getInventoryItem('weedindica').count
			local poochQuantity = xPlayer.getInventoryItem('weedindica_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif weedQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_weed'))
			else
				xPlayer.removeInventoryItem('weedindica', 3)
				xPlayer.addInventoryItem('weedindica_pooch', 1)
				TransformWeedIndica(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformWeed')
AddEventHandler('esx_veryfunstuff:startTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformWeed(_source)

end)

RegisterServerEvent('esx_veryfunstuff:startTransformWeedIndica')
AddEventHandler('esx_veryfunstuff:startTransformWeedIndica', function()

	local _source = source

	PlayersTransformingWeedIndica[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformWeedIndica(_source)

end)

--opium

local function HarvestOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingOpium[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local opium = xPlayer.getInventoryItem('opium')

			if opium.limit ~= -1 and opium.count >= opium.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_opium'))
			else
				xPlayer.addInventoryItem('opium', 1)
				HarvestOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestOpium')
AddEventHandler('esx_veryfunstuff:startHarvestOpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestOpium(_source)

end)

local function TransformOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local opiumQuantity = xPlayer.getInventoryItem('opium').count
			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif opiumQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_opium'))
			else
				xPlayer.removeInventoryItem('opium', 3)
				xPlayer.addInventoryItem('opium_pooch', 1)
			
				TransformOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformOpium')
AddEventHandler('esx_veryfunstuff:startTransformOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformOpium(_source)

end)

-- crack

local function HarvestCrack(source)

	if CopsConnected < Config.RequiredCopsCrack then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCrack))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingCrack[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local crack = xPlayer.getInventoryItem('crack')

			if crack.limit ~= -1 and crack.count >= crack.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_crack'))
			else
				xPlayer.addInventoryItem('crack', 1)
				HarvestCrack(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestCrack')
AddEventHandler('esx_veryfunstuff:startHarvestCrack', function()

	local _source = source

	PlayersHarvestingCrack[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestCrack(_source)

end)

local function TransformCrack(source)

	if CopsConnected < Config.RequiredCopsCrack then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCrack))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingCrack[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local crackQuantity = xPlayer.getInventoryItem('crack').count
			local poochQuantity = xPlayer.getInventoryItem('crack_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif crackQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_opium'))
			else
				xPlayer.removeInventoryItem('crack', 3)
				xPlayer.addInventoryItem('crack_pooch', 1)
			
				TransformCrack(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformCrack')
AddEventHandler('esx_veryfunstuff:startTransformCrack', function()

	local _source = source

	PlayersTransformingCrack[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformCrack(_source)

end)

-- Xanax
local function HarvestXanax(source)

	if CopsConnected < Config.RequiredCopsXanax then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsXanax))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingXanax[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local xanax = xPlayer.getInventoryItem('xanax')

			if xanax.limit ~= -1 and xanax.count >= xanax.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_xanax'))
			else
				xPlayer.addInventoryItem('xanax', 1)
				HarvestXanax(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestXanax')
AddEventHandler('esx_veryfunstuff:startHarvestXanax', function()

	local _source = source

	PlayersHarvestingXanax[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestXanax(_source)

end)

local function TransformXanax(source)

	if CopsConnected < Config.RequiredCopsXanax then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsXanax))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingXanax[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local xanaxQuantity = xPlayer.getInventoryItem('xanax').count
			local poochQuantity = xPlayer.getInventoryItem('xanax_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif xanaxQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_xanax'))
			else
				xPlayer.removeInventoryItem('xanax', 3)
				xPlayer.addInventoryItem('xanax_pooch', 1)
			
				TransformXanax(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformXanax')
AddEventHandler('esx_veryfunstuff:startTransformXanax', function()

	local _source = source

	PlayersTransformingXanax[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformXanax(_source)

end)

--Amfa
local function HarvestAmfa(source)

	if CopsConnected < Config.RequiredCopsAmfa then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsAmfa))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingAmfa[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local amfa = xPlayer.getInventoryItem('amfa')

			if amfa.limit ~= -1 and amfa.count >= amfa.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_amfa'))
			else
				xPlayer.addInventoryItem('amfa', 1)
				HarvestAmfa(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestAmfa')
AddEventHandler('esx_veryfunstuff:startHarvestAmfa', function()

	local _source = source

	PlayersHarvestingAmfa[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestAmfa(_source)

end)

local function TransformAmfa(source)

	if CopsConnected < Config.RequiredCopsAmfa then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsAmfa))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingAmfa[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local amfaQuantity = xPlayer.getInventoryItem('amfa').count
			local poochQuantity = xPlayer.getInventoryItem('amfa_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif amfaQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_amfa'))
			else
				xPlayer.removeInventoryItem('amfa', 3)
				xPlayer.addInventoryItem('amfa_pooch', 1)
			
				TransformAmfa(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformAmfa')
AddEventHandler('esx_veryfunstuff:startTransformAmfa', function()

	local _source = source

	PlayersTransformingAmfa[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformAmfa(_source)

end)

--Morfina
local function HarvestMorfina(source)

	if CopsConnected < Config.RequiredCopsMorfina then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMorfina))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingMorfina[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local morfina = xPlayer.getInventoryItem('morfina')

			if morfina.limit ~= -1 and morfina.count >= morfina.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_morfina'))
			else
				xPlayer.addInventoryItem('morfina', 1)
				HarvestMorfina(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestMorfina')
AddEventHandler('esx_veryfunstuff:startHarvestMorfina', function()

	local _source = source

	PlayersHarvestingMorfina[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestMorfina(_source)

end)

local function TransformMorfina(source)

	if CopsConnected < Config.RequiredCopsMorfina then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMorfina))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingMorfina[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local morfinaQuantity = xPlayer.getInventoryItem('morfina').count
			local poochQuantity = xPlayer.getInventoryItem('morfina_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif morfinaQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_morfina'))
			else
				xPlayer.removeInventoryItem('morfina', 3)
				xPlayer.addInventoryItem('morfina_pooch', 1)
			
				TransformMorfina(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformMorfina')
AddEventHandler('esx_veryfunstuff:startTransformMorfina', function()

	local _source = source

	PlayersTransformingMorfina[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformMorfina(_source)

end)

--Extazy
local function HarvestExtazy(source)

	if CopsConnected < Config.RequiredCopsExtazy then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsExtazy))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingExtazy[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local extazy = xPlayer.getInventoryItem('extazy')

			if extazy.limit ~= -1 and extazy.count >= extazy.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_extazy'))
			else
				xPlayer.addInventoryItem('extazy', 1)
				HarvestExtazy(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestExtazy')
AddEventHandler('esx_veryfunstuff:startHarvestExtazy', function()

	local _source = source

	PlayersHarvestingExtazy[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestExtazy(_source)

end)

local function TransformExtazy(source)

	if CopsConnected < Config.RequiredCopsExtazy then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsExtazy))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingExtazy[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local extazyQuantity = xPlayer.getInventoryItem('extazy').count
			local poochQuantity = xPlayer.getInventoryItem('extazy_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif extazyQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_extazy'))
			else
				xPlayer.removeInventoryItem('extazy', 3)
				xPlayer.addInventoryItem('extazy_pooch', 1)
			
				TransformExtazy(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformExtazy')
AddEventHandler('esx_veryfunstuff:startTransformExtazy', function()

	local _source = source

	PlayersTransformingExtazy[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformExtazy(_source)

end)

--Kodeina
local function HarvestKodeina(source)

	if CopsConnected < Config.RequiredCopsKodeina then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsKodeina))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingKodeina[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local kodeina = xPlayer.getInventoryItem('kodeina')

			if kodeina.limit ~= -1 and kodeina.count >= kodeina.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_kodeina'))
			else
				xPlayer.addInventoryItem('kodeina', 1)
				HarvestKodeina(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestKodeina')
AddEventHandler('esx_veryfunstuff:startHarvestKodeina', function()

	local _source = source

	PlayersHarvestingKodeina[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestKodeina(_source)

end)

local function TransformKodeina(source)

	if CopsConnected < Config.RequiredCopsKodeina then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsKodeina))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingKodeina[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local kodeinaQuantity = xPlayer.getInventoryItem('kodeina').count
			local poochQuantity = xPlayer.getInventoryItem('kodeina_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif kodeinaQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_kodeina'))
			else
				xPlayer.removeInventoryItem('kodeina', 3)
				xPlayer.addInventoryItem('kodeina_pooch', 1)
			
				TransformKodeina(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformKodeina')
AddEventHandler('esx_veryfunstuff:startTransformKodeina', function()

	local _source = source

	PlayersTransformingKodeina[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformKodeina(_source)

end)

RegisterServerEvent('esx_veryfunstuff:GetUserInventory')
AddEventHandler('esx_veryfunstuff:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_veryfunstuff:ReturnInventory', 
		_source, 
		xPlayer.getInventoryItem('coke').count, 
		xPlayer.getInventoryItem('coke_pooch').count,
		xPlayer.getInventoryItem('meth').count, 
		xPlayer.getInventoryItem('meth_pooch').count, 
		xPlayer.getInventoryItem('weed').count, 
		xPlayer.getInventoryItem('weed_pooch').count,
		xPlayer.getInventoryItem('weedindica').count, 
		xPlayer.getInventoryItem('weedindica_pooch').count, 
		xPlayer.getInventoryItem('opium').count, 
		xPlayer.getInventoryItem('opium_pooch').count,
		xPlayer.getInventoryItem('crack').count, 
		xPlayer.getInventoryItem('crack_pooch').count,
		xPlayer.getInventoryItem('xanax').count, 
		xPlayer.getInventoryItem('xanax_pooch').count,
		xPlayer.getInventoryItem('amfa').count, 
		xPlayer.getInventoryItem('amfa_pooch').count,
		xPlayer.getInventoryItem('morfina').count, 
		xPlayer.getInventoryItem('morfina_pooch').count,
		xPlayer.getInventoryItem('extazy').count, 
		xPlayer.getInventoryItem('extazy_pooch').count,
		xPlayer.getInventoryItem('kodeina').count, 
		xPlayer.getInventoryItem('kodeina_pooch').count,
		xPlayer.job.name, 
		currentZone
	)
end)

RegisterServerEvent('esx_veryfunstuff:wstrzymajkierownice')
AddEventHandler('esx_veryfunstuff:wstrzymajkierownice', function()

	local _source = source

	PlayersHarvestingCoke[_source] = false
	PlayersTransformingCoke[_source] = false
	PlayersHarvestingOpium[_source] = false
	PlayersTransformingOpium[_source] = false
	PlayersTransformingWeed[_source] = false
	PlayersHarvestingWeed[_source] = false
	PlayersTransformingWeedIndica[_source] = false
	PlayersHarvestingMeth[_source] = false
	PlayersTransformingMeth[_source] = false
	PlayersHarvestingCrack[_source] = false
	PlayersTransformingCrack[_source] = false
	PlayersHarvestingXanax[_source] = false
	PlayersTransformingXanax[_source] = false
	PlayersHarvestingAmfa[_source] = false
	PlayersTransformingAmfa[_source] = false
	PlayersHarvestingMorfina[_source] = false
	PlayersTransformingMorfina[_source] = false
	PlayersHarvestingExtazy[_source] = false
	PlayersTransformingExtazy[_source] = false
	PlayersHarvestingKodeina[_source] = false
	PlayersTransformingKodeina[_source] = false


end)
