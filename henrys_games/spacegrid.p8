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
empty_space_val=-1
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
actions_per_turn=3

--text dist horz/vert
--from hud box corner
horz_edge_dist=10
vert_edge_dist=3

--hud colors
hud_box_color=5
hud_border_color=4

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

--cursor modes
gmode="grid"
mmode="menu"

--side hud menu options

--sample menu options
sample_side_opts={
	text={
		"hello",
		"strategy",
		"world",
		"cancel",
	},
	callback={
		function(cur,teams,grid) menu_sample_hello() end,
		function(cur,teams,grid) menu_sample_strategy() end,
		function(cur,teams,grid) menu_sample_world() end,
		function(cur,teams,grid) menu_exit(cur) end,
	}
}

--options for when the side
--menu should be empty
menu_empty_opts={
	text={
		"select\na space..."
	},
	callback={
		function(cur,teams,grid) end
	}
}

--free spawn space menu opts
fss_opts={
	text={
		"spawn new",
		"cancel",
	},
	callback={
		function(cur,teams,grid) menu_spawn_new(cur,teams) end,
		function(cur,teams,grid) menu_exit(cur) end
	}
}

--free neutral space menu opts
fns_opts={
	text={
		"cancel",
	},
	callback={
		function(cur,teams,grid) menu_exit(cur) end,
	}
}

--enemy spawn space menu opts
ess_opts={
	text={
		"cancel",
	},
	callback={
		function(cur,teams,grid) menu_exit(cur) end,
	}
}

--occupied friendly space menu
--opts
ofs_opts={
	text={
		"move",
		"cancel",
	},
	callback={
		function(cur,teams,grid) menu_ship_move(cur) end,
		function(cur,teams,grid) menu_exit(cur) end,
	}
}

--occupied enemy space menu
--opts
oes_opts={
	text={
		"attack",
		"cancel",
	},
	callback={
		function(cur,teams,grid) menu_ship_attack(cur) end,
		function(cur,teams,grid) menu_exit(cur) end,
	}
}

--options for when a player is
--trying to spawn a new ship
spawn_new_opts={
	text={
		"rock",
		"paper",
		"scissors",
		"cancel",
	},
	callback={
		function(cur,teams,grid) menu_spawn_new_r(cur,teams,grid) end,
		function(cur,teams,grid) menu_spawn_new_p(cur,teams,grid) end,
		function(cur,teams,grid) menu_spawn_new_s(cur,teams,grid) end,
		function(cur,teams,grid) menu_exit(cur) end,
	}
}

--the current side menu options
side_opts=menu_empty_opts

function _init()
	grid=init_grid(grid_size)
	
	hud=init_hud()
	
	teams={
		init_team(),
		init_team()
	}
	
	cur={
		init_cursor(1),
		init_cursor(2)
	}
	
end

