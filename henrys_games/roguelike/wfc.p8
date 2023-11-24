pico-8 cartridge // http://www.pico-8.com
version 37
__lua__
--wave function collapse

function _init()
	--init the tiles
	tiles:init()
	
	--init the grid
	grid:init()
	
	--start by collapsing some
	--cells
	grid:collapse_cell(1,1,6)
	grid:collapse_cell(16,1,7)
	grid:collapse_cell(1,16,5)
	grid:collapse_cell(16,16,8)
end

function _update60()
end

function _draw()
	cls()
	grid:draw()
	--[[
	print("#tiles[7].nbors.s = "..#tiles[7].nbors.s)
	for i=1,#tiles[7].nbors.s do
		print("\t"..tiles[7].nbors.s[i])
	end
	--]]
end
-->8
--tab 1: grid

grid={
	size=16,
	
	init=function(self)
		for y=1,self.size do
			add(self,{})
			for x=1,self.size do
				add(self[y],{})
				self[y][x]=init_cell(x,y)
			end
		end	
	end,
	
	draw=function(self)
		local num_off=0
		for y=1,self.size do
			for x=1,self.size do
				self[y][x]:draw()
			end
		end
	end,
	
	collapse_cell=function(self,x,y,tile_id)
		self[y][x]:collapse(tile_id)
		
		--reduce entropy of neighbors
		to_visit={}
		visited={}
		add(visited,{px=x,py=y})
		--north
		if y>1 then
			add(to_visit,{px=x,py=y-1,fx=x,fy=y})
		end
		--east
		if x<self.size then
			add(to_visit,{px=x+1,py=y,fx=x,fy=y})
		end
		--south
		if y<self.size then
			add(to_visit,{px=x,py=y+1,fx=x,fy=y})
		end
		--west
		if x>1 then
			add(to_visit,{px=x-1,py=y,fx=x,fy=y})
		end
		
		while #to_visit>0 do
			local curr_cell=deli(to_visit)
			local cx=curr_cell.px
			local cy=curr_cell.py
			local fx=curr_cell.fx
			local fy=curr_cell.fy
			local nbor_list=nil
			local from_tile=self[fy][fx].entlist[1]
			assert(from_tile>0)
			if fy<cy then--from n
				--use s nbors
				nbor_list=tiles[from_tile].nbors.s
			elseif fx>cx then--from e
				--use w nbors
				nbor_list=tiles[from_tile].nbors.w
			elseif fy>cy then--from s
				--use n nbors
				nbor_list=tiles[from_tile].nbors.n
			elseif fx<cx then--from w
				--use e nbors
				nbor_list=tiles[from_tile].nbors.e
			else
				assert(false)
			end
			assert(nbor_list!=nil)
			self[cy][cx].entlist=nbor_list
			add(visited,curr_cell)
		end
	end,
}
-->8
--tab 2: cell

function init_cell(x,y)
	assert(x!=nil)
	assert(y!=nil)
	local cell={
		entlist={},
		edges={
			n={},e={},s={},w={}
		}
		pos={x=nil,y=nil},
		
		entropy=function(self)
			return #self.entlist
		end,
		
		draw=function(self)
			local dx=(self.pos.x-1)*8
			local dy=(self.pos.y-1)*8
			if #self.entlist>0 then
				spr(0,dx,dy)
				print(self:entropy(),
					dx,dy,7)
			elseif #self.entropy==1 then
				spr(self.entlist[1],
					dx,dy)
			else
				assert(false)
			end
		end,
		
		collapse=function(self,tile_id)
			--make sure the tile you're
			--trying to collapse to is
			--in the entropy list before
			--collapsing
			local valid=false
			for i=1,#self.entlist do
				if tile_id==self.entlist[i] then
					valid=true
				end
			end
			assert(valid==true)
			self.entlist={tile_id}
		end,
	}
	
	--populate the entropy list
	--with tile id's
	for t=tile_data.first,tile_data.last do
		add(cell.entlist,t)
	end
	
	cell.pos.x=x
	cell.pos.y=y
	
	return cell
end
-->8
--tab 3: tile

function init_tile(spr_id)
	local tile={
		--the sprite id of the tile
		id=nil,
		--3-zone data for each edge
		n={nil,nil,nil},
		e={nil,nil,nil},
		s={nil,nil,nil},
		w={nil,nil,nil},
		--list of valid neighbors
		nbors={
			n={},e={},s={},w={}
		}
	}
	
	--analyze 3 zones per edge
	
	--top left pixel of sprite
	local ssx=(spr_id%16)*8
	local ssy=flr(spr_id/16)*8
	--print("tile "..t.." x="..ssx.." y="..ssy)
	
	--pixel offsets from top left
	local px1=1
	local px2=3
	local px3=6
	
	local curr_x=nil
	local curr_y=nil
	
	--analyze north edge
	curr_y=ssy
	curr_x=ssx+px1
	tile.n[1]=sget(curr_x,curr_y)
	curr_x=ssx+px2
	tile.n[2]=sget(curr_x,curr_y)
	curr_x=ssx+px3
	tile.n[3]=sget(curr_x,curr_y)
	add_edge(n_edge_data,
		tile.n[1],tile.n[2],tile.n[3],
		spr_id)
	
	--analyze east edge
	curr_x=ssx+7
	curr_y=ssy+px1
	tile.e[1]=sget(curr_x,curr_y)
	curr_y=ssy+px2
	tile.e[2]=sget(curr_x,curr_y)
	curr_y=ssy+px3
	tile.e[3]=sget(curr_x,curr_y)
	add_edge(e_edge_data,
		tile.e[1],tile.e[2],tile.e[3],
		spr_id)
	
	--analyze south edge
	curr_y=ssy+7
	curr_x=ssx+px1
	tile.s[1]=sget(curr_x,curr_y)
	curr_x=ssx+px2
	tile.s[2]=sget(curr_x,curr_y)
	curr_x=ssx+px3
	tile.s[3]=sget(curr_x,curr_y)
	add_edge(s_edge_data,
		tile.s[1],tile.s[2],tile.s[3],
		spr_id)
	
	--analyze west edge
	curr_x=ssx
	curr_y=ssy+px1
	tile.w[1]=sget(curr_x,curr_y)
	curr_y=ssy+px2
	tile.w[2]=sget(curr_x,curr_y)
	curr_y=ssy+px3
	tile.w[3]=sget(curr_x,curr_y)
	add_edge(w_edge_data,
		tile.w[1],tile.w[2],tile.w[3],
		spr_id)
	
	return tile
end
-->8
--tab 4: tile data and lookups

tile_data={
	first=1,
	last=15,
}

--the array of tiles, where
--index==sprite id
tiles={
	init=function(self)
		--analyze sprites for wfc
		--and init the tiles table
		--with the data
		assert(tile_data.first==1)
		assert(tile_data.last>=1)
		--for each sprite id...
		for t=tile_data.first,tile_data.last do
			--create an associated tile
			--and its edge data
			local tile=init_tile(t)
			--add the tile to the list
			add(tiles,tile)
		end
		
		--now that edge data has been
		--created for every tile, we
		--can create lists of valid
		--neighbors for each tile
		for t=1,#tiles do
			local curr_edge=nil
			--create n-neighbor list
			curr_edge=tiles[t].n
			for se=1,#s_edge_data.edges do
				if s_edge_data.edges[se][1]==curr_edge[1] and
				   s_edge_data.edges[se][2]==curr_edge[2] and
				   s_edge_data.edges[se][3]==curr_edge[3] then
					for nn=1,#s_edge_data.tiles[se] do
						add(tiles[t].nbors.n,s_edge_data.tiles[se][nn])
					end
				end
			end
			--create e-neighbor list
			curr_edge=tiles[t].e
			for we=1,#w_edge_data.edges do
				if w_edge_data.edges[we][1]==curr_edge[1] and
				   w_edge_data.edges[we][2]==curr_edge[2] and
				   w_edge_data.edges[we][3]==curr_edge[3] then
					for en=1,#w_edge_data.tiles[we] do
						add(tiles[t].nbors.e,w_edge_data.tiles[we][en])
					end
				end
			end
			--create s-neighbor list
			curr_edge=tiles[t].s
			for ne=1,#n_edge_data.edges do
				if n_edge_data.edges[ne][1]==curr_edge[1] and
				   n_edge_data.edges[ne][2]==curr_edge[2] and
				   n_edge_data.edges[ne][3]==curr_edge[3] then
					for sn=1,#n_edge_data.tiles[ne] do
						add(tiles[t].nbors.s,n_edge_data.tiles[ne][sn])
					end
				end
			end
			--create w-neighbor list
			curr_edge=tiles[t].w
			for ee=1,#e_edge_data.edges do
				if e_edge_data.edges[ee][1]==curr_edge[1] and
				   e_edge_data.edges[ee][2]==curr_edge[2] and
				   e_edge_data.edges[ee][3]==curr_edge[3] then
					for wn=1,#e_edge_data.tiles[ee] do
						add(tiles[t].nbors.w,e_edge_data.tiles[ee][wn])
					end
				end
			end
		end
	end
}

n_edge_data={
	--list of triplets, where the
	--triplets contain the edge
	--data: {left, middle, right}
	edges={},
	
	--list of sublists
	--sublists contain sprite ids
	--index of a sublist is the
	--index of the edge data
	tiles={},
}

e_edge_data={
	edges={},
	tiles={},
}

s_edge_data={
	edges={},
	tiles={},
}

w_edge_data={
	edges={},
	tiles={},
}

--data == n/e/s/w_edge_data
--a,b,c == 1st,2nd,3rd edgezones
--id == sprite id of tile
function add_edge(data,a,b,c,id)
	local edge={a,b,c}
	
	local exists=false
	local i=1
	--search the list of edges
	--to see if this edge data
	--already exists
	while i<=#data.edges and exists==false do
		if data.edges[i][1]==edge[1] and
		   data.edges[i][2]==edge[2] and
		   data.edges[i][3]==edge[3] then
			exists=true
		end
		if exists==false then
			i+=1
		end
	end
	
	--if the edge exists already
	--just add the sprite id
	if exists then
		add(data.tiles[i],id)
	
	--otherwise, add the edge
	--and a new sublist with
	--the sprite id
	else
		add(data.edges,edge)
		add(data.tiles,{id})
	end
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
55555555555005550000000500000005000000000000000050000000500000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000500000005000000000000000050000000500000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000500000005000000000000000050000000500000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000500000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000500000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000500000005000000000000000050000000500000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000500000005000000000000000050000000500000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000500000005555555555550055550000000500000000000000000000000000000000000000000000000000000000000000000000000
