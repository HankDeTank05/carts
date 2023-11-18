pico-8 cartridge // http://www.pico-8.com
version 37
__lua__
--jukebox complete
--by hankdetank05

function _init()
	init_library()
	set_list_state()
end

function _update60()
end

function _draw()
end
-->8
--tab 1: global variables

states={
	list="list",
	player="player",
}

-----------
--globals--
-----------
curr_state=states.list

screen_size=128

txtcol_btns=12
txtcol_headfoot=2
txt_ysize=5
txt_xsize=4
txtbtn_xsize=7

spr_size=8

now_playing_index=nil
now_playing_song="song name"
now_playing_artist="artist name"
-->8
--tab 2: list state

--note: variables init'd as
--      are dependent on
--      library size, and will
--      be updated continuously

headfoot_ysize=7--the height of the header/footer bars
headfoot_col=8--the color of the header/footer bars
viewport_height=screen_size-headfoot_ysize*2
vport_ymin=headfoot_ysize
vport_ymax=screen_size-headfoot_ysize

--[[
scroll_bground_xsize=3--width of scroll bar
scroll_xspace=1--horiz. space between right side of scroll bar and left side of list text
scroll_yspace=4--vert. space between header/footer and ends of scroll background
scroll_ysize=screen_size-(headfoot_ysize*2)-(scroll_yspace*2)
scroll_bar_col=13--scroll bar color
scroll_bground_col=5--scroll bar background color
scroll_bground_ypos=headfoot_ysize+scroll_yspace
scroll_bar_height=nil
scroll_bar_dy_min=scroll_bground_ypos
scroll_bar_dy_max=nil
]]

list_bground_col=1--list background color
list_txt_xpos=txt_xsize*3
list_item_yspace=3--spacing between list items (bottom of one artist text to top of next song text)
list_txt_yspace=1--spacing between song and artist text
list_item_ysize=(txt_ysize*2)+list_txt_yspace--the height of a list item (from top of name text to bottom of artist text)

list_total_ysize=nil
list_dy_min=nil
list_dy_max=vport_ymin+3
list_dy=list_dy_max

cursor_index=1
cursor_x0=list_txt_xpos-2
cursor_y0=list_dy-1
cursor_x1=nil
cursor_y1=cursor_y0+list_item_ysize+3
cursor_col=12

function set_list_state()
	_update60=update_list_state
	_draw=draw_list_state
	curr_state=states.list
end

function update_list_state()
	
	--read for input
	if btnp(⬆️) and cursor_index>1 then
		cursor_index-=1
		--update cursor_y0/1
		cursor_y0-=list_item_ysize+list_item_yspace
		cursor_y1-=list_item_ysize+list_item_yspace
		--scroll to keep cursor on screen if needed
		if cursor_y0<=headfoot_ysize then
			local new_y0=headfoot_ysize+2
			local delta=new_y0-cursor_y0
			cursor_y0+=delta
			cursor_y1+=delta
			list_dy+=delta
			if list_dy>list_dy_max then
				delta=list_dy_max-list_dy
				list_dy+=delta
				cursor_y0+=delta
				cursor_y1+=delta
			end
		end
	elseif btnp(⬇️) and cursor_index<#library then
		cursor_index+=1
		--update cursor_y0/1
		cursor_y0+=list_item_ysize+list_item_yspace
		cursor_y1+=list_item_ysize+list_item_yspace
		--scroll to keep cursor on screen if needed
		if cursor_y1>=screen_size-headfoot_ysize then
			local new_y1=screen_size-headfoot_ysize-2
			local delta=new_y1-cursor_y1
			cursor_y0+=delta
			cursor_y1+=delta
			list_dy+=delta
			if list_dy_min>list_dy then
				delta=list_dy-list_dy_min
				list_dy+=delta
				cursor_y0+=delta
				cursor_y1+=delta
			end
		end
	elseif btnp(➡️) then
		--change the sorting
	elseif btnp(❎) then
		play_from_list()
	elseif btnp(🅾️) then
		--change to player state
		set_player_state()
	end
end

