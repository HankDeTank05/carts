pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--spacegrid
--by henry and joseph

--grid size on screen from 0,0
grid_width_px=72
grid_height_px=72

--grid config
grid_size=8
empty_space_val=0
cell_width=grid_width_px/grid_size
cell_height=grid_height_px/grid_size
t1_spawn={
	x1=1,y1=1,
	x2=1,y2=grid_size,
	col=1
}
t2_spawn={
	x1=grid_size,y1=1,
	x2=grid_size,y2=grid_size,
	col=2
}

--the player whose turn it is
turn=1 --either 1 or 2

--dist h/v from hud box corner
horz_edge_dist=10
vert_edge_dist=3

--side hud box text config
side_text_x=grid_width_px+horz_edge_dist
side_text_y=vert_edge_dist
side_text_spacing=6
cur_spacing=7
side_text_color=6

--bottom hud box text spacing
btm_text_line_spacing=6
btm_text_column_spacing=4*8

--bottom hud box team 1 config
btm_text_t1_x=horz_edge_dist
btm_text_t1_y=grid_height_px+vert_edge_dist
t1_text_color=12

--bottom hud box team 2 config
btm_text_t2_x=btm_text_t1_x+btm_text_column_spacing
btm_text_t2_y=btm_text_t1_y
t2_text_color=8

--side hud box options
sample_side_opts={"hello","strategy","world"}
spawn_area_opts={"place new","cancel"}

side_opts=sample_side_opts

function _init()
	grid=init_grid(grid_size)
	
	hud=init_hud()
	
	p1=init_team()
	p2=init_team()
	
	cur={
		init_cursor(1),
		init_cursor(2)
	}
	
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
			add(grid[y],empty_space_val)
		end
	end
	
	return grid
end

function update_grid()
end

function draw_grid()
	--draw team 1 placement area
	rectfill((t1_spawn.x1-1)*cell_width,(t1_spawn.y1-1)*cell_height,t1_spawn.x2*cell_width,t1_spawn.y2*cell_height,t1_spawn.col)
	
	--draw team 2 placement area
	rectfill((t2_spawn.x1-1)*cell_width,(t2_spawn.y1-1)*cell_height,t2_spawn.x2*cell_width,t2_spawn.y2*cell_height,t2_spawn.col)
	
	for y=1,#grid do
		for x=1,#grid[y] do
			draw_x=(x-1) * cell_width
			draw_y=(y-1) * cell_height
			rect(draw_x,draw_y,draw_x+cell_width,draw_y+cell_height,7)
		end
	end
end
-->8
--tab 2: ship

ship_types={"r", --rock
            "p", --paper
            "s"} --scissors

function init_ship(_x, _y)
	ship={
		x=_x,
		y=_y,
		pwr=rnd(ship_types)
	}
	
	
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
		
		--space selection
		if btnp(❎) then
			if turn==1 then
				--check if cursor is in
				--the spawn area for team 1
				if t1_spawn.x1<=cur.x
							and cur.x<=t1_spawn.x2
							and t1_spawn.y1<=cur.y
							and cur.y<=t1_spawn.y2
							then
					--cursor is in spawn area
					
					--set menu options
					--accordingly
					side_opts=spawn_area_opts
					
					--set the cursor mode to
					--menu
					cur.mode=mmode
					
				else
					--cursor is not in spawn
					--area
					
					--check if cursor is over
					--a piece or an empty
					--space
				end
				
			elseif turn==2 then
				--check if cursor is in
				--the spawn area for team 2
				if t2_spawn.x1<=cur.x
							and cur.x<=t2_spawn.x2
							and t2_spawn.y1<=cur.y
							and cur.y<=t2_spawn.y2
							then
					--cursor is in spawn area
					
					--set menu options
					--accordingly
					side_opts=spawn_area_opts
					
					--set the cursor mode to
					--menu
					cur.mode=mmode
					
				else
					--cursor is not in spawn
					--area
					
					--check if cursor is over
					--a piece or an empty
					--space
				end
			
			end
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
		
		if btnp(🅾️) then
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

function generate_team_hud_text(t,n)
	lines={
		"team "..n,
		"------",
		"r:"..t.r,
		"p:"..t.p,
		"s:"..t.s
	}
	
	return lines
end
-->8
--tab 5: hud

function init_hud()
end

function update_hud(h,t1,t2)
end

function draw_hud(h,side_opts)
	--side box + border
	draw_hud_box(grid_width_px+1,0,127,grid_height_px,5,4)
	
	--side box text
	draw_hud_text(side_text_x,side_text_y,side_opts,side_text_spacing,side_text_color)
	
	--bottom box + border
	draw_hud_box(0,grid_height_px+1,127,127,5,4)
	
	--bottom box text: team 1
	draw_hud_text(btm_text_t1_x,btm_text_t1_y,generate_team_hud_text(p1,1),btm_text_line_spacing,t1_text_color)
	
	--bottom box text: team 2
	draw_hud_text(btm_text_t2_x,btm_text_t2_y,generate_team_hud_text(p2,2),btm_text_line_spacing,t2_text_color)
end

function update_menu(cur)
	if side_opts==spawn_area_opts then
		--code for menu placement
		--menu interaction goes here
	end
end

function draw_hud_box(x1,y1,x2,y2,box_color,border_color)
	rectfill(x1,y1,x2,y2,box_color)
	rect(x1,y1,x2,y2,border_color)
end

function draw_hud_text(x,y,lines,line_spacing,text_color)
	for l=1,#lines do
		print(lines[l],x,y+(l-1)*line_spacing,text_color)
	end
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
0000000000cccc000000000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cccccc00000000008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cc111ccc0000000088222888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cc1c1ccc0000000088282888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cc11cccc0000000088228888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cc1c1ccc0000000088282888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cccccc00000000008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000cccc000000000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ccccc1000000000088888200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ccccc1100000000088888220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c111c1110000000082228222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c1c1cccc0000000082828888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c111cccc0000000082228888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c1cccccc0000000082888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c1cccccc0000000082888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc0000000088888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000c0000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cc000cc0000000008800088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c11c0cc00000000082280880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c1ccc0000000000082888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cc1cc0000000000088288000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c11c0cc00000000082280880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cc000cc0000000008800088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000c0000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
