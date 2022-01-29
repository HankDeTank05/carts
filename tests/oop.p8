pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--object-oriented programming
--by hankdetank05

--[[
function _init()
end

function _update60()
end

function _draw()
end
--]]

local a = makevec2d(3, 4)
local b = 2 * a

print(a) --calls __tostring
         --internally, so this
         --prints "(3, 4)"

print(b) --(6, 8)
print(a+b) --(9, 12)
-->8
--define a new metatable to be
--shared by all vectors
local mt = {}

--function to create a new
--vector
function makevec2d(x, y)
	local t = {
		x = x,
		y = y
	}
	setmetatable(t,mt)
	return t
end

--define some vector operations
--such as addition, subtraction
function mt.__add(a,b)
	return makevec2d(
		a.x + b.x,
		a.y + b.y
	)
end

function mt.__sub(a,b)
	return makevec2d(
		a.x - b.x,
		a.y - b.y
	)
end

--more fancy example, implement
--two different kinds of
--multiplication:
--number*vector -> scalar prod.
--vector*vector -> cross prod.

function mt.__mul(a,b)
	if type(a) == "number" then
		return makevec2d(
			b.x * a,
			b.y * a
		)
	elseif type(b) == "number" then
		return makevec2d(
			a.x * b,
			a.y * b
		)
	end
	return a.x * b.x + a.y * b.y
end

--check if two vectors with
--different addresses are equal
--to each other
function mt.__eq(a,b)
	return a.x==b.x and a.y==b.y
end

--custom format when converting
--to a string
function mt.__tostring(a)
	return "("..a.x..", "..a.y..")"
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
