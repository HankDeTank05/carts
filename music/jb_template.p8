pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--jukebox template
--by: hankdetank05

function _init()

	songs={
		"???",
		"???",
		"???"
	}
	
	artists={
		"???",
		"???",
		"???"
	}
	
	albums={
		"???",
		"???",
		"???"
	}
	
	years={
		"???",
		"???",
		"???"
	}
	
	patterns={
		-1,
		-1,
		-1
	}
	
	art={
		{x=64,y=0 ,w=64,h=64},
		{x=0 ,y=64,w=64,h=64},
		{x=64,y=64,w=64,h=64}
	}

	cur=1
	
	playing=false
	
	now_playing=""
	now_playing_dx=1
	
	current_song=songs[cur]
	current_artist=artists[cur]
	current_album=albums[cur]
	current_year=years[cur]
	
	art_dx=3
	art_dy=11
	art_dw=72
	art_dh=72
	
	button_diff=1

end

function _update()

	if btnp(➡️) then
		
		cur+=1
		if cur>#songs then
			cur=1
		end
		if playing then
			music(patterns[cur])
			now_playing_dx=1
		end
		
	elseif btnp(⬅️) then
	
		cur-=1
		if cur<1 then
			cur=#songs
		end
		if playing then
			music(patterns[cur])
			now_playing_dx=1
		end
	
	elseif btnp(❎) then
	
		if playing then
			music(-1)
			playing=false
			
		elseif cur<=#patterns then
			music(patterns[cur])
			playing=true
			
		end
	
	end
	
	current_song=songs[cur]
	current_artist=artists[cur]
	current_album=albums[cur]
	current_year=years[cur]
	current_art=art[cur]
	
	now_playing="now playing: "..songs[cur]
	
	if playing==true and #now_playing*4>126 then
		now_playing_dx-=1
		if abs(now_playing_dx)>#now_playing*4 then
			now_playing_dx=128
		end
	else
		now_playing_dx=1
	end

end

function _draw()

	// fill the screen dark blue
	cls(1)
	
	
	//draw the ui
	line(80,0,80,127,6)
	rectfill(art_dx-1,art_dy-1,art_dx+1+art_dw,art_dy+1+art_dh,0)
	sspr(current_art.x,current_art.y,current_art.w,current_art.h,art_dx,art_dy,art_dw,art_dh)
	--rectfill(art_dx,art_dy,art_dx+art_dw,art_dy+art_dh,7)	//this is for debugging
	print(current_song,art_dx,88,7)
	print(current_artist,art_dx,96,6)
	
	line(2,104,74,104,6)
	line(2,104,10,104,8)
	
	--draw rw button
	local rw=16
	if btn(⬅️) then
		rw+=button_diff
	end
	
	--draw play/pause button
	spr(rw,art_dx,110)
	if playing==true then
		playpause=32
	else
		playpause=48
	end
	if btn(❎) then
		playpause+=button_diff
	end
	spr(playpause,art_dx+32,110)
	
	--draw ff button
	local ff=0
	if btn(➡️) then
		ff+=button_diff
	end
	spr(ff,art_dx+64,110)

	// draw top bar
	rectfill(0,0,127,7,8)
	print("hank's jukebox vol. 1",1,1,2)
	
	--[[
	// draw album art and ui
	rectfill(0,88,127,120,0)
	if current_song==songs[1] then
		sspr(8,0,32,32,art_x,art_y,art_w,art_h)
	elseif current_song==songs[2] then
		sspr(48,0,32,32,art_x,art_y,art_w,art_h)
	elseif current_song==songs[3] then
		sspr(88,0,32,32,art_x,art_y,art_w,art_h)
	end
	print(current_song,34,90,7)
	print(current_artist,34,98,7)
	print(current_album,34,106,7)
	print(current_year,34,114,7)
	--]]
	
	// draw bottom bar
	rectfill(0,121,127,127,8)
	if playing then
		print(now_playing,now_playing_dx,122,2)		
	else
		print("paused",1,122,2)
	end
	
	// these are for debugging
	--print(stat(24),96,64,0)
	--print(stat(16),96,70,0)
	--print(stat(17),96,76,0)
	--print(stat(18),96,82,0)
	--print(stat(19),96,88,0)

