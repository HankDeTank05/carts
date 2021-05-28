pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--viz: math

function _init()
	options={
	"matrix * vector",
	"vector * matrix",
	"matrix * matrix"}
	
	cur=1
	
	_update60=menu_update
	_draw=menu_draw
end
-->8
--menu methods

function menu_init()
	options={
	"matrix * vector",
	"vector * matrix",
	"matrix * matrix"}
	
	cur=1
	
	_update60=menu_update
	_draw=menu_draw
end

function menu_update()

	if btnp(⬆️) then
		cur-=1
		if cur<=0 then
			cur=#options
		end
	elseif btnp(⬇️) then
		cur+=1
		if cur>#options then
			cur=1
		end
	end
	
	if btnp(❎) then
		if cur==1 then
			_init=setup_mv
			_update60=mv_update
			_draw=mv_draw
			
			_init()
		elseif cur==2 then
			_init=setup_vm
			_update60=vm_update
			_draw=vm_draw
			
			_init()
		elseif cur==3 then
			_init=setup_mm
			_update60=mm_update
			_draw=mm_draw
			
			_init()
		end
	end
	
end

function menu_draw()
	
	cls()
	
	print(">",0,6*cur,11)
	
	for i=1,#options do
		print(options[i],5,6*i,11)
	end
	
end
-->8

function setup_mv()
	finished=false
end

function mv_update()
	if finished then
		_init=menu_init
		_update60=menu_update
		_draw=menu_dra
		
		_init()
	end
end

function mv_draw()
	cls()
	
	print("mv_draw",0,0,11)
end
-->8

function setup_vm()
	finished=false
end

function vm_update()
	if finished then
		_init=menu_init
		_update60=menu_update
		_draw=menu_dra
		
		_init()
	end
end

function vm_draw()
	cls()
	
	print("vm_draw",0,0,11)
end
-->8

function setup_mm()
	finished=false
	
	seconds=1
	frame_count=0
	element_num=0
	obj_num_i=1
	curr_row=0
	curr_col=0
	
	opsi=1
	ops_show={false,
											false,
											false,
						     false,
						     false,
						     false,
						     false}
	ops={"*","+","*","+","*","+","*"}
	ops_locs={{x=13*1.7,y=6*6-1},
	          {x=13*2.7,y=6*6-1},
	          {x=13*3.7,y=6*6-1},
	          {x=13*4.7,y=6*6-1},
	          {x=13*5.7,y=6*6-1},
	          {x=13*6.7,y=6*6-1},
	          {x=13*7.7,y=6*6-1}}
	
	--[[objects={-1,--a
	         -1,--b
	         -1,--a
	         -1,--b
	         -1,--a
	         -1,--b
	         -1,--a
	         -1}--b--]]
	         
	objects=get_objs(element_num)
	
	--[[locations={{x=-1,y=-1},
	           {x=-1,y=-1},
	           {x=-1,y=-1},
	           {x=-1,y=-1},
	           {x=-1,y=-1},
	           {x=-1,y=-1},
	           {x=-1,y=-1},
	           {x=-1,y=-1}}--]]
	locations=reset_locations()
 
	dest1={{x=13*1,y=6*6},
	       {x=13*2,y=6*6},
	       {x=13*3,y=6*6},
	       {x=13*4,y=6*6},
	       {x=13*5,y=6*6},
	       {x=13*6,y=6*6},
	       {x=13*7,y=6*6},
	       {x=13*8,y=6*6}}
	       
	 dest2={{x=13*1+6,y=6*7},
	        {x=13*3+6,y=6*7},
	        {x=13*5+6,y=6*7},
	        {x=13*7+6,y=6*7}}
	        
	 dest3={{x=13*2.5,y=6*8},
	        {x=13*6.5,y=6*8}}
	        
	 dest4={}
	
	a={
	
	{x=12*1,y=6*1},
	{x=12*2,y=6*1},
	{x=12*3,y=6*1},
	{x=12*4,y=6*1},
	
	{x=12*1,y=6*2},
	{x=12*2,y=6*2},
	{x=12*3,y=6*2},
	{x=12*4,y=6*2},
	
	{x=12*1,y=6*3},
	{x=12*2,y=6*3},
	{x=12*3,y=6*3},
	{x=12*4,y=6*3},
	
	{x=12*1,y=6*4},
	{x=12*2,y=6*4},
	{x=12*3,y=6*4},
	{x=12*4,y=6*4}
	
	}
	
	b={
	
	{x=12*6,y=6*1},
	{x=12*7,y=6*1},
	{x=12*8,y=6*1},
	{x=12*9,y=6*1},
	
	{x=12*6,y=6*2},
	{x=12*7,y=6*2},
	{x=12*8,y=6*2},
	{x=12*9,y=6*2},
	
	{x=12*6,y=6*3},
	{x=12*7,y=6*3},
	{x=12*8,y=6*3},
	{x=12*9,y=6*3},
	
	{x=12*6,y=6*4},
	{x=12*7,y=6*4},
	{x=12*8,y=6*4},
	{x=12*9,y=6*4}
	
	}
	
	c={
	
	nil,nil,nil,nil,
	nil,nil,nil,nil,
	nil,nil,nil,nil,
	nil,nil,nil,nil
	
	}
	
	phase_1_cutoff=#objects*seconds*60
	phase_2_cutoff=phase_1_cutoff*1.5
	
