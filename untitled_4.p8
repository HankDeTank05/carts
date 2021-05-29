pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--adhd proof-of-concept
--by hankdetank05

function _init()

	link={
		sprite=8--x-val of topleft px
		next_spr=1
		size=16--sprite size
		xpos=0
		ypos=0
		frame_count=0
		moving=false
		stuck=false
	}
end

function _update60()

	if not(link.stuck) then
		if btn(⬅️) then link.xpos-=1 link.moving=true
		elseif btn(➡️) then link.xpos+=1 link.moving=true
		elseif btn(⬆️) then link.ypos-=1 link.moving=true
		elseif btn(⬇️) then link.ypos+=1 link.moving=true
		else link.moving=false end
	else
		--play sound and vibrate the
		--sprite in the direction
		--of the button press
	end

	if link.moving then
		link.frame_count+=1
		if link.frame_count>=30 then
			sprite+=link.next_spr*link.size
			next_spr*=-1
		end
	end
end

function _draw()
	
end
__gfx__
00000000000000555000000000000005550000000000055555000000000000000000000000ffffffffffff00000000000000000000000000ffffffff08888880
000000000000055555000000000000555550000000005bbbfb55000000005555550000000ffffffffffffff0000000000000000000000000ffffffff06666660
00700700000005ffff500000000005ffff5000000005bbffb5ff50000055bbbffb5505000ffffffffffffff0000000000000000000000000ffffffff06888860
0007700000055f5555f5500000055f5555f55000005bb5bb5ffb555005bbbffbb5ff55000ffffffffffffff0000000000000000000000000ffffffff06000060
00077000005f55bffb55f500005f55bffb55f50005bb5f55ffb5550005bbb5bb5ffb55000ffffffffffffff00000000000000000000000006050050606888860
00700700005f5bbffbb5f500005f5bbffbb5f50005bb5fb5b555000005bb5f55ffb55000ffffffffffffffff0000000000000000000000006050050606500560
00000000005f5b5bfbb5f500005f5bbfb5b5f500005b5ff55f5f5500005b5fb5b5550000ffffffffffffffff0000000000000000000000006000000606500560
00000000005b55bbfbb5b500005b5bbfbb55b50000055ff5ff5ff500005b5ff55f5f550015555555555555510000000000000000000000006000000606000060
00000000000555bbbb555000000555bbbb55500000005bf5fffb500000055ff5ff5ff50015555555555555510000000000000000000000000000000000000000
000000000005b5bbb5b5b500005b5b5bbb5b5000000055b5bbb5000000005bf5fffb5000611111111111111d0000000000000000000000000000000000000000
00000000005fb5bb5bb5b500005b5bb5bb5bf50000005b555555000000005555555500006d06d0000006d06d0000000000000000000000000000000000000000
00000000005f5b55bbfb55000055bfbb55b5f5000005bb5ff5b5000000055bb5ff5000007d06d0000006d07d0000000000000000000000000000000000000000
000000000005bfffffbb50000005bbfffffb50000005bb5ff5f50000005f5bb5ff5000006d06d0000006d06d0000000000000000000000000000000000000000
0000000000055bbbbb555000000555bbbbb550000005555555b50000005f55bb555500006d0000000000006d0000000000000000000000000000000000000000
000000000005555555ff55000055ff555555500000005ffff5550000005ff555ffff50006d0000000000006d0000000000000000000000000000000000000000
0000000000005555555550000005555555550000000555555555500000555555555550006d0000000000006d0000000000000000000000000000000000000000
00000000000000555550000000000000000000000000055555000000000000555550000000888888888888000000000000000000000000000000000000000000
00000000000055b0bbb50000000005555550000000005bffbb500000000005bbffb5000008888888888888800000000000000000000000000000000000000000
000000000005ff5bffbb500005055bffbbb5500000055b55bbb5500000055bbb55b5500008887777666688800000000000000000000000000000000000000000
000000000555bff5bb5bb500055ff5bbffbbb500005f55ffffb5f500005f5bffff55f500088756dddd6568800000000000000000000000000000000000000000
0000000000555bff55f5bb50055bff5bb5bbb500005f5f5555f5f500005f5f5555f5f50008876d8888d6d8800000000000000000000000000000000000000000
000000000000555f5bf5bb500055bff55f5bb500005f55555555f500005f55555555f5000887d8888886d8800000000000000000000000000000000000000000
000000000055f5f55ff5b500000555b5bf5b5000005bb555555bb500005bb555555bb5000086d8888886d8000000000000000000000000000000000000000000
00000000005ff5ff5ff55000055f5f55ff5b50000005ff5ff5ff50000005ff5ff5ff50000006d0000006d0000000000000000000000000000000000000000000
000000000005bfff5fb5000005ff5ff5ff5500000005bf5ff5fb50000005bf5ff5fb50000006d0000006d0000000000000000000000000000000000000000000
0000000000005bbb5b550000005bfff5fb500000005b5bffffb5b500005b5bffffb5b5000006d0000007d0000000000000000000000000000000000000000000
000000000000555555b50000000555555550000005fb55555555b500005b55555555bf500086d8888886d8000000000000000000000000000000000000000000
0000000000005b5ff5bb500000005ff5bb55000005f55bbbb5ffb500005bff5bbbb55f500886d8888886d8800000000000000000000000000000000000000000
0000000000005f5ff5bb500000005ff5bb5f50000055bffff5ff50000005ff5ffffb55000086d8888886d8000000000000000000000000000000000000000000
0000000000005b55555550000005555bb55f5000000555bbbb550000000055bbb55550000006d6d006d6d0000000000000000000000000000000000000000000
000000000000555ffff50000005ffff555ff50000055bff555555000000555555ffb55000006d0000006d0000000000000000000000000000000000000000000
0000000000055555555550000055555555555000000555555555000000005555555550000006d0000006d0000000000000000000000000000000000000000000
