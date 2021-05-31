pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--stack-based movement system
--by hankdetank05

function _init()

	char={
		xpos=64,
		ypos=64,
		spd=1,
		moving=false,
		curr_spr=1,
		size=8,
		sprites={
			⬅️=1,
			➡️=2,
			⬆️=3,
			⬇️=4
		}
	}

	stack={}

end

function _update60()

	contains_⬅️=stack_contains(stack,"⬅️")
	contains_➡️=stack_contains(stack,"➡️")
	contains_⬆️=stack_contains(stack,"⬆️")
	contains_⬇️=stack_contains(stack,"⬇️")

	if btn(⬅️) and not(contains_⬅️) then
		add(stack,"⬅️")
	elseif not(btn(⬅️)) and contains_⬅️ then
		del(stack,"⬅️")
	end
	
	if btn(➡️) and not(contains_➡️) then
		add(stack,"➡️")
	elseif not(btn(➡️)) and contains_➡️ then
		del(stack,"➡️")
	end
	
	if btn(⬆️) and not(contains_⬆️) then
		add(stack,"⬆️")
	elseif not(btn(⬆️)) and contains_⬆️ then
		del(stack,"⬆️")
	end
	
	if btn(⬇️) and not(contains_⬇️) then
		add(stack,"⬇️")
	elseif not(btn(⬇️)) and contains_⬇️ then
		del(stack,"⬇️")
	end
	
	if #stack>0 then
		char.moving=true
	else
		char.moving=false
	end
	
	top=stack[#stack]
	
	if top=="⬅️" then
		if char.xpos>0 then
			char.xpos-=char.spd
		end
		char.curr_spr=char.sprites.⬅️
	elseif top=="➡️" then
		if char.xpos+char.size-2<127 then
			char.xpos+=char.spd
		end
		char.curr_spr=char.sprites.➡️
	elseif top=="⬆️" then
		if char.ypos>0 then
			char.ypos-=char.spd
		end
		char.curr_spr=char.sprites.⬆️
	elseif top=="⬇️" then
		if char.ypos+char.size-1<127 then
			char.ypos+=char.spd
		end
		char.curr_spr=char.sprites.⬇️
	end

end

function _draw()

	cls(3)

	spr(char.curr_spr,char.xpos,char.ypos)
	
end
-->8
--tab 1: util

function stack_contains(stack,str)
	
	if #stack==0 then
		return false
		
	else
		for i=1,#stack do
			if stack[i]==str then
				return true
			end
		end
	end
	
	return false
	
end
__gfx__
00000000004444000044440000444400004444003333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000fff44400444fff00444444004ffff403333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000fbfff4004fffbf00f4444f00fbffbf03333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000ffffff00ffffff00ffffff00ffffff03333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000ffff0000ffff0000ffff0000ffff003333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000cccc0000cccc0000cccc0000cccc003333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000cfcc0000ccfc000fccccf00fccccf03333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000cccc0000cccc0000cccc0000cccc003333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
