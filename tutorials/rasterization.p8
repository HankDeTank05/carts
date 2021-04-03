pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--rasterization

function _init()
	world_l=-500
	world_r=500
	
	world_t=-500
	world_b=500
	
	world_n=500
	world_f=-500
	
	world_w=1000
	world_h=1000
	world_d=1000
	
	init_rasterization()
	init_trilist()
	create_tri()
end

function _update60()
	update_trilist()
end

function _draw()
	cls()
	draw_trilist()
	print("v0.x="..trilist[1].v0.x..",y="..trilist[1].v0.y,0,0,7)
	print("v1.x="..trilist[1].v1.x..",y="..trilist[1].v1.y,0,6,7)
	print("v2.x="..trilist[1].v2.x..",y="..trilist[1].v2.y,0,12,7)
end
-->8
--tab 1: rasterization util

function init_rasterization()
	// initialize a black
	// framebuffer
	fbuffer={}
	
	// initialize a distant
	// z-buffer
	zbuffer={}
	
	for x=1,128 do
		for y=1,128 do
			fbuffer[(y-1)*127+x]=0
			zbuffer=world_d
		end
	end
	
	// the distance from the
	// camera to the near clipping
	// plane
	znear=1
	
	// the distance from the
	// camera to the far clipping
	// plane
	zfar=1000
	
	// the camera position and
	// look-direction in
	// worldspace
	cam={
		pos={
			x=0,
			y=0,
			z=500
		},
		dir={
			x=0,
			y=0,
			z=1
		}
	}
	
	fov=0.66
end
-->8
--tab 2: triangle

function init_trilist()
	trilist={}
end

function create_tri()
	tri={
		v0={x=-250,y=250,z=0},
		v1={x=-250,y=-250,z=0},
		v2={x=250,y=0,z=0},
		col=1
	}
	add(trilist,tri)
end

function create_empty_tri()
	tri={
		v0={x=-1,y=-1},
		v1={x=-1,y=-1},
		v2={x=-1,y=-1},
		col=7
	}
	return tri
end

function update_trilist()

	for tri in all(trilist) do
		//convert world coords to
		//raster space
		local bbmin={x=128,y=128}
		local bbmax={x=-1,y=-1}
		
		local ptri=get_ptri(tri)
		
		//determine bbmin.x
		if ptri.v0.x<bbmin.x then
			bbmin.x=ptri.v0.x
		end
		if ptri.v1.x<bbmin.x then
			bbmin.x=ptri.v1.x
		end
		if ptri.v2.x<bbmin.x then
			bbmin.x=ptri.v2.x
		end
		
		//determine bbmin.y
		if ptri.v0.y<bbmin.y then
			bbmin.y=ptri.v0.y
		end
		if ptri.v1.y<bbmin.y then
			bbmin.y=ptri.v1.y
		end
		if ptri.v2.y<bbmin.y then
			bbmin.y=ptri.v2.y
		end
		
		//determine bbmax.x
		if ptri.v0.x>bbmax.x then
			bbmax.x=ptri.v0.x
		end
		if ptri.v1.x>bbmax.x then
			bbmax.x=ptri.v1.x
		end
		if ptri.v2.x>bbmax.x then
			bbmax.x=ptri.v2.x
		end
		
		//determine bbmax.y
		if ptri.v0.y>bbmax.y then
			bbmax.y=ptri.v0.y
		end
		if ptri.v1.y>bbmax.y then
			bbmax.y=ptri.v1.y
		end
		if ptri.v2.y>bbmax.y then
			bbmax.y=ptri.v2.y
		end
		
		bbmin.x=flr(bbmin.x)
		bbmin.y=flr(bbmin.y)
		
		bbmax.x=ceil(bbmax.x)
		bbmax.y=ceil(bbmax.y)

		--[[//clamp bbmin.x		
		if bbmin.x<0 then
			bbmin.x=0
		elseif bbmin.x>127 then
			bbmin.x=127
		end
		
		//clamp bbmin.y
		if bbmin.y<0 then
			bbmin.y=0
		elseif bbmin.y>127 then
			bbmin.y=127
		end
		
		//clamp bbmax.x
		if bbmax.x<0 then
			bbmax.x=0
		elseif bbmax.x>127 then
			bbmax.x=127
		end
		
		//clamp bbmax.y
		if bbmax.y<0 then
			bbmax.y=0
		elseif bbmax.y>127 then
			bbmax.y=127
		end--]]
		
		for px=bbmin.x,bbmax.x do
			for py=bbmin.y,bbmax.y do
				
				if pix_in_2d_tri(ptri,px,py) then
					fbuffer[(py-1)*127+px]=tri.col
				end
				
			end
		end
		
	end
end

function draw_trilist()
	for px=1,128 do
		for py=1,128 do
			pset(px,py,fbuffer[(py-1)*127+px])
		end
	end
end

function get_ptri(tri)
	// perspective projection
	ptri=create_empty_tri()
	
	// convert from worldspace to
	// ndc space
	ptri.v0.x=((tri.v0.x+(world_w/2))/world_w)
	ptri.v0.y=((tri.v0.y+(world_h/2))/world_h)
	
	ptri.v1.x=((tri.v1.x+(world_w/2))/world_w)
	ptri.v1.y=((tri.v1.y+(world_h/2))/world_h)
	
	ptri.v2.x=((tri.v2.x+(world_w/2))/world_w)
	ptri.v2.y=((tri.v2.y+(world_h/2))/world_h)
	
	// convert from ndc space to
	// raster-space
	ptri.v0.x*=127
	ptri.v0.y*=127
	
	ptri.v1.x*=127
	ptri.v1.y*=127
	
	ptri.v2.x*=127
	ptri.v2.y*=127
	
	// perspective-divide the
	// raster-space coordinates
	assert(cam.pos.z!=0)
	ptri.v0.x=(znear*cam.pos.x)/-cam.pos.z
	ptri.v0.y=(znear*cam.pos.y)/-cam.pos.z
	
	ptri.v1.x=(znear*cam.pos.x)/-cam.pos.z
	ptri.v1.y=(znear*cam.pos.y)/-cam.pos.z
	
	ptri.v2.x=(znear*cam.pos.x)/-cam.pos.z
	ptri.v2.y=(znear*cam.pos.y)/-cam.pos.z
	
	return ptri
end

function pix_in_2d_tri(tri,px,py)
	//determine if the pixel
	//at (px,py) is inside the
	//2d triangle "tri"
	
	local isin=true
	
	//return a boolean value
	return isin
end
-->8
--tab 3: camera

function init_camera()
	--[[cam={
		focal_length=
		aperture_x=
		aperture_y=
		near_cplane=
		far_cplane=
		screen_size_x=
		screen_size_y=
	}--]]
end

function update_camera()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
