pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--spacegrid
--by henry and joseph

grid_width_px=72
grid_height_px=72

grid_size=8
cell_width=grid_width_px/grid_size
cell_height=grid_height_px/grid_size

horz_edge_dist=10
vert_edge_dist=3
side_text_x=grid_width_px+horz_edge_dist
side_text_y=vert_edge_dist
side_text_spacing=6
cur_spacing=7

side_opts={"hello","strategy","world"}

function _init()
	grid=init_grid(grid_size)
	
	hud=init_hud()
	
	p1=init_team()
	p2=init_team()
	
	cur={
		init_cursor(1),
		init_cursor(2)
	}
	
	--the player whose turn it is
	turn=1 --either 1 or 2
	
	
end

function _update60()
	update_cursor(cur[turn],grid_size,#side_opts)
end

function _draw()
	cls()
	draw_grid()
	draw_hud(hud,side_opts)
	draw_cursor(cur[turn],cell_width,cell_height)
end
-->8
--tab 1: grid

function init_grid(size)
	assert(size>0)

	grid={}
	
	for y=1,size do
		add(grid,{})
		for x=1,size do
			add(grid[y],-1)
		end
	end
	
	return grid
end

function update_grid()
end

function draw_grid()
	for y=1,#grid do
		for x=1,#grid[y] do
			--grid takes up 96x96 px
			width=grid_width_px/#grid
			height=grid_height_px/#grid[y]
			draw_x=(x-1) * width
			draw_y=(y-1) * height
			rect(draw_x,draw_y,draw_x+width,draw_y+height,7)
		end
	end
end
-->8
--tab 2: ship

ship_types={"rock",
            "paper",
            "scissors"}

function init_ship(_x, _y)
	ship={
		x=_x,
		y=_y
	}
	
	ship.pwr=ship_types[rnd(#ship_types)]
	
	return ship
end

function update_ship()
end

function draw_ship()
end
-->8
--tab 3: cursor

gmode="grid"
mmode="menu"

function init_cursor(n)
	assert(n==1 or n==2, "cursor number must be 1 or 2")

	cur={
		--cursor mode (grid or menu)
		mode=gmode,
	
		--grid cursor
		x=1,
		y=1,
		sprt_g=n,
		
		--menu cursor
		n=1,
		sprt_m=n+1
	}
	return cur
end

function update_cursor(cur,grid_size,menu_size)
	if cur.mode==gmode then
		if btnp(⬆️) and cur.y>1 then
			cur.y-=1
		end
		
		if btnp(⬇️) and cur.y<grid_size then
			cur.y+=1
		end
		
		if btnp(⬅️) and cur.x>1 then
			cur.x-=1
		end
		
		if btnp(➡️) and cur.x<grid_size then
			cur.x+=1
		end
		
		if btnp(❎) then
			cur.mode=mmode
		end
		
	elseif cur.mode==mmode then
		if btnp(⬆️) then
			cur.n-=1
			if cur.n<1 then
				cur.n=menu_size
			end
		end
		
		if btnp(⬇️) then
			cur.n+=1
			if cur.n>menu_size then
				cur.n=1
			end
		end
		
		if btnp(❎) then
			cur.mode=gmode
		end
		
	end
end

function draw_cursor(cur)
	if cur.mode==gmode then
		spr(cur.sprt_g,(cur.x-1)*cell_width+1,(cur.y-1)*cell_height+1)
	elseif cur.mode==mmode then
		spr(cur.sprt_m,side_text_x-cur_spacing,side_text_y+(cur.n-1)*side_text_spacing)
	end
end
-->8
--tab 4: team

function init_team()
	team={
		r=4,
		p=4,
		s=4
	}
	
	return team
end

function update_team(t)
end

function draw_team(t)
end
-->8
--tab 5: hud

function init_hud()
end

function update_hud(h)
end

function draw_hud(h,side_opts)
	--side box + border
	rectfill(grid_width_px+1,0,127,grid_height_px,5)
	rect(grid_width_px+1,0,127,grid_height_px,4)
	
	--side box text
	for o=1,#side_opts do
		print(side_opts[o],side_text_x,side_text_y+(o-1)*side_text_spacing)
	end
	
	--bottom box + border
	rectfill(0,grid_height_px+1,127,127,5)
	rect(0,grid_height_px+1,127,127,4)
end
__gfx__
00000000cc0000cccccc000088000088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c000000cc11cc00080000008822880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000000000c1c1cc0000000000828288000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000000000c1c1cc0000000000828288000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000000000c11cc00000000000822880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000000000cccc000000000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c000000c0000000080000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cc0000cc0000000088000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
