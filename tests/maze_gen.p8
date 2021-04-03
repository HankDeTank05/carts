pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--maze generator
--by hankdetank05

menuitem(2,"recur. backtrack",function() set_recursive_backtracking() end)
menuitem(3,"randomized prims",function() set_randomized_prims() end)

empty=0
filled=1
size=127
has_current=false

function _init() menu_init() end

function menu_init()
	options={}
	add(options,"recursive backtracking")
	add(options,"randomized prim's algorithm")
	cur=1

	_update=menu_update()
	_draw=menu_draw()
end

function menu_update()
	if btnp(⬇️) and cur<#options then
		cur+=1
	elseif btnp(⬆️) and cur>1 then
		cur-=1
	elseif btnp(❎) then
		if cur==1 then
			set_recursive_backtracing()
		elseif cur==2 then
			set_randomized_prims()
		end
		
	end
end

function menu_draw()
	cls()
	for o=1,#options do
		print(options[o],1,o*6,7)
	end
	
	print("-",1,(cur)*6,7)
end

function maze_draw()
	cls()
	for x=1,size do
		for y=1,size do
			draw_cell(x,y)
			//draw_cell_num(x,y)
		end
	end
	
	if has_current then
		draw_current_cell()
	end
end

function generate_grid(size)
	grid={}
	for x=1,size do
		for y=1,size do
			if x%2==0 and y%2==0 then
				//printh("("..x..","..y..")")
				grid[(size-1)*y+x]=filled
			else
				grid[(size-1)*y+x]=filled
			end
		end
	end
	return grid
end

function draw_cell(x,y)
	//rectfill(x*cell_size,y*cell_size,x*cell_size+cell_size-border_size,y*cell_size+cell_size-border_size,grid[(size-1)*y+x])
	pset(x,y,grid[(size-1)*y+x])
end

function draw_current_cell()
	pset(current_cell.x,current_cell.y,8)
end

function draw_cell_num(x,y)
	print(grid[(size-1)*y+x],x*6,y*6)
end

-->8
--tab 1: changing algorithms

function set_recursive_backtracking()
	_init=init_maze_rb
	_update=update_maze_rb
	_draw=maze_draw
end

function set_randomized_prims()
	_init=init_maze_rp
	_update=update_maze_rp
	_draw=maze_draw
end
-->8
--tab 2: recursive backtracking


function init_maze_rb()
	has_current=true

	//create a square grid
	visited={}
	starting_cell={}
	starting_cell.x=2
	starting_cell.y=2
	
	//construct the cell grid
	grid=generate_grid(size)
	
	for x=1,size do
		for y=1,size do
			//set the visited grid to
			//false
			visited[(size-1)*y+x]=false
		end
	end
	
	//init the stack
	stack={}
		
	_update=update_maze_rb
		
	start_maze_rb(starting_cell.x,starting_cell.y)

end

function stack_push(cell)
	
	//table must have x,y
	assert(cell.x!=nil,"cell.x is nil!")
	assert(cell.y!=nil,"cell.y is nil!")
	
	//cell indices must be even
	assert(cell.x%2==0,"cell.x must be an even number! (was "..cell.x..")")
	assert(cell.y%2==0,"cell.y must be an even number! (was "..cell.y..")")
	
	//add the cell to the top
	//of the stack
	add(stack,cell)
	
end

