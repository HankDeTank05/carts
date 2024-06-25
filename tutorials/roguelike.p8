pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--lazy devs roguelike tutorial

function _init()
	t=0 --frame count
	p_anim={240,241,242,243}
	
	--     0  1  2  3
	--    ⬅️ ➡️ ⬆️ ⬇️
	--     l  r  u  d tr br tl bl
	dirx={-1, 1, 0, 0, 1, 1,-1,-1}
	diry={ 0, 0,-1, 1,-1, 1,-1, 1}
	-- i = 1  2  3  4  5  6  7  8
	
	_update_state=update_game
	_draw_state=draw_game
	start_game()
end

function _update60()
	t+=1
	_update_state()
end

function _draw()
	_draw_state()
	draw_windows()
end

function start_game()
	input_buf=-1
	
	mobs={}
	addmob(0,2,3)
	
	p_x=1--player x-pos (map x)
	p_y=1--player y-pos (map y)
	p_xoff=0--x-offset, for smooth movement between map tiles
	p_yoff=0--y-offset, for smooth movement between map tiles
	p_start_xoff=0
	p_start_yoff=0
	p_flip=false
	p_move=nil--which anim should we play?
	p_t=0--animation timer
	
	windows={}
	talkbox=nil
end
-->8
--tab 1: update states

function update_game()
	if talkbox then
		if get_input()==❎ then
			talkbox.dur=0
			talkbox=nil
		end
	else
		buffer_input()
		do_input(input_buf)
		input_buf=-1
	end
end

function update_pturn()
	--what happens during the
	--player's turn
	
	buffer_input()
	
	--clamp the timer, always <=1
	p_t=min(p_t+0.125,1)
	
	p_move()
	
	--if anim is done...
	if p_t==1 then
		_update_state=update_game
	end
	
end

function update_gameover()
end

function move_walk()
	--player moves smoothly from
	--one tile to the next
	p_xoff=p_start_xoff*(1-p_t)
	p_yoff=p_start_yoff*(1-p_t)
end

function move_bump()
	--player bumps into a tile
	--and then moves back
	local tmr=p_t
	
	if p_t>0.5 then
		tmr=1-p_t
	end
	
	p_xoff=p_start_xoff*tmr
	p_yoff=p_start_yoff*tmr
end

function buffer_input()
	if input_buf==-1 then
		input_buf=get_input()
	end
end

function get_input()
	--read inputs
	for b=0,5 do
		if btnp(b) then
			return b
		end
	end
	return -1
end

function do_input(_in)
	if _in<0 then return
	elseif _in<4 then
		moveplayer(dirx[_in+1],
		           diry[_in+1])
	end
	--menu button
end
-->8
--tab 2: draw states

function draw_game()
	cls()
	map()
	
	--draw player
	drawspr(getframe(p_anim),
	        p_x*8+p_xoff,
	        p_y*8+p_yoff,
	        12,
	        p_flip)
	
	--draw mobs
	for m in all(mobs) do
		drawspr(getframe(m.anim),
		        m.x*8,
		        m.y*8,
		        12,
		        false)
	end
end

function draw_gameover()
end
-->8
--tab 3: tools

