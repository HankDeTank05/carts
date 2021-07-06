pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--irresistible 8-bit
--by: hankdetank05

function _init()

	songs={
		"irresistible"
	}
	
	artists={
		"fall out boy"
	}
	
	albums={
		"american beauty/american psycho"
	}
	
	years={
		"2015"
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
		now_playing_dx-=1
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
010802031707018071180700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b00002467018671186701867000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010500002467024660246502464024630246202461000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800041867518675186751867500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00041867518675186751867500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010d03041c0701a070170701707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
311600201e1302113023130211302313023130231302313000100231302613023130261302613026130261301c1301f130211301f130211302113021130211300010026130281302613028130281302613026130
911600001725017250172501725500200002000020000200002000020017250172501725017255002000020000200152501525015250152550020000200002000020000200002000020015250152552607526075
4d1600001723517235172351723517235172351723517235172351723517235172351723517235172351723517235172351723517235172351723517235172351723517235172351723517235172351723517235
491600003c6203c6203c6113c6103c6153c6003c6003c6003c6003c6003c6003c6003c6003c600186001860018600186001860018600186001860018600186001860000000000003c00000000000001a0001a000
011600002607526075260752607026075000002607526075260752607526075260702607500000260752607025075250752507525070250752507525075250752507525070260702507023075230752307523075
011600002607526070230702607026075260702607526070260752607023070260702607500000260752607025075250752507525070250752507525075250752507525070230752307023075230752307523075
01160000280752807526070280702807500000280702607028075280702a0702807026075260752607526070280752807026070280702807500000280752607028075280752a8702807026070230752307025070
01160000260752607023070260702307000000260702307026075260702307026070260752307523075230702887528070260702807026070260752807026070280752807026070288702807528870280752a870
011600000c1730000000000000000c1730000000000000000c1730000000000000000c1730000000000000000c1730000000000000000c1730000000000000000c1730000000000000000c173000000000000000
011600000c1730000000000000000c1730000000000000000c1730000000000000000c173000000000000000249302493524635249302493500000000000000024930249350000000000000000c1000000000000
311600001e1202112023120211202312023120231202312000100231202612023120261202612026120261201c1201f120211201f120211202112021120211200010026120281202612028120281202612026120
011600001e1202112023120211202312023120231202312000100231202612023120261202612026120261201c1201f120211201f120211202112021120211250000000000000000000000000000000000000000
011600000c17300000000000000018a6018a6000000000000c17300000000000000018a6018a6000000000000c173000000c1730000018a6018a6000000000000c17300000246452464530645306453064530645
1d1600201e7401e7401c7401a7401774017740177401e7401e7401e7401c7401a74017740177401e7401c7401c7401c7401a7401a74017740177401e7401c7401c7401c7401a7401a7401774017740237001e740
1d1600001e7401e7401c7401a7401774017740177401e7401e7401e7401c7401a74017740177401e7401c7401c7401c7401a7401a74017740177401e7401c7401c7401c7401a7401a74000700007000070000700
011600002a0702a07028070260702307023070230702a8702a0702a070280702607023070230702a070280702807028070260702607023070230702a87028070280702807026070260702307023070230002a870
011600002a0702a07028070260702307023070230702a8702a0702a070280702607023070230702a070280702807028070260702607023070230702a870280702807028070260702607023050230502505025050
011600002605026050260502605026055000002605026050288502805028050280502a0502a0552a8502a0502a050280502a050280502a0502a0502a0502a0402a0402a035000000000000000260752607526075
01160000260702607526070260702d0702d0702d0702b0702a0702a0702a070280702a0702a0702a0700000000000000002d0702b0702a0702a0702a070280702a07028070230702307523070230702607026070
01160000000000000000000000002d0702d0702d0702b0702a0702a0702a070280702a0702a0702a0700000000000000002d0702b0702a0702a0702a070280702a07028070230702307523070230702607026070
0116000000000210702307021070230702307023070230700000023070260702307026070260702607026070000002807528070260702807028070260702607028070280702a0702a0752b8702b0702a0702a070
011600000c173000000c1730000018a6018a603c6003c6000c17300000000000000018a6018a6000000000000c17324655000000000018a6018a6000000000000c17300000000000000018a6018a600000000000
01160000246350000024635000003c6203c6203c6113c61024635000000000000000000000000030b2030b20246350000030b0030b0000000000000000030c20246350000000000000000000030b2030b2030b20
011600000c17300000000000000018a6018a6000000000000c17300000000000000018a6018a6000000000000c17300000000000000018a6018a6000000000000c17300000000000000018a6018a600000000000
011600002463500000000000000000000000000000018c5024635000000000000000000000000018b5018b5024635000000000000000000000000018c0018c5024635000000000000000000000000018b5018b50
011610002a8502a0502a8502a0502a8502a05024d5024d5024d500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 0b424308
00 0b0a0908
01 1042120c
00 1142130d
00 140b120e
00 1442120f
00 14121517
00 14131618
00 41424319
00 1d1e521a
00 1d1e431b
00 1f20121c
00 1f20121c
02 41424321

