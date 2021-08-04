pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--smash/sf mashup fighter
--by hankdetank05

--[[

controls:

⬆️ = jump
⬅️ = move left
➡️ = move right
⬇️ = crouch

❎/x = smash atk
🅾️/z = special atk

(assume facing right)
⬇️->⬇️➡️-> ➡️ ->🅾️ = hadoken
➡️-> ⬇️ ->⬇️➡️->🅾️ = shoryuken
⬇️->⬅️⬇️-> ⬅️ ->🅾️ = tatsumaki

--]]

function _init()
end

function _update60()
end

function _draw()
end
-->8
--tab 1: util
-->8
--tab 2: player

function init_player()

	plr1={
		sprt=-1,
		fwd="➡️",
		bwd="⬅️",
		hp=100.0,
		x=32,
		y=0
	}
	
	plr2={
		sprt=-2,
		fwd="⬅️",
		bwd="➡️",
		hp=100.0,
		x=96,
		y=0
	}

end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
