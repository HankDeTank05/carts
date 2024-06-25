pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

--[[
    this is the file for all code concerning the rooms
]]


function init_rooms()
    rooms = {} -- holds all the rooms in a list
    curr_room = nil -- the index of the current room
    scroll_x_offset = 0
    scroll_y_offset = 0

    -- room 1
    add_room(0, 16, 2, 14)
    set_connections(1, 9, nil, nil, 2)

    -- room 2
    add_room(16, 16, nil, nil)
    set_connections(2, nil, nil, 1, 3)

    -- room 3
    add_room(32, 16, nil, nil)
    set_connections(3, nil, nil, 2, 4)

    -- room 4
    add_room(48, 16, nil, nil)
    set_connections(4, nil, nil, 3, 5)

    -- room 5
    add_room(64, 16, nil, nil)
    set_connections(5, nil, nil, 4, 6)

    -- room 6
    add_room(80, 16, nil, nil)
    set_connections(6, 7, 8, 5, nil)

    -- room 7
    add_room(80, 0, nil, nil)
    set_connections(7, nil, 6, nil, nil)

    -- room 8
    add_room(80, 32, nil, nil)
    set_connections(8, 6, nil, nil, nil)

    -- room 9
    add_room(0, 0, nil, nil)
    set_connections(9, nil, 1, nil, nil)

    set_current_room(1)
end

function add_room(_map_x, _map_y, _start_x, _start_y)
    -- _map_x: the x-coordinate of the top-left of the room to be added
    -- _map_y: the y-coordinate of the top-left of the room to be added
    -- _start_x: the map x-coordinate where the player should start (set to nil if this room should not be a checkpoint)
    -- _start_y: the map y-coordinate where the player should start (set to nil if this room should not be a checkpoint)
    local room = {
        mx = _map_x,
        my = _map_y,
        start_mx = _start_x,
        start_my = _start_y,
        scroll_x = false, -- does this room scroll horizontally?
        scroll_y = false, -- does this room scroll vertically?
        mx_end = nil,
        my_end = nil,
        connections = {
            u = nil, -- connection when exiting up
            d = nil, -- connection when exiting down
            l = nil, -- connection when exiting left
            r = nil, -- connection when exiting right
        }
    }
    add(rooms, room)
end

function set_connections(_room_num, _up_conn, _down_conn, _left_conn, _right_conn)
    assert(_room_num > 0)
    assert(_room_num <= #rooms)

    assert(_up_conn != _room_num)
    assert(_down_conn != _room_num)
    assert(_left_conn != _room_num)
    assert(_right_conn != _room_num)

    rooms[_room_num].connections.u = _up_conn
    rooms[_room_num].connections.d = _down_conn
    rooms[_room_num].connections.l = _left_conn
    rooms[_room_num].connections.r = _right_conn
end

function set_current_room(_num)
    assert(_num > 0) -- ensure we have a valid room number
    assert(_num <= #rooms) -- ^^what he said^^
    curr_room = _num
    
    if get_current_room().scroll_x == false then
        scroll_x_offset = 0
    end
    if get_current_room().scroll_y == false then
        scroll_y_offset = 0
    end
end

function get_current_room()
    assert(curr_room != nil) -- ensure the rooms have been initialized before doing anything
    return rooms[curr_room]
end

function get_current_room_num()
    assert(curr_room != nil) -- ensure the rooms have been initialized before doing anything
    return curr_room
end

function screen_x_to_map_x(_screen_x)
    -- convert from a screen x-pos to a tile x-pos on the map
    -- note: the map x-pos will be based on the current room
    return (_screen_x / 8) + get_current_room().mx
end

function screen_y_to_map_y(_screen_y)
    -- convert from a screen y-pos to a tile y-pos on the map
    -- note: the map x-pos will be based on the current room
    return (_screen_y / 8) + get_current_room().my
end

function check_for_flag_at(_screen_x, _screen_y, _flag)
    return fget(mget(screen_x_to_map_x(_screen_x), screen_y_to_map_y(_screen_y)), _flag)
end

-- currently does nothing
function update_room()
    -- code goes here
end

-- currently does nothing
function trans_room_up()
    assert(get_current_room().connections.u != nil)
    set_current_room(get_current_room().connections.u)
    -- code goes here
end

-- not yet implemented
function trans_room_down()
    assert(get_current_room().connections.d != nil)
    set_current_room(get_current_room().connections.d)
    -- code goes here
end

function trans_room_left()
    assert(get_current_room().connections.l != nil)
    set_current_room(get_current_room().connections.l)
end

function trans_room_right()
    assert(get_current_room().connections.r != nil)
    set_current_room(get_current_room().connections.r)
end

function draw_room(_debug)
	
	--draw the map
	map(rooms[curr_room].mx, rooms[curr_room].my,
	    0, 0, -- x,y position to draw on screen
	    16, 16) -- w,h in tiles

    if _debug then
        -- code goes here
    end
end