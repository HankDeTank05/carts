pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--wave function collapse

cursor_x = 1
cursor_y = 1

function _init()
	tileset:init()
	grid:init()
	grid:collapse_cell(2, 2)
end

function _update60()
end

function _draw()
	cls()
	--print(tileset[1].id)
	--print(tileset[2].id)
	--print(tileset[3].id)
	grid:draw()
	-- print(tileset[1].edges.n)
end
-->8
--tab 1: tileset
tileset_sprites={
	--[[
	 1,
	 2,
	 3,
	 4,
	 5,
	 6,
	 7,
	 8,
	 9,
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	17,
	18,
	19,
	20,
	21,
	22,
	23,
	24,
	25,
	26,
	27,
	28,
	29,
	30,
	31,
	32,
	33,
	34,
	35,
	36,
	37,
	38,
	39,
	40,
	--]]
	41, 42, 43, --44, 45
}

tileset={
	init=function(self)
		for t = 1, #tileset_sprites do
			local tile = init_tile(tileset_sprites[t])
			add(tileset, tile)
		end
	end
}

-->8
--tab 2: tile

function init_tile(sprite_num)
	local tile={
		id=sprite_num,
		edges={
			n=nil,
			e=nil,
			s=nil,
			w=nil,
		},
	}

	--analyze pixels for edge data

	--top left pixel of sprite
	local sprite_x_on_sheet = (sprite_num % 16) * 8
	local sprite_y_on_sheet = flr(sprite_num / 16) * 8

	--pixel offsets from corner
	local p_off = 3

	--north edge
	local curr_x = sprite_x_on_sheet + p_off
	local curr_y = sprite_y_on_sheet
	tile.edges.n = sget(curr_x, curr_y)

	--east edge
	curr_x = sprite_x_on_sheet + 7
	curr_y = sprite_y_on_sheet + p_off
	tile.edges.e = sget(curr_x, curr_y)

	--south edge
	curr_x = sprite_x_on_sheet + p_off
	curr_y = sprite_y_on_sheet + 7
	tile.edges.s = sget(curr_x, curr_y)

	--west edge
	curr_x = sprite_x_on_sheet
	curr_y = sprite_y_on_sheet + p_off
	tile.edges.w = sget(curr_x, curr_y)

	return tile
end

-->8
--tab 3: grid
grid_size = 4

