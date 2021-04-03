pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--game of life
--by hankdetank05

function _init()
	cls()
	live=7
	dead=1
	
	for x=0,127 do
		for y=0,127 do
			if flr(rnd(32))==1 then
				pset(x,y,live)
			else
				pset(x,y,dead)
			end
		end
	end
	
end

function _update()
	for x=0,127 do
		for y=0,127 do
			update_cell(x,y)
		end
	end
end

function _draw()
end

function update_cell(x,y)
	assert(x>=0,"x is less than 0")
	assert(y>=0,"y is less than 0")
	
	assert(x<=127,"x is greater than 127")
	assert(y<=127,"y is greater than 127")
	
	local live_neighbors=0
	
	//check up to eight neighbors
	//up
	if y>0 and pget(x,y-1)==live then
		live_neighbors+=1
	end
	
	//up-right
	if x<127 and y>0 and pget(x+1,y-1)==live then
		live_neighbors+=1
	end
	
	//right
	if x<127 and pget(x+1,y)==live then
		live_neighbors+=1
	end
	
	//down-right
	if x<127 and y<127 and pget(x+1,y+1)==live then
		live_neighbors+=1
	end
	
	//down
	if y<127 and pget(x,y+1)==live then
		live_neighbors+=1
	end
	
	//down-left
	if x>0 and y<127 and pget(x-1,y+1)==live then
		live_neighbors+=1
	end
	
	//left
	if x>0 and pget(x-1,y)==live then
		live_neighbors+=1
	end
	
	//up-left
	if x>0 and y>0 and pget(x-1,y-1)==live then
		live_neighbors+=1
	end
	
	if pget(x,y)==live then
		//any cell with fewer than two
		//live neighbors dies, as if
		//by underpopulation
		if live_neighbors<2 then
			pset(x,y,dead)
		end
		
		//any live cell with two or
		//three live neighbors lives
		//on to the next generation
		if live_neighbors==2 or live_neighbors==3 then
			//do nothing
		end

		//any live cell with more than
		//three live neighbors dies,
		//as if by overpopulation
		if live_neighbors>3 then
			pset(x,y,dead)
		end
		
	elseif pget(x,y)==dead then
		//any dead cellwith exactly
		//three live neighbors becomes
		//a live cell, as if by
		//reproduction
		if live_neighbors==3 then
			pset(x,y,live)
		end
	
	end
	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