end

function mm_update()
	frame_count+=1
	
	if frame_count%(seconds*60)==0 then
		ops_show[opsi]=true
		opsi+=1
		if frame_count<=phase_1_cutoff then
			obj_num_i+=1
		elseif frame_count<=phase_2_cutoff then
			obj_num_i+=2
		end
		
		if obj_num_i>8 then
			obj_num_i=1
		end
	
	elseif frame_count<=phase_1_cutoff then
		// move to row 1
		if obj_num_i%2==1 then
			lx,ly=lerp(a[objects[obj_num_i]+1].x,a[objects[obj_num_i]+1].y,dest1[obj_num_i].x,dest1[obj_num_i].y,(frame_count-(seconds*(obj_num_i-1)*60))/(seconds*60))
		
		else			
			lx,ly=lerp(b[objects[obj_num_i]+1].x,b[objects[obj_num_i]+1].y,dest1[obj_num_i].x,dest1[obj_num_i].y,(frame_count-(seconds*(obj_num_i-1)*60))/(seconds*60))
			
		end
		--lx,ly=lerp(a[ttd+1].x,a[ttd+1].y,xend,yend,frame_count/(seconds*60))
		
		locations[obj_num_i].x=lx
		locations[obj_num_i].y=ly
	elseif frame_count<=#objects*1.5*seconds*60 then
		// move to row 2
		lx1,ly1=lerp(dest1[obj_num_i].x,dest1[obj_num_i].y,dest2[flr(obj_num_i/2)+1].x,dest2[flr(obj_num_i/2)+1].y,(frame_count-(seconds*(obj_num_i-1)*60))/(seconds*60))
		locations[obj_num_i].x=lx1
		locations[obj_num_i].y=ly1
		
		--[[lx2,ly2=lerp(dest1[obj_num_i+1].x,dest1[obj_num_i+1].y,dest1[obj_num_i].x,dest1[obj_num_i].y,(frame_count-(seconds*(obj_num_i-1)*60))/(seconds*60))
		locations[obj_num_i].x=lx2
		locations[obj_num_i].y=ly2--]]
	elseif frame_count<=#objects*1.75*seconds*60 then
		// move to row 3
	elseif frame_count<=#objects*1.875*seconds*60 then
		// move to product matrix
	elseif frame_count<=#objects*2*seconds*60 then
		// reset everything for the next element
		frame_count=0
		element_num+=1
		curr_col+=1
		obj_num_i=1
		ops1=""
		if curr_col>=4 then
			curr_col=0
			curr_row+=1
		end
		if element_num>15 then
			finished=true
		else
			objects=get_objs(element_num)
			locations=reset_locations()
		end
	
	else		
	end
	
	if finished then
		_init=menu_init
		_update60=menu_update
		_draw=menu_dra
		
		_init()
	end
end

