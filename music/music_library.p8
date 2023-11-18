pico-8 cartridge // http://www.pico-8.com
version 37
__lua__

--the available songs
library={
	{
		name="last young renegade",
		artist="all time low",
		sfxdata={
			{sfxid= 0,bytes="0x391c00001a520215201a5201f5201a5201e5201a520155201a520215201a5201f5201a5201e5201a520155201a520215201a5201f5201a5201e5201a520155201c5201a520155201c520155201e5201c5201a520"},
			{sfxid= 1,bytes="0xc11c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c0201c0201e0201c0201c0201e0201c0201a020"},
			{sfxid= 2,bytes="0x011c00001e0051e0551e0551e0551e0501e0501a0501a0501f0551f0551e0501e0501c0501c0501e0501e0551e0051e0551e0551e0551e0501e0501a0501a0501c0501c0501e0501c0501c0501a0501705015050"},
			{sfxid= 3,bytes="0x011c00002a0052a0552a0552a0552a0502a05026050260502b0552b0552a0502a05028050280502a0502a0552a0052a0552a0552a0552a0502a050260502605028050280502a0502805028050260502305021050"},
			{sfxid= 4,bytes="0x011c00001e0051e0551e0551e0551e0501e0551a0551a0551f0551f0551e0501e0501c0501c0501e0501e0551e0051e0551e0551e0551e0501e0551a0501a0501c0501c0501e0501c0501c0501e0501c0501a050"},
			{sfxid= 5,bytes="0x011c00002a0052a0552a0552a0552a0502a05526055260552b0552b0552a0502a05028050280502a0502a0552a0052a0552a0552a0552a0502a055260502605028050280502a05028050280502a0502805026050"},
			{sfxid=10,bytes="0x011c0000230552305523055230552305023055210501e0551e050210552105021055000000000021000210502105521050210552105521050210551e0501c0551c0501e0551e0501e05500000000002300023005"},
			{sfxid=11,bytes="0x011c0000230052305523055230552305023055210501e0551e050210552105021055000000000000000210052100521055210552105521050210551e0501e0551c0501e0551e0501e05500000000000000000000"},
			{sfxid=12,bytes="0x011c00001d00026055260552605526055260552605526055260502605526000260502605524000240002400024000260552605526055260552605526055280552805028055240002805028055260502a05028050"},
			{sfxid=13,bytes="0x011c00001e000260552605526055260552605526055280502a0502a0552400026050260552400023050230551e000260502305021050260552605023050210502605526050230502105026050280552805028055"},
			{sfxid=14,bytes="0x011c00000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000002863528635"},
			{sfxid=15,bytes="0x011c00000000000000286350063537615000002863500000006350000028635006353761500000286350000000635000002863500635376150000028635000000063500000286350063537615000002863537610"},
			{sfxid=16,bytes="0x011c00000000000000286350063537615000002863500000006350000028635006353761500000286350000000635000002863500635376150000028635000000063500000286350063537615000002863528635"},
			{sfxid=17,bytes="0x011c00000000034635346353463500000000002863500000006350000028635006353761500000286350000000635000002863500635376150000028635000000063500000286350063537615000002863537610"},
			{sfxid=18,bytes="0x011c00000000034635346353463500000000002863500000006350000028635376103761500000376103761500635000002863537615376003760528635376153760037605286353761537600376052864528645"},
			{sfxid=19,bytes="0x011c00001e5003463534635346351e5001e500286451a5000064500645286451e5000064500645286451e5001e5001e500286451e5001a5001a500286451c5000064500645286451a50000645006452864528645"},
			{sfxid=20,bytes="0x011c00001e5003463534635346351e5001e500286451a5000064500645286451e5000064500645286451e5001e5001e500286451e5001a5001a500286451c5000064500645286451a50000645006452864528645"}
		},
		start=0,
		patterns={
			{patid=0,bytes="0x0100014e44"},
			{patid=1,bytes="0x0000010e44"},
			{patid=2,bytes="0x0000010a0f"},
			{patid=3,bytes="0x0000010b10"},
			{patid=4,bytes="0x0000010c11"},
			{patid=5,bytes="0x0000010d12"},
			{patid=6,bytes="0x0000130203"},
			{patid=7,bytes="0x0200140405"},
		},
		art={},
	},
	{
		name="save rock and roll",
		artist="fall out boy",
		sfxdata={
			{sfxid= 6,bytes="0x011800002353020530235302053025530205302353020530235302053025530205302353023530205302053023530205302353020530255302053023530205302353020530255302053023530235302053020530"},
			{sfxid= 7,bytes="0x01180000235302053023530205302553020530235302053023530205302553020530235302353020530205302153021535215302153521530205301e5301c5302153021535215302153521530205301e53017530"},
			{sfxid= 8,bytes="0x0118000020050200552005020055200501e050000001f0000000000000000001e050230502305023050230501c050190501905000000000000000000000000000000000000000000000000000000000000000000"},
			{sfxid= 9,bytes="0x0118000020050200552005020055200502005526000260002b0002b0001c0551c0501e050200501e0501c0551c0501c0501c0552a0002600026000240002800028000280002a0002a00026000260000000000000"},
			{sfxid=21,bytes="0x011800001c0501c0551c0501c0551c0501c0551c0501c0551e0501e05520055200502005020050200552003420030200302003520024200202002020025200142001020010200150000000000000001c0501c055"},
			{sfxid=22,bytes="0x0118000023055230502305520055200552005520055200551e0551c0501c050200501e0501e0501c0501c0551c050190501905500000000000000000000000000000000000000000000000000000000000000000"},
			{sfxid=23,bytes="0x0118000023050230502305023055200501e0501e0501e0551c0501c05020050200501e0501e0501e0551c0551c0501c05020050200501e0501e0501c0501c0501c0501c0501c0401c04500000000001c0551c050"},
			{sfxid=24,bytes="0x0118000023050230502305023050200501e0501e0501e0501c0501e05020050200552005020050000001c0501e0501e0501c0501c050230522305223052230522305223052230522305200000000000000000000"},
			{sfxid=25,bytes="0x0118000020070200702007020075200702007020070200750060000600006001c0751c0701e0702007020075200701e0701e0701e075200701e0701e0701e0751c0001e000200001e0001c0701e070200701e070"},
			{sfxid=26,bytes="0x01180000200701e0701c0701c07019070190700000019070210752107020070200701e0701e0701c0701c07019070190701c0701c0701e0701e07020075200702007020070000000000000000000000000000000"},
			{sfxid=28,bytes="0x011800000000000000000000000000000000000000000000000000000000000000000000000000000000000015530155351553015535000000000000000000001553015535155301553500000000000000000000"},
			{sfxid=29,bytes="0x01180000000000000000000000000000000000000000000000000000000000000000000000000000000000002d5302d5352d5302d5352d5302c5302a530285302d5302d5352d5302d5352d5302c5302a53023530"},
			{sfxid=30,bytes="0x0118000018000180001800018000180001c0251c0201e020200201e0201e0251e0201e0251e0201e0251e02018000180001800018000180001c0251c0201e020200201e0201e0251e0201e0251e0201e0251e020"},
			{sfxid=31,bytes="0x0118000018000180001800018000180001c0251c0201e0201800018000180001e0201800018000180001e0201800018000180001e0201800018000180001e02018000200201e0201c02018000200201e0201c020"},
			{sfxid=32,bytes="0x011800001903000000000000000019030000000000000000190300000000000000001903019035190301903015030150351503015035150300000000000000001503015035150301503515030000000000000000"},
			{sfxid=33,bytes="0x011800001b313004000f3130c1433061500000000001b3130c1431b3130c1431b313306150000000000000001b313000000f3130c1433061500000000001b3130c1431b3130c1431b31330615000000000000000"},
		},
		start=8,
		patterns={
			{patid= 8,bytes="0x0146215e5e"},
			{patid= 9,bytes="0x0006215e1e"},
			{patid=10,bytes="0x0007215f1f"},
			{patid=11,bytes="0x0106210844"},
			{patid=12,bytes="0x0007210944"},
			{patid=13,bytes="0x0006211544"},
			{patid=14,bytes="0x0007211644"},
			{patid=15,bytes="0x0041211744"},
			{patid=16,bytes="0x0041211844"},
			{patid=17,bytes="0x0006211959"},
			{patid=18,bytes="0x0007211a5a"},
			{patid=19,bytes="0x0006211959"},
			{patid=20,bytes="0x0007211a5a"},
			{patid=21,bytes="0x0006615e1e"},
			{patid=22,bytes="0x02071c201f"},
		},
		art={},
	},
	{
		name="this is gospel",
		artist="panic! at the disco",
		sfxdata={
			{sfxid=34,bytes="0x011800000c17300000000000c1730c17300000000000c1730c17300000000000c1730c17300000000000c1730c17300000000000c1730c17300000000000c1730c17300000000000c1730c17300000000000c173"},
			{sfxid=35,bytes="0x011800000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005001a5501c5501e5501e5501c5501c5501c5501c5551c5501a5501c5501e5501c5501a550"},
			{sfxid=36,bytes="0x011800001a5501a5551a550175501a5501a55017550175501a5501a55517550155501a5501a5501c5501c5500050000500005001a5501e5501e5501c5501c5501c5551c5501c5501a5501c5501e5501c5501a550"},
			{sfxid=37,bytes="0x011800001a5501a5501a555175501a5501a55517550155501a5501a5501755017555175501555515550155500050000500005000050000500005001a5501c5501e5501e5501c5501c5501a5501a550215501e550"},
			{sfxid=38,bytes="0x011800001e5501e5501e5501e5501e5501e5501e5501e55500000000000000000000000000000000000000000000000000000000000000000000001a5501c5501e5501e5501c5501c5501a5501a550215501e550"},
			{sfxid=39,bytes="0x011800001e5501e5501e5501e5501e5501e5501e5501e555000000000000000000000000000000155501555017550175551755017555175501755017555175501755019555195551955019550195501955015550"},
			{sfxid=40,bytes="0x011800001a5501a5501a5551a5551a5501a550155501c5501c5501c5501c5501c5501c5501c5551a5501c5501e5501e5501c5501c5551c5501c5551a5551c5501c5501a5551c5501c5551c5501e5501c5501c550"},
			{sfxid=41,bytes="0x011800002460000000246000000024600000002460000000246000000024600000002460000000246000000030615000003061500000306150000030615000003061500000306150000030615000003061500000"},
			{sfxid=42,bytes="0x011800003061500000306150000030615000003061500000306150000030615000003061500000306150000030615000003061500000306150000030615000003061500000306150000030615000003061500000"},
			{sfxid=43,bytes="0x01180000005001a5551a5551a5551a5551a5551a5551a555005001a5551a5551a5551a5551a5551a5551a55500500005000050000500005000050000500005000050000500005000050000500005000050000500"},
			{sfxid=44,bytes="0x0118000030615000003061500000306150000030615000003061500000306150000030615000003061500000246150000024615000003c61500000246153c615246153c61524615000003c61500000246153c615"},
			{sfxid=45,bytes="0x01180000246150000024615000003c61500000246153c615246153c61524615000003c61500000246153c615246150000024615000003c61500000246153c615246153c61524615000003c61500000246153c615"},
			{sfxid=46,bytes="0x01180000246150000024615000003c615000000000000000000000000000000000000000000000000000000021500215002150021500215002150021500215001f5001f5001f5001f5001f5001f5001e5001e500"},
			{sfxid=47,bytes="0x0118000024000240002400024000240002400026050280502a0502a050280502805026050260502a0502a05021570215702157021570215702157021570215701f5701f5701f5701f5701f5701f5701e5701e570"},
			{sfxid=48,bytes="0x011800001e5701e5701e5701e570240002400026050280502a0502a050280502805026050260502a0502a05021570215702157021570215702157021570215701f5701f5701f5701f5701f5701f5701e5701e570"},
			{sfxid=49,bytes="0x011800001e5701e5701e5701e57000000000001c5001a5001d5001c5001a500000000000026055260502605521570215701e5701e57021570215701e57021570215701e57021570215701e5701e5701c5701c570"},
			{sfxid=50,bytes="0x011800001c0501c05028050280552805028055260502805028050260502a0502a0502805028050260502605021570215701e5701e57021570215701e57021570215701e57021570215701e5701e5701c5701c570"},
			{sfxid=51,bytes="0x011800001c0501c0502805028055280502805526050260502805028050260502805028050260502a0502a050320102d010340102d010360102d01034010320102d01032010340102d010360102d010340102d010"},
			{sfxid=52,bytes="0x01180000320102d010340102d010360102d01034010320102d01032010340102d010360102d010340102d010320102d010340102d010360102d01034010320102d01032010340102d010360102d010340102d010"},
			{sfxid=53,bytes="0x01180000320102d010340102d010360102d01034010320102d01032010340102d010360102d010340103401000500005001a5501c5501e5501e5501c5501c5501c5501c5551c5501a5501c5501e5501c5501a550"},
			{sfxid=54,bytes="0x011800001a0001a0001c0001c0001e0001e0001c0001a0001a0001a0001c0001c0001e0001e0001c0001c0001a0501a0501c0501c0501e0501e0501c0501a0501a0551a0501c0501c0501e0501e0501c0501c050"},
			{sfxid=55,bytes="0x01180000005001a5551a5551a5551a5551a5551a5551a555005001a5551a5551a5551a5551a5551a5551a5551a0501a0501c0501c0501e0501e0501c0501a0501a0551a05021050210501e0501e0501c0501c050"},
			{sfxid=56,bytes="0x01180000005001a5551a5551a5551a5551a5551a5551a555005001a5551a5551a5551a5551a5551a5551a55500000000000000000000000000000000000000000000000000000000000000000000000000000000"},
			{sfxid=57,bytes="0x01180000181431814318143000003c615000000c1430c143000000c1430c143000003c6150000000000000000c17300000000000c1730c17300000000000c1730c17300000000000c1730c17300000000000c173"},
			{sfxid=58,bytes="0x01180000000000000000000000000000000000000000000000000000000000000000000000000000000000003c6150000018143181433c615000000c1430c143000000c1430c143000003c615000001814318143"},
			{sfxid=59,bytes="0x01180000181431814318143000003c615000000c1430c143000000c1430c143000003c615000000000000000181430000018143181433c615000000c1430c143000000c1430c143000003c615000000c1430c143"},
			{sfxid=60,bytes="0x2118000000000000001e5700000000000001001e5700000000000000001e5700000000000000001e5700000000000000000000000000000000000000000000000000000000000000000000000000000000000000"},
			{sfxid=61,bytes="0x0118000000000000001e57000000000001e570000001e5751e5751e5751e570000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"},
			{sfxid=62,bytes="0x011800000000000000000000000000000000000000000000000000000000000000000000000000000000000015550155501555015550155501555015550155501355013550135501355013550135501255012550"},
			{sfxid=63,bytes="0x011800000e5400e5400e5400e5400e5400e5400e5400e545155401554015540155401554015540155401554513540135401354013540135401354013540135451254012540125401254012540125401254012545"},
		},
		start=23,
		patterns={
			{patid=23,bytes="0x01225c235f"},
			{patid=24,bytes="0x0122422444"},
			{patid=25,bytes="0x0022292544"},
			{patid=26,bytes="0x00222a262b"},
			{patid=27,bytes="0x00222c272b"},
			{patid=28,bytes="0x00222d2844"},
			{patid=29,bytes="0x003a2e7e2f"},
			{patid=30,bytes="0x003b3c3e30"},
			{patid=31,bytes="0x003b3d3f31"},
			{patid=32,bytes="0x003b423f32"},
			{patid=33,bytes="0x003b423336"},
			{patid=34,bytes="0x003b423437"},
			{patid=35,bytes="0x0239423538"},
		},
		art={},
	},
	{
		name="walls",
		artist="all time low",
		sfxdata={
			{sfxid= 5,bytes="0x010c00003c67030670306750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"},
			{sfxid= 6,bytes="0x010c00001c6501c6501c6401c62000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"},
			{sfxid= 8,bytes="0x011800001f5301a5351a5301f530265301a5301f53026530215301f5351f53021530235301f53021530235301a5301f5301a5301f530265301a5301f53026530215301f5351f53021530235301f5302153023530"},
			{sfxid= 9,bytes="0x011800001a5201f5201a5201f520265201a5201f52026520215201f5251f52021520235201f52021520235201a5201f5201a5201f520265201a5201f52026520215201f5251f52021520235201f5202152023520"},
			{sfxid=10,bytes="0x011800000c17318d1018d10000003c62539615396150000000000000000c173000003c6250000000000000000c17318d1018d10000003c625396153961500000000000c1730c173000003c6350c1730000000000"},
			{sfxid=11,bytes="0x011800000f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f6250f625"},
			{sfxid=12,bytes="0x0118000000000000002305023055230502305523055230502105521050230501f0501f0501f055000001a0502305523055230502305523050230552305523050210502105023050230501f0501f0501a05023050"},
			{sfxid=13,bytes="0x0118000021050210502105500000000001f0501a0502305021050210502105500000000001f0501a0502105023050230502305023055000000000000000000000000000000000001f57400000000000000000000"},
			{sfxid=14,bytes="0x011800000c1730000000000000003c62500000000000c173000000c1730c173000003c6250000000000000000c17300000000000c1733c625000000000000000000000c1730c173000003c6250c173000003c625"},
			{sfxid=15,bytes="0x011800000f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6350f6351f5751f5751f5751f575"},
			{sfxid=16,bytes="0x011800001f5601f5401f5301f5201f5201f5201f5201f5201f5201f5201f5201f5201f5201f52500000000001f5601f5401f5301f5201f5201f5201f5201f5201f5201f5201f5201f5201f5201f5250050000000"},
			{sfxid=17,bytes="0x0118000000000000001f0501f0501a0501a0501f05026050260501f0501f0501e0501e0501e0501f0501f0501e0501f0501f0501e0501e0501f0501f05026050260501f0501f0501e0501e0501e0501f0501f050"},
			{sfxid=18,bytes="0x0118000018e5018e5000000000003c615000000000000000000000000000000000003c61500000000000000018e5018e5000000000003c615000000000000000000000000000000000003c625000000000000000"},
			{sfxid=19,bytes="0x011800000c143003000c143001000c143003000c143003000c143001000c143001000c143001000c143001000c1430c1330c1230c1230c1230c1230c1230c1230c15300100001000010000100001000000000000"},
			{sfxid=20,bytes="0x011800001f5601f5401f5301f5201f5201f5201f5201f5201f5201f5201f5201f5201f5201f5201f5201f5251f5551f5551f5551f5551f5551f5551f5551f5551f55500000000000000000000000000000000000"},
			{sfxid=21,bytes="0x011800001e0501e0501f0501e0501e0501f0501f0501f0502605526050260552605026050260551a0551a0501c0501c0501c0501c0501c0501c0501c0501c0550000000000000001a0551a0551c0501a0501a050"},
			{sfxid=22,bytes="0x011800002305023050230502105021050210501a0501a0501a0501a05000000000000000000000000001a05021050210552105521050210551e0501e0501f0501f05000000000001a0551a0551c0501a0501a050"},
			{sfxid=23,bytes="0x01180000246551c0001c000246551a0001c0002465518000246551c0001c000246551a0001c000246551a000246551c0001c000246551a0001c000246551c000246551c00000000246551c000000002465500000"},
			{sfxid=24,bytes="0x011800002305023050230502105021050210501a0501a0501a0501a05000000000000000000000000001a05021055210502105521050210551e0501e0501f0501f05000000000001a0551a0551c0501a0501a050"},
			{sfxid=25,bytes="0x011800001f0501f0501f0501a000000001a0501a050210502105021050210501a000180001a000000001e0551e0551e0501e0551e0501e05521050210501f0501f0501f0501d0001a0551a0551c0501a0501a050"},
			{sfxid=26,bytes="0x010c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002465024655246502465500000000002465024655000000000024655246552465524655"},
			{sfxid=27,bytes="0x01180000246551c0001c000246551a0001c0002465518000246551c0001c000246551a0001c000246551a000246551c0001c000246551a0001c000246551c0000000024655246551c00024655000002465524655"},
			{sfxid=28,bytes="0x011800000c3430000024655000000c3430c34324655000000c3430000024655000000c3430c34324655000000c3430000024655000000c3430c34324655000000c3430000024655000000c343246552465500000"},
			{sfxid=29,bytes="0x01180000246551c0001c000246551a0001c0002465518000246551c0001c000246551a0001c000246551a000246551c0001c000246551a0001c000246551c000246551c000000000000000000000000000000000"},
			{sfxid=30,bytes="0x011800002305023050230502105021050210501a0501a0502105021050210502305023050230501e0501f0501e0501c0501c0501c05000000000000000000000000001a0501f0551f0501e0501e0501f0501f055"},
			{sfxid=31,bytes="0x011800001f5451f5451f5451f5451f5451f5451f5451f5451f5451f5451f5451f5451f5451f5451f5451f54521545215452154521545215452154521545215452154521545215452154521545215452154521545"},
			{sfxid=32,bytes="0x011800001f5451f5451f5451f5451f5451f5451f5451f54521545215452154521545215452154521545215451f5451f5451f5451f5451f5451f5451f5451f5452154521545215452154521545215452154521545"},
			{sfxid=33,bytes="0x011800001f5451f5451f5451f5451f5451f5451f5451f54521545215452154521545215452154521545215451f5451f5451f5451f5451f5451f5451f5551f5651f57500000000000000000000000000000000000"},
			{sfxid=34,bytes="0x011800001f0501f0501f0401f03500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"},
		},
		start=0,
		patterns={
			{patid= 0,bytes="0x010a080b44"},
			{patid= 1,bytes="0x010e090b0c"},
			{patid= 2,bytes="0x000e090f0d"},
			{patid= 3,bytes="0x00124a1011"},
			{patid= 4,bytes="0x0013421415"},
			{patid= 5,bytes="0x00171f4316"},
			{patid= 6,bytes="0x001b1f4318"},
			{patid= 7,bytes="0x001c204319"},
			{patid= 8,bytes="0x001d21431e"},
			{patid= 9,bytes="0x020a080b22"},
		},
		art={},
	},
	{
		name="way less sad",
		artist="ajr",
		sfxdata={
			{sfxid= 0,bytes="0x010d00041867518675186750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"},
			{sfxid= 1,bytes="0x330100003267032650326603264032650326303264000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"},
			{sfxid= 2,bytes="0x010d00002805026050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"},
			{sfxid= 3,bytes="0x010300063c623000003c623000003c623000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"},
			{sfxid= 4,bytes="0x010d07082305023050230502105021050210501e0501e050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"},
			{sfxid=35,bytes="0x911a00001a1401a1401e1401e1401e1451e1401a1401914019140191401c1401c1401c1401a140151401714017140171401a1401a1401a14015140171401a1401a14015140171401a1401e500215002350021500"},
			{sfxid=36,bytes="0x411a002026140261402a1402a1402a1452a1402614025140251402514028140281402814026140211402314023140231402614026140261402114023140261402614021140231402614026140211402314021140"},
			{sfxid=37,bytes="0x010d00200c17321500000002150026050260502605028050260502605026050260552605026050210502105023050230502605026055260502605028050280502a05028050280502605026050260500000000000"},
			{sfxid=38,bytes="0x010d00000c17321500215002150026050260502605028050260502605026050260552605026050210502105023050230502605026055260502605028050280502a05028050280502605026050260552605026055"},
			{sfxid=39,bytes="0x011a000026050280502a0502d0502f0502f0502f0502d0502a05018a5026050260502605000000260502305026050260552605026055260502605028050230502605026055000002115521155211551f1501f155"},
			{sfxid=40,bytes="0x011a00001e1501e15521110210502a0552a055280502805028050280500000021050280552805526050260502605026050000002a0552a0552605526055230552305023050210502105023050230502605026050"},
			{sfxid=41,bytes="0x911a0000000000000000000000003c615000000000000000000000000000000000003c615000000000000000000000000000000000003c6150000000000000000000000000000000000000000000000000000000"},
			{sfxid=42,bytes="0x011a00000e1200e0100e0100e0100e0150e0150e0100e0250e1350e0250e0250e0250e0250e0250e0250e0351712517035170351703517035170351703517035000000000000000000001e140211402314021140"},
			{sfxid=43,bytes="0x011a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003060530605306050000030820308203082030820"},
			{sfxid=44,bytes="0x011a00000c173000000c655000003c61500000000000c1730c655199730c173000003c6150000000000000000c1730000000000000003c61500000000000c17300000000000c173000003c6150c173199730c173"},
			{sfxid=45,bytes="0x010d00000e1300e1300e1300e13512130121301213012130121301213512130121350e1300e1350d1300d1300d1300d1300d1300d1351013010130101301013010130101350e1300e13509130091350b1300b130"},
			{sfxid=46,bytes="0x010d00000b1300b1300b1300b1350e1300e1300e1300e1300e1300e13509130091350b1300b1350e1300e1300e1300e13509130091350b1300b1350e1300e1300000000000000000000000000000000000000000"},
			{sfxid=47,bytes="0x010d00003c6103c6130000030614306150000000000000003061300000000000000000000000000c1730000019973000000c1730000024b0024b0024b0024b003061300000000000000000000000000000000000"},
			{sfxid=48,bytes="0x011a00000e1300e135121301213012135121350e1350d1300d1300d1351013010130101350e135091350b1300b1300b1350e1300e1300e100091000b100001000010000100000000000000000000000000000000"},
			{sfxid=49,bytes="0x011a00000e0200e0200e0200e0200e0200e0200e0200d0200d0200d0201002010020100201002010020100200b0200b0200b0200b0200b020090200b0200e0200e020090200b0200e0200e020090200b02009020"},
			{sfxid=50,bytes="0x011a0000246130000024613000000061300000000000c143000000c65518940000003061300000000000000024613000002461300000306130000000000000000000000000000000000000000000003061300000"},
			{sfxid=51,bytes="0x010d00003c6103c6130000030614306150000000000000003061300000000000000000000000000c1730000019973000000c1730000024b1024b1024b1024b103061300000000000000000000000000000000000"},
			{sfxid=52,bytes="0x011a00000c1730000000000000000000000000000000000000000000000000000000000000000000000000000c1730000000000000000000000000000000000021125211251f1150000000000000000000000000"},
			{sfxid=53,bytes="0x011a00000c17324b1024b10000003061300000000000c1730c655199730c17300000306130000000000000000c173000000000000000306130000000000000000000000000000001997324b1024b0524b1024b05"},
			{sfxid=54,bytes="0x011a00001a5301e5311e530000000000000000000001953019530195301c5301c53000000000000000017530175301a5311a5300000000000091300b1300e1300e130091300b1300e13012130091300b13009130"},
			{sfxid=55,bytes="0x011a0000000001a0351a0301e0301a0351a0351a0301e0301a0351a0351a0351a03518c3018c3018c3018c3018c3018c30000000000000000000001a0351a030230302303021030210301e0301e0301c0301a030"},
			{sfxid=56,bytes="0x011a0000000001a0451a0401e0401a0451a0451a0401e0401a0451a0451a0451a04518c4018c4018c4018c4018c4018c40000000000000000000001a0401a040230402307121070210701e0701e0701c0701a070"},
			{sfxid=57,bytes="0x011a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000e5000e50015500155001750017500105000e5000e5500e55015550155501755017550105500e550"},
			{sfxid=58,bytes="0x011a00000e1200e0100e0100e0100e0100e0100e0100e0100e1200e0100e0100e0100e0100e0100e0100e01017110170101701017010170101701017010170101511015010150101501015010150101501015010"},
			{sfxid=59,bytes="0x011a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000c6140c6100c6100c6100c6200c6300c6400c6500000000000000000000018820188201882018820"},
			{sfxid=60,bytes="0x011a00000000000000000001a5751a5751a57500000000000000000000000001a5751a5751a57500000000000000000000000001a5751a5751a5751a0601a060230602306121060210601e0601e0601c0601a060"},
			{sfxid=61,bytes="0x011a00000000000000000001a5751a5751a57500000000000000000000000001a5751a5751a57500000000000000000000000001a5751a5751a57500000000000000000000000000000000000000000000000000"},
		},
		start=10,
		patterns={
			{patid=10,bytes="0x0129232a2b"},
			{patid=11,bytes="0x002c31243d"},
			{patid=12,bytes="0x002c31243d"},
			{patid=13,bytes="0x012f2d2544"},
			{patid=14,bytes="0x00332e2644"},
			{patid=15,bytes="0x0032302734"},
			{patid=16,bytes="0x0035362844"},
			{patid=17,bytes="0x0035362844"},
			{patid=18,bytes="0x00413a3744"},
			{patid=19,bytes="0x003b2a3839"},
			{patid=20,bytes="0x002c31243c"},
			{patid=21,bytes="0x022c31243c"},
		},
		art={},
	},
	{
		name="believer",
		artist="imagine dragons",
		sfxdata={
			{sfxid=nil,bytes=nil},
		},
		start=nil,
		patterns={
			{patid=nil,bytes=nil},
		},
		art={},
	},
	{
		name="higher",
		artist="the score",
		sfxdata={
			{sfxid=nil,bytes=nil},
		},
		start=nil,
		patterns={
			{patid=nil,bytes=nil},
		},
		art={},
	},
	{
		name="irresistible",
		artist="fall out boy",
		sfxdata={
			{sfxid=nil,bytes=nil},
		},
		start=nil,
		patterns={
			{patid=nil,bytes=nil},
		},
		art={},
	},
	{
		name="death of a bachelor",
		artist="panic! at the disco",
		sfxdata={
			{sfxid=nil,bytes=nil},
		},
		start=nil,
		patterns={
			{patid=nil,bytes=nil},
		},
		art={},
	},
	{
		name="birds",
		artist="dempsey hope",
		sfxdata={
			{sfxid=nil,bytes=nil},
		},
		start=nil,
		patterns={
			{patid=nil,bytes=nil},
		},
		art={},
	},
	{
		name="change my mind",
		artist="peach tree rascals",
		sfxdata={
			{sfxid=nil,bytes=nil},
		},
		start=nil,
		patterns={
			{patid=nil,bytes=nil},
		},
		art={},
	},
	{
		name="chicken little",
		artist="spencer sutherland",
		sfxdata={
			{sfxid=nil,bytes=nil},
		},
		start=nil,
		patterns={
			{patid=nil,bytes=nil},
		},
		art={},
	},
}

