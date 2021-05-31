pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--adhd proof-of-concept
--by hankdetank05

function _init()

	palt(0,false)
	palt(1,true)

	link={
		sprx=8,--x-val of topleft px
		spry=0,
		next_spr=1,
		spr2=false,
		size=16,--sprite size
		spr_xspeed=10,
		spr_yspeed=15,
		xpos=17,
		ypos=17,
		frame_count=0,
		moving=false,
		moving_vert=false,
		stuck=false,
		sprs={{x1=8,y1=16,x2=24,y2=16},--left
		      {x1=40,y1=0,x2=56,y2=0},--right
		      {x1=8,y1=0,x2=24,y2=0},--up
		      {x1=40,y1=16,x2=56,y2=16}},--down
		dir=3
		}
		
		vase={
			sprx=88,
			spry=0,
			size=16,
			xpos=16,
			ypos=40
		}
		
		stack={}
		
end

function _update60()
		
		cc_lm={x=link.xpos+2,y=link.ypos+((link.size+2)/2)+2}
		cc_lb={x=link.xpos+2,y=link.ypos+link.size-2}
		
		cc_rm={x=link.xpos+link.size-1-2,y=link.ypos+((link.size+2+2)/2)}
		cc_rb={x=link.xpos+link.size-1-2,y=link.ypos+link.size-2}
		
		cc_ul={x=link.xpos+1+2,y=link.ypos+(link.size/2)+2}
		cc_ur={x=link.xpos+link.size-2-2,y=link.ypos+(link.size/2)+2}
		
		cc_dl={x=link.xpos+1+2,y=link.ypos+link.size-1}
		cc_dr={x=link.xpos+link.size-2-2,y=link.ypos+link.size-1}

	if not(link.stuck) then
		if btn(⬅️) and not(stack_contains(stack,"⬅️")) then
			add(stack,"⬅️")
			printh("adding l")
		elseif not(btn(⬅️)) and stack_contains(stack,"⬅️") then
			del(stack,"⬅️")
			printh("deleting l")
		end
			
		if btn(➡️) and not(stack_contains(stack,"➡️")) then
			add(stack,"➡️")
			printh("adding r")
		elseif not(btn(➡️)) and stack_contains(stack,"➡️") then
			del(stack,"➡️")
			printh("deleting r")
		end
			
		if btn(⬆️) and not(stack_contains(stack,"⬆️")) then
			add(stack,"⬆️")
			printh("adding u")
		elseif not(btn(⬆️)) and stack_contains(stack,"⬆️") then
			del(stack,"⬆️")
			printh("deleting u")
		end
			
		if btn(⬇️) and not(stack_contains(stack,"⬇️")) then
			add(stack,"⬇️")
			printh("adding d")
		elseif not(btn(⬇️)) and stack_contains(stack,"⬇️") then
			del(stack,"⬇️")
			printh("deleting d")
		end
		
		if #stack>0 then
		 link.moving=true
		else
			link.moving=false
		end
		
		local top=stack[#stack]
		if top=="⬅️" then
			link.dir=1
			--link.moving=true
			link.moving_vert=false
			local solid_left_mid=fget(mget(flr(cc_lm.x/8),flr(cc_lm.y/8)),0)
			local solid_left_btm=fget(mget(flr(cc_lb.x/8),flr(cc_lb.y/8)),0)
			if link.xpos>0 and not(solid_left_btm or solid_left_mid) then
				link.xpos-=1
			end
		
		elseif top=="➡️" then
			link.dir=2
			--link.moving=true
			link.moving_vert=false
			local solid_right_mid=fget(mget(flr(cc_rm.x/8),flr(cc_rm.y/8)),0)
			local solid_right_btm=fget(mget(flr(cc_rb.x/8),flr(cc_rb.y/8)),0)
			if link.xpos+link.size<127 and not(solid_right_btm or solid_right_mid) then
				link.xpos+=1
			end
		
		elseif top=="⬆️" then
			link.dir=3
			--link.moving=true
			link.moving_vert=true
			local solid_up_left =fget(mget(flr(cc_ul.x/8),flr(cc_ul.y/8)),0)
			local solid_up_right=fget(mget(flr(cc_ur.x/8),flr(cc_ur.y/8)),0)
			if link.ypos>0 and not(solid_up_left or solid_up_right) then
				link.ypos-=1
			end
		
		elseif top=="⬇️" then
			link.dir=4
			--link.moving=true
			link.moving_vert=true
			local solid_down_left =fget(mget(flr(cc_dl.x/8),flr(cc_dl.y/8)),0)
			local solid_down_right=fget(mget(flr(cc_dr.x/8),flr(cc_dr.y/8)),0)
			if link.ypos+link.size<127 and not(solid_down_left or solid_down_right) then
				link.ypos+=1
			end
		
		end
	
	else
		--play sound and vibrate the
		--sprite in the direction
		--of the button press
	end
			
	if link.sprx!=link.sprs[link.dir].x1 or link.sprx!=link.sprs[link.dir].x2 then
		if spr2 then
			link.sprx=link.sprs[link.dir].x2
			link.spry=link.sprs[link.dir].y2
		else
			link.sprx=link.sprs[link.dir].x1
			link.spry=link.sprs[link.dir].y1
		end
	end

	if link.moving then
		link.frame_count+=1
		if link.moving_vert then
			if link.frame_count>=link.spr_yspeed then
				if spr2 then
					link.sprx=link.sprs[link.dir].x1
					spr2=false
				else
					link.sprx=link.sprs[link.dir].x2
					spr2=true
				end
				link.frame_count=0
			end
		else
			if link.frame_count>=link.spr_xspeed then
				if spr2 then
					link.sprx=link.sprs[link.dir].x1
					spr2=false
				else
					link.sprx=link.sprs[link.dir].x2
					spr2=true
				end
				link.frame_count=0
			end
		end
	end
end

function _draw()
	cls()
	
	map(0,0,0,0,16,16)
	
	sspr(vase.sprx,vase.spry,vase.size,vase.size,vase.xpos,vase.ypos)
	sspr(link.sprx,link.spry,link.size,link.size,link.xpos,link.ypos)
	
	for i=1,#stack do
		print(stack[i],120,6*(21-i),11)
	end
	
	--print(link.sprx,0,6*0,0)
	--print(link.frame_count,0,6*1,0)
	
	--[[pset(cc_lm.x,cc_lm.y,8)
	pset(cc_lb.x,cc_lb.y,8)
	
	pset(cc_rm.x,cc_rm.y,8)
	pset(cc_rb.x,cc_rb.y,8)
	
	pset(cc_ul.x,cc_ul.y,8)
	pset(cc_ur.x,cc_ur.y,8)
	
	pset(cc_dl.x,cc_dl.y,8)
	pset(cc_dr.x,cc_dr.y,8)--]]
	
end
-->8
--tab 1: util

function stack_push(stack,str)
	stack[stack.size+1]=str
	stack.size+=1
end

function stack_top(stack)
	return stack[#stack]
end

function stack_contains(stack,str)
	for i=1,#stack do
		if str==stack[i] then
			return true
		end
	end
	return false
end
__gfx__
000000001111110001111111111111100011111111111000001111111111111111111111ff000000000000ff1111110000111111ff0000000000000000000000
000000001111100000111111111111000001111111110bbbfb0011111111000000111111f09999999999990f1111009999001111f09999999999999900000000
00700700111110ffff511111111110ffff0111111110bbffb0ff01111100bbbffb00101109999999999999901110999999990111099999999999999900000000
0007700011100f0000f0011111100f0000f00111110bb0bb0ffb000110bbbffbb0ff001109999999999999901110994444990111099999999999999900000000
00077000110f00bffb00f011110f00bffb00f01110bb0f00ffb0001110bbb0bb0ffb001109999999999999901109940000499011099999999999999900000000
00700700110f0bbffbb0f011110f0bbffbb0f01110bb0fb0b000111110bb0f00ffb0011109999999999999901009900000099001099999999999999900000000
00000000110f0b5bfbb0f011110f0bbfb5b0f011110b0ff00f0f0011110b0fb0b000111109999999999999901009900000099001099999999999999900000000
00000000110b00bbfbb0b011110b0bbfbb00b01111100ff0ff0ff011110b0ff00f0f001109999999999999901090990000990901099999999999999900000000
00000000111000bbbb000111111000bbbb00011111110bf0fffb011111100ff0ff0ff01109999999999999901090499999940901099999999999999900000000
000000001110b0bbb0b0b011110b0b0bbb0b0111111100b0bbb0111111110bf0fffb01110f999999999999f01049009ff90094010f9999999999999900000000
00000000110fb0bb0bb0b011110b0bb0bb0bf01111110b0000001111111100000000111109f9999999999f90104999000099940109f999999999999900000000
00000000110f0b00bbfb00111100bfbb00b0f0111110bb0ff0b0111111100bb0ff011111049ffffffffff9401049499999949401049fffffffffffff00000000
000000001110bfffffbb01111110bbfffffb01111110bb0ff0f01111110f0bb0ff011111f04444444444440f1104449ff9444011f04444444444444400000000
0000000011100bbbbb000111111000bbbbb001111110000000b01111110f00bb00001111f00000000000000f1104449999444011f00000000000000000000000
000000001110000000ff00111100ff000000011111110ffff0001111110ff000ffff0111f04994000049940f1110044994400111f04994004444444400000000
00000000111100000000011111100000000011111110000000000111110000000000011144000044440000441111100000011111440000444444444400000000
000000001111110000011111111111111111111111111000001111111111110000011111ffffffffffffffff008888888888880000000000000000ff00000000
00000000111100bfbbb01111111110000001111111110bffbb011111111110bbffb01111ffffffffffffffff0888888888888880999999999999990f00000000
000000001110ff0bffbb011110100bffbbb0011111100b00bbb0011111100bbb00b00111f44fffffffffffff0888777766668880999999999999999000000000
000000001000bff0bb0bb011100ff0bbffbbb011110f00ffffb0f011110f0bffff00f011ffffffffffffffff088756dddd656880999999999999999000000000
0000000011000bff00f0bb01100bff0bb0bbb011110f0f0000f0f011110f0f0000f0f011ffffffffffffffff08876d8888d6d880999999999999999000000000
000000001111000f0bf0bb011100bff00f0bb011110f00000000f011110f00000000f011ffffffff444fffff0887d8888886d880999999999999999000000000
000000001100f0f00ff0b011111000b0bf0b0111110bb000000bb011110bb000000bb011aaaaaaaaaaaaaaaa0086d8888886d800999999999999999000000000
00000000110ff0ff0ff00111100f0f00ff0b01111110ff0ff0ff01111110ff0ff0ff011144444444444444440006d0000006d000999999999999999000000000
000000001110bfff0fb0111110ff0ff0ff0011111110bf0ff0fb01111110bf0ff0fb0111ff444fffffffffff0006d0000006d000999999999999999000000000
0000000011110bbb0b001111110bfff0fb011111110b0bffffb0b011110b0bffffb0b011ffffffffffffffff0006d0000007d00099999999999999f000000000
000000001111000000b01111111000000001111110fb00000000b011110b00000000bf01ffffffffffffffff0086d8888886d8009999999999999f9000000000
0000000011110b0ff0bb011111110ff0bb00111110f00bbbb0ffb011110bff0bbbb00f01ffffffffffff44ff0886d8888886d880fffffffffffff94000000000
0000000011110f0ff0bb011111110ff0bb0f01111100bffff0ff01111110ff0ffffb0011ffffffffffffffff0086d8888886d800444444444444440f00000000
0000000011110b00000001111110000bb00f0111111000bbbb001111111100bbb0000111ffffffffffffffff0006d6d006d6d000000000000000000f00000000
000000001111000ffff01111110ffff000ff01111100bff000000111111000000ffb0011aaaaaaa444aaaaaa0006d0000006d000444444440049940f00000000
00000000111000000000011111000000000001111110000000001111111100000000011144444444444444440006d0000006d000444444444400004400000000
00000000000000007777777777777777777777777777777777777777777777771110101000011111000000000000000011010100001111110000000000000000
00000000000000007444444444444444444444444444444444444444444444471110000000000111000000000000000011000000000011110000000000000000
404444444044444474444444444444444444444444444444444444444444444711100ffffff00011000000000000000011000000000001110000000000000000
000000000000000074400000000000000000000000000000000000000000044711000ffffff0001100000000000000001110ffff000000110000000000000000
444440444444404474400777777777777777777777777777777777777770044710f0ff0ff0ff0f010000000000000000110f0f0fff0ff0110000000000000000
444440444444404474407077777777777777777777777777777777777707044710f0f000f0ff0f01000000000000000011000f0ffffff0110000000000000000
9999909999999099744077077777777777777777777777777777777770770447108f08ff88fff8010000000000000000108ff8ffffff80110000000000000000
0000000000000000744077707777777777777777777777777777777707770447110f08888800f0110000000000000000108888000fff01110000000000000000
7777777777777777744077770000000000000000000000000000000077770447110f0000000ff011000000000000000010000000ffff01110000000000000000
77777777777777777440777700999999999990999999909999999900777704471100f00000ff080100000000000000001100000ffff001110000000000000000
777777777777777774407777090444444444404444444044444440907777044710f00fffff008801000000000000000011108fff000880110000000000000000
777777777777777774407777094044444444404444444044444404907777044710f0800000ff0801000000000000000011110000ff0880110000000000000000
0000000000000000744077770944000000000000000000000000449077770447110088fff0ff0011000000000000000011108880ff0880110000000000000000
44444444444444447440777709440044404444444044444444004490777704471110000888000111000000000000000011100000000001110000000000000000
4444444444444444744077770944040000000000000000000040449077770447110fff80000000110000000000000000111108ffff8011110000000000000000
77777777777777777440777709440400000000000000000000404490777704471110000000001111000000000000000011100000000001110000000000000000
0040449077770447744077770944040074407777094404000040449077770447100011000001111100000000000000000000000000000000ffffffffffffffff
00404490777704477440777709440400744077770944040000404490777704470fff0000000001110000000000000000fff0444444444440ffffffffffffffff
00404490777704477440777709440400744077770944004444004490777704470fff0f0ff0f00011000000000000000044ff099444499440ffffffffffffffff
00400000777704477440777700000400744077770944000000004490777704470ff00000f0f000110000000000000000ff4f044499944990ffffffffffffffff
0040449077770447744077770944040074407777094044444444049077770447000008ff8fff00010000000000000000ff4f099999999990ffffffffffffffff
004044907777044774407777094404007440777709044444444440907777044708800888800f0f01000000000000000044ff0fff99fff990ffffffffffffffff
000044907777044774407777094400007440777700999999999999007777044708800000000fff010000000000000000fff0fffffffffff0ffffffffffffffff
00404490777704477440777709440400744077770000000000000000777704471088000000fff80100000000000000000000000000000009ffffffffffffffff
004044907777044774407777094404007440777077777777777777770777044710880ff00ffff0110000000000000000ffffffffffffffff0000000000000009
0040449077770447744077770944040074407707777777777777777770770447110808f00fff08010000000000000000fffffffffffffffffff0fffffffffff0
00404490777704477440777709440400744070777777777777777777770704471110808ff80008800000000000000000ffffffffffffffff44ff0fff99fff990
00400000777704477440777700000400744007777777777777777777777004471110f800000ff0800000000000000000ffffffffffffffffff4f099999999990
004044907777044774407777094404007440000000000000000000000000044711088ffff80ff0010000000000000000ffffffffffffffffff4f044499944990
004044907777044774407777094404007444444444444444444444444444444710000888888000010000000000000000ffffffffffffffff44ff099444499440
00004490777704477440777709440000744444444444444444444444444444470fff80000008fff00000000000000000fffffffffffffffffff0444444444440
004044907777044774407777094404007777777777777777777777777777777700000000000000000000000000000000ffffffffffffffff0000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001111110001111111111111100011111111111000001111111111111111111111ff000000000000ffffffff0000ffffffff0000000000000000000000
000000001111100000111111111111000001111111110bbbfb0011111111000000111111f09999999999990fffff00999900fffff09999999999999900000000
00700700111110ffff011111111110ffff0111111110bbffb0ff01111100bbbffb0010110999999999999990fff0999999990fff099999999999999900000000
0007700011100f0000f0011111100f0000f00111110bb0bb0ffb000110bbbffbb0ff00110999999999999990fff0994444990fff099999999999999900000000
00077000110f00bffb00f011110f00bffb00f01110bb0f00ffb0001110bbb0bb0ffb00110999999999999990ff099400004990ff099999999999999900000000
00700700110f0bbffbb0f011110f0bbffbb0f01110bb0fb0b000111110bb0f00ffb001110999999999999990f00990000009900f099999999999999900000000
00000000110f0b5bfbb0f011110f0bbfb0b0f011110b0ff00f0f0011110b0fb0b00011110999999999999990f00990000009900f099999999999999900000000
00000000110b00bbfbb0b011110b0bbfbb00b01111100ff0ff0ff011110b0ff00f0f00110999999999999990f09099000099090f099999999999999900000000
00000000111000bbbb000111111000bbbb00011111110bf0fffb011111100ff0ff0ff0110999999999999990f09049999994090f099999999999999900000000
000000001110b0bbb5b0b011110b0b0bbb0b0111111100b0bbb0111111110bf0fffb01110f999999999999f0f049009ff900940f0f9999999999999900000000
00000000110fb0bb5bb0b011110b0bb0bb0bf01111110b0000001111111100000000111109f9999999999f90f04999000099940f09f999999999999900000000
00000000110f5b55bbfb00111100bfbb00b0f0111110bb0ff0b0111111100bb0ff011111049ffffffffff940f04949999994940f049fffffffffffff00000000
000000001110bfffffbb01111110bbfffffb01111110bb0ff0f01111110f0bb0ff011111f04444444444440fff04449ff94440fff04444444444444400000000
0000000011100bbbbb000111111000bbbbb001111110000000b01111110f00bb00001111f00000000000000fff044499994440fff00000000000000000000000
000000001110000000ff00111100ff000000011111110ffff0001111110ff000ffff0111f04994000049940ffff0044994400ffff04994004444444400000000
0000000011110000000001111110000000001111111000000000011111000000000001114400004444000044fffff000000fffff440000444444444400000000
000000001111110000011111111111111111111111111000001111111111110000011111ffffffffffffffff008888888888880000000000000000ff00000000
00000000111100bfbbb01111111110000001111111110bffbb011111111110bbffb01111ffffffffffffffff0888888888888880999999999999990f00000000
000000001110ff0bffbb011110100bffbbb0011111100b00bbb0011111100bbb55b00111f44fffffffffffff0888777766668880999999999999999000000000
000000001000bff0bb0bb011100ff5bbffbbb011110f00ffffb0f011110f0bffff00f011ffffffffffffffff088756dddd656880999999999999999000000000
0000000011000bff00f0bb01100bff5bb5bbb011110f0f0000f0f011110f0f0000f0f011ffffffffffffffff08876d8888d6d880999999999999999000000000
000000001111000f0bf0bb011100bff00f0bb011110f00000000f011110f00000000f011ffffffff444fffff0887d8888886d880999999999999999000000000
000000001100f0f00ff0b011111000b0bf0b0111110bb000000bb011110bb000000bb011aaaaaaaaaaaaaaaa0086d8888886d800999999999999999000000000
00000000110ff0ff0ff00111100f0f00ff0b01111110ff0ff0ff01111110ff0ff0ff011144444444444444440006d0000006d000999999999999999000000000
000000001110bfff0fb0111110ff0ff0ff0011111110bf0ff0fb01111110bf0ff0fb0111ff444fffffffffff0006d0000006d000999999999999999000000000
0000000011110bbb0b001111110bfff0fb011111110b0bffffb0b011110b0bffffb0b011ffffffffffffffff0006d0000007d00099999999999999f000000000
000000001111000000b01111111000000001111110fb00000000b011110b00000000bf01ffffffffffffffff0086d8888886d8009999999999999f9000000000
0000000011110b0ff0bb011111110ff0bb00111110f00bbbb0ffb011110bff0bbbb00f01ffffffffffff44ff0886d8888886d880fffffffffffff94000000000
0000000011110f0ff0bb011111110ff0bb0f01111100bffff0ff01111110ff0ffffb0011ffffffffffffffff0086d8888886d800444444444444440f00000000
0000000011110b00000001111110000bb00f0111111000bbbb001111111100bbb0000111ffffffffffffffff0006d6d006d6d000000000000000000f00000000
000000001111000ffff01111110ffff000ff01111100bff000000111111000000ffb0011aaaaaaa444aaaaaa0006d0000006d000444444440049940f00000000
00000000111000000000011111000000000001111110000000001111111100000000011144444444444444440006d0000006d000444444444400004400000000
00000000000000007777777777777777777777777777777777777777777777771110101000011111000000000000000011010100001111110000000000000000
00000000000000007444444444444444444444444444444444444444444444471110000000000111000000000000000011000000000011110000000000000000
404444444044444474444444444444444444444444444444444444444444444711100ffffff00011000000000000000011000000000001110000000000000000
000000000000000074400000000000000000000000000000000000000000044711000ffffff0001100000000000000001110ffff000000110000000000000000
444440444444404474400777777777777777777777777777777777777770044710f0ff0ff0ff0f010000000000000000110f0f0fff0ff0110000000000000000
444440444444404474407077777777777777777777777777777777777707044710f0f000f0ff0f01000000000000000011000f0ffffff0110000000000000000
9999909999999099744077077777777777777777777777777777777770770447108f08ff88fff8010000000000000000108ff8ffffff80110000000000000000
0000000000000000744077707777777777777777777777777777777707770447110f08888800f0110000000000000000108888000fff01110000000000000000
7777777777777777744077770000000000000000000000000000000077770447110f0000000ff011000000000000000010000000ffff01110000000000000000
77777777777777777440777700999999999990999999909999999900777704471100f00000ff080100000000000000001100000ffff001110000000000000000
777777777777777774407777090444444444404444444044444440907777044710f00fffff008801000000000000000011108fff000880110000000000000000
777777777777777774407777094044444444404444444044444404907777044710f0800000ff0801000000000000000011110000ff0880110000000000000000
0000000000000000744077770944000000000000000000000000449077770447110088fff0ff0011000000000000000011108880ff0880110000000000000000
44444444444444447440777709440044404444444044444444004490777704471110000888000111000000000000000011100000000001110000000000000000
4444444444444444744077770944040000000000000000000040449077770447110fff80000000110000000000000000111108ffff8011110000000000000000
77777777777777777440777709440400000000000000000000404490777704471110000000001111000000000000000011100000000001110000000000000000
00404490777704477440777709440400744077770944040000404490777704471000110000011111000000000000000000000000000000000000000000000000
00404490777704477440777709440400744077770944040000404490777704470fff000000000111000000000000000000000000000000000000000000000000
00404490777704477440777709440400744077770944004444004490777704470fff0f0ff0f00011000000000000000000000000000000000000000000000000
00400000777704477440777700000400744077770944000000004490777704470ff00000f0f00011000000000000000000000000000000000000000000000000
0040449077770447744077770944040074407777094044444444049077770447000008ff8fff0001000000000000000000000000000000000000000000000000
004044907777044774407777094404007440777709044444444440907777044708800888800f0f01000000000000000000000000000000000000000000000000
000044907777044774407777094400007440777700999999999999007777044708800000000fff01000000000000000000000000000000000000000000000000
00404490777704477440777709440400744077770000000000000000777704471088000000fff801000000000000000000000000000000000000000000000000
004044907777044774407777094404007440777077777777777777770777044710880ff00ffff011000000000000000000000000000000000000000000000000
0040449077770447744077770944040074407707777777777777777770770447110808f00fff0801000000000000000000000000000000000000000000000000
00404490777704477440777709440400744070777777777777777777770704471110808ff8000880000000000000000000000000000000000000000000000000
00400000777704477440777700000400744007777777777777777777777004471110f800000ff080000000000000000000000000000000000000000000000000
004044907777044774407777094404007440000000000000000000000000044711088ffff80ff001000000000000000000000000000000000000000000000000
00404490777704477440777709440400744444444444444444444444444444471000088888800001000000000000000000000000000000000000000000000000
00004490777704477440777709440000744444444444444444444444444444470fff80000008fff0000000000000000000000000000000000000000000000000
__gff__
0000000000000000000101010101010000010101010101010101010101010100000000000000000000000000000101000001010101010101010000000001010001010101010101010000000000000000010101010101010100000000000000000101010101010101000000000101000001010101010101010000000000000101
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4243444544454445444544454445464700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5253545554555455545554555455565700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6c6d292a292a292a292a292a292a606100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7c7d393a393a393a393a393a393a707100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6e6f292a292a292a292a0d0e2d2e606100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7e7f393a393a393a393a1d1e3d3e707100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6263292a292a292a292a292a292a606100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7273393a393a393a393a393a393a707100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6263090a292a090a292a090a292a606100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7273191a393a191a2a3a191a393a707100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6263292a292a29393a2a292a292a606100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7273090a292a090a292a090a292a707100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6263191a393a191a393a191a393a606100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7273393a393a393a393a393a393a707100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6465404140414041404140414041666700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7475505150515051505150515051767700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
