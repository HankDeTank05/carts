pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
--house explorer (working title)
--a game jam project

act=1

function _init()
	
	printh("\n\n")

	player=init_player()
	
	map_data=init_map()
	
	obj_mgr=init_obj_mgr()
	int_obj_mgr=init_obj_mgr()
	
	init_objs(obj_mgr)
	init_interactibles(int_obj_mgr)
	
	crp={} --corruption particles
	
	global_tb=nil
	
end

function _update60()
	
	if global_tb==nil then
		update_player(player,int_obj_mgr)
		update_map(map_data,player)
	
	else
		update_textbox()
		
	end
	
end

function _draw()
	
	cls()
	draw_map_background(map_data,
	                    false,
	          player.curr_room_spr)
	
	draw_corruption(crp)
	
	draw_obj_mgr(obj_mgr,player)
	
	draw_player(player)
	
	draw_obj_mgr(int_obj_mgr,player)
	
	draw_map_foreground(map_data,
	                    player)
	
	if global_tb!=nil then
		draw_textbox()
	end

end

--[[

credits
-------

programming:  henry holman

game design:  ruben rojas
              sj singh
              joseph turzitti
              henry holman
             
level design: ruben rojas
              henry holman
              
spritework:   sj singh
              henry holman
              
story:        ruben rojas
              joseph turzitti

--]]

--assertion shortcuts
function floor_assert(plr)
	assert(plr.floor==2 or
	       plr.floor==1 or
	       plr.floor==0)
end

function layer_assert(plr)
	assert(plr.layer=="b" or
	       plr.layer=="m" or
	       plr.layer=="f")
end
-->8
--tab 1: player

x_snsr_offset=8
anim_first_frame=1

function init_player()
	
	local player={
		xpos= 152, --x position on map
		ypos=-1, --y position on map
		xcenter=-1,
		
		xdraw=56, --x pos. on screen
		ydraw=-1, --y pos. on screen
		
		floor=2,
		layer="b",
		
		speed=0.75,
		
		right=false, --whether player
		             --is facing
		             --right or not
		
		anim_length=3, --num frames
		anim_frame=anim_first_frame, --current frame
		anim_counter=0,
		anim_speed=16,
		moving=false,
		
		can_press_up=false,
		can_press_dn=false,
		can_press_xb=false,
		can_press_ob=false,
		
		curr_room_spr=-1,
		
		int_obj_index=-1,
		
		keys={}, --keyring (inventory)
		pages={}, --diary (inventory)
	}
	
	-- plr.right explanation:
	------------------------
	-- determine whether or not to
	-- horizontally flip player
	-- sprite based on the
	-- direction the player is
	-- facting
	
	return player
	
end

