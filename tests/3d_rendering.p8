pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

function _init()
	
	printh("\n\n\n")
	
	square={
	        {
	         {-1,-1,0},
	         {1,-1,0},
	         {-1,1,0},
	         c=7
	        },
	        {
	         {1,-1,0},
	         {1,1,0},
	         {-1,1,0},
	         c=7
	        }
	       }
	triangle={
	          {-0.5,-0.5,0},
	          {0.5,0.5,0},
	          {-0.5,0.5,0},
	          c=11
	         }
	map_to_screen(triangle)
end

function _update()
	--if btn(⬅️) then translate_tri(triangle,{-1,0,0}) end
	--if btn(➡️) then translate_tri(triangle,{1,0,0}) end
	--if btn(⬆️) then translate_tri(triangle,{0,-1,0}) end
	--if btn(⬇️) then translate_tri(triangle,{0,1,0}) end
	--if btn(🅾️) then scale_tri(triangle,1.1) end
	--if btn(❎) then scale_tri(triangle,1/1.1) end
	if btn(⬅️) then rot_y_tri(triangle,1) end
	if btn(➡️) then rot_y_tri(triangle,-1) end
	if btn(⬆️) then rot_x_tri(triangle,1) end
	if btn(⬇️) then rot_x_tri(traingle,-1) end
	if btn(🅾️) then rot_z_tri(triangle,1) end
	if btn(❎) then rot_z_tri(triangle,-1) end
end

function _draw()
	cls()
	--[[
	pset(triangle[1][1],triangle[1][2],11)
	pset(triangle[2][1],triangle[2][2],11)
	pset(triangle[3][1],triangle[3][2],11)
	--]]
	
	line(triangle[1][1],triangle[1][2],triangle[2][1],triangle[2][2],11)
	line(triangle[2][1],triangle[2][2],triangle[3][1],triangle[3][2],11)
	line(triangle[3][1],triangle[3][2],triangle[1][1],triangle[1][2],11)
end
-->8
function translate_p(p,trans)
	p[1]+=trans[1]
	p[2]+=trans[2]
	p[3]+=trans[3]
end

function translate_tri(tri,trans)
	translate_p(tri[1],trans)
	translate_p(tri[2],trans)
	translate_p(tri[3],trans)
end

function scale_p(p,scl)
	p[1]*=scl
	p[2]*=scl
	p[3]*=scl
end

function scale_tri(tri,scl)
	--translate p1 of the triangle back to the origin
	trans={-tri[1][1],-tri[1][2],-tri[1][3]}
	printh("trans={"..trans[1]..","..trans[2]..","..trans[3].."}")
	printh_tri(tri,"pre trans ")
	printh("\n")
	translate_tri(tri,trans)
	--scale the triangle
	printh_tri(tri,"pre scale ")
	scale_p(tri[1],scl)
	scale_p(tri[2],scl)
	scale_p(tri[3],scl)
	printh_tri(tri,"post scale")
	--translate p1 of the triangle back to its original position
	translate_tri(tri,{-trans[1],-trans[2],-trans[3]})
	printh("\n")
	printh_tri(tri,"final tri ")
	
end

function rot_z_p(p,rad)
	old=p
	p[1]=old[1]*cos(rad)-old[2]*sin(rad)
	p[2]=old[1]*sin(rad)+old[2]*cos(rad)
end

function rot_z_tri(tri,deg,trans)
	rad=deg*(3.14159/180)
	if trans==nil then trans={0,0,0} end
	translate_tri(tri,trans)
	rot_z_p(tri[1],rad)
	rot_z_p(tri[2],rad)
	rot_z_p(tri[3],rad)
	translate_tri(tri,{-trans[1],-trans[2],-trans[3]})
end

function rot_x_p(p,rad)
	--[[
	x-axis rotation looks like
	z-axis rotation if replace:
	
	x-axis with y-axis
	y-axis with z-axis
	z-axis with x-axis
 --]]
	old=p
	p[2]=old[2]*cos(rad)-old[3]*sin(rad)
	p[3]=old[2]*sin(rad)+old[3]*cos(rad)
end

function rot_x_tri(tri,deg,trans)
	rad=deg*(3.14159/180)
	if trans==nil then trans={0,0,0} end
	translate_tri(tri,trans)
	rot_x_p(tri[1],rad)
	rot_x_p(tri[2],rad)
	rot_x_p(tri[3],rad)
	translate_tri(tri,{-trans[1],-trans[2],-trans[3]})
end

function rot_y_p(p,rad)
	--[[
	y-axis rotation looks like
	z-axis rotation if replace:
	
	x-axis with z-axis
	y-axis with x-axis
	z-axis with y-axis
	--]]
	old=p
	p[3]=old[3]*cos(rad)-old[1]*sin(rad)
	p[1]=old[3]*sin(rad)+old[1]*cos(rad)
end

function rot_y_tri(tri,deg,trans)
	rad=deg*(3.14159/180)
	if trans==nil then trans={0,0,0} end
	translate_tri(tri,trans)
	rot_y_p(tri[1],rad)
	rot_y_p(tri[2],rad)
	rot_y_p(tri[3],rad)
	translate_tri(tri,{-trans[1],-trans[2],-trans[3]})
end

function map_to_screen(tri)
	tri[1][1]*=(127/2)
	tri[1][1]+=(127/2)
	
	tri[1][2]*=(127/2)
	tri[1][2]+=(127/2)
	
	tri[2][1]*=(127/2)
	tri[2][1]+=(127/2)
	
	tri[2][2]*=(127/2)
	tri[2][2]+=(127/2)
	
	tri[3][1]*=(127/2)
	tri[3][1]+=(127/2)
	
	tri[3][2]*=(127/2)
	tri[3][2]+=(127/2)
end
-->8
--tab 2: util

function printh_tri(tri,name)
	if name==nil then name="tri" end
	printh(name.."[1]={"..tri[1][1]..","..tri[1][2]..","..tri[1][3].."}")
	printh(name.."[2]={"..tri[2][1]..","..tri[2][2]..","..tri[2][3].."}")
	printh(name.."[3]={"..tri[3][1]..","..tri[3][2]..","..tri[3][3].."}")
end

__gfx__
00000000000008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008888888eee880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700008888888eefee88000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000888888eefffee8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007008888888efffffe8800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888eefffee8800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000088888888eefee88800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000288888888eee888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000288888888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000288888888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000028888888888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000022888888888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000002288888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000228888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000002228880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
