pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--jukebox template
--by: hankdetank05

function _init()

	songs={
		"artifact",
		"???",
		"???"
	}
	
	artists={
		"i fight dragons",
		"???",
		"???"
	}
	
	albums={
		"canon eyes",
		"???",
		"???"
	}
	
	years={
		"2019",
		"???",
		"???"
	}
	
	patterns={
		0,
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
76000076070000070000000000000000000000000000000000000000000000008888888888888888888888888888888888888888888888888888888888888888
77760076077700070000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77777676077777070000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77777776077777770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77777776077777770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77777676077777070000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77760076077700070000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
76000076070000070000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
76000076070000070000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
76007776070007770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
76777776070777770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77777776077777770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77777776077777770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
76777776070777770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
76007776070007770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
76000076070000070000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00777600000777000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
07777760007777700000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77070776077070770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77070776077070770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77070776077070770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77070776077070770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
07777760007777700000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00777600000777000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00777600000777000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
07077760007077700000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77007776077007770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77000776077000770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77000776077000770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
77007776077007770000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
07077760007077700000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00777600000777000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000008
00000000000000000000000000000000000000000000000000000000000000008888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
80000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000008
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
__sfx__
010502031a1501c1511c1501a1001c1001a1001c1001c100001001810018100181001c1001a1001c1000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
010502031a5501c5511c5500050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
010500002467024650246552464024640246452464024640246450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
311400001811018110181101a1101c1101a1101c1101c11000100171151711517115188101a1101c1101c110151101511015110001001c1101a1101c1101c11013115131151311513115198101d1101c1101c110
011400001855018550185501a5511c5501a5501c5501c550005001755517555175551c5501a5501c5501c550155501555015550005001c5501a5501c5501c55013555135551355513555199501d5501c5501c550
011400000000000000240452404524040230402304000000000002304523045230452304024040230402304000000000002404524045240402404524045240452404021045210452104521040210451f0401f040
011400000000000000240452404526040240402404000000000002304523045230452304024040230402304000000000002404524045240402404524045240452404524045240452404526040260402804028040
011400002804028045280402804026040260402404024040000002304523045230452304024040230402304000000240452404524045240402404524045240452404021045210452104521040210401f0401f040
011400000000000000240452404524045240402404023041000000000023045230452304523040230402304500000000002304523045230452304023045230402304523045230452404024045260402604528040
011400002804528045280452804528045280402804028040240410000024040240402604026040240402404524040240452804128040260402604024040240402604026045280412804026040260402404024040
011400002804528045280452804528040280402804024041000002404024040260402604024040240452404024045280412804026040260402404024040260402604528041280402604026040240402404000000
0114000000000000000000000000246350000024635000000000024635000000000024635000002463518a4018a4018a400000000000246350000024635000000000024635000000000024635000000000000000
0114000018a3018a3018a3000000246350000024635000000000024635000000000024635000002463518a3018a3018a300000000000246350000024635000000000024635000000000024635000000000000000
__music__
01 08424344
00 4a104309
00 4a114309
01 4150430a
00 4142430b
00 4142430c
00 4142430d
00 41420e44
00 41420f44
00 41420944
02 41420944

