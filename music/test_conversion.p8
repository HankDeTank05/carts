pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--testing music conversion
--by hankdetank05

function _init()

	convert_filebytes={
		"0x1c165",
		"0x1c454",
		"0x1cf43",
		"0x18b32",
		"0x1c421",
		"0x1f210"
	}
	
	output_membytes={
		"0x5c5c",
		"0x1c4b",
		"0xdcb9",
		"0xd8a6",
		"0x1c15",
		"0x9f02"
	}
	
	convert_filebits={
		"0b00011100000101100101",
		"0b00011100010001010100",
		"0b00011100111101000011"
	}
	
	output_membits={
		"0b0101110001011100",
		"0b0001110001001011",
		"0b1101110010111001",
		"0b1101100010100110",
		"0b0001110000010101",
		"0b1001111100000010"
	}
	
	conv_output={}
	
	--[[for i=1,#convert_filebits do
		add(conv_output,note_file2mem(convert_filebits[i]))
	end--]]
	
	for i=1,#convert_filebytes do
		add(conv_output,note_file2mem(str_hex2bin(convert_filebytes[i])))
	end
	
	for i=1,#conv_output do
		conv_output[i]=str_bin2hex(conv_output[i])
	end

end

function _update60()
end

function _draw()

	cls(1)
	
	for i=1,#conv_output do
		local note_result_col=8
		--convert note i
		print("convert note "..i..": file 2 mem",0*5,4*(i-1)*6,12)
		if conv_output[i]==output_membytes[i] then
			note_result_col=11
		end
		print("output: "..conv_output[i],0*5,((4*(i-1))+1)*6,note_result_col)
		print("expect: "..output_membytes[i],0*5,((4*(i-1))+2)*6,note_result_col)
	end

end
-->8
--tab 1: util f(x)'s

function str_hex2bin(hexstr)

	local binstr="0b"
	
	for i=3,#hexstr do
	
		local nyble=sub(hexstr,i,i)
		
		if nyble=="0" then
			binstr=binstr.."0000"
		elseif nyble=="1" then
			binstr=binstr.."0001"
		elseif nyble=="2" then
			binstr=binstr.."0010"
		elseif nyble=="3" then
			binstr=binstr.."0011"
		elseif nyble=="4" then
			binstr=binstr.."0100"
		elseif nyble=="5" then
			binstr=binstr.."0101"
		elseif nyble=="6" then
			binstr=binstr.."0110"
		elseif nyble=="7" then
			binstr=binstr.."0111"
		elseif nyble=="8" then
			binstr=binstr.."1000"
		elseif nyble=="9" then
			binstr=binstr.."1001"
		elseif nyble=="a" then
			binstr=binstr.."1010"
		elseif nyble=="b" then
			binstr=binstr.."1011"
		elseif nyble=="c" then
			binstr=binstr.."1100"
		elseif nyble=="d" then
			binstr=binstr.."1101"
		elseif nyble=="e" then
			binstr=binstr.."1110"
		elseif nyble=="f" then
			binstr=binstr.."1111"
		else
			assert(1==0,nyble.." is not a hex digit!")
		end
	end
	
	return binstr

end

function str_bin2hex(binstr)

	assert(sub(binstr,1,2)=="0b","binstr is not a binary string! binary strings must start with '0b'!")
	assert((#binstr-2)%4==0,"the number of bits in binstr must be a multiple of 4!")

	local hexstr="0x"
	
	for i=3,#binstr,4 do
		
		local nyble=sub(binstr,i,i+3)
		assert(#nyble==4,"nyble must have 4 binary digits!")
		
		if nyble=="0000" then
			hexstr=hexstr.."0"
		elseif nyble=="0001" then
			hexstr=hexstr.."1"
		elseif nyble=="0010" then
			hexstr=hexstr.."2"
		elseif nyble=="0011" then
			hexstr=hexstr.."3"
		elseif nyble=="0100" then
			hexstr=hexstr.."4"
		elseif nyble=="0101" then
			hexstr=hexstr.."5"
		elseif nyble=="0110" then
			hexstr=hexstr.."6"
		elseif nyble=="0111" then
			hexstr=hexstr.."7"
		elseif nyble=="1000" then
			hexstr=hexstr.."8"
		elseif nyble=="1001" then
			hexstr=hexstr.."9"
		elseif nyble=="1010" then
			hexstr=hexstr.."a"
		elseif nyble=="1011" then
			hexstr=hexstr.."b"
		elseif nyble=="1100" then
			hexstr=hexstr.."c"
		elseif nyble=="1101" then
			hexstr=hexstr.."d"
		elseif nyble=="1110" then
			hexstr=hexstr.."e"
		elseif nyble=="1111" then
			hexstr=hexstr.."f"
		else
			assert(1==0,nyble.." is not equivalent to any hex digit!")
		end
		
	end
	
	return hexstr

end

function note_file2mem(filebits)

	--filebits is a string
	--starting with "0b" followed
	--by twenty characters, all
	--ones or zeros
	
	assert(sub(filebits,1,2)=="0b","filebits is not a binary string! binary strings must start with '0b'!")
	assert(#filebits==20+2,"filebits is not the correct length! must be 20 binary digits with a leading '0b'!")

	local membits="0b"
	
	--cust./reg. inst. (1 bit)
	membits=membits..sub(filebits,9+2,9+2) --9th bit, add two because of leading '0b'
	
	--effect (3 bits)
	membits=membits..sub(filebits,18+2,20+2) --bits 18-20 from filebits
	
	--volume (3 bits)
	membits=membits..sub(filebits,14+2,16+2) --bits 14-16 from filebits
	
	--waveform (3 bits)
	membits=membits..sub(filebits,10+2,12+2) --bits 10-12 from filebits
	
	--pitch (6 bits)
	membits=membits..sub(filebits,3+2,8+2) --bits 3-8 from filebits
	
	--finish by swapping upper and
	--lower bytes of membits
	membits=sub(membits,1,2)..sub(membits,11,18)..sub(membits,3,10)
	
	assert(sub(membits,1,2)=="0b","membits is not a binary string! binary strings must start with '0b'!")
	assert(#membits==16+2,"membits is not the correct length! must be 16 binary digits with a leading '0b'!")
	
	return membits

end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