function draw_list_state()
	--------------------
	--background layer--
	--------------------
	rectfill(0,0,
		127,127,
		list_bground_col)
	
	----------------
	--middle layer--
	----------------
	draw_list()
	
	-------------
	--top layer--
	-------------
	
	--top bar
	rectfill(0,0,
		127,headfoot_ysize,
		headfoot_col)
	if curr_state==states.list then
		print("⬆️",1,1,txtcol_btns)
	end
	print("sort: none",10,1,
		txtcol_headfoot)
	
	--bottom bar
	rectfill(0,128-headfoot_ysize,
		127,127,
		headfoot_col)
	print("now playing: none",
		1,122,
		txtcol_headfoot)
	
	if curr_state==states.list then
		draw_player_state()
	end
end

function draw_list()
	assert(list_dy_min<=list_dy)
	assert(list_dy<=list_dy_max)
	
	--------
	--list--
	--------
	
	local curr_dy=list_dy--the ypos where a list item will be drawn
	for s=1,#library do
		draw_list_item(library[s].name,
		               library[s].artist,
		               curr_dy,
		               cursor_index==s)
		curr_dy+=list_item_ysize+list_item_yspace
	end
	
	------------
	--scroller--
	------------
	
	--[[
	--background
	rectfill(scroll_xspace,scroll_bground_ypos,
		scroll_bground_xsize+scroll_xspace,scroll_bground_ypos+scroll_ysize,
		scroll_bground_col)
	
	--bar
	local list_y_percent=(list_dy-list_dy_min)/(list_dy_max-list_dy_min)
	local scroll_bar_dy=list_y_percent*(scroll_bar_dy_max-scroll_bar_dy_min)+scroll_bar_dy_min
	--[[
	rectfill(0,scroll_bar_dy,
		scroll_xsize,scroll_bar_dy+scroll_bar_height,
		scroll_bar_col)
	]]
	]]

end