end
-->8
--tab 1: sfx index

--[[

key
---
??? = song 1
??? = song 2
??? = song 3
---

count
---
??? : 00/64 : 00%
??? : 00/64 : 00%
??? : 00/64 : 00%
---

sfx
---
01
02
03
04
05
06
07
08
09
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
---

--]]
-->8
--tab 2: percussion

--[[
bass drum = c 1?43
?	for more punchy sound, try
		different instrumnets

snare drum = c ?615
?	(start with 3) the higher the
		pitch, the more the sound
		will cut through everything
		else in the track

cymbal bell = d#5?15
?	(start with 2) try
		experimenting with the
		instrument, see what you like

cool sound = d#2?13
?	(start with 3) experiment
		with the instrument
--]]
__gfx__
76000076070000070000000000000000000000000000000000000000000000005555555511111111155555555d11111111111115555555511111111155555555
777600760777000700000000000000000000000000000000000000000000000055555555551111111555d5555111111515d51115d5ddd5511111115555555555
7777767607777707000000000000000000000000000000000000000000000000555555555d1111111155d55d5111111111511115dddd55111111115555555555
777777760777777700000000000000000000000000000000000000000000000055555555555111111155dd6d5515d55155555d5ddd6d5d511111155555555555
7777777607777777000000000000000000000000000000000000000000000000dd5555555555111151155d6d5d5dddd16dddd6dd5dd555511111555555555d55
7777767607777707000000000000000000000000000000000000000000000000d665555555551115d11555d55d5dddd1dd66d66d555554251555555555555d66
77760076077700070000000000000000000000000000000000000000000000001d6d555554555155111155555dd6dd555d5d55dd5dd44444422242555555d66d
7600007607000007000000000000000000000000000000000000000000000000156d5555555555244515d55dd5ddddd6d6d56d66dd5dd4444444dd55555555d5
7600007607000007000000000000000000000000000000000000000000000000dd6dd5555555524444511556ddd56dd5655d66d6dd5566d4444d666d555555d5
7600777607000777000000000000000000000000000000000000000000000000566d1155555544444dd515566d6d6d6d6d56d6dd65556665245566d555516511
7677777607077777000000000000000000000000000000000000000000000000d655115155544d444444455666d66d65d6d6d6dd6511d666dd666d5515111155
77777776077777770000000000000000000000000000000000000000000000005d511111154466d44444d4ddd6dddd6d66d5d66d6d155246d66d555555551555
777777760777777700000000000000000000000000000000000000000000000055d5511112446dd4444665ddd6dd55555511555551155556d6d5551551155d55
767777760707777700000000000000000000000000000000000000000000000055d55515544d6555554dd555555555555511555d6111556ddddd555511555d55
760077760700077700000000000000000000000000000000000000000000000055ddd5554446d555555255115554444444445d5dd5115d66dd6d511555555dd5
760000760700000700000000000000000000000000000000000000000000000055dddd55444d5555555511115444555524444dd5d6d55d666dddd55555555555
007776000007770000000000000000000000000000000000000000000000000011ddd6d5444d11ddd555515dd425511111244466d5555666dd6dddd555555511
0777776000777770000000000000000000000000000000000000000000000000115d66d5444d15d66dd5d5d6d451511111154444d666d6d5d666dddddd5d5511
77070776077070770000000000000000000000000000000000000000000000005555ddd54446ddd65555ddd66411111100115244444d6651156dddddddd55d11
77070776077070770000000000000000000000000000000000000000000000006dd55d55544dd5d5155ddd4445551111101115544444551115dddddddd555d55
7707077607707077000000000000000000000000000000000000000000000000dd555d511244ddd55dd445451556d5111111551524dd45115566666dd5d5d55d
770707760770707700000000000000000000000000000000000000000000000055dd5dd51dd4444dd4444455544ffe5111112445554d6766667666dddddd5dd5
077777600077777000000000000000000000000000000000000000000000000055dddd651554444dd444455544efd4d51114444455544667766ddddd66dd555d
00777600000777000000000000000000000000000000000000000000000000006d5d6d65d55dd45544445154444fd5d5552444444514442dd7666dd5d6d6dd66
0077760000077700000000000000000000000000000000000000000000000000665dd6dddd5dd55d25555544444d6dd1514444444455444676dddd6d5dd66d66
0707776000707770000000000000000000000000000000000000000000000000d66d666d6d55d55dd5115444444555d11115244444452444d555d6dd55d66666
77007776077007770000000000000000000000000000000000000000000000005d6ddd66ddddd5dddd515444244555511111122424455444555ddd66dd6d6ddd
770007760770007700000000000000000000000000000000000000000000000011d6dddddddd555dddd5444424fd555111111555552d544455d66dd6d65dd51d
7700077607700077000000000000000000000000000000000000000000000000d55ddd5ddddddd5ddd5542224df655511111551111145544456f65d554dd555d
77007776077007770000000000000000000000000000000000000000000000005dd55ddddddd55dd555542224d66455111115511111455444566d5556445dddd
07077760007077700000000000000000000000000000000000000000000000005dd4454555ddd6dddd5522255ddfd55451115551111255444555555dd644dd66
00777600000777000000000000000000000000000000000000000000000000005d6d4444445d6ff7d5d522555ddf64155515555111125544dddd4555d6d45ddd
00000000000000000000000000000000000000000000000000000000000000005ddd4244444445d66d55555d5d66d5115551555511125544f64455555d555d5d
000000000000000000000000000000000000000000000000000000000000000056dddd4254444444dd5525555ddd5111dd50055100115544444dddd55555dd25
000000000000000000000000000000000000000000000000000000000000000046d5ddddd2dd4444444d45155dd511156441111100111544444dd665556dd554
00000000000000000000000000000000000000000000000000000000000000004dd456ddddd66eedeedd5211555115556d411551111115244446ddd55d6d5555
0000000000000000000000000000000000000000000000000000000000000000466ddd6d5dddd44d44dd5d51111555515dd5155101111116d54d66555551155d
00000000000000000000000000000000000000000000000000000000000000004dd6d666dddd444d4dd51d55115555515d551551101111d65d5dd5555555555d
0000000000000000000000000000000000000000000000000000000000000000446776d66ddd52ddd6651555111155d55dd41551111111445dd5555455555555
00000000000000000000000000000000000000000000000000000000000000004d767676666655d6666d5551111155d256d4511111111125dd6dd45d544d55dd
00000000000000000000000000000000000000000000000000000000000000002d7666666d66dd6ddddd5511111155d55d6551111111111166d6665d44d445dd
000000000000000000000000000000000000000000000000000000000000000055dd6667d5566666d44455111511555556f4511111111115dddd6d4d44d544dd
00000000000000000000000000000000000000000000000000000000000000001544ddd6ddd6dddd444451511511555556645111111111111ddddd4545ddd44d
0000000000000000000000000000000000000000000000000000000000000000444545ddddddddd445dd551115155551566d5511111111115d6ddd5dddddd55d
0000000000000000000000000000000000000000000000000000000000000000455451ddd55556445d5d5111155115515d665511111111115d66ddd5d55dddd6
00000000000000000000000000000000000000000000000000000000000000001154515dd5115d45dddd5111151115155d6d5511111111001566dd6ddd5555d6
00000000000000000000000000000000000000000000000000000000000000001115555d6d115d445ddd551155511d115ddd5211111111111155dd6651111566
00000000000000000000000000000000000000000000000000000000000000001111515666d11d4455d55111155115115d6d121111101011555ddd6651111566
00000000000000000000000000000000000000000000000000000000000000001111111566d11d4442551111155115055d515511111110115566ddd651111566
0000000000000000000000000000000000000000000000000000000000000000111111115d1111d444421101151115111511155551110001d456dd511111115d
0000000000000000000000000000000000000000000000000000000000000000111111111111115d544551111111551111111122511101115455551111111111
0000000000000000000000000000000000000000000000000000000000000000111111111111111151111d511115511111111125111111515545111111111111
00000000000000000000000000000000000000000000000000000000000000001111111111111111111115511115511111111122500111111555111111111111
00000000000000000000000000000000000000000000000000000000000000001111111111111111111115111111511111111125211155111551111111111111
0000000000000000000000000000000000000000000000000000000000000000111111111111111111111d451111511111111155111111111111111111111111
0000000000000000000000000000000000000000000000000000000000000000111111111111111111111d451111111111011115125151111111111111111111
0000000000000000000000000000000000000000000000000000000000000000111111111111111111111d441511111111111111055511111111111111111111
0000000000000000000000000000000000000000000000000000000000000000111111111111111111115d554551151111111111111111111111111111111111
00000000000000000000000000000000000000000000000000000000000000001111111111111111111115115511111111111111111111111111111111111111
00000000000000000000000000000000000000000000000000000000000000001111111111111111111155515115111155111111111111111111111111111111
00000000000000000000000000000000000000000000000000000000000000001111111111111111111115515515111555111111111111111111111111111111
000000000000000000000000000000000000000000000000000000000000000011111111111111111111151115551155d5511111111111111111111111111111
00000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111115ddd515111111111111111111111111111
00000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111115dd5111511111111111111111111111111
0001111d66676651155d511100115dd555551111100001111101111111111100777777777777777777777777777777777777777766ddd56d7777777777777777
000111156667665115dd5111111115111111111111111111000000011115511077777777777777777777777777777777777777766d66d5d67766677777777777
00011105666666511555511111111110111111111111111111100101115d5111777777777777777777777777777777777777777765ddd55dddd5566677777776
01111105d6666651111151111111111111111115555dd5111110111001155111777777777676677666677777777777777777777665d5555dd5444ddd66777766
111111155ddd555111115111111111111111115555ddd551111111111111111177777766d6ddddd6d65d6d6677777777777777766d6dd5d44444444d66677777
1111111115554445111551111111155101111555555dd55115511115511011117776d6d666766777777666ddd6777777777766666666d4444d44444dd6677777
1111551555544445111555d6d10115510111555555dd5551111111115110111177776677777777777777777666777777777766666666ddd4444444444d677777
11155d6d555555511115555d6651111111111555555dd551111111111001111177777776ddd67777776777777777777777766666666dd6664444e4444d677777
5155dd66555444511111555d6765111111555554d455d511111111100011111177777766676577777756777777777777777666666666666666ed44444d677777
5225dd5d555444511115554577751111156665444445d5511115511000111111777776d7d77d7777765777777666667777766667776676666666d444d6677777
5425555555544451111544dd77661111556665444445d5d5111dd5100011111177777d76d77d777776d776666666766666666666666666666d46655dd6677777
5455111555544451115544d66666555555dd44444455d2d5555555110151151177777d7d77d6767675666ddd666666677777777777777666d44dd555dd667777
5455515555544441112244d6666666ddddd6d4e4444445ddd55555111151111177777d7d666676dd6d6d6d667777777777767666d67766666d45d555d46f7777
54555555555444455152445ddd66666d66666dee4d44d6776dd55555155155117777776d56d56dd6d6667666677776666666d551156766666ddddd55dd6f6777
55555515554445d5d55544445d66ddddd66666444444d6666ddd555555555555777777d6dddddd5d677666d666666676666d111011567766666d5dddd66ff777
d555511155555555d55522445d66ddddd6dd66d444556ddddddddd5555555555777777dddd65d677d665ddd67776666777751000001d777766d555d666767777
765d6d1111555555dd5d444556666666666666d4445566ddddddddddddd5555577777d65d66dd56d65d6ddd67777777777750000000d7776dddd55d666777777
7f5d6d111155555dd55d444556677777777ff7d444556666666666666666d55577777d7776d6d75d6d56667777777777776151001515777d56d555dd66777777
776d6d111115555ddd55444256f677777777764444454522167777777777fd55777777777d7d77d56d777777777777777761dd555d557776555555d6dd677777
777f7f111115555dd51015555d555df777f6dd444445111115777777777776d5777777777d7d77d677777777777777777765dddddd5577776555d6666d667777
77777651111555551100000000551556f6554d444451111111e7777777777f6d777777777d66766777777777777777777775ddd5dddd777666d6767666667777
ff666d511115550000000000000100015554444451111122111d7ffffffffff67777777777d77d7777777777777777777765d55555556776666d666666676777
5dd5551111155000000000000000000015444422112111221111d6ddd6d6666677777776ddd7d677777777777777777777655105115d6766667dd66666777777
55555511111510000000010100100010052422251211122211111dd6666666667777777d6ddd67777777777777777777777d5555555d66666777666667777777
555555111111100000000d551d5500d5dd652dd5ddd122221111156666ddd666777777766777777777777777777777777776d55dd55667777777776777777777
ddd555555555000000000d0d5d5500d5ddd12ddddd5221212111116666666666777777777777777777777777777777777777d555555677777777777777777777
ddddddddddd1000000000d565d5500d5d5d11d6ddd522111120011566666666d777777777777777777777777777777777776555555dd77777777777777777777
ddddddddddd5000000000d1ddd550065ddd12ddddd5220111111011d666666667777777777777777777777777777777777651555555167777777777777777777
ddd666666666500000000d1dd656106565d12ddd655220111111111d66666666777777777777777777777777777777776d10155551100d677777777777777777
66666666f7f622100000010115551551155155225152101211201105666666dd7776666666666666667677776666665510005d55d55000156777777777777777
66666666666d2450000000001ddd16d61dd566521112101210211101dddddddd6666666666666666666666666666510000005555555000001566677777777777
66666666666d4215000000001dd51d6656d5d6521112101210110000dddddddd6666666666dddddddd6666666666500000005555510000000011666666666666
6666666666644215000000000000015250101221211210121011000066ffff666666dddddddddddddd6666666666100000005d55100000000000d66666666666
d666666666d4425d1000000000000552200112212111101210111005777777ffdd6dddddddd5ddddddd66d666dd6500000000551000000000000566666666666
6666f7777755225d00000000000005524101121121211102101100577777777fdddddd55dd555ddddddddddddddd500000000000000000000000566666666666
777777777622256d0000000000000d124111221221201102101100677777777f5dddd5555555555d555555d5dddd1000000000000000000000005ddddddd6666
777777777625557d10000000000006522111211221211111101105777777777f5d55dddddddddd55555555555555000000000000000000000000155555555555
777777777d255d7511000000000005d2211121121111211110110d7777f66fff555dd55d5ddd5555555555555555000000000000000000000000155d55555555
777777777d25576100000000000001d5211121221211210111110d666666d66655ddd55555555555d555d555ddd5000000000000000000000000155555515555
777777777425d7d00000000000000065211112221112110011100d6666666d6d555555555d5515555551151555510000000000000000000000000555ddd55555
77777777f255775000000000000000612101111221121110111106f66ff66666551555555d555551551115155d51000000000000000000000000011155555155
777777776516775000000000000000d121110222201210011010166ff777777f5515555155551155555111155510000000000000000000000000011111115551
76777777d5167600000000000000005121511222111101110000566d666666ff115555551111155d5dd511111110000000000000000000000000011111115111
76666666115ddd0000000000000000115551122111001111000016ddddd666ff111515555115555dd55551111150000000000000000000000000011115555551
6666d66d00ddd5000000000000000001000012211001011100001ddddddddd6611111555551555d5555555155551000000000000000000000000055555ddd551
5ddd5d5100d66d000000000000000001111011101111110100001ddddddddd55555155555555555d555555555555500000000000000000000000015d55ddddd5
dd677fd511d6750000000000000000050100111221121111000005ddddddd55555555515555555555d5d5555555555510000000000000000000001555ddd5555
76d677d51d766d00000000000000001dd511211221211110000115ddddddd5555555511555555515555555555555555100000000000000000000015555555555
4d6666d1577665111000000000000015d111111221211111000015dddddd5555555111555555555555555555555555510000000000000000000001555555dddd
66ddd5115111111111000000000000015511111222211111000151ddddd55555555555555555551155ddddd555555551000000000000000000000555555555dd
d6d5dd555115510100000000011100051101012211111100000110ddddddd555555555555155511155ddddd5555555510000000000000000000005555555555d
dddddd555511511111000000000000051550022212111100001110ddddd5555515155555515555555555d5dd5555555000000000000000000000055555555ddd
5dddd65525555111111000000000000546d10222211110100001005dddddd55511555155511555555dddd5dd5555511000000000000000000000055555555d5d
11166666dddd50111110000000110014d4620112211111100000005dddd555551155555555155555ddddddddd5555510000000000000000000000511555555d5
6d666666dd5d501111100d000011001dd66d1221111111100000005dd55555555555555155115555d555dd555555551100000000000000000000155155555555
76151dd655551111111006100011101666661122111111000000001ddd55555555555551555555555dddddd5555515100000000000000000000015555555555d
6666dd6ddddd11111110165001111016666621211111110000000005ddd55555555555111155555555dddd5555551500000000000000000000005ddddddddddd
6666666d5555111111105650011110166666d1211111110000000000ddd555555555555511555555555d555555511100000000000000000000005d5ddddddddd
7ddddd6d555511111100d6d00111105666665021111110000010000015555555555555555555555d55dd55dd55511100000000000000000000015ddd55555555
776dddd5555511111100d661011110d66666422111111010000000000555555555555555ddd5555555d5ddd55551110000000000000000000001d5555d555dd5
f777ffd55555111111016665010110d666666122111101100000000005555555d55555555ddddd55dd5555dd5555510000000000000000000005d55d55ddd5dd
f7777f511111011111056665011110d666666221110001100000000155555555d5ddd5dddd5d5d5ddddddd5d55dd510000000000000000000055555dd55555dd
d6d666f55555011110566665011110dddddd64210000011100000015555555555d5ddddddddddd5555dd555555555500000000000000000000555dddddddd5dd
5f51155555551010006ff66d00010166ddddd62200000024000000555555555555ddd55dddddddd55dd5dd555555d5000000000000000000005555555d5d5555
__sfx__
391c00001a520215201a5201f5201a5201e5201a520155201a520215201a5201f5201a5201e5201a520155201a520215201a5201f5201a5201e5201a520155201c5201a520155201c520155201e5201c5201a520
c11c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c0201c0201e0201c0201c0201e0201c0201a020
011c00001e0051e0551e0551e0551e0501e0501a0501a0501f0551f0551e0501e0501c0501c0501e0501e0551e0051e0551e0551e0551e0501e0501a0501a0501c0501c0501e0501c0501c0501a0501705015050
011c00002a0052a0552a0552a0552a0502a05026050260502b0552b0552a0502a05028050280502a0502a0552a0052a0552a0552a0552a0502a050260502605028050280502a0502805028050260502305021050
011c00001e0051e0551e0551e0551e0501e0551a0551a0551f0551f0551e0501e0501c0501c0501e0501e0551e0051e0551e0551e0551e0501e0551a0501a0501c0501c0501e0501c0501c0501e0501c0501a050
011c00002a0052a0552a0552a0552a0502a05526055260552b0552b0552a0502a05028050280502a0502a0552a0052a0552a0552a0552a0502a055260502605028050280502a05028050280502a0502805026050
011800002353020530235302053025530205302353020530235302053025530205302353023530205302053023530205302353020530255302053023530205302353020530255302053023530235302053020530
01180000235302053023530205302553020530235302053023530205302553020530235302353020530205302153021535215302153521530205301e5301c5302153021535215302153521530205301e53017530
0118000020050200552005020055200501e050000001f0000000000000000001e050230502305023050230501c050190501905000000000000000000000000000000000000000000000000000000000000000000
0118000020050200552005020055200502005526000260002b0002b0001c0551c0501e050200501e0501c0551c0501c0501c0552a0002600026000240002800028000280002a0002a00026000260000000000000
011c0000230552305523055230552305023055210501e0551e050210552105021055000000000021000210502105521050210552105521050210551e0501c0551c0501e0551e0501e05500000000002300023005
011c0000230052305523055230552305023055210501e0551e050210552105021055000000000000000210052100521055210552105521050210551e0501e0551c0501e0551e0501e05500000000000000000000
011c00001d00026055260552605526055260552605526055260502605526000260502605524000240002400024000260552605526055260552605526055280552805028055240002805028055260502a05028050
011c00001e000260552605526055260552605526055280502a0502a0552400026050260552400023050230551e000260502305021050260552605023050210502605526050230502105026050280552805028055
011c00000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000002863528635
011c00000000000000286350063537615000002863500000006350000028635006353761500000286350000000635000002863500635376150000028635000000063500000286350063537615000002863537610
011c00000000000000286350063537615000002863500000006350000028635006353761500000286350000000635000002863500635376150000028635000000063500000286350063537615000002863528635
011c00000000034635346353463500000000002863500000006350000028635006353761500000286350000000635000002863500635376150000028635000000063500000286350063537615000002863537610
011c00000000034635346353463500000000002863500000006350000028635376103761500000376103761500635000002863537615376003760528635376153760037605286353761537600376052864528645
011c00001e5003463534635346351e5001e500286451a5000064500645286451e5000064500645286451e5001e5001e500286451e5001a5001a500286451c5000064500645286451a50000645006452864528645
011c00001e5003463534635346351e5001e500286451a5000064500645286451e5000064500645286451e5001e5001e500286451e5001a5001a500286451c5000064500645286451a50000645006452864528645
011800001c0501c0551c0501c0551c0501c0551c0501c0551e0501e05520055200502005020050200552003420030200302003520024200202002020025200142001020010200150000000000000001c0501c055
0118000023055230502305520055200552005520055200551e0551c0501c050200501e0501e0501c0501c0551c050190501905500000000000000000000000000000000000000000000000000000000000000000
0118000023050230502305023055200501e0501e0501e0551c0501c05020050200501e0501e0501e0551c0551c0501c05020050200501e0501e0501c0501c0501c0501c0501c0401c04500000000001c0551c050
0118000023050230502305023050200501e0501e0501e0501c0501e05020050200552005020050000001c0501e0501e0501c0501c050230522305223052230522305223052230522305200000000000000000000
0118000020070200702007020075200702007020070200750060000600006001c0751c0701e0702007020075200701e0701e0701e075200701e0701e0701e0751c0001e000200001e0001c0701e070200701e070
01180000200701e0701c0701c07019070190700000019070210752107020070200701e0701e0701c0701c07019070190701c0701c0701e0701e07020075200702007020070000000000000000000000000000000
011800001e0201e025200202002520050200502005020055200502005020050200550060000600006001c0551c0501e0502005020055200501e0501e0501e055200501e0501e0501e0551c0001e000200001e000
011800000000000000000000000000000000000000000000000000000000000000000000000000000000000015530155351553015535000000000000000000001553015535155301553500000000000000000000
01180000000000000000000000000000000000000000000000000000000000000000000000000000000000002d5302d5352d5302d5352d5302c5302a530285302d5302d5352d5302d5352d5302c5302a53023530
0118000018000180001800018000180001c0251c0201e020200201e0201e0251e0201e0251e0201e0251e02018000180001800018000180001c0251c0201e020200201e0201e0251e0201e0251e0201e0251e020
0118000018000180001800018000180001c0251c0201e0201800018000180001e0201800018000180001e0201800018000180001e0201800018000180001e02018000200201e0201c02018000200201e0201c020
011800001903000000000000000019030000000000000000190300000000000000001903019035190301903015030150351503015035150300000000000000001503015035150301503515030000000000000000
011800001b313004000f3130c1433061500000000001b3130c1431b3130c1431b313306150000000000000001b313000000f3130c1433061500000000001b3130c1431b3130c1431b31330615000000000000000
011800000c17300000000000c1730c17300000000000c1730c17300000000000c1730c17300000000000c1730c17300000000000c1730c17300000000000c1730c17300000000000c1730c17300000000000c173
011800000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005001a5501c5501e5501e5501c5501c5501c5501c5551c5501a5501c5501e5501c5501a550
011800001a5501a5551a550175501a5501a55017550175501a5501a55517550155501a5501a5501c5501c5500050000500005001a5501e5501e5501c5501c5501c5551c5501c5501a5501c5501e5501c5501a550
011800001a5501a5501a555175501a5501a55517550155501a5501a5501755017555175501555515550155500050000500005000050000500005001a5501c5501e5501e5501c5501c5501a5501a550215501e550
011800001e5501e5501e5501e5501e5501e5501e5501e55500000000000000000000000000000000000000000000000000000000000000000000001a5501c5501e5501e5501c5501c5501a5501a550215501e550
011800001e5501e5501e5501e5501e5501e5501e5501e555000000000000000000000000000000155501555017550175551755017555175501755017555175501755019555195551955019550195501955015550
011800001a5501a5501a5551a5551a5501a550155501c5501c5501c5501c5501c5501c5501c5551a5501c5501e5501e5501c5501c5551c5501c5551a5551c5501c5501a5551c5501c5551c5501e5501c5501c550
011800002460000000246000000024600000002460000000246000000024600000002460000000246000000030615000003061500000306150000030615000003061500000306150000030615000003061500000
011800003061500000306150000030615000003061500000306150000030615000003061500000306150000030615000003061500000306150000030615000003061500000306150000030615000003061500000
01180000005001a5551a5551a5551a5551a5551a5551a555005001a5551a5551a5551a5551a5551a5551a55500500005000050000500005000050000500005000050000500005000050000500005000050000500
0118000030615000003061500000306150000030615000003061500000306150000030615000003061500000246150000024615000003c61500000246153c615246153c61524615000003c61500000246153c615
01180000246150000024615000003c61500000246153c615246153c61524615000003c61500000246153c615246150000024615000003c61500000246153c615246153c61524615000003c61500000246153c615
01180000246150000024615000003c615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0118000024000240002400024000240002400026050280502a0502a050280502805026050260502a0502a0502d0502d0502d0502d0502d0502d0502d0502d0502b0502b0502b0502b0502b0502b0502a0502a050
011800002a0502a0502a0502a050240002400026050280502a0502a050280502805026050260502a0502a0502d0502d0502d0502d0502d0502d0502d0502d0502b0502b0502b0502b0502b0502b0502a0502a050
011800002a0502a0502a0502a0500000000000000000000000000000000000000000000002605526050260552d0502d0502a0502a0502d0502d0502a0502d0502d0502a0502d0502d0502a0502a0502805028050
011800001c0501c05028050280552805028055260502805028050260502a0502a050280502805026050260502d0502d0502a0502a0502d0502d0502a0502d0502d0502a0502d0502d0502a0502a0502805028050
011800001c0501c0502805028055280502805526050260502805028050260502805028050260502a0502a050320102d010340102d010360102d01034010320102d01032010340102d010360102d010340102d010
01180000320102d010340102d010360102d01034010320102d01032010340102d010360102d010340102d010320102d010340102d010360102d01034010320102d01032010340102d010360102d010340102d010
01180000320102d010340102d010360102d01034010320102d01032010340102d010360102d010340103401000500005001a5501c5501e5501e5501c5501c5501c5501c5551c5501a5501c5501e5501c5501a550
011800001a0001a0001c0001c0001e0001e0001c0001a0001a0001a0001c0001c0001e0001e0001c0001c0001a0501a0501c0501c0501e0501e0501c0501a0501a0551a0501c0501c0501e0501e0501c0501c050
01180000005001a5551a5551a5551a5551a5551a5551a555005001a5551a5551a5551a5551a5551a5551a5551a0501a0501c0501c0501e0501e0501c0501a0501a0551a05021050210501e0501e0501c0501c050
01180000005001a5551a5551a5551a5551a5551a5551a555005001a5551a5551a5551a5551a5551a5551a55500000000000000000000000000000000000000000000000000000000000000000000000000000000
01180000000000000000000000000000000000000000000000000000000000000000000000000000000000000c17300000000000c1730c17300000000000c1730c17300000000000c1730c17300000000000c173
01180000000000000000000000000000000000000000000000000000000000000000000000000000000000003c6150000018143181433c615000000c1430c143000000c1430c143000003c615000000000000000
__music__
01 00014e44
00 00010e44
00 00010a0f
00 00010b10
00 00010c11
00 00010d12
00 00130203
02 00140405
01 46215e5e
00 06215e1e
00 07215f1f
01 06210844
00 07210944
00 06211544
00 07211644
00 41211744
00 41211844
00 06211959
00 07211a5a
00 06211959
00 07211a5a
00 06615e1e
02 071c201f
01 225c235f
01 22422444
00 22292544
00 222a262b
00 222c272b
00 222d2844
00 3a2e2f44
00 41423044
00 41423144
00 41423244
00 41423336
00 41423437
02 39423538
