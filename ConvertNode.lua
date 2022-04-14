local Source = io.open("Bug_Footnotes.xml", "r")
local Finish = io.open("New.xml", "w") -- Nom du nouveau fichier

local Balise_Start = "<level1>" -- Balise à check
local Balise_End = "</level1>" -- Fin

local Search_Start = "<note id=" -- Balise à déplacer
local Search_End = "</note>" -- Fin

---
local Table = {} -- Stockage des Balise à déplacer
---

function GotBalise(_str, _target)
	local j = string.find(_str, _target, 1)
	if j then
		-- find Balise
		return true
	else
		return false
	end
end

function RecupString(_string, _finisher ,i)
	local j = string.find(_string, _finisher, i)
	if not j then return nil end -- Last lign
	local tmp = string.sub(_string, i, j)
	return tmp, j + 1
end

function main()
	-- Recup File XML
	if Src and Finish then -- Check Error
		-- Read it & search data
		local Reader = Source:read("*all")
		-- Init Variable
		local lign = ""
		local i = 1
		--
		while i do
			lign, i = RecupString(Reader, "\n", i) -- Recup until Balise
			if not lign then break end -- Finish
			if GotBalise(lign, Balise_Start) then
				-- work inside balise
				while not GotBalise(lign, Balise_End) do
					if (not GotBalise(lign, Search_Start) and not GotBalise(lign, Search_End)) then -- No Node
						Finish:write(lign)
					else
						table.insert(Table, lign)
					end
					lign, i = RecupString(Reader, "\n", i) -- Next Lign
				end
				Finish:write(lign) -- Write Balise_End
				if Table then
					for id, e in pairs(Table) do
						Finish:write(e) -- Write Balise_End
					end
					Table = {}
				end
			else
				Finish:write(lign)
			end
		end
	end
end

main()