--- Store user data using the PlayFab API

local clientapi = require "PlayFab.PlayFabClientApi"
local listener = require "ludobits.m.listener"


local M = {
	listeners = listener.create()
}

--- Will be triggered when userdata has refreshed
M.REFRESH_SUCCESS = hash("playfab.title_data.refresh_success")

--- Will be triggered when userdata failed to refresh
M.REFRESH_FAILED = hash("playfab.title_data.refresh_failed")

local data = {}


--- Refresh the title data for the currently logged in player
-- Will trigger a @{REFRESH_SUCCESS} or @{REFRESH_FAILED}
function M.refresh()
	local response, error = clientapi.GetTitleData({},
	function(response)
		data = response and response.Data or {}
		M.listeners.trigger(M.REFRESH_SUCCESS)
	end,
	function(error)
		M.listeners.trigger(M.REFRESH_FAILED)
	end)
end


--- Call this function when the user has logged out
-- This will clear any locally stored title data
function M.clear()
	data = {}
end


--- Get stored title data
-- @param key The key to get value for
-- @param default Default value to return if no value exists
-- @return The value stored for the key, or default value
function M.get(key, default)
	--return data[key] and data[key].Value or default
	if data[key] ~= nil then
		return data[key] 
	else
		return default
	end
	end

return M