function draw_list_item(sname,
                        sartist,
                        ypos,
                        selected)
 assert(type(selected)=="boolean")
 local sname_col=7
 local sartist_col=6
	
	local sname_ypos=ypos+list_txt_yspace
	local sartist_ypos=sname_ypos+txt_ysize+list_txt_yspace
	
	print(sname,
		list_txt_xpos,sname_ypos,
		sname_col)
	print(sartist,
		list_txt_xpos,sartist_ypos,
		sartist_col)
	
	if selected then
		cursor_x1=list_txt_xpos+max(#sname,#sartist)*txt_xsize+1
		if curr_state==states.list then
			print("❎",
				list_txt_xpos-txt_xsize*2-2,(sname_ypos+sartist_ypos)/2,
				txtcol_btns)
		end
		rect(cursor_x0,cursor_y0,
			cursor_x1,cursor_y1,
			cursor_col)
	end
end

function play_from_list()
	load_art(library[cursor_index])
	load_and_play(library[cursor_index])
	now_playing_index=cursor_index
	set_player_state()
end
-->8
--tab 3: player state

--animation state
plr_anim=0.0
-- 0.0 = retracted
-- 0.x = somewhere in between
-- 1.0 = expanded

--amount to animate per frame
plr_delta=0.1

--direction to animate
plr_motion=0
--  1 = animating in
--  0 = not animating
-- -1 = animating out

--is something playing?
plr_playing=false

--player controls sprite ids
--(constants)
prev_spr_up=16
prev_spr_dn=17
paus_spr_up=32
paus_spr_dn=33
play_spr_up=48
play_spr_dn=49
next_spr_up=0
next_spr_dn=1
--(vars used for drawing)
prev_ctrl_spr_id=prev_spr_up
plps_ctrl_spr_id=play_spr_up
next_ctrl_spr_id=next_spr_up

--album art draw vars
plr_art_sx=64
plr_art_sy=0
plr_art_sw=64
plr_art_sh=64
plr_art_dw=plr_art_sw
plr_art_dh=plr_art_sh


function set_player_state()
	_update60=update_player_state
	_draw=draw_player_state
	plr_motion=1
	curr_state=states.player
end

function update_player_state()
	if plr_motion==1 then
		--if animating in
		if plr_anim<1 and plr_anim+plr_delta<1 then
			plr_anim+=plr_delta
		else
			plr_motion=0
			plr_anim=1
		end
		
	elseif plr_motion==-1 then
		--if animating out
		if plr_anim>0 and plr_anim-plr_delta>0 then
			plr_anim-=plr_delta
		else
			plr_motion=0
			plr_anim=0
			set_list_state()
		end
		
	else--if not animating
		--read for input (press)
		if btnp(🅾️) then
			--begin closing animation
			plr_motion=-1
			--note: state changes after animation
		elseif btnp(❎) then
			play_pause()
		elseif btnp(⬅️) then
			skip_back()
		elseif btnp(➡️) then
			skip_fwd()
		elseif btnp(⬆️) then
			--toggle shuffle
		elseif	btnp(⬇️) then
			--rotate repeat state
		end
		set_ctrl_spr_ids()
	end
end

function draw_player_state()
	if curr_state==states.player then
		cls()
		draw_list_state()
	end
	
	local bground=3--background color
	local radius=16--rounded corner radius

	local start_x=128--xpos to start the animation from
	local final_x=24--xpos to end the animation at
	local curr_x=(final_x-start_x)*plr_anim+start_x--current draw xpos
	--assert(curr_x<=128)
	--assert(plr_anim>=0)
	
	local aart_xoff=0--album art xoff from curr_dx
	local aart_ypos=16--album art ypos
	local aart_dsize=64--square size of drawn album art
	local aart_dx=curr_x+aart_xoff
	local aart_dy=aart_ypos
	
	local ctrl_yoff=16--music controls yoff from bottom of album art
	local prev_xoff=8--prev control xoff from curr_dx
	local play_xoff=28--play control xoff from curr_dx
	local next_xoff=48--next control xoff from curr_dx
	
	local ctrl_xoff=16--music controls xoffset from right of album art
	local shfl_ypos=spr_size--shuffle control ypos
	local rept_ypos=spr_size*2--repeat control ypos
	
	local txtcol_song=7--text color of the song name
	local txtcol_artist=6--text color of the artist name
	local txt_yspace=1--vertical spacing between text

	--top rounded corner
	circfill(curr_x,radius,
		radius,bground)
	--btm rounded corner
	circfill(curr_x,128-radius,
		radius,bground)
	--bground between corners
	rectfill(curr_x-radius,radius,
		curr_x,128-radius,
		bground)
	--remaining bground
	rectfill(curr_x,0,
		127,127,
		bground)
	
	--album art backdrop
	rectfill(aart_dx,aart_dy,
		aart_dx+plr_art_dw-1,
		aart_dy+plr_art_dh-1,
		0)
	
	--album art
	sspr(plr_art_sx,plr_art_sy,
		--draw from (sx,sy) on
		--spritesheet
	           
		plr_art_sw,plr_art_sh,
		--draw sw x sh pixels from
		--spritesheet
		
		aart_dx,aart_dy,
		--draw at calculated position
		
		plr_art_dw,plr_art_dh)
		--draw selected area as
		--dw x dh (size on screen)
	
	--song name
	print(now_playing_song,
		curr_x+aart_xoff,
		aart_dy+aart_dsize+txt_yspace,
		txtcol_song)
	--artist name
	print(now_playing_artist,
		curr_x+aart_xoff,
		aart_dy+aart_dsize+txt_yspace+txt_ysize+txt_yspace,
		txtcol_artist)

	--bottom row music ctrls ypos	
	local ctrl_dypos=aart_ypos+aart_dsize+ctrl_yoff
	--bottom row music btns ypos
	local btn_dypos=ctrl_dypos+spr_size+txt_yspace
	
	--prev ctrl
	spr(prev_ctrl_spr_id,
		curr_x+prev_xoff,
		ctrl_dypos)
	--play/pause ctrl
	spr(plps_ctrl_spr_id,
		curr_x+play_xoff,
		ctrl_dypos)
	--next ctrl
	spr(next_ctrl_spr_id,
		curr_x+next_xoff,
		ctrl_dypos)

	--prev btn
	print("⬅️",
		curr_x+prev_xoff,btn_dypos,
		txtcol_btns)
	--play btn
	print("❎",
		curr_x+play_xoff,btn_dypos,
		txtcol_btns)
	--next btn
	print("➡️",
		curr_x+next_xoff,btn_dypos,
		txtcol_btns)
	
	--return to list btn
	if plr_motion==0 then
		print("🅾️",
			curr_x-radius-txtbtn_xsize+2,128/2,
			txtcol_btns)
	end
	
	--for debugging
	--print(plr_anim,0,0,7)
	--print(now_playing_index)
end

function play_pause()
	if plr_playing==true then
		music(-1)
		plr_playing=false
	else
		assert(now_playing_index!=nil)
		assert(now_playing_index>-1)
		music(library[now_playing_index].start)
		plr_playing=true
	end
end

function skip_back()
	--decrement the song index
	now_playing_index-=1
	--loop around if at first song
	if now_playing_index<1 then
		now_playing_index=#library
	end
	--load the album art
	load_art(library[now_playing_index])
	--play the song
	load_and_play(library[now_playing_index])
end

function skip_fwd()
	--increment the song index
	now_playing_index+=1
	--loop around if at last song
	if now_playing_index>#library then
		now_playing_index=1
	end
	--load the album art
	load_art(library[now_playing_index])
	--play the song
	load_and_play(library[now_playing_index])
end

function set_ctrl_spr_ids()
	--read for input (holds)
	
	--play/pause control
	if btn(❎) then
		if plr_playing==true then
			--pause is down
			plps_ctrl_spr_id=paus_spr_dn
		else
			--play is down
			plps_ctrl_spr_id=play_spr_dn
		end
	else
		if plr_playing==true then
			--pause is up
			plps_ctrl_spr_id=paus_spr_up
		else
			--play is up
			plps_ctrl_spr_id=play_spr_up
		end
	end
	
	--prev control
	if btn(⬅️) then
		--prev is down
		prev_ctrl_spr_id=prev_spr_dn
	else
		--prev is up
		prev_ctrl_spr_id=prev_spr_up
	end
	
	--next control
	if btn(➡️) then
		--next is down
		next_ctrl_spr_id=next_spr_dn
	else
		--next is up
		next_ctrl_spr_id=next_spr_up
	end
end
-->8
--tab 4: music data
#include music_library.p8
-->8
--tab 5: music mem util

function sfxaddr(sfxid)
	return 0x3200+sfxid*68
end

function musicaddr(patid)
	return 0x3100+patid*4
end

function num2hex(number)
    local base = 16
    local result = {}
    local resultstr = ""

    local digits = "0123456789abcdef"
    local quotient = flr(number / base)
    local remainder = number % base

    add(result, sub(digits, remainder + 1, remainder + 1))

  while (quotient > 0) do
    local old = quotient
    quotient /= base
    quotient = flr(quotient)
    remainder = old % base

         add(result, sub(digits, remainder + 1, remainder + 1))
  end

  for i = #result, 1, -1 do
    resultstr = resultstr..result[i]
  end

  return resultstr
end

function printsfx(sfxid)
	
	local x=0
	local y=0
	
	sfxstart=sfxaddr(sfxid)
	sfxend=sfxstart+67

	for i=sfxstart,sfxend do
		print(num2hex(peek(i)),x,y,11)
		x+=10
		if x>=119 then
			x=0
			y+=6
		end
	end
	
	print(sfxid,x,y,8)
end

function printmusic(patid)
	
	musicstart=musicaddr(patid)
	musicend=musicstart+3
	
	local x=0
	local y=7*6
	
	for i=musicstart,musicend do
		print(num2hex(peek(i)),x,y,11)
		x+=10
		if x>=119 then
			x=0
			y+=6
		end
	end
	
	print(patid,x,y,8)
	
end

function convertsfxdata(hex_str)

	assert(#hex_str==168)

	--byte #0
	--0x00==pitch mode
	--0x01==note entry mode
	local editor_mode=hex_str[1]..hex_str[2]
	
	--byte #1
	--multiples of 1/128 seconds
	local note_duration=hex_str[3]..hex_str[4]
	
	--byte #2
	--note number, 0-63
	local loop_range_start=hex_str[5]..hex_str[6]
	
	--byte #3
	--note number, 0-63
	local loop_range_end=hex_str[7]..hex_str[8]
	
	--bytes 4-84
	--the rest are notes
	local notes={}
	
	local current_note=""
	local nybble=0
	for i=9,168 do
		--conversion stuff
		
		nybble+=1
		if nybble>4 then
			nybble=0
		end
	end

end--tab 1: util f(x)'s

function str_hex2bin(hexstr)
	
	assert(sub(hexstr,1,2)=="0x","hex strings must lead with '0x'!")
	
	local binstr="0b"
	
	for i=3,#hexstr do
	
		local nyble=sub(hexstr,i,i)
		
		if nyble=="0" then
			binstr=binstr.."0000"
		elseif nyble=="1" then
			binstr=binstr.."0001"
		elseif nyble=="2" then
			binstr=binstr.."0010"
		elseif nyble=="3" then
			binstr=binstr.."0011"
		elseif nyble=="4" then
			binstr=binstr.."0100"
		elseif nyble=="5" then
			binstr=binstr.."0101"
		elseif nyble=="6" then
			binstr=binstr.."0110"
		elseif nyble=="7" then
			binstr=binstr.."0111"
		elseif nyble=="8" then
			binstr=binstr.."1000"
		elseif nyble=="9" then
			binstr=binstr.."1001"
		elseif nyble=="a" then
			binstr=binstr.."1010"
		elseif nyble=="b" then
			binstr=binstr.."1011"
		elseif nyble=="c" then
			binstr=binstr.."1100"
		elseif nyble=="d" then
			binstr=binstr.."1101"
		elseif nyble=="e" then
			binstr=binstr.."1110"
		elseif nyble=="f" then
			binstr=binstr.."1111"
		else
			assert(1==0,nyble.." is not a hex digit!")
		end
	end
	
	return binstr

end

function str_bin2hex(binstr)

	assert(sub(binstr,1,2)=="0b","binstr is not a binary string! binary strings must start with '0b'!")
	assert((#binstr-2)%4==0,"the number of bits in binstr must be a multiple of 4!")

	local hexstr="0x"
	
	for i=3,#binstr,4 do
		
		local nyble=sub(binstr,i,i+3)
		assert(#nyble==4,"nyble must have 4 binary digits!")
		
		if nyble=="0000" then
			hexstr=hexstr.."0"
		elseif nyble=="0001" then
			hexstr=hexstr.."1"
		elseif nyble=="0010" then
			hexstr=hexstr.."2"
		elseif nyble=="0011" then
			hexstr=hexstr.."3"
		elseif nyble=="0100" then
			hexstr=hexstr.."4"
		elseif nyble=="0101" then
			hexstr=hexstr.."5"
		elseif nyble=="0110" then
			hexstr=hexstr.."6"
		elseif nyble=="0111" then
			hexstr=hexstr.."7"
		elseif nyble=="1000" then
			hexstr=hexstr.."8"
		elseif nyble=="1001" then
			hexstr=hexstr.."9"
		elseif nyble=="1010" then
			hexstr=hexstr.."a"
		elseif nyble=="1011" then
			hexstr=hexstr.."b"
		elseif nyble=="1100" then
			hexstr=hexstr.."c"
		elseif nyble=="1101" then
			hexstr=hexstr.."d"
		elseif nyble=="1110" then
			hexstr=hexstr.."e"
		elseif nyble=="1111" then
			hexstr=hexstr.."f"
		else
			assert(1==0,nyble.." is not equivalent to any hex digit!")
		end
		
	end
	
	return hexstr

end

function note_file2mem(filebits)

	--filebits is a string
	--starting with "0b" followed
	--by twenty characters, all
	--ones or zeros
	
	assert(sub(filebits,1,2)=="0b","filebits is not a binary string! binary strings must start with '0b'!")
	assert(#filebits==20+2,"filebits is not the correct length! must be 20 binary digits with a leading '0b'!")

	local membits="0b"
	
	--cust./reg. inst. (1 bit)
	membits=membits..sub(filebits,9+2,9+2) --9th bit, add two because of leading '0b'
	
	--effect (3 bits)
	membits=membits..sub(filebits,18+2,20+2) --bits 18-20 from filebits
	
	--volume (3 bits)
	membits=membits..sub(filebits,14+2,16+2) --bits 14-16 from filebits
	
	--waveform (3 bits)
	membits=membits..sub(filebits,10+2,12+2) --bits 10-12 from filebits
	
	--pitch (6 bits)
	membits=membits..sub(filebits,3+2,8+2) --bits 3-8 from filebits
	
	--finish by swapping upper and
	--lower bytes of membits
	membits=sub(membits,1,2)..sub(membits,11,18)..sub(membits,3,10)
	
	assert(sub(membits,1,2)=="0b","membits is not a binary string! binary strings must start with '0b'!")
	assert(#membits==16+2,"membits is not the correct length! must be 16 binary digits with a leading '0b'!")
	
	return membits

end

function sfx_file2mem(filebytes)
	
	assert(sub(filebytes,1,2)=="0x","hex strings must lead with '0x'!")
	
	local membytes="0x"
	local config_info=sub(filebytes,3,10)
	
	for i=11,#filebytes,5 do
		local note_filebytes="0x"..sub(filebytes,i,i+4)
		local note_filebits=str_hex2bin(note_filebytes)
		
		local note_membits=note_file2mem(note_filebits)
		local note_membytes=str_bin2hex(note_membits)
		
		membytes=membytes..sub(note_membytes,3)
	end
	
	membytes=membytes..config_info
	
	return membytes
	
end

function music_file2mem(filebytes)
	
	assert(sub(filebytes,1,2)=="0x","hex strings must lead with '0x'!")
	
	local membytes="0x"..sub(filebytes,3+2)
	local membits=str_hex2bin(membytes)
	
	local flagsbytes="0x"..sub(filebytes,2+2,2+2)
	local flagsbits=str_hex2bin(flagsbytes)
	
	printh(flagsbits)
	
	if sub(flagsbits,-1,-1)=="1" then
		printh("flag 0")
		membits=sub(membits,1,2).."1"..sub(membits,4)
	end
	
	if sub(flagsbits,-2,-2)=="1" then
		printh("flag 1")
		membits=sub(membits,1,10).."1"..sub(membits,12)
	end
	
	if sub(flagsbits,-3,-3)=="1" then
		printh("flag 2")
		membits=sub(membits,1,18).."1"..sub(membits,20)
	end
	
	printh("\n")
	
	membytes=str_bin2hex(membits)
	
	return membytes
	
end

function memset_hexstr(addr,data)
	data=sub(data,3)
	for i=1,#data,2 do
		poke(addr,"0x"..sub(data,i,i+1))
		addr+=1
	end
end

function load_song(data)
	print("load song")
	loadsfxdata(data.sfxdata)
	loadpatterns(data.patterns)
end

function load_and_play(data)
	print("load and play")
	load_song(data)
	music(data.start)
	plr_playing=true
	now_playing_song=data.name
	now_playing_artist=data.artist
end

function loadsfxdata(sfxdata)
	--load the sfx data
	for i=1,#sfxdata do
		local membytes=sfx_file2mem(sfxdata[i].bytes)
		local address=sfxaddr(sfxdata[i].sfxid)
		memset_hexstr(address,membytes)
	end
end

function loadpatterns(patterns)
	--load the pattern data	
	for i=1,#patterns do
		local membytes=music_file2mem(patterns[i].bytes)
		local address=musicaddr(patterns[i].patid)
		memset_hexstr(address,membytes)
	end
end

-->8
--tab 6: gfx mem util

function gfxaddr(sx,sy)
	--make sure sx and sy are valid
	assert(sx>=1,"sx is too small")
	assert(sy>=1,"sy is too small")
	assert(sx<=128,"sx is too large")
	assert(sy<=128,"sy is too large")
	--get the sprite x and y
	local spr_x=(sx/8)-(sx%8)
	local spr_y=(sy/8)-(sy%8)
	--make sure they are ints
	assert(spr_x%1==0)
	assert(spr_y%1==0)
	--get the sprite id num from
	--the sprite x and y
	local spr_num=spr_x+(16*spr_y)
	--make sure it's an int
	assert(spr_num%1==0)
	local gfx_addr=gfxaddr(spr_num)
	--get
end

function gfxaddr(spr_num)
	assert(spr_num>=0,"spr_num is too small")
	assert(spr_num<=255,"spr_num is too large")
	return 512 * (spr_num/16) + 4 * (spr_num%16)
end

function load_art(data)
	assert(plr_art_sx%8==0)
	assert(plr_art_sy%8==0)
	local spr_start_id=(plr_art_sx/8)+(16*(plr_art_sy/8))
	assert(spr_start_id==8)
	local gfx_addr=gfxaddr(spr_start_id)
	--this is a shit bandaid
	--solution. fix gfxaddr() and
	--get rid of this
	gfx_addr-=(64*4)

	for row=1,#data.art do
		local filebytes=data.art[row]
		local membytes=gfx_file2mem(filebytes)
		memset_hexstr(gfx_addr,membytes)
		gfx_addr+=64
	end
end

function gfx_file2mem(filebytes)
	
	assert(sub(filebytes,1,2)=="0x","hex strings must lead with '0x'!")
	
	local membytes="0x"
	
	--swap the nybbles of each
	--byte, starting from index 3,
	--so we don't include a
	--swapped "0x"
	for i=3,#filebytes,2 do
		local filebyte=sub(filebytes,i,i+1)
		local membyte=nil
		--if the nybbles are different
		--then they need to be swapped
		if sub(filebyte,1,1)!=sub(filebyte,2,2) then
			membyte=swap_nybbles(filebyte)
			assert(membyte!=filebyte,"the nybbles did not swap."..filebyte.."=="..membyte)
		else
			membyte=filebyte
		end
		membytes=membytes..membyte
	end
	
	return membytes
end

function swap_nybbles(filebyte)
	return sub(filebyte,2,2)..sub(filebyte,1,1)
end
__gfx__
76000076070000070005556055555055111111111111111111111111111111116666666666666666666666666666666666666666666666666666666666666666
77760076077700070005555650550005188111118811888888118811111111116666666666666666666666666666666666666666666666666666666666666666
77777676077777070005560050500005188111118811888888118811111111116666666666666666666666666666666666666666666666666666666666666666
77777776077777770005560050000005188111118818811118818811111111116666666666666666666666666666666666666666666666666666666666666666
77777776077777770555560050000005188111118818811118818811111111116666666666666666666666666666666666666666666666666666666666666666
77777676077777075555560050000505118811188118811118818811111111116666666666666666666666666666666666666666666666666666666666666666
77760076077700075555560050005505118811188118811118818811111111116666666666666666666666666666666666666666666666666666666666666666
76000076070000070555600055055555118811188118811118818811111111116666666666666666666666666666666666666666666666666666666666666666
76000076070000070000555088888088118811188118811118818811111111116666666666666666666666666666666666666666666666666666666666666666
76007776070007770000555580880008111881881118811118818811111111116666666666666666666666666666666666666666666666666666666666666666
76777776070777770000550080800008111881881118811118818811111111116666666666666666666666666666666666666666666666666666666666666666
77777776077777770000550080000008111881881118811118818811111111116666666666666666666666666666666666666666666666666666666666666666
77777776077777770055550080000008111881881118811118818811111111116666666666666666666666666666666666666666666666666666666666666666
76777776070777770555550080000808111188811111888888118888888118816666666666666666666666666666666666666666666666666666666666666666
76007776070007770555550080008808111188811111888888118888888118816666666666666666666666666666666666666666666666666666666666666666
76000076070000070055500088088888111111111111111111111111111111116666666666666666666666666666666666666666666666666666666666666666
00777600000777000000055588888088111111111111111111111111111111116666666666666666666666666666666666666666666666666666666666666666
07777760007777705500005580880008111881111118811111111144441111116666666666666666666666666666666666666666666666666666666666666666
77070776077070770050050580800008111888111188811111114499994411116666666666666666666666666666666666666666666666666666666666666666
77070776077070770005500080088008111188111188111111149994499941116666666666666666666666666666666666666666666666666666666666666666
77070776077070770005500080088008111188811888111111149444444941116666666666666666666666666666666666666666666666666666666666666666
77070776077070770050050580000808111118888881111111666444444666116666666666666666666666666666666666666666666666666666666666666666
077777600077777055000055800088081111118888111111118882ffff2888116666666666666666666666666666666666666666666666666666666666666666
007776000007770000000555880888881111118888111111116662ffff2666116666666666666666666666666666666666666666666666666666666666666666
00777600000777000000088800000000111111888811111111495555555594116666666666666666666666666666666666666666666666666666666666666666
07077760007077708800008800000000111111888811111111495444444594116666666666666666666666666666666666666666666666666666666666666666
77007776077007770080080800000000111118888881111111495444444594116666666666666666666666666666666666666666666666666666666666666666
77000776077000770008800000000000111188811888111111495444444594116666666666666666666666666666666666666666666666666666666666666666
77000776077000770008800000000000111188111188111111445444444544116666666666666666666666666666666666666666666666666666666666666666
77007776077007770080080800000000111888111188811111445555555544116666666666666666666666666666666666666666666666666666666666666666
07077760007077708800008800000000111881111118811111441111111144116666666666666666666666666666666666666666666666666666666666666666
00777600000777000000088800000000111111111111111111111111111111116666666666666666666666666666666666666666666666666666666666666666
11111111111111111111111111111111111111111111111111111111111111116666666666666666666666666666666666666666666666666666666666666666
11111111881881111881881111881888888881888888111118888111881118816666666666666666666666666666666666666666666666666666666666666666
11111111881881111881881118881888888881888888811188888811881118816666666666666666666666666666666666666666666666666666666666666666
11111111881881111881881188811881111111881118811188118811888188816666666666666666666666666666666666666666666666666666666666666666
11111111881881111881881888111881111111881118811888118881188188116666666666666666666666666666666666666666666666666666666666666666
11111111881881111881888881111881111111881118811881111881188888116666666666666666666666666666666666666666666666666666666666666666
11111111881881111881888811111888888111888888811881111881118881116666666666666666666666666666666666666666666666666666666666666666
11111111881881111881888111111888888111888888111881111881118881116666666666666666666666666666666666666666666666666666666666666666
11111111881881111881888811111881111111888888811881111881118881116666666666666666666666666666666666666666666666666666666666666666
11111111881881111881888881111881111111881118881881111881118881116666666666666666666666666666666666666666666666666666666666666666
11111111881881111881881881111881111111881111881881111881188888116666666666666666666666666666666666666666666666666666666666666666
11111111881888118881881888111881111111881111881888118881188188116666666666666666666666666666666666666666666666666666666666666666
18811111881188118811881188811881111111881118881188118811888188816666666666666666666666666666666666666666666666666666666666666666
18881118881188888811881118881888888881888888811188888811881118816666666666666666666666666666666666666666666666666666666666666666
11888888811118888111881111881888888881888888111118888111881118816666666666666666666666666666666666666666666666666666666666666666
11188888111111111111111111111111111111111111111111111111111111116666666666666666666666666666666666666666666666666666666666666666
11111111111111111111111111111111111111111111111111111111111111116666666666666666666666666666666666666666666666666666666666666666
18811111881188888811881111111111111881111118811111111144441111116666666666666666666666666666666666666666666666666666666666666666
18811111881188888811881111111111111888111188811111114499994411116666666666666666666666666666666666666666666666666666666666666666
18811111881881111881881111111111111188111188111111149994499941116666666666666666666666666666666666666666666666666666666666666666
18811111881881111881881111111111111188811888111111149444444941116666666666666666666666666666666666666666666666666666666666666666
11881118811881111881881111111111111118888881111111666444444666116666666666666666666666666666666666666666666666666666666666666666
118811188118811118818811111111111111118888111111118882ffff2888116666666666666666666666666666666666666666666666666666666666666666
118811188118811118818811111111111111118888111111116662ffff2666116666666666666666666666666666666666666666666666666666666666666666
11881118811881111881881111111111111111888811111111495555555594116666666666666666666666666666666666666666666666666666666666666666
11188188111881111881881111111111111111888811111111495444444594116666666666666666666666666666666666666666666666666666666666666666
11188188111881111881881111111111111118888881111111495444444594116666666666666666666666666666666666666666666666666666666666666666
11188188111881111881881111111111111188811888111111495444444594116666666666666666666666666666666666666666666666666666666666666666
11188188111881111881881111111111111188111188111111445444444544116666666666666666666666666666666666666666666666666666666666666666
11118881111188888811888888811881111888111188811111445555555544116666666666666666666666666666666666666666666666666666666666666666
11118881111188888811888888811881111881111118811111441111111144116666666666666666666666666666666666666666666666666666666666666666
11111111111111111111111111111111111111111111111111111111111111116666666666666666666666666666666666666666666666666666666666666666
