pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init() menu_init() end


function menu_init()
	options={}
	options[1]="option 1"
	options[2]="option 2"
	cur=1
	_update=menu_update
	_draw=menu_draw
end

function menu_update()
	if btnp(⬇️) and cur<#options then
		cur+=1
	elseif btnp(⬆️) and cur>1 then
		cur-=1
	end
end

function menu_draw()
	cls()
	for o=1,#options do
		print(options[o],8,(o-1)*8)
	end
	
	spr(1,0,(cur-1)*8)
end
__gfx__
00000000330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
