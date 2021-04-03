pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function _init()
	sll=sll_init()
	
	sll_insert(sll,7,0)
	sll_insert(sll,10,1)
	sll_insert(sll,2,2)	
	
end

function _update60()
end

function _draw()
	cls()
	sll_print(sll)
	
	sll_draw(sll,0,64)
	--[[if sll.size>0 then
		sll_draw_node(sll.next,64,64)
	end--]]
	
	//draw_next_arrow(64,64)
	//draw_prev_arrow(32,32)
end
-->8
--tab 1: singly linked list

function sll_init()
	head={}
	head.next={}
	head.size=0
	return head
end

function sll_create_node(num)
	node={}
	node.num=num
	node.next=nil
	return node
end

function sll_insert(head,num,i)
	if i>head.size then
		return false
	elseif i==0 then
		local new_node=sll_create_node(num)
		new_node.next=head.next
		head.next=new_node
		head.size+=1
		return true
	end
	
	local current=head.next
	local curr_i=1
	
	while curr_i<i do
		current=current.next
		curr_i+=1
	end
	
	local new_node=sll_create_node(num)
	
	new_node.next=current.next
	current.next=new_node
	
	head.size+=1
	
	return true
end

function sll_print(head)
	local current=head.next
	local i=1
	
	while current!=nil do
		print(current.num,0,i*7,7)
		current=current.next
		i+=1
	end
	
end

function sll_draw(head,x,y)
	local current=head.next
	local node_draw_width=51
	
	local p=0
	
	while current!=nil do
		sll_draw_node(current,x+(node_draw_width*p),y)
		current=current.next
		p+=1
	end
	
	
end

function sll_draw_node(node,x,y)
	
	local box_size=25
	
	//assert(node.num!=nil)
	
	rect(x,y,x+box_size,y+box_size,7)
	print(node.num,x+2,y+2)
	
	draw_next_arrow(x+box_size+2,y+8)
	
end

function draw_next_arrow(x,y)

	local arrow_point={
		x=x+22,
		y=y+4
	}
	
	//draw from x,y -> down/right
	line(x,y,x+16,y,7)
	line(x,y,x,y+8,7)
	line(x,y+8,x+16,y+8,7)
	
	line(x+16,y+8,x+16,y+10,7)
	line(x+16,y+10,arrow_point.x,arrow_point.y,7)
	
	line(x+16,y,x+16,y-2,7)
	line(x+16,y-2,arrow_point.x,arrow_point.y,7)
	
	print("next",x+2,y+2,7)
end

function draw_prev_arrow(x,y)
	
	local arrow_point={
		x=x-22,
		y=y+4
	}
	
	//draw from x,y -> down/left
	
	line(x,y,x-16,y,7)
	line(x,y,x,y+8,7)
	line(x,y+8,x-16,y+8,7)
	
	line(x-16,y+8,x-16,y+10,7)
	line(x-16,y+10,arrow_point.x,arrow_point.y,7)
	
	line(x-16,y,x-16,y-2,7)
	line(x-16,y-2,arrow_point.x,arrow_point.y,7)
	
	print("prev",x-16,y+2,7)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
