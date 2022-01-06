pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--death of a bachelor 8-bit
--by: hankdetank05

function _init()

	songs={
		"death of a bachelor"
	}
	
	artists={
		"panic! at the disco"
	}
	
	albums={
		"death of a bachelor"
	}
	
	years={
		"2016"
	}
	
	patterns={
		0
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
	
	btn_y=107
	
	button_diff=1
	
	--⬆️+🅾️+❎ to toggle photo mode
	debug=true
	in_photo_mode=false
	_draw=jukebox_mode
	⬆️released=true

end

function _update60()

	if debug then
		if btn(❎) 
		   and btn(🅾️) 
		   and btn(⬆️) 
		   and ⬆️released then
			if in_photo_mode then
				_draw=jukebox_mode
				in_photo_mode=false
			else
				_draw=photo_mode
				in_photo_mode=true
			end
			⬆️released=false
		elseif not(btn(⬆️)) then
			⬆️released=true
		end
	end

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
	
	elseif btnp(❎) and not(btn(🅾️) or btn(⬆️)) then
	
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
		now_playing_dx-=0.5
		if abs(now_playing_dx)>#now_playing*4 then
			now_playing_dx=128
		end
	else
		now_playing_dx=1
	end

end

function jukebox_mode()

	// fill the screen dark blue
	cls(1)
	
	
	//draw the ui
	line(80,0,80,127,6)
	
	print("❎",100,6*7,12)
	print("play/pause",85,6*8,12)
	
	print("⬅️",100,6*10,12)
	print("skip back",86,6*11,12)
	
	print("➡️",100,6*13,12)
	print("skip next",86,6*14,12)
	
	rectfill(art_dx-1,art_dy-1,art_dx+1+art_dw,art_dy+1+art_dh,0)
	sspr(current_art.x,current_art.y,current_art.w,current_art.h,art_dx,art_dy,art_dw,art_dh)
	--rectfill(art_dx,art_dy,art_dx+art_dw,art_dy+art_dh,7)	//this is for debugging
	print(current_song,art_dx,88,7)
	print(current_artist,art_dx,96,6)
	
	--line(2,104,74,104,6)
	--line(2,104,10,104,8)
	
	--draw rw button
	local rw=16
	if btn(⬅️) then
		rw+=button_diff
	end
	spr(rw,art_dx,btn_y)
	
	--draw play/pause button
	if playing==true then
		playpause=32
	else
		playpause=48
	end
	if btn(❎) then
		playpause+=button_diff
	end
	spr(playpause,art_dx+32,btn_y)
	
	--draw ff button
	local ff=0
	if btn(➡️) then
		ff+=button_diff
	end
	spr(ff,art_dx+64,btn_y)

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

function photo_mode()
	cls()
	local draw_pos={
		{x=0,y=0},
		{x=64,y=0},
		{x=0,y=64},
		{x=64,y=64,size=64},
		{x=0,y=64,w=128,h=64}
	}
	if #songs>1 then
		for i=1,#art do
			sspr(art[i].x,art[i].y,art[i].w,art[i].h,draw_pos[i].x,draw_pos[i].y)
		end
	else
		sspr(art[1].x,art[1].y,art[1].w,art[1].h,32,0)
	end
	if #songs==3 then
		sspr(32,0,32,32,draw_pos[4].x,draw_pos[4].y,draw_pos[4].size,draw_pos[4].size)
	elseif #songs<=2 then
		sspr(0,32,64,32,draw_pos[5].x,draw_pos[5].y,draw_pos[5].w,draw_pos[5].h)
	end
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
76000076070000070005556000000000111111111111111111111111111111118888888888888888888888888888888888888888888888888888888888888888
77760076077700070005555600000000188111118811888888118811111111118000000000000000000000000000000000000000000000000000000000000008
77777676077777070005560000000000188111118811888888118811111111118000000000000000000000000000000000000000000000000000000000000008
77777776077777770005560000000000188111118818811118818811111111118000000000000000000000000000000000000000000000000000000000000008
77777776077777770555560000000000188111118818811118818811111111118000000000000000000000000000000000000000000000000000000000000008
77777676077777075555560000000000118811188118811118818811111111118000000000000000000000000000000000000000000000000000000000000008
77760076077700075555560000000000118811188118811118818811111111118000000000000000000000000000000000000000000000000000000000000008
76000076070000070555600000000000118811188118811118818811111111118000000000000000000000000000000000000000000000000000000000000008
76000076070000070000555000000000118811188118811118818811111111118000000000000000000000000000000000000000000000000000000000000008
76007776070007770000555500000000111881881118811118818811111111118000000000000000000000000000000000000000000000000000000000000008
76777776070777770000550000000000111881881118811118818811111111118000000000000000000000000000000000000000000000000000000000000008
77777776077777770000550000000000111881881118811118818811111111118000000000000000000000000000000000000000000000000000000000000008
77777776077777770055550000000000111881881118811118818811111111118000000000000000000000000000000000000000000000000000000000000008
76777776070777770555550000000000111188811111888888118888888118818000000000000000000000000000000000000000000000000000000000000008
76007776070007770555550000000000111188811111888888118888888118818000000000000000000000000000000000000000000000000000000000000008
76000076070000070055500000000000111111111111111111111111111111118000000000000000000000000000000000000000000000000000000000000008
00777600000777000000000000000000111111111111111111111111111111118000000000000000000000000000000000000000000000000000000000000008
07777760007777700000000000000000111881111118811111111144441111118000000000000000000000000000000000000000000000000000000000000008
77070776077070770000000000000000111888111188811111114499994411118000000000000000000000000000000000000000000000000000000000000008
77070776077070770000000000000000111188111188111111149994499941118000000000000000000000000000000000000000000000000000000000000008
77070776077070770000000000000000111188811888111111149444444941118000000000000000000000000000000000000000000000000000000000000008
77070776077070770000000000000000111118888881111111666444444666118000000000000000000000000000000000000000000000000000000000000008
077777600077777000000000000000001111118888111111118882ffff2888118000000000000000000000000000000000000000000000000000000000000008
007776000007770000000000000000001111118888111111116662ffff2666118000000000000000000000000000000000000000000000000000000000000008
00777600000777000000000000000000111111888811111111495555555594118000000000000000000000000000000000000000000000000000000000000008
07077760007077700000000000000000111111888811111111495444444594118000000000000000000000000000000000000000000000000000000000000008
77007776077007770000000000000000111118888881111111495444444594118000000000000000000000000000000000000000000000000000000000000008
77000776077000770000000000000000111188811888111111495444444594118000000000000000000000000000000000000000000000000000000000000008
77000776077000770000000000000000111188111188111111445444444544118000000000000000000000000000000000000000000000000000000000000008
77007776077007770000000000000000111888111188811111445555555544118000000000000000000000000000000000000000000000000000000000000008
07077760007077700000000000000000111881111118811111441111111144118000000000000000000000000000000000000000000000000000000000000008
00777600000777000000000000000000111111111111111111111111111111118000000000000000000000000000000000000000000000000000000000000008
11111111111111111111111111111111111111111111111111111111111111118000000000000000000000000000000000000000000000000000000000000008
11111111881881111881881111881888888881888888111118888111881118818000000000000000000000000000000000000000000000000000000000000008
11111111881881111881881118881888888881888888811188888811881118818000000000000000000000000000000000000000000000000000000000000008
11111111881881111881881188811881111111881118811188118811888188818000000000000000000000000000000000000000000000000000000000000008
11111111881881111881881888111881111111881118811888118881188188118000000000000000000000000000000000000000000000000000000000000008
11111111881881111881888881111881111111881118811881111881188888118000000000000000000000000000000000000000000000000000000000000008
11111111881881111881888811111888888111888888811881111881118881118000000000000000000000000000000000000000000000000000000000000008
11111111881881111881888111111888888111888888111881111881118881118000000000000000000000000000000000000000000000000000000000000008
11111111881881111881888811111881111111888888811881111881118881118000000000000000000000000000000000000000000000000000000000000008
11111111881881111881888881111881111111881118881881111881118881118000000000000000000000000000000000000000000000000000000000000008
11111111881881111881881881111881111111881111881881111881188888118000000000000000000000000000000000000000000000000000000000000008
11111111881888118881881888111881111111881111881888118881188188118000000000000000000000000000000000000000000000000000000000000008
18811111881188118811881188811881111111881118881188118811888188818000000000000000000000000000000000000000000000000000000000000008
18881118881188888811881118881888888881888888811188888811881118818000000000000000000000000000000000000000000000000000000000000008
11888888811118888111881111881888888881888888111118888111881118818000000000000000000000000000000000000000000000000000000000000008
11188888111111111111111111111111111111111111111111111111111111118000000000000000000000000000000000000000000000000000000000000008
11111111111111111111111111111111111111111111111111111111111111118000000000000000000000000000000000000000000000000000000000000008
18811111881188888811881111111111111881111118811111111144441111118000000000000000000000000000000000000000000000000000000000000008
18811111881188888811881111111111111888111188811111114499994411118000000000000000000000000000000000000000000000000000000000000008
18811111881881111881881111111111111188111188111111149994499941118000000000000000000000000000000000000000000000000000000000000008
18811111881881111881881111111111111188811888111111149444444941118000000000000000000000000000000000000000000000000000000000000008
11881118811881111881881111111111111118888881111111666444444666118000000000000000000000000000000000000000000000000000000000000008
118811188118811118818811111111111111118888111111118882ffff2888118000000000000000000000000000000000000000000000000000000000000008
118811188118811118818811111111111111118888111111116662ffff2666118000000000000000000000000000000000000000000000000000000000000008
11881118811881111881881111111111111111888811111111495555555594118000000000000000000000000000000000000000000000000000000000000008
11188188111881111881881111111111111111888811111111495444444594118000000000000000000000000000000000000000000000000000000000000008
11188188111881111881881111111111111118888881111111495444444594118000000000000000000000000000000000000000000000000000000000000008
11188188111881111881881111111111111188811888111111495444444594118000000000000000000000000000000000000000000000000000000000000008
11188188111881111881881111111111111188111188111111445444444544118000000000000000000000000000000000000000000000000000000000000008
11118881111188888811888888811881111888111188811111445555555544118000000000000000000000000000000000000000000000000000000000000008
11118881111188888811888888811881111881111118811111441111111144118000000000000000000000000000000000000000000000000000000000000008
11111111111111111111111111111111111111111111111111111111111111118888888888888888888888888888888888888888888888888888888888888888
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
010c00001807018070180701707017070170700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001807018070180701a0701a0701a0700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c0500180701a070186751867518675000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001807018070180701607016070160700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c0000180701c0701c0701c07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00081817300000000001817300000000001817300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001867518675186751867500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600001867518675186751867500000000000000000000186751867518675186750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0118000000000000000000000000248502485024850210502405024050240501a0501a0501a0501a050000000000000000000000000021950219502195021050230501c0501c0551c0501c0501a0501a0501c050
011800001c0501c0501c0501c055248502485024850210502405024050240501a0501a0501a0501a050000000000024050230502305021050210501f0501a0501c0511c0501c0501c0501c0501c0501c0501c050
0118000000000000000000000000249502495024950280502605026050260502105021050210502105000000000000000000000000002395023950239502605026050240501f0501f0501f0501f0501f0501f050
0118000000000000000000021a50248502485021050240502405024050240501fa5023b5023b501f050230502305023050230501fa5023b5023b5023b501f0501fc501fc501a0501c0511c0501c0501c0501c055
011800000000000000000002105023950239502395028050260502605026050240502405024050240500000000000000000000000000219502195021950240502305023050230502105021050210502105021050
01180000000000000000000210502485024850248502105024050240502405024055248502485024850210502405024050240502405021950219502195024050240502405024050240502b0502b0502b0502b050
0118000000000000000000000000000000000000000000000c17300000000000c17324600000000c17300000000000c1730c17300000000000c17300000000000c17300000000000c17300000000000c17300000
011800000000000000000000000000000000000000000000000000000000000000003c615000000000000000000000000000000000003c615000000000000000000000000000000000003c615000000000000000
011800000cd500cd500cd500cd550cd500cd500cd500cd550c17300000000000c17324600000000c17300000000000c1730c17300000000000c17300000000000c17300000000000c17300000000000c17300000
01180000006000060000600006003c615006000060000600006000060000600006003c615006000060000600006000060000600006003c615006000060000600006000060000600006003c615006000060000600
011800000000000000000003c0003c615000000000000000246352463500000000003c615000002463524635000000000000000000003c6150000018e6018e60246352463500000000003c615000002463524635
011800000cd500cd500cd500cd550cd500cd500cd500cd550c17300000000000c17324600000000c17300000000000c1730c17300000000000c17300000000000c17300000000000c17300000000000c17300000
01180000000000c1730c17300000000000c173000000c1730c17300000000000c17300000000000c17300000000000c1730c17300000000000c173000000c1730c17300000000000c17300000000000c17300000
011800000000000000000000000018f300000018f3000000246352463500000000003c615000002463524635000000000000000000002463524635000000000024635246350000024a0024a3024a300000000000
011800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0118000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000024a0024a3024a300000024a0024a3024a300000024a0024a3024a30
010c00002b0502b0502b0502b0502b0502b0551c5501c5502155021550215502155021550215501f5501c55021550215502155021550215502155021550215501c5501c5501c5501c5501c5501c5501c5501c550
010c00001a5501a5501a5501a5501a5501a5501a5501a5501855018550185501a5501c5501c5501c5501c5501c5501c5551c5501c5501a5501a55018550185501a5501a5501a5501855018550185551855018550
011810002463500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001a5501a5501a5501a5501a5501a5501a5501a5501855018550185501a5501c5501c5501c5501c5501c5501c5551c5501c5501a5501a55018550185501a5501a5501a5501855018550185551855018550
0118100024a0024a3024a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001855018550185501855018550185551c5501c5502155021550215502155021550215501f5501c5502155021550215502155021550215501c5501c5501a5501a5501a5501855015550155501555015550
010c000015550155501555015550155501555015555155001855018550185501a5501c5501c5501c5501c5501c5501c5501c5551c5001f5501f5501c5501c5501a5501a5501a5501855018550185551855018550
010c000018550185501855018550185550000000000185002155021550215501f5501f5501f5551f5502155024550245502455024550245502455024550245502155021550215502155021550215502155021550
010c00002855128550285502855028550285502855028550285502855028550265512655026550265502655000000000002855028550265502655024550245502655026550265502455024550245552455024550
010c000024550245502455024550245502455024555245002155021550215501f5501f5501f5501c5501c5502155021550215502155021550215501c5501c5501a5501a5501a5501855015550155501555015550
010c000018550185501a5501a5501c5501c5501a5501a5501a5501a5501a5501a5501855018550155501555018550185501a5501a5501c5501c5501a5501a5501a5501a5501a5501a55018550185551855018550
0118000018550185500000000000248502485024850210502405024050240501a0501a0501a0501a050000000000000000000000000021950219502195021050230501c0501c0551c0501c0501a0501a0501c050
01180000007000070000700007000070000700007000070018750187501875018750007000070000700007001a7501a7501a7501a750007000070000700007001c7501c7501c7501c75000000000000000000000
011800001c7501c7501c7501c7501975019750197501975018750187501875018750007000070000700007001a7501a7501a7501a750007000070000700007001775017750177501775000000000000000000000
011800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 0e0f2408
01 10112509
00 1011260a
00 1011270b
00 1312160c
00 1415170d
00 411c1a18
00 4142431b
00 4142431d
00 4142431e
00 4142431f
00 41424320
00 41424321
00 41424322
02 0e0f4323

