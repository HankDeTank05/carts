pico-8 cartridge // http://www.pico-8.com
version 37
__lua__
--malloc sim
--by hankdetank05

rng_seed=1

timer_s=2

--frames btwn malloc/free cmds
cmd_timer_len=60*timer_s

algos={
	firstf="f",
	bestf ="b",
	worstf="w",
	nextf ="n"
}

function _init()
	printh("\n\n")
	mem=init_mem()
	cmd_timer=cmd_timer_len
end

function _update60()
	cmd_timer-=1
	if cmd_timer<=0 then
		generate_cmd()
		cmd_timer=cmd_timer_len
	end
end
-->8
--tab 1: memory

screen_w=128
screen_h=128

mem_bits=screen_w*screen_h
mem_blocks={}

used_col=8
free_col=11

drawq={}

-------------------
--basic functions--
-------------------

function init_mem()
	local mem={}
	for b=1,mem_bits do
		add(mem,false)
	end
	draw_free(1,#mem)
	
	add(mem_blocks,get_free(0,#mem))
	--printh(#mem_blocks)
	
	--seed rng for predictability
	srand(rng_seed)
	
	return mem
end

function update_mem()
end

function draw_mem()
end

--------------------
--memory functions--
--------------------

function malloc(mem,amt)
	local addr=alg_first(mem,amt)
	printh("malloc "..amt.." at "..addr)
	printh("\t#mem_blocks="..#mem_blocks)
	assert(addr!=nil,"memory address is nil")
	
	--draw the memory on screen
	draw_used(addr,amt)
	
	return addr
end

function free(addr)
	for i=1,#mem_blocks do
		--free memory at address
		local block=mem_blocks[i]
		if block.addr==addr then
			assert(false)
			block.status="free"
			
			--coalesce with block ahead
			if i<#mem_blocks then
				local next_block=mem_blocks[i+1]
				if next_block.status=="free" then
					mem_blocks[i].size+=mem_blocks[i+1].size
					deli(mem_blocks,i+1)
				end
			end
			
			--coalesce with block behind
			if i>1 then
				local prev_block=mem_blocks[i-1]
				if prev_block.status=="free" then
					mem_blocks[i-1].size+=mem_blocks[i].size
					deli(mem_blocks,i)
					i-=1
				end
			end
		
		--draw the newly freed block
		draw_free(mem_blocks[i].addr,mem_blocks[i].size)
		
		break	
	
		end
	end

end

-----------------------------
--internal helper functions--
-----------------------------

function get_free(_addr,_size)
	return {status="free",
	        addr=_addr,
	        size=_size}
end

function get_used(_addr,_size)
	return {status="used",
	        addr=_addr,
	        size=_size}
end

function draw_used(addr,size)
	local sx,sy=addr_to_scr(addr)
	for b=1,size do
		pset(sx,sy,used_col)
		sx+=1
		if sx>screen_w then
			sx=0
			sy+=1
		end
		assert(sy<=screen_h)
	end
end

function draw_free(addr,size)
	local sx,sy=addr_to_scr(addr)
	for b=1,size do
		pset(sx,sy,free_col)
		sx+=1
		if sx>screen_w then
			sx=0
			sy+=1
		end
		assert(sy<=screen_h)
	end
end

function addr_to_scr(addr)
	local sx=addr%screen_h
	local sy=flr(addr/screen_h)
	return sx,sy
end

-------------------------
--allocation algorithms--
-------------------------

function alg_first(mem,amt)
	local addr=nil
	
	for i=1,#mem_blocks do
		local block=mem_blocks[i]
		if block.status=="free" and block.size>=amt then
			addr=block.addr
			block.size-=amt
			block.addr+=amt
			add(mem_blocks,get_used(addr,amt),i)
			break
		end
	end
	
	return addr
end

function alg_best(mem,amt)
	local addr=nil
	
	--code goes here
	
	return addr
end

function alg_worst(mem,amt)
	local addr=nil
	
	--code goes here
	
	return addr
end

function alg_next(mem,amt)
	local addr=nil
	
	--code goes here
	
	return addr
end

-->8
--tab 2: malloc/free cmds

--array of addresses that have
--been allocated
allocated={}

--[[
… ∧ ░ ➡️ ⧗ ▤ ⬆️ ☉ 🅾️ ◆
█ ★ ⬇️ ✽ ● ♥ 웃 ⌂ ⬅️
▥ ❎ 🐱 ˇ ▒ ♪ 😐
--]]

function generate_cmd(mem)
	local choice=flr(rnd(2))
	
	if #allocated==0 or choice==0 then
		local size=flr(rnd(50))+1
		local addr=malloc(mem,size)
		
		--add address to array
		add(allocated,addr)
		
		print("██████",0,120,0)
		print("██████",1,120,0)
		print("malloc "..size,1,120,7)
	else
		index=flr(rnd(#allocated))+1
		local addr=allocated[index]
		assert(addr!=nil,"index="..index)
		
		print("███████",0,120,0)
		print("███████",1,120,0)
		print("free "..addr.." … "..#allocated,1,120,7)
		
		free(mem,addr)
		
		--remove address from array
		del(addresses,addr)
		
	end
	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
