pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--pseudo-3d racer tutorial
--tutorial by @mot

//ct: segment count
//tu: how much to turn
//tu=-1 : left turn
//tu= 0 : straight
//tu= 1 : right turn
road={
	{ct=10,tu=0},
	{ct=6,tu=-1},
	{ct=8,tu=0},
	{ct=4,tu=1.5},
	{ct=10,tu=0.2},
	{ct=4,tu=0},
	{ct=5,tu=-1}
}

camcnr,camseg=1,1

camx,camy,camz=0,0,0

function _init()
end

function _update60()
	
	camz+=0.1
	if camz>1 then
		camz-=1
		camcnr,camseg=advance(camcnr,camseg)
	end
	
end

function _draw()
	cls()

	// x=right   -x=left
	// y=down    -y=up
	// z=forward -z=backward
	
	// direction
	local camang=camz*road[camcnr].tu
	local xd,yd,zd=-camang,0,1
	
	local cx,cy,cz=skew(camx,camy,camz,xd,yd)
	
	// cursor
	local x,y,z=-cx,-cy+1,-cz+1
	
	// road position
	local cnr,seg=camcnr,camseg
	
		line(x+64,z,z+64,z)
	
	for i=1,30 do
		
		// project
		local px,py,scale=project(x,y,z)
		
		// draw road
		local width=3*scale
		line(px-width,py,px+width,py)
		
		// move forward
		x+=xd
		y+=yd
		z+=zd
		
		
		// turn
		xd+=road[cnr].tu
		
		// advance along road
		cnr,seg=advance(cnr,seg)
		
	end
	
end

function project(x,y,z)
	local scale=64/z
	return x*scale+64,y*scale+64,scale
end

function advance(cnr,seg)
		
	seg+=1
	if seg>road[cnr].ct then
		seg=1
		cnr+=1
		if cnr>#road then
			cnr=1
		end
	end
	return cnr,seg

end

function skew(x,y,z,xd,yd)

	return x+z*xd,y+z*yd,z

end

function drawtracks()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