function mm_draw()
	cls()
	
	--[[for i=1,8 do
		draw_numbox(dest1[i].x,dest1[i].y)
	end--]]
	
	for i=1,4 do
		draw_numbox(dest2[i].x,dest2[i].y)
	end
	
	for i=1,2 do
		draw_numbox(dest3[i].x,dest3[i].y)
	end
	
	for i=1,7 do
		if ops_show[i] then
			print(ops[i],ops_locs[i].x,ops_locs[i].y,7)
		end
	end
	
	--[[draw_opbox(12*1.5,6*6)
	draw_opbox(12*2.5,6*6)--carry down
	draw_opbox(12*3.5,6*6)
	draw_opbox(12*4.5,6*6)--carry down
	draw_opbox(12*5.5,6*6)
	draw_opbox(12*6.5,6*6)--carry down
	draw_opbox(12*7.5,6*6)--]]
	
	draw_opbox(12*2.5,6*7)
	draw_opbox(12*4.5,6*7)--carry down
	draw_opbox(12*6.5,6*7)
	
	draw_opbox(12*4.5,6*8)
	
	--[[for i=1,8 do
		draw_numbox(dest4[i].x,dest4[i].y)
	end--]]
	
	--x=14*1,y=6*6
	//print(ops1,12*1-1,6*6-1,7)
	//print(ops2,12*1-1,6*7-1,7)
	//print(ops3,12*1-1,6*8-1,7)
	
	print("a=",12*0,15,1)
	draw_left_bracket(12*1-2,6*1-2,1)
	for am=0,#a-1 do
		if curr_row*4<=am and am<curr_row*4+4 then
			col=12
		else
			col=1
		end
		--draw_numbox(a[am+1].x,a[am+1].y)
		print(am,a[am+1].x,a[am+1].y,col)
	end
	draw_right_bracket(12*5-4,6*1-2,1)
	
	print("b=",12*5,15,2)
	draw_left_bracket(12*6-2,6*1-2,2)
	for bm=0,#b-1 do
		if bm%4==curr_col then
			col=8
		else
			col=2
		end
		print(bm,b[bm+1].x,b[bm+1].y,col)
	end
	draw_right_bracket(12*10-4,6*1-2,2)
	
	if frame_count<#objects*2*seconds*60 then
		for i=1,8 do
			if i%2==0 then
				col=8
			else
				col=12
			end
			
			print(objects[i],locations[i].x,locations[i].y,col)
		end
		--print(0,lx,ly,12)
	end
	
	print("seconds="..seconds,0,6*13,11)
	print("frame_count="..frame_count,0,6*14,11)
	print("element_num="..element_num,0,6*15,11)
	print("obj_num_i="..obj_num_i,0,6*16,11)
	print("curr_row="..curr_row,0,6*17,11)
	print("curr_col="..curr_col,0,6*18,11)
	print("phase_1_cutoff="..phase_1_cutoff,0,6*19,11)
	print("phase_2_cutoff="..phase_2_cutoff,0,6*20,11)
	
	--print("mm_draw",0,0,11)
end
-->8
--util

function draw_left_bracket(x,y,col)
	line(x,y,x,y+26,col)
	pset(x+1,y,col)
	pset(x+1,y+26,col)
end

function draw_right_bracket(x,y,col)
	line(x,y,x,y+26,col)
	pset(x-1,y,col)
	pset(x-1,y+26,col)
end

function lerp(x1,y1,x2,y2,t)
	return x1+(x2-x1)*t, y1+(y2-y1)*t
end

function get_objs(element)
	assert(element>=0)
	assert(element<=15)
		
	if element==0 then
		objs={0,0,1,4,2,8,3,12}
		
	elseif element==1 then
		objs={0,1,1,5,2,9,3,13}
		
	elseif element==2 then
		objs={0,2,1,6,2,10,3,14}
		
	elseif element==3 then
		objs={0,3,1,7,2,11,3,15}
		
	elseif element==4 then
		objs={4,0,5,4,6,8,7,12}
		
	elseif element==5 then
		objs={4,1,5,5,6,9,7,13}
		
	elseif element==6 then
		objs={4,2,5,6,6,10,7,14}
		
	elseif element==7 then
		objs={4,3,5,7,6,11,7,15}
		
	elseif element==8 then
		objs={8,0,9,4,10,8,11,12}
		
	elseif element==9 then
		objs={8,1,9,5,10,9,11,13}
		
	elseif element==10 then
		objs={8,2,9,6,10,10,11,14}
		
	elseif element==11 then
		objs={8,3,9,7,10,11,11,15}
		
	elseif element==12 then
		objs={12,0,13,4,14,8,15,12}
		
	elseif element==13 then
		objs={12,1,13,5,14,9,15,13}
		
	elseif element==14 then
		objs={12,2,13,6,14,10,15,14}
		
	elseif element==15 then
		objs={12,3,13,7,14,11,15,15}
		
	end
	
	return objs
end

function reset_locations()
	locs={{x=-12,y=-12},
	      {x=-12,y=-12},
	      {x=-12,y=-12},
	      {x=-12,y=-12},
	      {x=-12,y=-12},
	      {x=-12,y=-12},
	      {x=-12,y=-12},
	      {x=-12,y=-12}}
	
	return locs
end

function draw_numbox(x,y)
	rect(x-1,y-1,x+11,y+4,11)
end

function draw_opbox(x,y)
	rect(x-1,y-1,x+4,y+4,10)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