function getframe(_anim)
	--anim is an array of spr nums
	local frame_num=(flr(t/15) % #_anim) + 1
	return _anim[frame_num]
end

function drawspr(_spr,_x,_y,_c,_flip)
	--_spr:sprite num to draw
	--_x:x-pos on screen
	--_y:y-pos on screen
	--_c:color to draw spr in
	--_flip:bool, mirror horiz.?
	
	--change which colors are transparent
	palt(0,false) --in this case, 0/black is set to be not transparent
	
	--change color a into color b when rendering
	pal(6,_c) --in this case, 6/gray is being changed to the chosen color "_c"
	
	spr(_spr,--sprite num
	    _x,_y,--x,y pos on screen
	    1,1,--w,h on screen
	    _flip,false)--flip x,y
	pal() --when empty, resets the pal and palt settings to default
end

function rect2(_x,_y,_w,_h,_c)
	rect(_x,_y,
	     _x+max(_w-1,0),
	     _y+max(_h-1,0),
	     _c)
end

function rectfill2(_x,_y,_w,_h,_c)
	rectfill(_x,_y,
	         _x+max(_w-1,0),
	         _y+max(_h-1,0),
	         _c)
end

function print_oline(_t,_x,_y,_c,_c2)
	--_t:the text to print
	--_x:x-pos of top-left of txt
	--_y:y-pos of top-left of txt
	--_c:text color
	--_c2:outline color
	for i=1,8 do
		print(_t,_x+dirx[i],_y+diry[i],_c2)
	end
	print(_t,_x,_y,_c)
end
-->8
--tab 4: gameplay

function moveplayer(dx,dy)
	local dest_x=p_x+dx
	local dest_y=p_y+dy
	local tile=mget(dest_x,dest_y)
	
	--change player facing dir,
	--if necessary
	if dx<0 then
		p_flip=true
	elseif dx>0 then
		p_flip=false
	end
	
	if fget(tile,0) then
		--you've hit a wall (ouch!)
		p_start_xoff=dx*8
		p_start_yoff=dy*8
		p_xoff=0
		p_yoff=0
		p_t=0
		_update_state=update_pturn
		p_move=move_bump
		
		--if interactible...
		if fget(tile,1) then
			triggerbump(tile,dest_x,dest_y)
		end
	else
		--no wall, proceed!
		sfx(63)
		p_x+=dx
		p_y+=dy
		p_start_xoff=dx*-8
		p_start_yoff=dy*-8
		p_xoff=p_start_xoff
		p_yoff=p_start_yoff
		p_t=0
		_update_state=update_pturn
		p_move=move_walk
	end
end

function triggerbump(tile,dest_x,dest_y)
	if tile==7 or tile==8 then
		--vases
		sfx(59)
		mset(dest_x,dest_y,1)
	elseif tile==10 or tile==12 then
		--chests
		sfx(61)
		mset(dest_x,dest_y,tile-1)
	elseif tile==13 then
		--door
		sfx(62)
		mset(dest_x,dest_y,1)
	elseif tile==6 then
		--stone tablet
		if dest_x==2 and dest_y==5 then
			showmsg({"welcome to henry's",
			         "roguelike! glad you",
			         "could make it!",
			         "",
			         "let me show you the",
			         "ropes."})
		elseif dest_x==13 and dest_y==12 then
			showmsg({"getting warmer!",
			         "keep going!"})
		elseif dest_x==13 and dest_y==6 then
			showmsg({"don't fuck up, now!",
			         "you're an epic gamer"})
		end
	end
end
-->8
--tab 5: ui

function addwindow(_x,_y,_w,_h,_txt)
	local w={x=_x,
	         y=_y,
	         w=_w,
	         h=_h,
	         txt=_txt}
	add(windows,w)
	return w
end

function draw_windows()
	for w in all(windows) do
		--quick and dirty token
		--optimization so we don't
		--have to use dots!
		local wx,wy,ww,wh=w.x,w.y,w.w,w.h
		rectfill2(wx,wy,
		      ww,wh,
		      0)--black
		rect2(wx+1,wy+1,
		     ww-2,wh-2,
		     6)--lt gray
		wx+=4
		wy+=4
		clip(wx,wy,ww-8,wh-8)
		for i=1,#w.txt do
			local txt=w.txt[i]
			print(txt,wx,wy,6)--lt gray
			wy+=6
		end
		clip()
		
		if w.dur!=nil then
			w.dur-=1
			if w.dur<=0 then
				local dif=w.h/4
				w.y+=dif/2
				w.h-=dif
				if w.h<3 then
					del(windows,w)
				end
			end
		else
			if w.wait then
				print_oline("❎",
				            wx+ww-15,
				            wy-1+sin(time())/2,
				            6,0)
		end
		
		end
	end
end

function showmsg(_txt,_dur)
	local width=(#_txt+2)*4+7
	local w=addwindow(63-(width/2),50,width,13,{" ".._txt})
	w.dur=_dur
end

function showmsg(_lines)
	talkbox=addwindow(16,50,94,#_lines*6+7,_lines)
	talkbox.wait=true
end
-->8
--tab 6: mobs

function addmob(_kind,_mx,_my)
	local m={
		x=_mx,
		y=_my,
		anim={192,193,194,195},
	}
	add(mobs,m)
end
__gfx__
000000000000000060666060000000000000000000000000cccccccc00ccc00000ccc00000000000000000000000000000ccc000c0ccc0c0c000000055555550
000000000000000000000000000000000000000000000000cccccccc0c000c000c000c00066666600cccccc066666660c0ccc0c000000000c0cc000000000000
007007000000000066606660000000000000000000000000c000000c0c000c000c000c00060000600c0000c060000060c00000c0c0ccc0c0c0cc0cc055000000
00077000000000000000000000000000000000000000000000cc0c0000ccc000c0ccc0c0060000600c0cc0c060000060c00c00c000ccc00000cc0cc055055000
000770000000000060666060000000000000000000000000c000000c0c00cc00cc00ccc0066666600cccccc066666660ccc0ccc0c0ccc0c0c0000cc055055050
007007000005000000000000000000000000000000000000c0c0cc0c0ccccc000ccccc000000000000000000000000000000000000ccc000c0cc000055055050
000000000000000066606660000000000000000000000000c000000c00ccc00000ccc000066666600cccccc066666660ccccccc0c0ccc0c0c0cc0cc055055050
000000000000000000000000000000000000000000000000cccccccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666000060666000066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06066600060666000606660006666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60666660066666006066666060066666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666660066666006666666066666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666600006660000666660006666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006060000000000000060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060600066660000006060000666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666600006066600066660000060666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060666006666600006066600066666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06066666060000000006666606000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66000000660660000660000066066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66066606660660000660660066066606000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600600006600000060060000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010000000303030103010303020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020f0101020808010708020101010e0200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020101010d010101010702010202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010102010101010102010101010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010102070101010102020202010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201060102080701010101020101010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010102020202020201020106010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02020d0202020202020201020101010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020101010d010102010101020d02020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010102020101010202020101010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020101010202020d020202020101010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010102010101010101020101010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02010101020101010101010d0106010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02010a0102010c01010101020101010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010102010101010101020101010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001f5302b5302e5302e5300000000000000002751027510285102a510000000000000000275102951029510000000000000000000002451024510245102751029510000000000000000000000000000000
000100001f0301f03015030150302a23025230202101d2101b2101821016210142101321012210102100f2100e2100c2100a21009210092100721007210072100621006210062100621000000000000000000000
000100002003020030130301303032010320103401029010290102601026000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001e03024030200401f0300e0300c0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000e720147200d7100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
