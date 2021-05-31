pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--stack-based movement system
--by hankdetank05

function _init()

	char={,
		xpos=64,
		ypos=64,
		moving=false,
		sprite={
			⬅️=1,
			➡️=2,
			⬆️=3,
			⬇️=4
		}
	}

	stack={}

end

function _update()

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

end

function _draw()
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
