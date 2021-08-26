pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--ga ga
--by hankdetank05

function _init()

	players=0

	p1=init_player()
	--p2=init_player()

end

function _update60()
	
	update_player(p1)
	
end

function _draw()

	cls()
	
	draw_player(p1)
	--draw_player(p2)

end
-->8
--tab 1: util

function contains(tbl,key)

	for i=1,#tbl do
		if tbl[i]==key then
			return true
		end
	end
	
	return false

end
-->8
--tab 2: player

function init_player(num)

	players+=1
	
	plrtbl={
		num=players,
		x=64,
		y=64,
		out=false,
		stack={}
	}
	
	if players==1 then
		plrtbl.x=0
		plrtbl.y=0
	elseif players==2 then
		plrtbl.x=128-8
		plrtbl.y=0
	elseif players==3 then
		plrtbl.x=0
		plrtbl.y=128-8
	elseif players==4 then
		plrtbl.x=128-8
		plrtbl.y=128-8
	end
	
	return plrtbl

end

function update_player(plr)

	if btn(⬅️) and not(contains(plr.stack,"⬅️")) then add(plr.stack,"⬅️")
	else del(plr.stack,"⬅️") end
	
	if btn(➡️) and not(contains(plr.stack,"➡️")) then add(plr.stack,"➡️")
	else del(plr.stack,"➡️") end

	if btn(⬆️) and not(contains(plr.stack,"⬆️")) then add(plr.stack,"⬆️")
	else del(plr.stack,"⬆️") end

	if btn(⬇️) and not(contains(plr.stack,"⬇️")) then add(plr.stack,"⬇️")
	else del(plr.stack,"⬇️") end
	
	if plr.stack[#plr.stack]=="⬅️" then
	 if plr.x>0 then
	 	plr.x-=1
	 end
	elseif plr.stack[#plr.stack]=="➡️" then
		if plr.x<127 then
			plr.x+=1
		end
	elseif plr.stack[#plr.stack]=="⬆️" then
		if plr.y>0 then
			plr.y-=1
		end
	elseif plr.stack[#plr.stack]=="⬇️" then
		if plr.y<127 then
			plr.y+=1
		end
	end

end

function draw_player(plr)

	spr(plr.num,plr.x,plr.y)

end
__gfx__
0000000088888888ccccccccbbbbbbbbaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000080000008c000000cb000000ba000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070080000808c000cc0cb00bbb0ba0a00a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700080000808c0000c0cb000bb0ba0a00a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700080000808c000c00cb0000b0ba0aaaa0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070080000808c000cc0cb00bbb0ba0000a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000080000008c000000cb000000ba000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000088888888ccccccccbbbbbbbbaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
