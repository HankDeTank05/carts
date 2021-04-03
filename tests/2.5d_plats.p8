pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function _init()
	init_ground()
end

function _update60()
	update_ground()
end

function _draw()
	cls()
	draw_ground()
	
	show_stats()
end

function show_stats()
	print("mem: "..stat(0).." kb",0,0,7)
	print("cpu: "..flr(stat(1)*100).."%",0,6,7)
end
-->8
--tab 1: ground

depth=0.8
spawn_threshold=96
bg_color=5
platform_color=6
fg_color=13

function init_ground()
	ground={}
	create_platform()
end

function update_ground()
	for plat in all(ground) do
		plat.fg_x-=1
		plat.bg_x=depth*(plat.fg_x-64)+64
		
		if plat.bg_x+plat.bg_w<0 then
			del(ground,plat)
		end
	end
	
	//spawn new platform
	local last=ground[#ground]
	if last.bg_x+last.bg_w<spawn_threshold then
		create_platform()
	end
	
end

function draw_ground()
	for plat in all(ground) do
		//draw background
		rectfill(plat.bg_x,plat.bg_h,plat.bg_x+plat.bg_w,127,bg_color)
		
		//draw lines connecting the
		//background and foreground
		for fg_x_pos=plat.fg_x,plat.fg_x+plat.fg_w do
			local bg_x_pos=depth*(fg_x_pos-64)+64
			local x1=fg_x_pos
			local y1=plat.fg_h+1
			local x2=bg_x_pos
			local y2=plat.bg_h
			line(fg_x_pos,plat.fg_h,bg_x_pos,plat.bg_h,platform_color)
			
			//local mx,my=midpoint(x1,y1,x2,y2)
			//pset(mx,my,1)
		
		end
		
		//draw foreground
		rectfill(plat.fg_x,plat.fg_h,plat.fg_x+plat.fg_w,127,fg_color)
	end
end

function create_platform()
	plat={}
	
	plat.bg_x=128
	plat.fg_x=(1/0.8)*plat.bg_x
	
	plat.fg_h=flr(rnd(64))+48
	plat.fg_w=flr(rnd(32))+32
	
	
	plat.bg_h=depth*(plat.fg_h-48)+48
	plat.bg_w=depth*plat.fg_w
	
	add(ground,plat)
end
-->8
--tab 2: utilities

function distance(x1,y1,x2,y2)
	return sqrt((x2-x1)^2 + (y2-y1)^2)
end

function midpoint(x1,y1,x2,y2)
	return (x1+x2)/2,(y1+y2)/2
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