function _update60()
	update_cursor(cur[turn],grid,#side_opts.text,teams)
	if btnp(🅾️) then
		gridh(grid)
	end
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
	
	--draw gridlines
	for y=1,#grid do
		for x=1,#grid[y] do
			draw_x=(x-1) * cell_width
			draw_y=(y-1) * cell_height
			
			--draw grid cell
			rect(draw_x,draw_y,draw_x+cell_width,draw_y+cell_height,7)
			
			--if cell is not empty, draw
			--the ship in that cell
			local contents=grid_get(grid,x,y)
			if contents!=empty_space_val then
				draw_ship(contents)
			end
			
		end
	end
	
end

function grid_get(grid,gx,gy)
	assert(gx>=1, "gx is too small")
	assert(gx<=grid_size, "gx is too large")
	assert(gy>=1, "gy is too small")
	assert(gy<=grid_size, "gy is too large")
	
	return grid[gy][gx]
end

function gridh(grid)
	for y=1,#grid do
		printline=""
		for x=1,#grid[y] do
			contents=grid_get(grid,x,y)
			if contents==empty_space_val then
				printline=printline.."_"
			else
				printline=printline..contents.class
			end
		end
		printh(printline)
	end
	printh("\n")
end
-->8
--tab 2: ship

--[[
ship_types={"r", --rock
            "p", --paper
            "s"} --scissors
--]]

ship_class_rock="r"
ship_class_paper="p"
ship_class_scissors="s"

function init_ship(team_number,_x,_y,_class)

	assert(_class!=nil)
	
	local tmp_sprite=-1
	
	if team_number==1 then
		if _class==ship_class_rock then
			tmp_sprite=17
		elseif _class==ship_class_paper then
			tmp_sprite=33
		elseif _class==ship_class_scissors then
			tmp_sprite=49
		end
		
	elseif team_number==2 then
		if _class==ship_class_rock then
			tmp_sprite=19
		elseif _class==ship_class_paper then
			tmp_sprite=35
		elseif _class==ship_class_scissors then
			tmp_sprite=51
		end
		
	end
	
	ship={
		--which sprite to draw
		sprite=tmp_sprite,
		
		--which team the ship is on
		--(either 1 or 2)
		team=team_number,
		
		--ship position on grid
		x=_x,
		y=_y,
		
		--ship class (r/p/s)
		class=_class,
		
		--ship stats
		atk=20.0, --base dmg output
		
		def=5.0, --base incoming
		         --damage subtractor
		
		hp=100.0, --health
		
		skill=0.75, --% chance to
		            --land a hit when
		            --attacking
		
		luck=0.10 --% chance to land
		          --a critical hit
	}
	
	
	return ship
end

function update_ship()
end

function draw_ship(s)
	spr(s.sprite,
	    (s.x-1)*cell_width+1,
	    (s.y-1)*cell_height+1)
end

function shiph(s)
	printh("ship at ("..s.x..","..s.y..")\n\tclass="..s.class.."\n")
end
-->8
--tab 3: cursor

function init_cursor(team_n)
	assert(team_n==1 or team_n==2, "cursor number must be 1 or 2")

	cur={
		--cursor mode (grid or menu)
		mode=gmode,
		
		--cell state, aka what kind
		--of cell the cursor is
		--highlighting
		state=states.initial_state,
		
		--actions per turn
		acts_this_turn=0,
	
		--grid cursor
		x=1,
		y=1,
		sprt_g=2*team_n-1,
		
		--menu cursor
		n=1,
		sprt_m=2*team_n
	}
	
	return cur
end

function update_cursor(cur,grid,menu_size,teams)
	
	get_next_state(cur,grid)
	
	if cur.mode==gmode then
		if btnp(⬆️) and cur.y>1 then
			cur.y-=1
		end
		
		if btnp(⬇️) and cur.y<#grid then
			cur.y+=1
		end
		
		if btnp(⬅️) and cur.x>1 then
			cur.x-=1
		end
		
		if btnp(➡️) and cur.x<#grid then
			cur.x+=1
		end
		
		--space selection
		if btnp(❎) then
			set_menu_opts(cur)
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
			select_opt(cur,teams,grid)
		end
		
		if btnp(🅾️) then
			cur.mode=gmode
		end
		
	end
	
	if cur.acts_this_turn>=actions_per_turn then
		cur.acts_this_turn=0
		if turn==1 then
			turn=2
		else
			turn=1
		end
	end
end

function draw_cursor(cur)
	if cur.mode==gmode then
		spr(cur.sprt_g,(cur.x-1)*cell_width+1,(cur.y-1)*cell_height+1)
	elseif cur.mode==mmode then
		spr(cur.sprt_m,
					side_text_x-cur_spacing,
					side_text_y+(cur.n-1)*side_text_spacing)
	end
end

function select_opt(cur,teams,grid)
	side_opts.callback[cur.n](cur,teams,grid)
end

function in_spawn_area_1(cur)
	return t1_spawn.x1<=cur.x
	       and cur.x<=t1_spawn.x2
	       and t1_spawn.y1<=cur.y
	       and cur.y<=t1_spawn.y2
end

function in_spawn_area_2(cur)
	return t2_spawn.x1<=cur.x
	       and cur.x<=t2_spawn.x2
	       and t2_spawn.y1<=cur.y
	       and cur.y<=t2_spawn.y2
end

function do_action(cur)
	cur.acts_this_turn+=1
	printh(cur.acts_this_turn.."/"..actions_per_turn.." actions taken this turn\n")
end
-->8
--tab 4: team

function init_team()
	team={
		r=4,
		p=4,
		s=4,
		active_ships=0,
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
	--side menu box + border
	draw_hud_box(grid_width_px+1,0,127,grid_height_px,hud_box_color,hud_border_color)
	
	--side menu box text
	draw_hud_text(side_text_x,side_text_y,side_opts.text,side_text_spacing,side_text_color)
	
	--bottom box + border
	draw_hud_box(0,grid_height_px+1,127,127,hud_box_color,hud_border_color)
	
	--bottom box text: team 1
	draw_hud_text(btm_text_t1_x,btm_text_t1_y,generate_team_hud_text(teams[1],1),btm_text_line_spacing,t1_text_color)
	
	--bottom box text: team 2
	draw_hud_text(btm_text_t2_x,btm_text_t2_y,generate_team_hud_text(teams[2],2),btm_text_line_spacing,t2_text_color)
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
-->8
--tab 6: menu callbacks

--sample menu callbacks
function menu_sample_hello()
	printh("hello")
end

function menu_sample_strategy()
	printh("strategy")
end

function menu_sample_world()
	printh("world!")
end

--menu exit callback
function menu_exit(cur)
	cur.mode=gmode
	cur.n=1
	side_opts=menu_empty_opts
	printh("exited side menu\n")
end

--ship spawner callbacks
function menu_spawn_new(cur,teams)
	side_opts=spawn_new_opts
end

function menu_spawn_new_r(cur,teams,grid)
	if teams[turn].r>0 then
		--create a rock ship
		rship=init_ship(turn,cur.x,cur.y,ship_class_rock)
		shiph(rship)
		
		--add that ship to the grid
		gridh(grid)
		grid[cur.y][cur.x]=rship
		gridh(grid)
		
		--decrement the idle rock ship
		--counter for the appropriate
		--team
		teams[turn].r-=1
		
		--increment the active ship
		--counter for the appropriate
		--team
		teams[turn].active_ships+=1
		
		printh("spawned new rock for team "..turn.."\n")
		do_action(cur)
	else
		printh("all out of rocks!\n")
	end
	menu_exit(cur)
end

function menu_spawn_new_p(cur,teams,grid)
	if teams[turn].p>0 then
		--create a rock ship
		pship=init_ship(turn,cur.x,cur.y,ship_class_paper)
		shiph(pship)
		
		--add that ship to the grid
		grid[cur.y][cur.x]=pship
		gridh(grid)
		
		--decrement the idle paper
		--ship counter for the
		--appropriate team
		teams[turn].p-=1
		
		--increment the active ship
		--counter for the appropriate
		--team
		teams[turn].active_ships+=1
		
		printh("spawned new paper for team "..turn.."\n")
		do_action(cur)
	else
		printh("all out of papers!\n")
	end
	menu_exit(cur)
end

function menu_spawn_new_s(cur,teams,grid)
	if teams[turn].s>0 then
		--create a rock ship
		sship=init_ship(turn,cur.x,cur.y,ship_class_scissors)
		shiph(pship)
		
		--add that ship to the grid
		grid[cur.y][cur.x]=sship
		gridh(grid)
		
		--decrement the idle scissors
		--ship counter for the
		--appropriate team
		teams[turn].s-=1
		
		--increment the active ship
		--counter for the appropriate
		--team
		teams[turn].active_ships+=1
		
		printh("spawned new scissors for team "..turn.."\n")
		do_action(cur)
	else
		printh("all out of scissors!\n")
	end
	menu_exit(cur)
end

--ship action callbacks
function menu_ship_move(cur)
end

function menu_ship_attack(cur)
end
-->8
--tab 7: cursor fsm

--defines the cursor mode
cursor_modes={
	grid_mode="grd",
	menu_mode="mnu",
}

--defines what kind of cell
--the cursor is highlighting
states={
	initial_state="ins",
	free_spawn_space="fss",
	free_neutral_space="fns",
	enemy_spawn_space="ess",
	occupied_friendly_space="ofs",
	occupied_enemy_space="oes",
}

function get_next_state(cur,grid)
	
	if cur.state==states.initial_state then
		cur.state=gns_logic(cur,grid)
		
	elseif cur.state==states.free_spawn_space then
		cur.state=gns_logic(cur,grid)
		
	elseif cur.state==states.free_neutral_space then
		cur.state=gns_logic(cur,grid)
		
	elseif cur.state==states.enemy_spawn_space then
		cur.state=gns_logic(cur,grid)
		
	elseif cur.state==states.occupied_friendly_space then
		cur.state=gns_logic(cur,grid)
		
	elseif cur.state==states.occupied_enemy_space then
		cur.state=gns_logic(cur,grid)
		
	else
		assert(false,"unknown state of cursor")
		
	end
	
end

function gns_logic(cur,grid)
	local next_state
	
	--determine whether the grid
	--cell is free or not
	contents=grid_get(grid,cur.x,cur.y)
	if contents==empty_space_val then
		--the current cell is free
		
		--determine whether the free
		--cell is a spawn space or
		--not
		spawn1=in_spawn_area_1(cur)
		spawn2=in_spawn_area_2(cur)
		
		if (spawn1 and turn==1)
		   or (spawn2 and turn==2) then
			next_state=states.free_spawn_space
		
		elseif (spawn1 and turn==2)
		       or (spawn2 and turn==1) then
			next_state=states.enemy_spawn_space
		
		else
			next_state=states.free_neutral_space
			
		end
		
	else
		--the cell is not free
		
		if contents.team==turn then
			next_state=states.occupied_friendly_space
		
		else
		 next_state=states.occupied_enemy_space
		 
		end
		
	end
	
	if next_state!=cur.state then
		printh("new state: "..next_state.."\n")
	end
	
	return next_state
end

function set_menu_opts(cur)
	if cur.state==states.free_spawn_space then
		--fss menu opts
		side_opts=fss_opts
		
	elseif cur.state==states.free_neutral_space then
		--fns menu opts
		side_opts=fns_opts
		
	elseif cur.state==states.enemy_spawn_space then
		--ess menu opts
		side_opts=ess_opts
		
	elseif cur.state==states.occupied_friendly_space then
		--ofs menu opts
		side_opts=ofs_opts
		
	elseif cur.state==states.occupied_enemy_space then
		--oes menu opts
		side_opts=oes_opts
		
	else
		assert(false,"unable to set menu opts, unknown cursor state!")
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005555000000000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000005ccc5500000000005888550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000005c5c5500000000005858550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000005cc55500000000005885550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000005c5c5500000000005858550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005555000000000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077776000000000007777600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007ccc6600000000007888660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007c7c7700000000007878770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007ccc7700000000007888770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007c777700000000007877770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007c777700000000007877770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000060000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099000660000000009900066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009cc906600000000098890660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009c9990000000000098999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000099c990000000000099899000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009cc906600000000098890660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099000660000000009900066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000060000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
