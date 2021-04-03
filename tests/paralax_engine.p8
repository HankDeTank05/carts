pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--paralax engine
--by hankdetank05

--tab 0: main

function _init()
	init_plax_layers()
end

function _update60()
	update_plax_layers()
end

function _draw()
	draw_plax_layers()
end
-->8
--tab 1: util
-->8
--tab 2: layers

function init_plax_layers()
	layers={}
	layerdata={}
	timer=60
end

function update_plax_layers()
	assert(#layers==#layerdata)
	
	timer-=1
	
	for l=#layers,1,-1 do
		if timer<=0 then
			if layers[l][2]=="dot" then
				add(layerdata[l],{x=flr(rnd(127)),y=flr(rnd(127))})
			end
		end
	end
	
	if timer<=0 then
		timer=60
	end
	
end

function draw_plax_layers()
	assert(#layers==#layerdata)
	
	cls()

	for l=#layers,1,-1 do
		if layers[l][2]=="dot" then
			for d=0,#layerdata[l] do
				draw_dot(layerdata[l][d].x,layerdata[l][d].y,7)
			end
		end
	end

end

function create_layer(ltype)

	if ltype[1]=="shape" then
		if ltype[2]=="dot" or ltype[2]=="square" or ltype[2]=="circle" then
			if 0<=ltype[3] and ltype[3]<16 then
				add(layers,ltype)
				add(layerdata,{})
			end
		end

	elseif ltype[1]=="sprite" then
		if 0<ltype[2] and ltype[2]<256 then
			add(layers,ltype)
			add(layerdata,{})
		end
	end
end
-->8
--tab 3: ltype shape

function draw_dot(x,y,clr)
	pset(x,y,clr)
end

function draw_square(x,y,size,clr)
	rectfill(x,y,x+size,y+size,clr)
end

function draw_circle(x,y,r,clr)
	circfill(x,y,r,clr)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