function init_library()
	--update variables which depend
	--on library size
	list_total_ysize=(list_item_ysize+list_item_yspace)*#library+list_item_yspace
	list_dy_min=vport_ymin-list_total_ysize+viewport_height
	--[[
	scroll_bar_dy_max=scroll_bground_ypos+scroll_ysize
	scroll_bar_height=(viewport_height/list_total_ysize)*scroll_ysize
	]]
end

function add_song(sname,
                  sartist,
                  start)
	--type-check first
	assert(type(sname)=="string")
	assert(type(sartist)=="string")
	assert(type(start)=="number")
	
	--add song with empty data to
	--the library
	add(library,{
		name=sname,
		artist=sartist,
		sfxdata={},
		start_pattern=start,
		patterns={},
		art={}
	})
end

function set_sfxdata(sname,
                     sartist,
                     sfxidnum,
                     sfxbytes)
 --type-check first
 assert(type(sname)=="string")
 assert(type(sartist)=="string")
 assert(type(sfxidnum)=="number")
 assert(sfxidnum%1==0)--must be an int
 assert(type(sfxbytes)=="string")
 assert(sub(sfxbytes,1,2)=="0x")--must be a string of hex characters
 assert(#sfxbytes==170)--must be 170 chars long
 
	--search through the library
	for s=1,#library do
		local song=library[s]
		--if a song with the given
		--name and artist exists...
		if song.name==sname and song.artist==sartist then
			local already_exists=false
			for i=1,#library[s].sfxdata do
				if library[s].sfxdata[i].sfxid==sfxidnum then
					already_exists=true
					assert(already_exists==false)
				end
			end
			
			--add the sfx data if it doesn't already exist
			add(library[s].sfxdata,{
				sfxid=sfxidnum,
				bytes=sfxbytes
			})
		end
	end
end

function set_pattern()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000