grid={
	init=function(self)
		for y = 1, grid_size do
			add(self,{})
			for x = 1, grid_size do
				local cell = init_cell()
				add(self[y], cell)
			end
		end
	end,

	update=function(self)
		local lowest_entropy_x = 0
		local lowest_entropy_y = 0
		local lowest_entropy = #tileset
		for y = 1, #grid do
			for x = 1, #grid[y] do
				-- calculate entropy for the current cell
				local curr_entropy = 0
				for t = 1, #grid[y][x].tiles do
					if grid[y][x].tiles[t].possible == true then
						curr_entropy += 1
					end
				end

				-- if the current entropy is 1, then we want to collapse the cell
				if curr_entropy == 1 then
					--code goes here
				
				-- if the current entropy is lower than the lowest, update the lowest entropy info
				elseif curr_entropy < lowest_entropy then
					lowest_entropy_x = x
					lowest_entropy_y = y
					lowest_entropy = curr_entropy
				end
			end
		end
	end,

	draw=function(self)
		local cell_draw_size = (128 / grid_size) - 1
		for y = 1, #self do
			for x = 1, #self[y] do
				local dx0 = (x - 1) * cell_draw_size
				local dy0 = (y - 1) * cell_draw_size
				local dx1 = dx0 + cell_draw_size
				local dy1 = dy0 + cell_draw_size

				local cell = self[y][x]

				if grid[y][x].collapsed then
					spr(self[y][x].collapsed_tile.id, dx0 + 12, dy0 + 12)
				else
					for t = 1, #self[y][x].tiles do
						if self[y][x].tiles[t].possible == true then
							spr(self[y][x].tiles[t].id, dx0 + (t%4) * 8, dy0 + 8 * flr(t/4))
						end
					end
				end

				rect(dx0, dy0, dx1, dy1, 1)
			end
		end
	end,

	collapse_cell=function(self, x, y)
		assert(x >= 1)
		assert(x <= grid_size)
		assert(y >= 1)
		assert(y <= grid_size)

		local possible_indices = {}
		for t = 1, #self[y][x].tiles do
			if self[y][x].tiles[t].possible == true then
				add(possible_indices, t)
			end
		end

		-- pick a tile to collapse to
		assert(#possible_indices >= 1) -- there must be at least one possible tile to collapse to
		local rand_i = flr(rnd(#possible_indices)+1)
		-- print("rand_i="..rand_i)
		local chosen_i = possible_indices[rand_i]
		printh("chosen_i="..chosen_i)
		for t = 1, #self[y][x].tiles do
			if t != chosen_i then
				self[y][x].tiles[t].possible = false
			end
		end
		self[y][x].collapsed = true
		self[y][x].collapsed_tile = self[y][x].tiles[chosen_i]
		-- print(self[y][x].collapsed_tile)
		local tileset_i = self[y][x].collapsed_tile.tileset_index
		self[y][x].edges.n = {tileset[tileset_i].edges.n}
		self[y][x].edges.e = {tileset[tileset_i].edges.e}
		self[y][x].edges.s = {tileset[tileset_i].edges.s}
		self[y][x].edges.w = {tileset[tileset_i].edges.w}

		printh("starting propogation from ("..x..", "..y..")")
		self.propogate(self, x, y)
	end,

	propogate=function(self, start_x, start_y)
		-- propogate edge data from start cell to entropy data of neighbors

		-- if not on top edge, propogate north
		local n_changed = false
		if start_y > 1 then
			local neighbor_x = start_x
			local neighbor_y = start_y - 1

			for tile_i = 1, #self[neighbor_y][neighbor_x].tiles do
				if self[neighbor_y][neighbor_x].tiles[tile_i].possible == true then
					local tileset_i = self[neighbor_y][neighbor_x].tiles[tile_i].tileset_index
					local still_possible = list_search(self[start_y][start_x].edges.n, tileset[tileset_i].edges.s)
					-- printh("north option "..self[neighbor_y][neighbor_x].tiles[tile_i].id.." possible?")
					-- if still_possible then printh("\tyes") else printh("\tno") end
					if n_changed == false and self[neighbor_x][neighbor_y].tiles[tile_i].possible != still_possible then
						n_changed = true
					end
					self[neighbor_y][neighbor_x].tiles[tile_i].possible = still_possible
				end
			end
			-- propagate changes further
			if n_changed then
			end
		end
		
		-- if not on right edge, propogate east
		local e_changed = false
		if start_x < grid_size then
			local neighbor_x = start_x + 1
			local neighbor_y = start_y
			
			for tile_i = 1, #self[neighbor_y][neighbor_x].tiles do
				if self[neighbor_y][neighbor_x].tiles[tile_i].possible == true then
					local tileset_i = self[neighbor_y][neighbor_x].tiles[tile_i].tileset_index
					local still_possible = list_search(self[start_y][start_x].edges.e, tileset[tileset_i].edges.w)
					-- printh("north option "..self[neighbor_y][neighbor_x].tiles[tile_i].id.." possible?")
					-- if still_possible then printh("\tyes") else printh("\tno") end
					if e_changed == false and self[neighbor_x][neighbor_y].tiles[tile_i].possible != still_possible then
						e_changed = true
					end
					self[neighbor_y][neighbor_x].tiles[tile_i].possible = still_possible
				end
			end
			-- propogate changes further
			if e_changed then
			end
		end
		
		-- if not on bottom edge, propogate south
		local s_changed = false
		if start_y < grid_size then
			local neighbor_x = start_x
			local neighbor_y = start_y + 1
			
			for tile_i = 1, #self[neighbor_y][neighbor_x].tiles do
				if self[neighbor_y][neighbor_x].tiles[tile_i].possible == true then
					local tileset_i = self[neighbor_y][neighbor_x].tiles[tile_i].tileset_index
					local still_possible = list_search(self[start_y][start_x].edges.s, tileset[tileset_i].edges.n)
					-- printh("north option "..self[neighbor_y][neighbor_x].tiles[tile_i].id.." possible?")
					-- if still_possible then printh("\tyes") else printh("\tno") end
					if s_changed == false and self[neighbor_x][neighbor_y].tiles[tile_i].possible != still_possible then
						s_changed = true
					end
					self[neighbor_y][neighbor_x].tiles[tile_i].possible = still_possible
				end
			end
			-- propogate changes further
			if s_changed then
				self.propogate(self, neighbor_x, neighbor_y)
			end
		end
		
		-- if not on left edge, propogate east
		local w_changed = false
		if start_x > 1 then
			local neighbor_x = start_x - 1
			local neighbor_y = start_y
			
			for tile_i = 1, #self[neighbor_y][neighbor_x].tiles do
				if self[neighbor_y][neighbor_x].tiles[tile_i].possible == true then
					local tileset_i = self[neighbor_y][neighbor_x].tiles[tile_i].tileset_index
					local still_possible = list_search(self[start_y][start_x].edges.w, tileset[tileset_i].edges.e)
					-- printh("north option "..self[neighbor_y][neighbor_x].tiles[tile_i].id.." possible?")
					-- if still_possible then printh("\tyes") else printh("\tno") end
					if w_changed == false and self[neighbor_x][neighbor_y].tiles[tile_i].possible != still_possible then
						w_changed = true
					end
					self[neighbor_y][neighbor_x].tiles[tile_i].possible = still_possible
				end
			end
			-- propogate changes further
			if w_changed then
			end
		end

	end,
}

-->8
--tab 4: cell
function init_cell()
	local cell = {
		tiles = {}, -- a list of tables with the following format: {id=<sprite number>, possible=<true or false>, tileset_index=<index of tile in tileset>}
		edges = { -- lists of unique edge codes based on what is set to "possible" in the tiles list
			n = {},
			e = {},
			s = {},
			w = {},
		},
		collapsed = false,
		collapsed_tile = nil
	}

	for t = 1, #tileset do
		add(cell.tiles, {id = tileset[t].id, possible = true, tileset_index = t})

		-- if the edge is not already in the cell edge list, then add it
		if list_search(cell.edges.n, tileset[t].edges.n) == false then
			add(cell.edges.n, tileset[t].edges.n)
		end

		-- repeat for east
		if list_search(cell.edges.e, tileset[t].edges.e) == false then
			add(cell.edges.e, tileset[t].edges.e)
		end

		-- repeat for south
		if list_search(cell.edges.s, tileset[t].edges.s) == false then
			add(cell.edges.s, tileset[t].edges.s)
		end

		-- repeat for west
		if list_search(cell.edges.w, tileset[t].edges.w) == false then
			add(cell.edges.w, tileset[t].edges.w)
		end
	end

	return cell
end
-->8
--tab 5: util functions

function list_search(list, search_item)
	-- printh("searching for "..search_item.." in list")
	for i = 1, #list do
		-- printh("\tcomparing to "..list[i].."...")
		if list[i] == search_item then
			-- printh("\t\tfound")
			return true
		end
	end
	-- printh("\t\tnot found")
	return false
end

__gfx__
08080080555005555555555555555555555555555550055555555555555555555550055555500555555555555555555555500555555005555550055555500555
80000008500000055000000550000005500000055000000550000005500000055000000550000005500000055000000550000005500000055000000550000005
00000000500000055000000550000005500000055000000550000005500000055000000550000005500000055000000550000005500000055000000550000005
80000008500000055000000050000005000000055000000050000000000000050000000550000005000000000000000000000005000000005000000000000000
00000000500000055000000050000005000000055000000050000000000000050000000550000005000000000000000000000005000000005000000000000000
00000000500000055000000550000005500000055000000550000005500000055000000550000005500000055000000550000005500000055000000550000005
80000008500000055000000550000005500000055000000550000005500000055000000550000005500000055000000550000005500000055000000550000005
08080080555555555555555555500555555555555555555555500555555005555555555555500555555555555550055555500555555555555550055555500555
50000000500000005000000050000000000000050000000500000005000000055555555555555555555005555550055555555555555555555550055555500555
50000000500000005000000050000000000000050000000500000005000000055000000050000000500000005000000000000005000000050000000500000005
50000000500000005000000050000000000000050000000500000005000000055000000050000000500000005000000000000005000000050000000500000005
50000000000000005000000000000000000000050000000000000005000000005000000000000000500000000000000000000005000000000000000500000000
50000000000000005000000000000000000000050000000000000005000000005000000000000000500000000000000000000005000000000000000500000000
50000000500000005000000050000000000000050000000500000005000000055000000050000000500000005000000000000005000000050000000500000005
50000000500000005000000050000000000000050000000500000005000000055000000050000000500000005000000000000005000000050000000500000005
55555555555555555550055555500555555555555555555555500555555005555000000050000000500000005000000000000005000000050000000500000005
555555555550055500000005000000050000000000000000500000005000000000000000cccccccccc3333cccccccccccc3333cccc3333cc0000000000000000
000000000000000000000005000000050000000000000000500000005000000000000000cccccccccc3333ccc333333ccc3333cccc3333cc0000000000000000
000000000000000000000005000000050000000000000000500000005000000000000000cccccccccc3333ccc333333ccc333333333333cc0000000000000000
000000000000000000000005000000000000000000000000500000000000000000000000cccccccccc3333ccc333333ccc333333333333cc0000000000000000
000000000000000000000005000000000000000000000000500000000000000000000000cccccccccc3333cccc3333cccc333333333333cc0000000000000000
000000000000000000000005000000050000000000000000500000005000000000000000cccccccccc3333cccc3333cccc333333333333cc0000000000000000
000000000000000000000005000000050000000000000000500000005000000000000000cccccccccc3333cccc3333cccc3333cccc3333cc0000000000000000
000000000000000000000005000000055555555555500555500000005000000000000000cccccccccc3333cccc3333cccc3333cccc3333cc0000000000000000
