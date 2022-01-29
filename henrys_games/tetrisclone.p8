pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--tetris clone
--by hankdetank05

tetro_ct={1,2,3,4,5,6,7,}

sq_size=8

grid_width=10
grid_height=16

fall_speed=1
fall_timer_max=60
fall_timer=fall_timer_max

function _init()
	--[[
	tetros={
		create_tetro(1),--i
		create_tetro(2),--l
		create_tetro(3),--j
		create_tetro(4),--s
		create_tetro(5),--z
		create_tetro(6),--t
		create_tetro(7),--o
	}
	
	update_tetro(tetros[2],1*12  ,0*12,0)
	update_tetro(tetros[3],2*12  ,0*12,0)
	update_tetro(tetros[4],3*12  ,0*12,0)
	update_tetro(tetros[5],0.5*12,1*12,0)
	update_tetro(tetros[6],1.5*12,1*12,0)
	update_tetro(tetros[7],2.5*12,1*12,0)
	--]]
	
	slist=init_squarelist()
	
end

function _update60()
	local dx=0
	local dy=0
	local drot=0
	
	fall_timer-=fall_speed
	if fall_timer<0 then
		fall_timer=fall_timer_max
		dy+=1
	end
	
	if btnp(⬅️) then dx-=1 end
	if btnp(➡️) then dx+=1 end
	if btnp(⬇️) then dy+=1 end
	
	if btnp(🅾️) then rot_left(slist.웃) end
	if btnp(❎) then rot_left(slist.웃) end
	
	update_tetro(slist.웃,dx,dy,drot)
	
end

function _draw()
	cls()
	
	--map(0,0,0,0,16,16)
	
	draw_tetro(slist.웃)
end
-->8
--tab 1: tetromino

--[[

tetrominos:
i l j s z t o

]]--

function create_tetro(_num)
	local tetro={
		num=_num,--id number
		act=false,--piece active?
		rot="⬆️",--rotation direction
		◆={-1,-1},--rot anchor pos
		░={},--pos of other squares
	}
	
	if _num==1 then
		--i
		tetro.░={
			{-1,-3},
			{-1,-2},
			--◆
			{-1, 0},
		}
		
	elseif _num==2 then
		--l
		tetro.░={
			{-1,-2},
			--◆
			{-1, 0}, { 0, 0},
		}
		
	elseif _num==3 then
		--j
		tetro.░={
			        {-1,-2},
			        --◆
			{-2, 0},{-1, 0},
		}
	elseif _num==4 then
		--s
		tetro.░={
			      --[[◆--]]{ 0,-1},
			{-2, 0},{-1, 0},
		}
	elseif _num==5 then
		--z
		tetro.░={
			{-2,-1},--◆
			       {-1, 0},{ 0, 0}
		}
	elseif _num==6 then
		--t
		tetro.░={
			{-2,-1},--[[◆--]]{ 0,-1},
			        {-1, 0},
		}
	elseif _num==7 then
		--o
		tetro.░={
			--[[◆--]]{ 0,-1},
			{-1, 0},  { 0, 0},
		}
	else
		assert(false,_num.." is not a valid tetromino id. must be in the range [1,7].")
	end
	
	return tetro
end

function update_tetro(_tetro,dx,dy,drot)
	--change position first...
	_tetro.◆[1]+=dx
	_tetro.◆[2]+=dy
	for i=1,#_tetro.░ do
		_tetro.░[i][1]+=dx
		_tetro.░[i][2]+=dy
	end
	
	--...then change rotation...
	--[[ code goes here ]]--
	
	--...then place the tetromino
	--permanently into the grid
	--if it's time
	
end

function draw_tetro(_tetro)
	local sq_size=3
	
	rect(_tetro.◆[1]*sq_size,
	     _tetro.◆[2]*sq_size,
	     _tetro.◆[1]*sq_size+sq_size,
	     _tetro.◆[2]*sq_size+sq_size,
	     _tetro.num)
	     
	for i=1,#_tetro.░ do
		rectfill(_tetro.░[i][1]*sq_size,
		         _tetro.░[i][2]*sq_size,
   _tetro.░[i][1]*sq_size+sq_size,
   _tetro.░[i][2]*sq_size+sq_size,
           _tetro.num)
	end
end

function place_tetro(_slist,_tetro)
	--add the root square to the
	local tmp_square=_tetro.◆
	tmp_square.col=_tetro.num
	add(_slist.░,tmp_square)
	
	for i=1,#_tetro.░ do
		tmp_square=_tetro.░[i]
		tmp_square.col=_tetro.num
		add(_slist.░,tmp_square)
	end
end

function rot_left(_tetro)
	--code goes here
end

function rot_right(_tetro)
	--code goes here
end

function tetroh(_tetro)
	if _tetro.num==1 then
		printh("tetromino i")
	elseif _tetro.num==2 then
		printh("tetromino l")
	elseif _tetro.num==3 then
		printh("tetromino j")
	elseif _tetro.num==4 then
		printh("tetromino s")
	elseif _tetro.num==5 then
		printh("tetromino z")
	elseif _tetro.num==6 then
		printh("tetromino t")
	elseif _tetro.num==7 then
		printh("tetromino o")
	end
	printh("\n")
end
-->8
--tab 2: square list

function init_squarelist()
	local random1=rnd(tetro_ct)
	local random2=rnd(tetro_ct)
	
	local slist={
		--next/"waiting" tetromino
		⧗=create_tetro(random1),
		
		--active/"player" tetromino
		웃=create_tetro(random2),
		░={},  --placed squares
	}
	return slist
end

function update_squarelist(_slist)
	
end

function draw_squarelist(_slist)
end

function next_tetro(_slist)
	_slist.웃=_slist.⧗
	local random=rnd()%tetro_ct
	printh("generating new tetromino with id number "..random)
	_slist.⧗=create_tetro(random)
end
-->8
--tab 3: grid

function init_grid()
	local grid={}
	return grid
end
__gfx__
00000000cccccccccccc28eeddddddddee82cccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
00000000cccccccccccc28eeddddddddee82cccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
00700700cccccccccccc28eeddddddddee82cccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
00077000cccccccccccc28eeddddddddee82cccccccccccccc4444cccccccccc0000000000000000000000000000000000000000000000000000000000000000
00077000cccccccccccc28eeddddddddee82cccccccccc444444444444cccccc0000000000000000000000000000000000000000000000000000000000000000
00700700cccccccccccc28eeddddddddee82ccccccccc45555555555554ccccc0000000000000000000000000000000000000000000000000000000000000000
00000000cccccccccccc28eeddddddddee82cccccccc4500000000000054cccc0000000000000000000000000000000000000000000000000000000000000000
00000000cccccccccccc28eeddddddddee82cccccccc4500000000000054cccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccc4500000000000054cccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccc4500000000000054cccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ccc445000000000000544ccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ccc445000000000000544ccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ccc445000000000000544ccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ccc445000000000000544ccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccc4500000000000054cccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccc4500000000000054cccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccc4500000000000054cccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccc4500000000000054cccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ccccc45555555555554ccccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccccc444444444444cccccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccccccccc4444cccccccccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010100000000000000000101010101010101000000000000000001010101010101010000000000000000010101010101010100000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0102010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
