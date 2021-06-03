pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--beat-em-up
--by hankdetank05

--tab 0: main

function _init()
	init_plr()
	debug=true
end

function _update60()
	update_plr()
end

function _draw()
	cls()
	draw_plr()
end
-->8
--tab 1: player

function init_plr()
	plr={
		xpos=0,
		ypos=0,
		spr_top_idl=32,
		spr_top_pnc=33,
		spr_btm_idl=48,
		spr_btm_pnc=49,
		spr_pnc=34,
		xspeed=1,
		yspeed=1,
		
		pnc=false,
		pnc_active=false,
		
		pnc_xpos=0,
		pnc_ypos=0,
		
		pframes=0,
		pstartup=5,
		pactive=5,
		pendlag=10,
		
		stack={}
	}
	
	hitboxes={
		fist=nil
	}
	
	hitboxes.fist=make_box(plr.xpos,plr.ypos+4,8,3,0,0,false)
	
	hurtboxes={
		body=nil,
		fist=nil
	}
	
	hurtboxes.body=make_box(plr.xpos,plr.ypos,8,16,0,0,true)
	hurtboxes.fist=make_box(plr.xpos,plr.ypos+4,8,3,0,0,false)
	
	colboxes={
		body=nil,
		feet=nil
	}
	
	colboxes.body=make_box(plr.xpos,plr.ypos,8,16,0,0,true)
	colboxes.feet=make_box(plr.xpos,plr.ypos+12,8,3,0,0,true)
	
	colboxes.body=make_box()
	colboxes.feet=make_box()
	
	btn_released=true
end

function update_plr()
	
	--update movement stack
	if btn(⬅️) and not(in_stack("⬅️")) then
		add(plr.stack,"⬅️")
	elseif not(btn(⬅️)) and in_stack("⬅️") then
		del(plr.stack,"⬅️")
	end
	
	if btn(➡️) and not(in_stack("➡️")) then
		add(plr.stack,"➡️")
	elseif not(btn(➡️)) and in_stack("➡️") then
		del(plr.stack,"➡️")
	end
	
	if btn(⬆️) and not(in_stack("⬆️")) then
		add(plr.stack,"⬆️")
	elseif not(btn(⬆️)) and in_stack("⬆️") then
		del(plr.stack,"⬆️")
	end
	
	if btn(⬇️) and not(in_stack("⬇️")) then
		add(plr.stack,"⬇️")
	elseif not(btn(⬇️)) and in_stack("⬇️") then
		del(plr.stack,"⬇️")
	end
	
	if btn(❎) and btn_released then
		plr.pnc=true
		btn_released=false
	elseif not(btn(❎)) then
		btn_released=true
	end
	
	if not plr.pnc then
		top=plr.stack[#plr.stack]
		
		if top=="⬅️" then
			plr.xpos-=plr.xspeed
			plr.pnc_xpos-=plr.xspeed
		elseif top=="➡️" then
			plr.xpos+=plr.xspeed
			plr.pnc_xpos+=plr.xspeed
		elseif top=="⬆️" then
			plr.ypos-=plr.yspeed
			plr.pnc_ypos-=plr.yspeed
		elseif top=="⬇️" then
			plr.ypos+=plr.yspeed
			plr.pnc_ypos+=plr.yspeed
		end
		
	else
		plr.pframes+=1
		local pframes_phase_end=plr.pstartup
		local pnc_xdest=plr.xpos+8
		local pnc_ydest=plr.ypos
		
		if plr.pframes<plr.pstartup then
			local progress=plr.pframes/pframes_phase_end
			plr.pnc_xpos=progress*(pnc_xdest-plr.xpos)+plr.xpos
			plr.pnc_ypos=pnc_ydest
		
		elseif plr.pframes<plr.pstartup+plr.pactive then
			plr.pnc_active=true
			plr.pnc_xpos=pnc_xdest
			plr.pnc_ypos=pnc_ydest
		
		elseif plr.pframes<plr.pstartup+plr.pactive+plr.pendlag then
			local progress=(plr.pendlag-(plr.pframes-plr.pactive-plr.pstartup))/plr.pendlag
			plr.pnc_active=false
			plr.pnc_xpos=progress*(pnc_xdest-plr.xpos)+plr.xpos
			plr.pnc_ypos=pnc_ydest
			
		else
			plr.pframes=0
			plr.pnc=false
		end
	end
	
	--update hitboxes
	update_box(hitboxes.fist,plr.pnc_xpos,plr.pnc_ypos)
	
	--update hurtboxes
	update_box(hurtboxes.body,plr.xpos,plr.ypos)
	update_box(hurtboxes.fist,plr.pnc_xpos,plr.pnc_ypos)
	
	--update colboxes
	update_box(colboxes.body,plr.xpos,plr.ypos)
	update_box(colboxes.feet,plr.xpos,plr.ypos)
	
end

function draw_plr()
	if plr.pnc then
		spr(plr.spr_top_pnc,plr.xpos,plr.ypos)
		spr(plr.spr_btm_pnc,plr.xpos,plr.ypos+8)
		spr(plr.spr_pnc,plr.pnc_xpos,plr.pnc_ypos)
	else
		spr(plr.spr_top_idl,plr.xpos,plr.ypos)
		spr(plr.spr_btm_idl,plr.xpos,plr.ypos+8)
	end
	
	if debug then
		--plr punch animation info
		print(plr.pnc_xpos,0,6*0,11)

		--draw hitboxes
		rect(hitboxes.body.xpos,hitboxes.body.ypos,hitboxes.body.ypos+hitboxes.body.width-1,hitboxes.body.ypos+hitboxes.body.height-1,11)
		
		--draw hurtboxes
		
		--draw colboxes
		
	end
	
end

function in_stack(str)
	if #plr.stack==0 then
		return false
	else
		for i=1,#plr.stack do
			if plr.stack[i]==str then
				return true
			end
		end
		return false
	end
end
-->8
--tab 2: bounding boxes

function make_box(x,y,w,h,px,py,act)
	local box={
		xpos=x,
		ypos=y,
		width=w,
		height=h,
		parent_offset_x=px,
		parent_offset_y=py,
		active=act
	}
	
	return box
end

function update_box(box,parent_x,parent_y)
	box.xpos=parent_x+box.parent_offset_x
	box.ypos=parent_y+box.parent_offset_y
end
__gfx__
00000000005550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000005ffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000ffcfc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000fffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070009ff99ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000099ff94ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999494990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999499900000000099994999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000094999000000000009949999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000001111100000000000011111f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011111000000000000111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011011000000000000110110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011011000000000001100110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000045045000000000005500450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000044544500000000004500445000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555000005550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05ffff0005ffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ffcfc000ffcfc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0fffff000fffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00fff00000fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09ff99ff099999999999ffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99ff94ff099999999999ffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
999494990999944400000fff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99949990099999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09499900099999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d1111000d1111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d1dd1000d1dd1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d10d1000d10d1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d10d1000d10d1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04504500045045000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04454450044544500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
