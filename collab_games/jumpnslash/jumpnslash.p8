pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--jump 'n' slash
--designed by joseph turzitti
--programmed by henry holman

#include player.p8
#include rooms.p8

debug_rooms = true
debug_player = true

f = 1 -- frame count

function _init()
	init_rooms()
	init_player()

	set_state_game()
end

function set_state_game()
	_update60 = update_game_state
	_draw = draw_game_state
end

function update_game_state()
	p1_update()
	update_room()
end

function draw_game_state()
	cls() -- clear screen

	draw_room(debug_rooms)
	p1_draw(debug_player)

	f += 1 -- increment frame counter
end

-->8
--tab 1: reference

--[[
sprite flags
------------

num | hex  | color  | meaning
---------------------------
 0  | 0x1  | red    | hurts player
 1  | 0x2  | orange |
 2  | 0x4  | yellow | 
 3  | 0x8  | green  | player can land on top of
 4  | 0x10 | blue   | player cannot pass horizontally thru sides
 5  | 0x20 | gray   | player cannot pass upwards thru bottom
 6  | 0x40 | pink   |
 7  | 0x80 | tan    |
]]
__gfx__
00000000001cc100001cc100001cc100001cc100001cc100001cc100007667004444444488888888aaaaaaaa0000000000000000000000000000000000000000
0000000001111cc001111cc001111cc001111cc001111cc00777766001111cc04555555488888888eaeaeaea0000000000000000000000000000000000000000
007007001111ccc11111ccc11111ccc11111ccc11111ccc11111ccc11111ccc14555555488888888707070700000000000000000000000000000000000000000
00077000111ccc1c111ccc1c111ccc1c111ccc1c77766676111ccc1c111ccc1c4555555488888888070707070000000000000000000000000000000000000000
00077000111cc11c111cc11c111cc11c77766776111cc11c111cc11c111cc11c4555555488888888707070700000000000000000000000000000000000000000
00700700111111111111111111111111111111111111111111111111111111114555555488888888070707070000000000000000000000000000000000000000
00000000011111100111111007777770011111100111111001111110011111104555555488888888707070700000000000000000000000000000000000000000
00000000001111000077770000111100001111000011110000111100001111004444444488888888070707070000000000000000000000000000000000000000
00111100001111000011110000111100001111000011110000111100001111000099990000000000000000000000000000000000000000000000000000000000
01111c1001111c1001111c1001111c1001111c1001111c1001111c1001111c100999989000000000000000000000000000000000000000000000000000000000
111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c19999998900000000000000000000000000000000000000000000000000000000
111ccccc1117cccc11177ccc111c77cc111cc77c111ccc77111cccc7111ccccc9998888800000000000000000000000000000000000000000000000000000000
111ccccc111ccccc1116cccc11166ccc111c66cc111cc66c111ccc66111cccc69998888800000000000000000000000000000000000000000000000000000000
111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c19999998900000000000000000000000000000000000000000000000000000000
01111c1001111c1001111c1001111c1001111c1001111c1001111c1001111c100999989000000000000000000000000000000000000000000000000000000000
00111100001111000011110000111100001111000011110000111100001111000099990000000000000000000000000000000000000000000000000000000000
00000000001111000077770000111100001111000011110000111100001111000000000000000000000000000000000000000000000000000000000000000000
00111100011111100111111007777770011111100111111001111110011111100000000000000000000000000000000000000000000000000000000000000000
01111c10111111111111111111111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
111111c1111cc11c111cc11c111cc11c77766776111cc11c111cc11c111cc11c0000000000000000000000000000000000000000000000000000000000000000
111ccccc111ccc1c111ccc1c111ccc1c111ccc1c77766676111ccc1c111ccc1c0000000000000000000000000000000000000000000000000000000000000000
111111c11111ccc11111ccc11111ccc11111ccc11111ccc11111ccc11111ccc10000000000000000000000000000000000000000000000000000000000000000
01111c1001111cc001111cc001111cc001111cc001111cc00777766001111cc00000000000000000000000000000000000000000000000000000000000000000
00111100001cc100001cc100001cc100001cc100001cc100001cc100007667000000000000000000000000000000000000000000000000000000000000000000
bbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbb000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bb0b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bb0b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbb000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000808080808080808080808080000080800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000800000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000800000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000800000000000000000000080808080800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000800000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000800000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000008000000000000000a0a0a0a0000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000800000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000800000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000008000000000000000a0a0a0a0000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000800000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000800000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000008000000000000000a0a0a0a0000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000800000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000800000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000808080808080808080808080808080800000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000383908000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0808080808080808080808080808080808080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080808080808080808080808080808080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000a0a000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000000000808080800000000000000000000000008080808000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000909000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000909000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000a0a0000000000000a0a0000090900000a0a0000000000000a0a000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000909000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000909000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000909000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
080808080808000a0a0008080808080808080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080808080808000a0a000808080808080000000000000000000000000000000000000000000000000000000000000000
0808080808080000000008080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808000000000808080808080000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000808000000000000000000000000000008080000000000000000000000000000080800000000000000000000000000000000000000000000000000000000000008090909000000000000000000000000090000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000808000000000000000000000000000008080000000000000000000000000000080800000000000000000000000000000000000000000000000000000000000008090900000000000000000000000000090000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000808000000000000000000000000000008080000000000000000000000000000080800000a0a0a0a0a0a0a0a0a0a0a0a0808000000000000000000000000000008090000000000000909000000000000090000000000000000000000000000000000000000000000000000000000000000
0800000000000a0a0a0a00000000000808000000000000000000000000000008080000000000000000000000000000080809000000000000000000000000000808080808080800000808000000000008090000000008090909090808080000090000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000808000000000000000000000000000008080000000a0000080800000a0000000808090000000000000000000000000008080000000000000000000000000000080900000a0a00000909000000080000090000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000808000000000000000000000000000008080000000000000000000000000000080809080000000000000000000000000808000000000000000000000000000008090000000000000909000000080000090000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000808000000000000000000000000000008080a0a000000000000000000000a0a08080808080808000000080808080a0a0808000000000000000000000008080808090800000000000909000a0a080000090000000000000000000000000000000000000000000000000000000000000000
0800000000000a0a0a0a00000000000808000000000000000000000000000008080000000000000000000000000000080800000000000000000000000000000808000008000009090808090900000008090000000000000909000800000000090000000000000000000000000000000000000000000000000000000000000000
08000000000000000000000000000008080a0a0a0a0a0a0000000000000000080800000000000800000800000000000808000000000000000000000000000008080000080000000000000000000000080900000a0a00000909000800000000090000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000808000000000000000000000000000008080000000000000000000000000000080800000000000000000000000000000808000008080808080808080808080808090000000000000909000808080808090000000000000000000000000000000000000000000000000000000000000000
080000000a000000000000080808000808000000000000000000000000000008080808000000000000000000000808080800000000000000000000000000080808000000000000000000000000000008090000000000000909000000000000090000000000000000000000000000000000000000000000000000000000000000
08000000000000000000000000000008080000000000000000000000000000080800000a0a0000000000000a0a0000080800000000000008080000000008080808000000000000000000000000000000000000000008080909000000000000090000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000808080909090908080808000000000000000000000000000000000000000000000909000000000000090000000000000000000000000000000000000000000000000000000000000000
0800000000000909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000080808080808080808080808000008080808000008080808080808000000000000000909000000000000090000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080808080808080809090909090908080808080808080808090909090808080808080808080808080808080808080808080808080808080808090908080808080808080808080808080808080808000008080000000000000000000000000000000000000000000000000000000000000000