function update_player(plr,int_mgr)
	
	floor_assert(plr)
	layer_assert(plr)
	
	-- determine the vertical
	-- position at which to draw
	-- the player based on which
	-- floor of the house they're
	-- on
	floor_assert(plr)
	if plr.floor==2 then
		plr.ydraw=8
		if plr.layer=="b" then
			plr.ypos= 1*8
		elseif plr.layer=="m" then
			plr.ypos= 6*8
		elseif plr.layer=="f" then
			plr.ypos=11*8
		end
		
	elseif plr.floor==1 then
		plr.ydraw=8+40
		if plr.layer=="b" then
			plr.ypos=16*8
		elseif plr.layer=="m" then
			plr.ypos=21*8
		elseif plr.layer=="f" then
			plr.ypos=26*8
		end
		
	elseif plr.floor==0 then
		plr.ydraw=8+40+40
		if plr.layer=="b" then
			plr.ypos=31*8
		elseif plr.layer=="m" then
			plr.ypos=36*8
		elseif plr.layer=="f" then
			plr.ypos=41*8
		end
		
	end
	
	plr.xcenter=plr.xpos+8
	spr_num=mget(plr.xcenter/8,
	             plr.ypos/8)
	spr_below=mget(plr.xcenter/8,
	               (plr.ypos/8)+5)
	spr_overhead=mget(plr.xcenter/8,
	                  (plr.ypos/8)
	                  -1)
	spr_left=mget((plr.xcenter/8)-1,
	              (plr.ypos/8))
	spr_right=mget((plr.xcenter/8)+1,
	               (plr.ypos/8))
	
	if global_tb==nil then
		if btn(⬅️) or btn(➡️) then
			if btn(⬅️) then
				if fget(spr_left)==0x86 then
					printh("narrow door unlock attempt (left)")
					unlock_narrow_door(plr)
				elseif fget(spr_left)!=0 and
				       fget(spr_left)!=0x86 then
					plr.xpos-=plr.speed
				end
				plr.right=false
			elseif btn(➡️) then
				if fget(spr_right)==0x86 then
					printh("narrow door unlock attempt (right)")
					unlock_narrow_door(plr)
				elseif fget(spr_right)!=0 and
				   fget(spr_right)!=0x86 then
					plr.xpos+=plr.speed
				end
				plr.right=true
			end
			plr.moving=true
			plr.anim_counter+=1
			if plr.anim_counter>=plr.anim_speed then
				plr.anim_counter=0
				plr.anim_frame+=1
				if plr.anim_frame>=plr.anim_length then
					plr.anim_frame=anim_first_frame
				end
			end
		else
			plr.moving=false
			plr.anim_frame=0
			plr.anim_counter=0
		end
	end
	
	--determine whether player
	--can press ⬆️ or ⬇️ to switch
	--floors/layers for button
	--prompt
	
	--⬆️ check
	if (fget(spr_num,0) or
	   (not(fget(spr_num,0)) and fget(spr_num,7))
	    and plr.floor<2) then
		plr.can_press_up=true
	else
		plr.can_press_up=false
	end
	
	--⬇️ check
	if fget(spr_below,0)
	   or (fget(spr_num,7) and not(fget(spr_num,0))
	       and plr.floor>0) then
	 plr.can_press_dn=true
	else
		plr.can_press_dn=false
	end
	
	--determine whether or not
	--player can press ❎ to
	--interact with an object
	--or not for button prompt
	assert(int_mgr!=nil)
	if #int_mgr>0 then
		for i=1,#int_mgr do
			local obj=int_mgr[i]
			if obj.xpos<=plr.xcenter and
			   plr.xcenter<obj.xpos+8 and
			   obj.floor==plr.floor and
			   obj.layer==plr.layer then
			 plr.can_press_xb=true
			 plr.int_obj_index=i
			 --printh(int_mgr[i].name)
			 break
			else
				plr.can_press_xb=false
				plr.int_obj_index=-1
			end
		end
	else
		plr.can_press_xb=false
		plr.int_obj_index=-1
	end
	
	--set the current room sprite
	--number for room shading
	plr.curr_room_spr=spr_overhead
	
	if btnp(⬆️) then
	
		--door to layer back unlocked
		if fget(spr_num,0) and not(fget(spr_num,7)) then
			if plr.layer=="f" then
				plr.layer="m"
			elseif plr.layer=="m" then
				plr.layer="b"
			end
		
		--door to layer back locked
		elseif fget(spr_num,0) and fget(spr_num,7) then
			unlock_wide_door(plr)
		
		--stairs
		elseif fget(spr_num,7) and not(fget(spr_num,0)) and
		       plr.floor<2 then
			plr.floor+=1
			plr.layer="m"
			
		end
		
	elseif btnp(⬇️) then
			
		--door to layer fwd unlocked
		if fget(spr_below,0) and not(fget(spr_below,7)) then
		   --[[and (plr.layer=="m"
		        or plr.layer=="b") then--]]
			if plr.layer=="m" then
				plr.layer="f"
			elseif plr.layer=="b" then
				plr.layer="m"
			end
		
		--door to layer fwd locked
		elseif fget(spr_below,0) and fget(spr_below,7) then
			unlock_wide_door(plr)
			if doors.bedroom.lock==true then
				init_locked_door_tb()
			end
			
		--stairs
		elseif fget(spr_num,7) and not(fget(spr_num,0)) and
		       plr.floor>0 then
			plr.floor-=1
			plr.layer="m"
		 
		end
		
	end
	
	if btnp(❎) and plr.int_obj_index>0 then
		local obj=del(int_mgr,int_mgr[plr.int_obj_index])
		printh("obj.name="..obj.name)
		--bring up text box
		init_textbox(obj.int_text,"n",obj.int_sprn)
		if sub(obj.name,1,10)=="diary page" then
			--add page to diary
			add(plr.pages,obj)
			printh("added page to diary")
		elseif sub(obj.name,#obj.name-2,#obj.name)=="key" then
			--add key to keyring
			add(plr.keys,obj)
			printh("added key to keyring")
		end
		plr.int_obj_index=-1
	end
	
end

function draw_player(plr)
	
	--debug curr room flag
	print("curr_room_spr="..plr.curr_room_spr,
	      0,108,7)
	
	--debug player pos. on map
	print("("..(plr.xpos+8)..", "..plr.ypos..")",
	      0,114,7)
	
	--debug map spr flag at curr.
	--payer pos.
 print(
 	fget(
 		mget(
 			(plr.xpos+8)/8,
 			(plr.ypos)/8
 		)
 	),
 	0,120,7
 )

	-- draw player sprite
	sspr(plr.anim_frame*16,0,
	                  --sx, sy
	     16,32,       --sw, sh
	     plr.xdraw,plr.ydraw,
	                  --dx, dy
		    16,32,       --dw, dh
		    plr.right,false)
		             --flip_x, flip_y
		
		--draw d-pad hints
		local dpad_xoff=4
		local dpad_yoff=33
		if plr.can_press_up and
		   not(plr.can_press_dn) then
			spr(76,
			    plr.xdraw+dpad_xoff,
			    plr.ydraw+dpad_yoff)
		elseif not(plr.can_press_up)
		       and plr.can_press_dn then
			spr(78,
			    plr.xdraw+dpad_xoff,
			    plr.ydraw+dpad_yoff)
		elseif plr.can_press_up and
		       plr.can_press_dn then
			spr(77,
			    plr.xdraw+dpad_xoff,
			    plr.ydraw+dpad_yoff)   
		end
		
		--draw button hints
		local xbtn_xoff=4
		local xbtn_yoff=33
		if plr.can_press_xb then
			spr(79,
				   plr.xdraw+xbtn_xoff,
				   plr.ydraw+xbtn_yoff)
		end

end

function get_spr_layer_fwd(plr)
	local xcenter=plr.xpos+8
	spr_below=mget(xcenter/8,
	               (plr.ypos/8)+5)
	return spr_below
end
-->8
--tab 2: map control

function init_map()
	
	local mdata={
		map_y_back2=-1,
		map_y_back1=-1,
	 map_y=-1,
	 map_y_fore1=-1,
	 map_y_fore2=-1,
	 
	 xdraw=-1,
	 ydraw=-1,
	}
	
	return mdata
	
end

function update_map(md,plr)
	
	md.map_y_back2=-1
	md.map_y_back1=-1
	md.map_y=-1
	md.map_y_fore1=-1
	md.map_y_fore2=-1
	 
	md.ydraw=-1
	
	floor_assert(plr)
	layer_assert(plr)
	
	if plr.floor==2 then
		if plr.layer=="b" then
			md.map_y=0
			md.map_y_fore1=5
			--md.map_y_fore2=10
		elseif plr.layer=="m" then
			md.map_y_back1=0
			md.map_y=5
			md.map_y_fore1=10
		elseif plr.layer=="f" then
			md.map_y_back2=0
			md.map_y_back1=5
			md.map_y=10
		end
		md.ydraw=0
		
	elseif plr.floor==1 then
		if plr.layer=="b" then
			md.map_y=15
			md.map_y_fore1=20
			--md.map_y_fore2=25
		elseif plr.layer=="m" then
			md.map_y_back1=15
			md.map_y=20
			md.map_y_fore1=25
		elseif plr.layer=="f" then
			md.map_y_back2=15
			md.map_y_back1=20
			md.map_y=25
		end
		md.ydraw=40
		
	elseif plr.floor==0 then
		if plr.layer=="b" then
			md.map_y=30
			md.map_y_fore1=35
			--md.map_y_fore2=40
		elseif plr.layer=="m" then
			md.map_y_back1=30
			md.map_y=35
			md.map_y_fore1=40
		elseif plr.layer=="f" then
			md.map_y_back2=30
			md.map_y_back1=35
			md.map_y=40
		end
		md.ydraw=80
		
	end
	
	md.xdraw=plr.xdraw-plr.xpos
	
end

function draw_map_background(md,
                        layered,
                  curr_room_spr)

	if layerd==nil then
		layered=false
	end
	
	if layered then
		if md.map_y_back2!=-1 then
			map(0,md.map_y_back2,
			    md.xdraw,md.ydraw,
			    26,5)
		end
		
		if md.map_y_back1!=-1 then
			map(0,md.map_y_back1,
			    md.xdraw,md.ydraw,
			    26,5)
		end
	end
	
	local flags=fget(curr_room_spr)
	
	flags=bor(flags,0x1)
	flags=bor(flags,0x80)
	print("flags="..flags,
	      0,102,7)
	
	map(0,md.map_y,
		   md.xdraw,md.ydraw,
		   26,5,
		   flags)
	
end

function draw_map_foreground(md,plr)
	
	if md.map_y_fore1!=-1 then
		--[[
		map(0,md.map_y_fore1,
		    md.xdraw,md.ydraw,
		    26,5,
		    0x01) --only draw the
		          --doors leading to
		          --the next layer
		          --into the
		          --foreground
		--]]
		--[[
		sspr(14*8,4*8,
		     16,32,
		     md.xdraw,md.ydraw)
		--]]
		spr_below=get_spr_layer_fwd(plr)
		if fget(spr_below,0) then
			map(0,md.map_y_fore1,
		     md.xdraw,md.ydraw,
		     26,5,
		     0x01)
			     
		end
	end
	
	if md.map_y_fore2!=-1 then
		--[[
		map(0,md.map_y_fore2,
		    md.xdraw,md.ydraw,
		    26,5,
		    0x01) --only draw the
		          --doors leading to
		          --the 2nd layer
		          --into the
		          --foreground
		--]]
		--[[
		sspr(14*8,4*8,
		     16,32,
		     md.xdraw,md.ydraw)
		--]]
	end
	
end
-->8
--tab 3: spr flags + tb txt

--[[

flag 0      : 0x01 : 0000 0001
	unlocked door, wide

flag 1      : 0x02 : 0000 0010
	basement background

flag 2      : 0x04 : 0000 0100
	room background a

flag 3      : 0x08 : 0000 1000
	room background b

flag 4      : 0x10 : 0001 0000
	kitchen background

flag 5      : 0x20 : 0010 0000
	bathroom background

flag 6      : 0x40 : 0100 0000
	brick background

flag 7      : 0x80 : 1000 0000
	stairs

flags 0&7   : 0x81 : 1000 0001
 locked door, wide

flags 1&7   : 0x82 : 1000 0010
	unlocked door, narrow

flags 1,2&7 : 0x86 : 1000 0110
	locked door, narrow

--]]

diary_1_kitchen="mom didn't buy groceries again. she said she forgot but i don't think getting food is something you can forget. josh and andrew took the last leftover chinese food. i tried to tell mom, but she told me to go figure it out before locking herself in her room. i'm so hungry. it feels like no one ever thinks about me. it makes me so mad! that reminds me, the doctor gave me a new medicine for my 'problem.' they said i have to eat before i take it though... i guess i'll have to wait"
diary_2_bedroom="josh and andrew stole my gameboy! they said that since it was theirs first, they can take it whenever they want but they're just trying to bully me. they didn't care about it at all until they saw me playing with it yesterday. i hate them! they're awful and i hope awful things happen to them! i wish they would just go away and leave me alone. i never want to see them again!"
diary_3_hall_closet="dad locked me in the closet. he got pissed when he found out that i broke his favorite mug. he screamed in my face until he was red before dragging me upstairs and throwing me in here. it's been hours, i haven't eaten, and i have to use the bathroom. i wish i had broken more than his stupid mug. like his teeth maybe? i wish i could get away from this shitty family. or better yet, i wish they'd all get away from me."
diary_4_bathroom="i've been having problems with my memory lately. i keep having these blackouts and coming-to in different places, and they keep getting worse. all i can remember about yesterday is leaving the house in the morning and coming home in the afternoon. what did i do all day? i don't know. apparently, i didn't go to school--my teacher called to ask about it. i was lucky that i picked up the phone before my parents. i called my doctor today and they just asked if i was still taking my pills. of course i've been taking them! did i take them today? i can't remember, but the bottle is empty. i must have..."
diary_5_crawlspace="they're gone :)"

locked_door="the door is locked? there must be a key somewhere..."
unlocked_door="i unlocked the door."

txt_closet_key="upstairs closet key"
txt_crawlspace_key="crawlspace key"
txt_bro_bedroom_key="brother's beroom key"
txt_lwr_basement_key="lower basement key"
txt_master_bath_key="master bathroom key"
txt_garage_key="garage key"

pcbed_pill_bottle="these are my pills. i can't remember if i've taken them or not. that happens a lot."
pcbed_key="it's the key to my door. what's it doing under my desk?"

--text box prompts for act 1
--upstairs hall
a1_bro_bedroom_text="it's locked, as usual. but everything's quiet on the other side..."
a1_hall_closet_door="it's locked. i bet the key is in my parents' room."

--master bedroom
a1_closet_key="it's the key to the clost. normally i'm not supposed to touch this but..."
a1_bathroom_door="it's locked. it sounds like the sink is dripping in there."
a1_check_nightstand="dad's stuff isn't here, but mom's is. so where is she?"

--upstairs bathroom
a1_check_mirror="i look tired. but i was just sleeping wasn't i?"
a1_check_shower="it's still wet. there's a weird metalic smell too..."

--hall closet
a1_check_closet_page="this is one of my diary pages... what's it doing here?"

--dining room
a1_check_wall_clock="it's almost midnight. everyone should be home, where could they be? something feels off..."
a1_check_overturned_chairs="why are these just lying on the floor? mom should have never picked them up..."
a1_check_dining_room_table="it's been a long time since we've eaten here together."

--living room
a1_check_recliner="this is where dad sits when he gets back from work."
a1_check_family_photo="we almost look like a happy family in this one."

--kitchen
a1_check_counter="there's a knife missing from the knife block. for some reason, that feels wrong."
a1_check_kitchen_page="this is one of my diary pages... what's it doing here?"
a1_check_trash="ugh, something's leaking out of the garbage! it smells awful!"

--family room
a1_check_couch="there's a layer of dust over everything. we don't spend much time here."

--downstairs bathroom
a1_check_cabinet="...? are these... my pill bottles? but i've been taking them, haven't i?"
a1_check_bathroom_page="this is one of my diary pages... what's it doing here?"
a1_check_bathroom_key="this key... it's for the crawlspace in the basement. what's it doing here?"

--main basement
a1_check_key="this is the key to my brothers' room. it doesn't belong here..."
a1_check_lower_basement_door="this goes to the lower basement. it's always locked. so why does that feel so wrong?"
a1_check_crawlspace_door="the door is locked. the key went missing a while ago, but the dust has clearly been disturbed in front of it."

--crawlspace
a1_check_knife="a kitchen knife jammed into a box. it has blood on it..."
a1_check_crawlspace_page="this is one of my diary pages... what's it doing here?"

--text box prompts for act 2

--act 2 triggers when the
--player enters the brothers'
--bedroom. the particle
--effects begin, along with
--very minor additions of
--corruption prites throughout
--the house

--brothers' bedroom
a2_check_bed_1="this is josh's bed. it's soaked in blood..."
a2_check_bed_2="this is andrew's bed. it looks like something hit it hard and cracked the wood."
a2_check_blood_1="are they...? but, their bodies aren't here..."
a2_check_blood_2="this is horrible... they didn't deserve this... did they?"
a2_check_master_bathroom_key="the key to my parents' bathroom? why in the world is it here?"

--master bathroom

--corruption effect intensifies
--throughout (particles and
--sprites). reflections will
--now show the alternate
a2_enter_master_bathroom="oh god, here too? who did this? this is like a nightmare..."
a2_check_shower="it looks like there was a struggle. the rod fell out and the curtains are a mess..."
a2_check_bathroom_blood="there are drag marks in the blood. somebody moved the body."
a2_check_mirror="..."
a2_check_garage_key="the key to the garage? dad is the one who carries this."

--garage

--the corruption effect will
--become the strongest
a2_enter_garage="...! oh no... oh god..."
a2_check_body="it's dad... there are huge gashes in his body. his face is twisted in pain."
a2_check_blood_g1="i may not have had a good relationship with him, but this is terrifying."
a2_check_blood_g2="how could this have happened? who could have done something so terrible?"
a2_check_blood_g3="i can't believe he's gone"
a2_check_lower_basement_key="the key to the lower basement. i'm not sure i want to know what's down there..."

--act 3

--enter the lower basement.
--the pc walks toward the
--bodies and stops near a
--mirror. the reflection is
--still the alternate
a3_dialogue={
	{"p","oh my god... this is sick..."},
	{"a","sick, is it? that's rich, coming from you."},
	{"p","who's there? show yourself!"},
	{"a","show myself? i'm already here..."},
	{"p","what the-? w-who are you?"},
	{"a","tut tut, how rude! you don't recognize me? after everything we've been through? for shame."},
	{"p","what are you talking about? this doesn't make any sense!"},
	{"a","come now, do i need to spell things out for you? i'm a aprt of you. i've been with you for a long time, and i finally decided to do something about this horrendous family of ours."},
	{"p","are you saying...?"},
	{"a","i got rid of them. without those pills keeping me down, i was finally able to take control for a time. i did what we always wanted to do but you could never do."},
	{"p","this is so wrong. you're crazy!"},
	{"a","i don't care what you think, you've been a pushover your whole life, but when ^i'm^ in calling the shots, things will be different."},
	{"p","what? w-what are you going to do?"},
	{"a","i'm taking the reins"},
	--the corruption effect
	--covers the screen
}
a3_bad_ending={
	--the corruption effect clears
	--revealing the alternate and
	--the player have switched
	--places. the alternate is
	--outside the mirror while the
	--player is inside.
	{"p","what? no! let me go!"},
	{"a","i'm sorry, but that won't be happening. i'm going to take care of loose ends while you take a nice, long rest."},
	--the alternate walks away and
	--through the door, leaving
	--the pc in the mirror
	{"p","no, stop! don't leave me in here! noooo!"},
	--the screen fades to black
	--with the text "bad ending"
	{"n","bad ending"},
}
a3_good_ending={
	--sound of breaking glass.
	--when corruption clears from
	--the screen, the mirror is
	--destroyed
	{"p","i'm not going to let that happen. just because they were terrible to me doesn't mean i should be terrible too. i won't let this happen ever again..."},
	--the screen fades to black
	--with the text "good ending"
	{"n","good ending"},
}

function init_locked_door_tb()
	init_textbox(locked_door,"p",8)
end

function init_unlocked_door_tb()
	init_textbox(unlocked_door,"p",8)
end

-->8
--tab 4: object manager

function init_obj_mgr()
	
	local object_manager={}
	
	return object_manager
	
end

function update_obj_mgr(mgr)
end

function draw_obj_mgr(mgr,plr)
	--printh(#mgr)
	for i=1,#mgr do
		if mgr[i].floor==plr.floor and
		   mgr[i].layer==plr.layer then
		 
		 --printh("drawing obj["..i.."]")
		 
			if mgr[i].size=="s" then
				draw_sobj(mgr[i],plr)
			elseif mgr[i].size=="l" then
				draw_lobj(mgr[i],plr)
			end
		end
	end
end

function init_objs(mgr)
	
	--initialize objects here
	
	--dining room table
	add(mgr,init_lobj("table",
	                  48,32,
	                  24,16,
	                  16,184,
	                  1,"m",
	                  false))
	
	--bed (player bedroom)
	add(mgr,init_lobj("plr bed",
	                  96,16,
	                  32,16,
	                  144,24,
	                  2,"b",
	                  false))
	
	--bed (master bedroom)
	add(mgr,init_lobj("mst bed",
	                  96,16,
	                  32,16,
	                  144,104,
	                  2,"f",
	                  false))
	
end

function init_interactibles(int_mgr)
	
	--pill bottle in bedroom
	add(int_mgr,init_sobj("pill bottle",
	                      27,
	                      152,24,
	                      2,"b",
	                      false,
	                      true,
	                      pcbed_pill_bottle,
	                      11))
	
	--pc's bedroom key
	add(int_mgr,init_sobj("my bedroom key",
	                      24,
	                      104,32,
	                      2,"b",
	                      false,
	                      true,
	                      pcbed_key,
	                      8))
	
	--diary page 1 (kitchen)
	add(int_mgr,init_sobj("diary page 1 kitchen",
	                      25,
	                      24,136,
	                      1,"b",
	                      false,
	                      true,
	                      diary_1_kitchen,
	                      9))
	
	--diary page 2 (bedroom)
	add(int_mgr,init_sobj("diary page 2 bedroom",
	                  25,
	                  144,24,
	                  2,"b",
	                  false,
	                  true,
	                  diary_2_bedroom,
	                  9))
	
	--diary page 3 (hall closet)
	add(int_mgr,init_sobj("diary page 3 hall closet",
	                      25,
	                      56,72,
	                      2,"m",
	                      false,
	                      true,
	                      diary_3_hall_closet,
	                      9))
	
	--diary page 4 (downstairs bathroom)
	add(int_mgr,init_sobj("diary page 4 bathroom",
	                      25,
	                      176,136,
	                      1,"b",
	                      false,
	                      true,
	                      diary_4_bathroom,
	                      9))
	
	--diary page 5 (crawlspace)
	add(int_mgr,init_sobj("diary page 5 crawlspace",
	                      25,
	                      104,352,
	                      0,"f",
	                      false,
	                      true,
	                      diary_5_crawlspace,
	                      9))
	
	--closet key (in mst.bedroom)
	add(int_mgr,init_sobj("closet key",
	                      24,
	                      168,112,
	                      2,"f",
	                      false,
	                      true,
	                      txt_closet_key,
	                      8))
	
	--crawlspace key (in dstairs bath)
	add(int_mgr,init_sobj("crawlspace key",
	                      24,
	                      192,152,
	                      1,"b",
	                      false,
	                      true,
	                      txt_crawlspace_key,
	                      8))
	
	--bro's bedroom key (in main basement)
	add(int_mgr,init_sobj("brother's bedroom key",
	                      24,
	                      40,312,
	                      0,"m",
	                      false,
	                      true,
	                      txt_bro_bedroom_key,
	                      8))
	
	--lo basement key (in garage)
	add(int_mgr,init_sobj("lower basement key",
	                      24,
	                      144,232,
	                      1,"f",
	                      false,
	                      true,
	                      txt_lwr_basement_key,
	                      8))
	
	--master bath key (in bro bed)
	add(int_mgr,init_sobj("master bathroom key",
	                      24,
	                      176,64,
	                      2,"m",
	                      false,
	                      true,
	                      txt_master_bath_key,
	                      8))
	
	--garage key (in master bath)
	add(int_mgr,init_sobj("garage key",
	                      24,
	                      64,96,
	                      2,"f",
	                      false,
	                      true,
	                      txt_garage_key,
	                      8))
	
end
-->8
--tab 5: object

--small object
function init_sobj(name_,
                   spr_num_,
                   xpos_,
                   ypos_,
                   floor_,
                   layer_,
                   crp_,
                   interact_,
                   int_text_,
                   int_sprn_)
	
 assert(name_!=nil)
 assert(spr_num_!=nil)
 assert(xpos_!=nil)
 assert(ypos_!=nil)
 assert(floor_!=nil)
 assert(layer_!=nil)
 assert(crp_!=nil)
 assert(interact_!=nil)
 if interact_!=nil then
 	assert(int_text_!=nil)
 	assert(int_sprn_!=nil)
 end
	
	local small_object={
		size="s",
		name=name_,
		spr_num=spr_num_,
		xpos=xpos_,
		ypos=ypos_,
		floor=floor_,
		layer=layer_,
		crp=crp_,
		interact=interact_,
		int_text=int_text_,
		int_sprn=int_sprn_,
	}
	
	return small_object
	
end

function draw_sobj(sobj,plr)
	
	if sobj.crp==true then
		update_corruption(crp,
		                  sobj.xpos-plr.xpos+plr.xdraw+4,
		                  sobj.ypos-plr.ypos+plr.ydraw+4)
	end
	
	spr(sobj.spr_num,
	    sobj.xpos-plr.xpos+plr.xdraw,
	    sobj.ypos-plr.ypos+plr.ydraw)
	
end

--large object
function init_lobj(name_,
                   sx_,sy_,
                   sw_,sh_,
                   xpos_,ypos_,
                   floor_,
                   layer_,
                   crp_,
                   dw_,dh_)
	
	assert(name_!=nil)
	assert(sx_!=nil)
	assert(sy_!=nil)
	assert(sw_!=nil)
	assert(sh_!=nil)
	assert(xpos_!=nil)
	assert(ypos_!=nil)
	assert(floor_!=nil)
	assert(layer_!=nil)
	assert(crp_!=nil)
	
	local large_object={
		size="l",
		name=name_,
		sx=sx_,
		sy=sy_,
		sw=sw_,
		sh=sh_,
		xpos=xpos_,
		ypos=ypos_,
		floor=floor_,
		layer=layer_,
		crp=crp_,
		dw=dw_,
		dh=dh_,
	}
	
	if large_object.dw==nil then
		large_object.dw=large_object.sw
	end
	
	if large_object.dh==nil then
		large_object.dh=large_object.sh
	end
	
	return large_object
	
end

function draw_lobj(lobj,plr)
	
	if lobj.crp==true then
		update_corruption(crp,
		                  lobj.xpos-plr.xpos+plr.xdraw+(lobj.dw/2),
		                  lobj.ypos-plr.ypos+plr.ydraw+(lobj.dh/2))
	end
	
	sspr(lobj.sx,lobj.sy,
	     lobj.sw,lobj.sh,
	     lobj.xpos-plr.xpos+plr.xdraw,
	     lobj.ypos-plr.ypos+plr.ydraw,
	     lobj.dw,lobj.dh)
	
end
-->8
--tab 6: text box

tb_char_width=25
tb_linex=16
tb_line1y=113
tb_line2y=119

function init_textbox(str_,
                      char_,
                      spr_num_)
	--char_=character
	--"p"=player
	--"a"=alternate
	--"n"=narrator/descriptions
	
	assert(str_!=nil)
	assert(char_!=nil)
	assert(spr_num_!=nil)
	
	global_tb={
		str=str_,
		col=-1,
		lines={},
		curr_line=1,
		spr_num=spr_num_,
		btn_released=false,
	}
	
	if char_=="p" then
		global_tb.col=7
	elseif char_=="a" then
		global_tb.col=8
	elseif char_=="n" then
		global_tb.col=13
	else
		assert(false)
	end
	
	--split string into lines
	--if it's longer than the
	--textbox line length
	if #str_>tb_char_width then
		for i=1,#str_,tb_char_width do
			add(global_tb.lines,sub(str_,i,i+tb_char_width-1))
		end
	else
		add(global_tb.lines,str_)
	end
	
	--[[
	for linestr in all(global_tb.lines) do
		printh(linestr)
	end
	--]]
	
end

function update_textbox()
	
	if btnp(❎) and
	   global_tb.btn_released==true then
		global_tb.curr_line+=1
		global_tb.btn_released=false
		if global_tb.curr_line>#global_tb.lines then
			--printh("global_tb.curr_line="..global_tb.curr_line)
			--printh("#global_tb.lines="..#global_tb.lines)
			global_tb=nil
		end
	elseif not(btn(❎)) then
		global_tb.btn_released=true
	end
	
end

function draw_textbox()
	--left edge of text box
	sspr(80,64,
	     8,16,
	     0,111)
	
	--middle of text box
	sspr(88,64,
	     8,16,
	     8,111,
	     111,16)
	
	--right edge of text box
	sspr(80,64,
	     8,16,
	     119,111,
	     8,16,
	     true,
	     false)
	
	--icon for text box
	spr(global_tb.spr_num,4,115)
	
	--draw text for global_tb
	print(global_tb.lines[global_tb.curr_line],
	      tb_linex,tb_line1y)
	if #global_tb.lines>1 and
	   global_tb.curr_line+1<=#global_tb.lines then
		print(global_tb.lines[global_tb.curr_line+1],
		      tb_linex,tb_line2y)
	end
	
	--debug textbox line length
	--[[
	print("0        1         2         3",16,113)
	print("123456789012345678901234567890",16,119)
	--]]
	
end
-->8
--tab 7: corruption

c_grav=0.1 --part. gravity
c_max_vel=1 --max init. vel.
c_min_time=2 --time btwn parts
c_max_time=5 --time btwn parts
c_min_life=1 --particle life
c_max_life=15
c_time=0
c_cols={0,2,5}
c_burst=10

function init_corruption()
	
	next_p=rndb(c_min_time,c_max_time)
	
end

function update_corruption(crp,x,y)
	c_time+=1
	if c_time==next_p then
		add_p(crp,x,y)
		next_p=rndb(c_min_time,c_max_time)
		t=0
	end
	--burst
	
	for i=1, c_burst do
		add_p(crp,x,y)
	end
	
	foreach(crp,update_p)
	
end

function draw_corruption(crp,x,y)
	
	foreach(crp,draw_p)
	
end

function rndb(low,high)
	return flr(rnd(high-low+1)+low)
end

function add_p(crp,x,y)
	local p={}
	p.x=x
	p.y=y
	p.dx=rnd(c_max_vel)-c_max_vel/2
	p.dy=rnd(c_max_vel)*-1
	p.life_start=rndb(c_min_life,c_max_life)
	p.life=p.life_start
	add(crp,p)
end

function update_p(p)
	if p.life<=0 then
		del(crp,p) --kill old part.'s
	else
		p.dy+=c_grav --add gravity
		if (p.y+p.dy)>127 then
			p.dy*=-0.8
		end
		p.x+=p.dx --update pos.
		p.y+=p.dy
		p.life-=1 --die a little
	end
end

function draw_p(p)
	local pcol=flr(p.life/p.life_start*#c_cols+1)
	pset(p.x,p.y,c_cols[pcol])
end
-->8
--tab 8: door unlocking

doors={
	
	closet={
		lock=true,
		tiles={
			{x=9,y=6},
			{x=9,y=7},
			{x=9,y=8},
			{x=9,y=9},
		},
		size="narrow",
	},
	
	crawlspace={
		lock=true,
		tiles={
			{x=6,y=41},
			{x=7,y=41},
			{x=6,y=42},
			{x=7,y=42},
			{x=6,y=43},
			{x=7,y=43},
			{x=6,y=44},
			{x=7,y=44},
		},
		size="wide",
	},
	
	bro_bedroom={
		lock=true,
		tiles={
			{x=18,y=6},
			{x=18,y=7},
			{x=18,y=8},
			{x=18,y=9},
		},
		size="narrow",
	},
	
	lo_basement={
		lock=true,
		tiles={
			{x=2,y=36},
			{x=3,y=36},
			{x=2,y=37},
			{x=3,y=37},
			{x=2,y=38},
			{x=3,y=38},
			{x=2,y=39},
			{x=3,y=39},
		},
		size="wide",
	},
	
	master_bath={
		lock=true,
		tiles={
			{x=11,y=11},
			{x=11,y=12},
			{x=11,y=13},
			{x=11,y=14},
		},
		size="narrow",
	},
	
	garage={
		lock=true,
		tiles={
			{x=22,y=26},
			{x=23,y=26},
			{x=22,y=27},
			{x=23,y=27},
			{x=22,y=28},
			{x=23,y=28},
			{x=22,y=29},
			{x=23,y=29},
		},
		size="wide",
	},
	
	bedroom={
		lock=true,
		tiles={
			{x=16,y=6},
			{x=17,y=6},
			{x=16,y=7},
			{x=17,y=7},
			{x=16,y=8},
			{x=17,y=8},
			{x=16,y=9},
			{x=17,y=9},
		},
		size="wide",
	}
	
}

wide_unlocked_tiles={
	 66, 67,
	 82, 83,
	 98, 99,
	114,115,
}

narrow_unlocked_tiles={
	141,
	157,
	173,
	189,
}

function unlock_wide_door(plr)
	
	printh("attempting to unlock")
	printh("("..plr.xpos..","..plr.ypos..")")
	printh("floor="..plr.floor)
	printh("layer="..plr.layer)
	local unlocked=false
	
	--check for crawlspace unlock
	if 6*8<plr.xcenter and plr.xcenter<=8*8
	   and plr.floor==0
	   and plr.layer=="m" then
		if search_for_key("crawlspace",plr) then
			set_wide_door_tiles(doors.crawlspace.tiles)
			doors.crawlspace.lock=false
			unlocked=true
		end
	
	--check for lo basement unlock
	elseif 2*8<plr.xcenter and plr.xcenter<=4*8
	       and plr.floor==0
	       and plr.layer=="m" then
		if search_for_key("lower basement",plr) then
			set_wide_door_tiles(doors.lo_basement.tiles)
			doors.lo_basement.lock=false
			unlocked=true
		end
	
	--check for garage unlock
	elseif 22*8<plr.xcenter and plr.xcenter<=24*8
	       and plr.floor==1
	       and plr.layer=="m" then
	 if search_for_key("garage",plr) then
	 	set_wide_door_tiles(doors.garage.tiles)
	 	doors.garage.lock=false
	 	unlocked=true
	 end
	
	--check for bedroom door
	elseif 16*8<plr.xcenter and plr.xcenter<=18*8
	       and plr.floor==2
	       and plr.layer=="b" then
	 printh("bedroom door unlock attempt")
		if search_for_key("my bedroom",plr) then
			set_wide_door_tiles(doors.bedroom.tiles)
			doors.bedroom.lock=false
			unlocked=true
		end
	end
	
	if unlocked==true then
		init_unlocked_door_tb()
	end
	
end

function unlock_narrow_door(plr)
	
	local unlocked=false
	
	printh("("..plr.xpos..","..plr.ypos..")")
	
	
	--check for closet unlock
	if 9*8<plr.xpos and plr.xpos<=11*8
	   and plr.floor==2
	   and plr.layer=="m" then
	 if search_for_key("closet",plr) then
	 	set_narrow_door_tiles(doors.closet.tiles)
	 	doors.closet.lock=false
	 	unlocked=true
	 end
	
	--check for master bath unlock
	elseif 11*8<plr.xpos and plr.xpos<=13*8
	   and plr.floor==2
	   and plr.layer=="f" then
		if search_for_key("master bathroom",plr) then
			set_narrow_door_tiles(doors.master_bath.tiles)
			doors.master_bath.lock=false
			unlocked=true
		end
	
	--check for bro bedroom unlock
	elseif 15*8<plr.xpos and plr.xpos<=17*8
	       and plr.floor==2
	       and plr.layer=="m" then
	 if search_for_key("brother's bedroom",plr) then
	 	set_narrow_door_tiles(doors.bro_bedroom.tiles)
	 	doors.bro_bedroom.lock=false
	 	unlocked=true
	 else --don't have the key
	 	if act==1 then
	 		--text box goes here
	 	elseif act==2 then
	 		--text box goes here
	 	elseif act==3 then
	 		--text box goes here
	 	end
	 end
	
	end
	
	if unlocked==true then
		init_unlocked_door_tb()
	end
	
end

function search_for_key(room_name,plr)
	printh("room name="..room_name)
	printh("#plr.keys="..#plr.keys)
	for i=1,#plr.keys do
		printh("substring="..sub(plr.keys[i].name,1,#room_name))
		if sub(plr.keys[i].name,1,#room_name)==room_name then
			printh("key accepted")
			return true
		end
	end
	
	return false
	
end

function set_wide_door_tiles(tiles)
	assert(#tiles==#wide_unlocked_tiles)
	for i=1,#tiles do
		mset(tiles[i].x,tiles[i].y,wide_unlocked_tiles[i])
	end
end

function set_narrow_door_tiles(tiles)
	assert(#tiles==#narrow_unlocked_tiles)
	for i=1,#tiles do
		mset(tiles[i].x,tiles[i].y,narrow_unlocked_tiles[i])
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000ffffff0000000aaaa0000000000000000880067760066666665666566654444444454544544
0000000000000000000000000000000000000000000000000000f0f00f0f00000aa99aa07777777000000668067777606777776567555765ffffffff55545454
000eeeeee0000000000eeee000000000000eeee0000000000000f0f00f0f000009a00a9007667670000066800049940067777765655555654444444454545554
00eeeeeeeeee000000eeeeeeeee0000000eeeeeeeeee00000000f0f00f0f0000009aa900777777700d066800006666006777776555555555ffffffff44445454
0eeeeeeeeeeee0000eeeeeeeeeee00000eeeeeeeeeeee0000000f0f00f0f0000000aa0000767667000d660000065560067777765655555654444444444444444
0eeeeeeeeeeeee000eeeeeeeeeeee0000eeeeeeeeeeeee000000f0f00f0f000000aaa00077777770011d0000006555006777776567555765ffffffff54454444
77e7e7eeee7e7e007e7ee7eee7e7ee000eee7eeee7e7ee000000f0f00f0f0000009aaa00076667701110d0000066660066666665666566654444444454454444
ee7eeef7efeeee00e74eee7eeeeeee00ee7eeef7eeeeee000000ffffffff0000000999007777777001000000004994006555555565555555ffffffff55455444
ee44eef44eeeee00e44fee44eeeeee00ee44eef44eeeee00000dddddddddd000000000000000000000000000000000006666666511111111f55f555f44244444
ee99ffe99feeee00e99fffe9ffeeee00ee99fef99feeee0000dddddddddddd000000000000000000000000000000000066666665111111115ffff5ff44244444
eeffffffffeeee00effffffffeeeee00eeffffffffeeee0000ffffffffffff00000000000000000000000000000000006666666511111111ff5ff5ff22222222
eeeffffffeeeee00eeefffffffeee000eeeffffffeeeee0000f0500000050f0000000000000000000000000000000000666666651111111155fff5ff44444244
0eeff444ffe000000eef444fffe000000eef444fffe0000000f0400000040f00000000000077700000000000000000006666666511111111fffff55f44444244
0e0efffff40000000e0effff440000000e0efffff400000000f0400000040f0000a00aa007767767000000000f65f7006666666511111111555f5fff44444244
000000044f000000000000044f000000000000044f00000000f0000000000f000a0aa0007767767000dd000009659600666666651111111155ffff5f22222222
00000001111000000000001111110000000000011110000000f0000000000f000aa000000007770011d6668804664d0066666665111111115f5f55ff44244444
00000011c111100000000011c11c100000000111cc11100000000000000000000000011111111111111000000000000000000000000000000000000000000d00
000001c11c1c1100000001c11c1c1000000001c1111c1000000004444440000000011dddddddddddddd11000000000000000000000000000000000000000d0d0
0000011ddd1cc1000000011ccd1cc10000001c1ccc1cc1000004455555544000001dd11111111111111dd1000000000000d0000000000000000000000000d0d0
00001c1ddd1ccc1000001c1ddd1ccc1000001c1dd1ccc100004554444445540001d111111111111111111d10000000000d0d000000000000000000000000d00d
00011c1ccc1ccc1000011c1ccc1ccc100001cc1dd1ccc100004544444444540001d111111111111111111d10000000000d0d000000000000000000000000d00d
0001cc1ccc1ccc1000011c1ccc1c11100011cc1cc1ccc10004544444444445401d11111111111111111111d100000000d00eeeeeeeeeeeeeeeeee7777777700d
00011c1ddd1cc1100001c11ddc11cc100011c1dd1cc1110005554444444455501ddddd111111111111ddddd100000000d0eeeeeeeeeeeeeeeeeeee777777770d
0001c1ddddc11c100001c1dddd1cc100001c11dd111cc1005444544444454445d11111d1111111111d11111d00000000deeeeeeeeeeeeeeeeeeeeee77777777d
000011ccccc11100000111cccc111000000111ccc11110005545544444455455dddd1dd1111111111dd1dddd00000000deeeeeeeeeeeeeeeeeeeeeee7777777d
00004411111444000000441111444000000444111444000044545555555545441111d1dddddddddddd1d111100000000d888888888888888888888886666666d
0000ff550055ff00000fff55005ff000000ff05505ff000044544444444445441111d11111111111111d111100000000d888888888888888888888886666666d
0000ff550055ff00000fff55eefff000000ff0550fff000044555555555555441111dddddddddddddddd111100000000dddddddddddddddddddddddddddddddd
000000550055000000000055ee550000000000550055ee0044544444444445441111d11111111111111d111100000000d050000000000000000000000000050d
0000000500050000000000000e050000000000050000ee0045444444444444541111d11111111111111d111100000000d010000000000000000000000000010d
000000ee00ee00000000000000ee0000000000ee00000e0045555555555555541111d11111111111111d111100000000d000000000000000000000000000000d
0000eeee0eee0000000000000eee00000000eeee0000000044400000000004441111d11111111111111d111100000000d000000000000000000000000000000d
55555555555555555555555555555555777777777777777700000000000000000000000000000000567676664000000000cccc0000cccc0000cccc0000cccc00
54444444444444455444000000000005777777777777777700009999999999999999000000000000dd7d7d746000000000c66c0000c66c0000c55c000c5555c0
544444444444444554444444000000057777777777777777000999999999999999999000000000000056767446000000ccc66cccccc66cccccc55cccc565565c
5444444444444445544444444440000577777777777777770099999999999999999999000000000000dd7d7447660000c555655cc555655cc555555cc556655c
544454444444454554444444444000057777777777777777099999999999999999999990000000000000557647076000c555555cc556555cc556555cc556655c
544454444444454554454444544000057777777777777d77999999999999999999999999000000000000dd7d47070600ccc55cccccc66cccccc66cccc565565c
5444544444444545544544445440000577777777777776d744444444444444444444444400000000000000556707076000c55c0000c66c0000c66c000c5555c0
5444544444444545544544445440000577777777777777d740001000000000000001000400000000000000ddd707076000cccc0000cccc0000cccc0000cccc00
5444544444444545544544445440000577777777777777d740005000000000000005000400000000000000055507070666666665666666650000000000000000
544454444444454554454444444000057777777777777d67400050000000000000050004066600000000000ddd07070767777765677777650000000000000000
54445444454444455445445444400005777777777777767740005000000000000005000466566000000000045555070767777765677777650000000000000000
5444444445444445544444544440000577777777777777774000500000000000000500046505600000000004dddd0707dd777765677777dd0000000000000000
54444444454444455444445444400005dddddddddddddddd40000000000000000000000400056000000000044555550777d7776567777d770000000000000000
5444444444444445544444444440000577777777777777774000000000000000000000048005600c000000044ddddd0777d7776567777d770000000000000000
54444444444994455444444444990005777777777777777740000000000000000000000456056065000000044555555566d6666566666d660000000000000000
544445444499994554444444999900057777777777777d7740000000000000000000000456056065000000044ddddddd66555555655555660000000000000000
5444454444999945544454449999000577777777777776d7dddddddddddddddd6666666666666666000000044555555566000000000000660000000000000000
5444454444599545544454445599000577777777777777d7dddddddddddddddd6666666666666666000000044ddddddd66777770077777660000000000000000
5444454444555545544454445550000577777777777777d7555555555555555566555556655555660000006445555500667ccc7777ccc7660000000000000000
544445444445544554444444455000057777777777777d6755555555555555557777777777777777000066744ddddd0007777777777777700000000000000000
544444444444444554444444444000057777777777777677444444444444444477dddddddddddd77000670744555000000777770077777000000000000000000
54444444444444455444444444400005777777777777777745555554455555547776666666666777006070744ddd000000666660066666000000000000000000
54444444444444455444444444400005777777777777777745444454454444547777777777777777067070744500000007666667766666700000000000000000
54454444454444455454444544400005777777777777777745444454454444547755555555555577067070744d00000007777777777777700000000000000000
54454444454444455454444544400005777777777777777745444454454444547755555555555577607070644000000060707064400000000000000000000000
544544444544444554544445444000057777777777777777454449544594445477555555555555777bb070d440000880707070d4400000000000000000000000
54454444454444455454444545400005777777777777777745444954459444547755555555555577bbbb66644000088070706664400000000000000000000000
544444444544544554444444454000057777777777777777454444544544445477555555555555777bb0ddd4400008807070ddd4400000000000000000000000
544444444444544554444444444000057777777777777777454444544544445477555555555555777bb666644000088070666664400000000000000000000000
544444444444444554444444444000057777777777777777454444544544445477555555555555777bbdddd44000088070ddddd4400000000000000000000000
544444444444444554444444000000057777777777777777455555544555555477777777777777776bb666644000888866666664400000000000000000000000
54444444444444455444000000000005777777777777777744444444444444447777777777777777dbbdddd440000880ddddddd4400000000000000000000000
c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1000000000000111111111111111111111111055555555555555500550000005500000000000000000000
00000000000000000000000000000000000000000000000000000000177166611171666117716661051111111111111100550000005500450000000000000000
c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1000000000000711761161771611671176116051111111111111100550000005504450000000000000000
00000000000000000000000000000000000000000000000000000000111766611171666171776661051111111111111100550000005544450000000000000000
c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1000000000000117161161171611677176116051111111111111100550000005544450000000000000000
00000000000000000000000000000000000000000000000000000000171161161171611671176116051111111111111100550000005544450000000000000000
e0e0e0e0e0e0e0e0e0e0e0e0e0e00000000000000000000000000000777766667777666617716666051111111111111100550000005545450000000000000000
00000000000000000000000000000000000000000000000000000000111111111111111111111111051111111111111100550000005545450000000000000000
e0e00414e0e0e0e0e0e0e0e0a4b40000000000000000000000000000111111111111111111111111051111111111111100550000005545450000000000000000
00000000000000000000000000000000000000000000000000000000177161161171611617716116051111111111111100550000005545450000000000000000
e0e00515e0e0e0e0e0e0e0e0a5b50000000000000000000000000000711766661771666671176666051111111111111100550000005545450000000000000000
00000000000000000000000000000000000000000000000000000000111761661171616671776166051111111111111100550000005544450000000000000000
e0e00616e0e0e0e0e0e0e0e0a6b60000000000000000000000000000117161161171611677176116051111111111111100550000005544450000000000000000
00000000000000000000000000000000000000000000000000000000171161161171611671176116051111111111111100550000005544450000000000000000
e0e00717e0e0e0e0e0e0e0e0a7d70000000000000000000000000000777761167777611617716116055555555555555500550000005544450000000000000000
00000000000000000000000000000000000000000000000000000000111111111111111111111111000000000000000009559000005549950000000000000000
c1c1c1c1c1c1c1c1c1c1c1c1c1c100000000000000000000000000001111111111111111111111110000000000000000095590000055499d0000000000000000
00000000000000000000000000000000000000000000000000000000177166661171666617716666000000000000000000550000005545550000000000000000
c1c1c1c1c1c10414c1c1c1c1c1c10000000000000000000000000000711761111771611171176111000000000000000000550000005545450000000000000000
00000000000000000000000000000000000000000000000000000000111761111171611171776111000000000000000000550000005544450000000000000000
c1c1c1c1c1c10515c1c1c1c1c1c10000000000000000000000000000117166611171666177176661000000000000000000550000005544450000000000000000
00000000000000000000000000000000000000000000000000000000171161111171611171176111000000000000000000550000005544450000000000000000
c1c1c1c1c1c10616c1c1c1c1c1c10000000000000000000000000000777761117777611117716111000000000000000000550000005544450000000000000000
00000000000000000000000000000000000000000000000000000000111111111111111111111111000000000000000000550000005545450000000000000000
c1c1c1c1c1c10717c1c1c1c1c1c10000000000000000000000000000000000000000000000000000000000000000000000550000005545450000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000550000005545450000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000550000005545450000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000550000005544450000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000550000005544450000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000550000005544450000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000550000005504450000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000550000005500450000000000000000
00000fff8f9000000000000000000000000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000fffff8ff990000000000000000000880088800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ffffff8ffff9000000000000000000888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0fffffff8fffff900000000000000000088888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0fffffff8fffff900000000000000000008888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff8ffffff90000000000000000088808880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff8ffffff90000000000000000088000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff8ffffff90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff8ffffff90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff8ffffff90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff8ffffff90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0fffffff8fffff900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0fffffff8fffff900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ffffff8ffff9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000fffff8ff990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000fff8f9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000ccccc8ccc10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccc8cccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000002010040000000000000000000000000002088040000000000000000000000000000000000000000000000000000000000000000081810101101000000000808000000000818101011010000000308080202000008181010110103030101080802020000081810101101030301010808080800000
0000000000000000000000008682000000000000000000000000000086820000000000000000000000000000868200000000000000000000000000008682000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
00000000000000000c0c0c0c001d1d1d1d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000c0c0c0c001d1d1d1d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000c0c0c59001d1d1d1d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005c0c6667001d1d1d1d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006c0c7677001d1d1d1d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001d1d1d1d0e0e0e0e0e0e0e0e1d1d1d1d1d1d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001d1d1d8c42434a4b0e0e40418c1d1d1d1d1d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001d1d1d9c52535a5b0e0e50519c1d1d1d1d1d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001d1d1dac62636a6b0e0e6061ac1d1d1d1d1d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001d1d1dbc72737c7b0e0e7071bc1d1d1d1d1d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c0c0c0c0c0c0c0c1d1d1d1d1d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c0c0c0c0c0c0c8c1d1d42431d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c0c0c0c590c0c9c1d1d52531d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000005c0c666766670cac1d1d62631d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006c0c767776770cbc1d1d72731d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d1d1d1d1d1d1d1d1d1d1d0c0c0c0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44450d0d0d0d0d0d0d0d0d0d1d1d1d1d1d1d1d1d1d1d0c0c0c0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54550d0d0d0d0d590d0d0d0d1d1d1d1d1d1d1d1d1d1d0c590c0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
64656667686966670d0d0d0d1d1d1d1d1d1d1d1d1d1d66670c5d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
74757677787976770d0d0d0d1d1d1d1d1d1d1d1d1d1d76770c6d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d0e0e0e0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1d1d1d1d1d1d1d1d1d1d1d4a4b1d1d42430e0e0e0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1d1d1d1d1d1d1d1d1d1d1d5a5b1d1d52530e0e0e0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1d1d1d1d1d1d1d1d1d1d1d6a6b1d1d62630e0e0e0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1d1d1d1d1d1d1d1d1d1d1d7a7b1d1d72730e0e0e0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e001f1f1f1f1f1f1f1f1f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e42430e0e0e0e0e0e001f1f1f1f1f40411f1f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e52530e0e0e0e0e0e001f1f1f1f1f50511f1f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e62630e0e0e0e0e0e001f1f1f1f1f60611f1f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e72730e0e0e0e0e0e001f1f1f1f1f70711f1f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
