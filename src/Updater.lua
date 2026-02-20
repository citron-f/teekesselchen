--[[----------------------------------------------------------------------------

    Teekesselchen is a plugin for Adobe Lightroom that finds duplicates by metadata.
    Copyright (C) 2013  Michael Bungenstock

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
--------------------------------------------------------------------------------

Updater.lua (citron-f fork): check GitHub Releases

------------------------------------------------------------------------------]]

local LrHttp = import "LrHttp"
local LrDialogs = import "LrDialogs"

Updater = {}

function Updater.new()
	local self = {}
	self.info = {}
	
	function self.getInfo()

		local body, headers = LrHttp.get("https://api.github.com/repos/citron-f/teekesselchen/releases/latest", nil, 5)
		local status = headers["status"]
		self.info = {}
		if status == 200 and body then
			-- Parse GitHub JSON
			local tag  = string.match(body, '"tag_name"%s*:%s*"([^"]+)"')
			local page = string.match(body, '"html_url"%s*:%s*"([^"]+)"')
			if tag and page then
				self.info["currentVersion"] = string.gsub(tag, "^v", "")
				self.info["showUrl"] = page
				return true
			end
		end
		return false
	end
	
	function self.getVersion()
		local cv = self.info["currentVersion"]
		if not cv then return 0 end
		local a,b,c = string.match(cv, "(%d+)%.(%d+)%.(%d+)")
		if a and b and c then
			return tonumber(a)*10000 + tonumber(b)*100 + tonumber(c)
		end
		return 0
	end
	
	function self.getVersionStr()
		return self.info["currentVersion"]
	end
	
	
	function self.getUrl()
		local result = "https://github.com/citron-f/teekesselchen/releases/latest"
		local sUrl = self.info["showUrl"]
		if sUrl then result = sUrl end
		return result
	end
	return self
end