function stack_pop()
	
	//stack must not be empty
	assert(#stack>0,"attempted to pop from an empty stack!")
	
	//remove the cell at the top
	//of the stack
	local pop=deli(stack,#stack)
	return pop
	
end

function set_visited(x,y)
	assert(x%2==0,"set_visited: x must be an even number! (was "..x..")")
	assert(y%2==0,"set_visited: y must be an even number! (was "..y..")")
	
	visited[(size-1)*y+x]=true
	grid[(size-1)*y+x]=empty
	
end

function get_visited(x,y)
	assert(x%2==0,"get_visited: x must be an even number! (was "..x..")")
	assert(y%2==0,"get_visited: y must be an even number! (was "..y..")")
	
	return visited[(size-1)*y+x]

end

function get_unv_neighbors(x,y)
	assert(x%2==0,"has_unv_neighbors: x must be an even number! (was "..x..")")
	assert(y%2==0,"has_unv_neighbors: y must be an even number! (was "..y..")")

	unv_neighbors={}
	
	//check left
	if x>2 and not(get_visited(x-2,y)) then
		add(unv_neighbors,"left")
	end
	
	//check right
	if x<size-2 and not(get_visited(x+2,y)) then
		add(unv_neighbors,"right")
	end
	
	//check up
	if y>2 and not(get_visited(x,y-2)) then
		add(unv_neighbors,"up")
	end
	
	//check down
	if y<size-2 and not(get_visited(x,y+2)) then
		add(unv_neighbors,"down")
	end
	
	return unv_neighbors
end

function remove_wall(x,y,neighbor)
	assert(x%2==0,"remove_wall: x must be an even number! (was "..x..")")
	assert(y%2==0,"remove_wall: y must be an even number! (was "..y..")")
	
	if neighbor=="left" then
		grid[(size-1)*y+x-1]=empty
	elseif neighbor=="right" then
		grid[(size-1)*y+x+1]=empty
	elseif neighbor=="up" then
		grid[(size-1)*(y-1)+x]=empty
	elseif neighbor=="down" then
		grid[(size-1)*(y+1)+x]=empty
	else
		printh("error with removing wall between current and neighbor cells! neighbor string is invalid! ("..neighbor..")")
	end

end

function start_maze_rb(start_x,start_y)
	
	//starting x and y must both
	//be even numbers
	assert(start_x%2==0,"start_x must be an even number! (was "..start_x..")")
	assert(start_y%2==0,"start_y must be an even number! (was "..start_y..")")
	
	//choose an initial cell...
	start_cell={}
	start_cell.x=start_x
	start_cell.y=start_y
	
	//...mark it as visited...
	set_visited(start_cell.x,start_cell.y)
	
	//...and push it to the stack
	stack_push(start_cell)
	
	
end

function update_maze_rb()
	//while the stack is not empty
	if #stack>0 then
		//printh("running")
		printh(#stack)
		
		//pop a cell from the stack
		//and make it the current
		//cell
		current_cell=stack_pop()
		
		//if the cell has any
		//unvisited neighbors...
		unv_neighbors=get_unv_neighbors(current_cell.x,current_cell.y)
		if #unv_neighbors>0 then
			
			//..push the current cell to
			//the stack
			stack_push(current_cell)
			
			//choose one of the
			//unvisitied neighbors			
			local choice_i=flr(rnd(#unv_neighbors))+1
			local neighbor=unv_neighbors[choice_i]
			local chosen_cell={}
			if neighbor=="left" then
				chosen_cell.x=current_cell.x-2
				chosen_cell.y=current_cell.y
			elseif neighbor=="right" then
				chosen_cell.x=current_cell.x+2
				chosen_cell.y=current_cell.y
			elseif neighbor=="up" then
				chosen_cell.x=current_cell.x
				chosen_cell.y=current_cell.y-2
			elseif neighbor=="down" then
				chosen_cell.x=current_cell.x
				chosen_cell.y=current_cell.y+2
			else
				printh("error creating chosen cell object! invalid neighbor string! ("..neighbor..")")
			end
			
			//remove the wall between
			//the current cell and the
			//chosen cell
			remove_wall(current_cell.x,current_cell.y,neighbor)
			
			//mark the chosen cell as
			//visited...
			set_visited(chosen_cell.x,chosen_cell.y)
			
			//...and push it to the
			//stack
			stack_push(chosen_cell)
			
		end
	end

	
end
-->8
--tab 3: randomized prim's

prims_wall_list={}
function init_maze_rp()
	//create a square grid
	visited={}
	starting_cell={}
	starting_cell.x=2
	starting_cell.y=2
	
	//construct the cell grid
	grid=generate_grid(size)
	
	for x=1,size do
		for y=1,size do
			//set the visited grid to
			//false
			visited[(size-1)*y+x]=false
		end
	end
	
	//wall_list={}
	//assert(wall_list!=nil)
	
	start_maze_rp(2,2)
 //assert(wall_list!=nil)
end

function start_maze_rp(start_x,start_y)
	
	//starting x and y must both
	//be even numbers
	assert(start_x%2==0,"start_x must be an even number! (was "..start_x..")")
	assert(start_y%2==0,"start_y must be an even number! (was "..start_y..")")
	
	//pick a cell...
	start_cell={}
	start_cell.x=start_x
	start_cell.y=start_y
	
	//...mark it as part of the
	//maze...
	set_visited(start_cell.x,start_cell.y)
	
	//...add the walls of the cell
	//to the wall list
	cell_walls=get_cell_walls(start_cell.x,start_cell.y)
	
	for wall in all(cell_walls) do
		add(prims_wall_list,wall)
	end
end

function update_maze_rp()
	printh("prims update")
	printh(#prims_wall_list)
	if #prims_wall_list>0 then
		//pick a random wall from
		//the list...
		wall_i=flr(rnd(#wall_list))+1
		
		wall=wall_list[wall_i]
		
		printh("wall : ("..wall.x..","..wall.y..")")
		
		//...if only one of the two
		//cells the wall divides is
		//visited, then:
		one_adj_visited,unv_location=one_adj_cell_visited(wall.x,wall.y)
		if one_adj_visited then
			//make the wall a passage...
			grid[(size-1)*wall.y+wall.x]=empty
			
			//...and mark the unvisited
			//cell as part of the maze
			set_visited(wall.x,wall.y)
			
			//add the neighboring walls
			//of the cell to the wall
			//list
			cell_walls=get_cell_walls(unv_location.x,unv_location.y)
			for adj_wall in all(cell_walls) do
				add(prims_wall_list,adj_wall)
			end
		end
		
		del(prims_wall_list,wall)
	end
end

function get_cell_walls(x,y)
	assert(x%2==0,"get_cell_walls: x must be an even number! (was "..x..")")
	assert(y%2==0,"get_cell_walls: y must be an even number! (was "..y..")")
	
	walls={}
	wall_l={x-1,y}
	wall_r={x+1,y}
	wall_u={x,y-1}
	wall_d={x,y+1}
	
	if x==2 and grid[(size-1)*y+x-1]==filled then
		add(walls,wall_r)
	elseif x==size-1 and grid[(size-1)*y+x+1]==filled then
		add(walls,wall_l)
	else
		if grid[(size-1)*y+x-1]==filled then
			add(walls,wall_l)
		end
		
		if grid[(size-1)*y+x+1]==filled then
			add(walls,wall_r)
		end
	end
	
	if y==2 and grid[(size-1)*(y-1)+x]==filled then
		add(walls,wall_d)
	elseif y==size-1 and grid[(size-1)*(y+1)+x]==filled then
		add(walls,wall_u)
	else
		if grid[(size-1)*(y-1)+x]==filled then
			add(walls,wall_u)
		end
		
		if grid[(size-1)*(y+1)+x]==filled then
			add(walls,wall_d)
		end
	end
	
	return walls
end

function one_adj_cell_visited(wall_x,wall_y)
	assert(wall_x%2==1 or wall_y%2==1,"one_adj_cell_visited: one element of the wall's location must be odd! (x:"..wall_x..",y:"..wall_y..")")
	
	root_adj={}
	next_adj={}
	
	//check horizontal neighbors
	//left
	if wall_x>1 and get_visited(wall_x-1,wall_y) then
		root_adj.x=wall_x-1
		root_adj.y=wall_y

		next_adj.x=wall_x+1
		next_adj.y=wall_y

		
	//right
	elseif wall_x<size-1 and get_visited(wall_x+1,wall_y) then
		root_adj.x=wall_x+1
		root_adj.y=wall_y

		next_adj.x=wall_x-1
		next_adj.y=wall_y
				
	//up
	elseif wall_y>1 and get_visited(wall_x,wall_y-1) then
		root_adj.x=wall_x
		root_adj.y=wall_y-1

		next_adj.x=wall_x
		next_adj.y=wall_y+1
	
	//down
	elseif wall_y<size-1 and get_visited(wall_x,wall_y+1) then
		root_adj.x=wall_x
		root_adj.y=wall_y+1

		next_adj.x=wall_x
		next_adj.y=wall_y-1
	
	end
	
	if not(get_visited(next_adj.x,next_adj.y)) then
		return true,next_adj
	end
	
	return false,next_adj
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
