--此lua是经验丹,暂时注释掉，不用
function FreeCharExpSave( charaindex, getexp )
	itemindex = -1;
	itemindex = char.Finditem(charaindex, 2258);--获取经验丹
	if itemindex > -1 then
		if item.getInt(itemindex, "堆叠") > 1 then
			return;
		end
		local itemexp = other.atoi(item.getChar(itemindex, "字段"));
		if item.getInt(itemindex, "敏") == 140 then--当大于这个值时，就为圆满了。敏记录经验丹等级
			return;
		end

		if item.getInt(itemindex, "攻") > 1 then--攻为经验丹初始
			getexp = getexp + expdata1[item.getInt(itemindex, "攻") - 1];
			item.setInt(itemindex, "攻",0);
		end
		
		if item.getInt(itemindex, "敏") == 0 then--修复经验丹初始等级为0的问题
			item.setInt(itemindex, "敏",1);
		end
		item.setChar(itemindex, "字段", itemexp + math.ceil(getexp));--字段记录经验丹经验
		for i=1,140 do 
			local nextexp = expdata_[item.getInt(itemindex, "敏")];
			itemexp = other.atoi(item.getChar(itemindex, "字段"));
			if itemexp >= nextexp then
				item.setChar(itemindex, "字段", itemexp - nextexp);
				item.setInt(itemindex, "敏", item.getInt(itemindex, "敏") + 1);
			else
				
				break;
			end
		end
		if item.getInt(itemindex, "敏") == 140 then
			item.setChar(itemindex, "说明", "经验丹收集140级！");
		else
			char.TalkToCli(charaindex, -1, "经验丹得到："..getexp, "黄色")
			nextexp = expdata_[item.getInt(itemindex, "敏")];
			item.setChar(itemindex, "说明", "已收集到" .. item.getInt(itemindex, "敏") .. "级,EXP:" .. item.getChar(itemindex, "字段") .. " ,NEXTEXP:" .. nextexp);
		end
		item.UpdataItemOne(charaindex, itemindex);
		return
	end
end

function mydata()
	expdata_={						2,--2
									6,--3
									18,--4
									37,--5
									67,
									110,
									170,
									246,
									344,
									464,
									610,
									782,
									986,
									1221,
									1491,
									1798,
									2146,
									2534,
									2968,
									3448,
									3978,
									4558,
									5194,
									5885,
									6635,
									7446,
									8322,
									9262,
									10272,
									11352,
									12506,
									13734,
									15042,
									16429,
									17899,
									19454,
									21098,
									22830,
									24656,
									26576,
									28594,
									30710,
									32930,
									35253,
									37683,
									40222,
									42874,
									45638,
									48520,
									51520,
									54642,
									57886,
									61258,
									64757,
									68387,
									72150,
									76050,
									80086,
									84264,
									106110,
									113412,
									121149,
									129352,
									138044,
									147256,
									157019,
									167366,
									178334,
									189958,
									202282,
									215348,
									229205,
									243901,
									259495,
									276041,
									293606,
									312258,
									332071,
									353126,
									375511,
									399318,
									424655,
									451631,
									480370,
									511007,
									543686,
									578571,
									615838,
									655680,
									698312,
									743971,
									792917,
									845443,
									901868,
									962554,
									1027899,
									1098353,
									1174420,
									1256663,
									1345723,
									1442322,
									1547281,
									1661531,
									1786143,
									1922340,
									2071533,
									2235351,
									2415689,
									2614754,
									2835137,
									3079892,
									3352633,
									3657676,
									4000195,
									4386445,
									4824041,
									5322323,
									5892866,
									6550125,
									12326614,
									15496114,
									20025638,
									26821885,
									37698249,
									36734876,
									48097265,
									48290815,
									48487425,
									48687119,
									48889921,
									49095855,
									49304945,
									49517215,
									49732689,
									49951391,
									50173345,
									50398575,
									50627105,
									50858959,
									51244161
									}
	expdata = {};
	local num = 0;
	for i=1,table.getn(expdata_) do 
		num = num + expdata_[i];
		expdata[i] = num;
	end
	expdata1 ={
							2,
							8,
							25,
							62,
							129,
							240,
							409,
							656,
							1000,
							1464,
							2073,
							2856,
							3841,
							5062,
							6553,
							8352,
							10497,
							13032,
							16000,
							19448,
							23425,
							27984,
							33177,
							39062,
							45697,
							53144,
							61465,
							70728,
							81000,
							92352,
							104857,
							118592,
							133633,
							150062,
							167961,
							187416,
							208513,
							231344,
							256000,
							282576,
							311169,
							341880,
							374809,
							410062,
							447745,
							487968,
							530841,
							576480,
							625000,
							676520,
							731161,
							789048,
							850305,
							915062,
							983449,
							1055600,
							1131649,
							1211736,
							1296000,
							1402110,
							1515521,
							1636671,
							1766022,
							1904066,
							2051322,
							2208342,
							2375708,
							2554041,
							2744000,
							2946281,
							3161630,
							3390834,
							3634736,
							3894230,
							4170272,
							4463878,
							4776136,
							5108207,
							5461333,
							5836843,
							6236162,
							6660816,
							7112448,
							7592818,
							8103824,
							8647511,
							9226082,
							9841920,
							10497600,
							11195912,
							11939882,
							12732800,
							13578242,
							14480111,
							15442664,
							16470563,
							17568917,
							18743336,
							20000000,
							21345723,
							22788045,
							24335325,
							25996856,
							27783000,
							29705340,
							31776872,
							34012224,
							36427912,
							39042666,
							41877804,
							44957696,
							48310329,
							51968004,
							55968200,
							60354645,
							65178685,
							70501009,
							76393874,
							82944000,
							95270613,
							110766728,
							130792366,
							157614250,
							195312500,
							252047376,
							320144641,
							388435456,
							456922881,
							525610000,
							594499921,
							663595776,
							732900721,
							802417936,
							872150625,
							942102016,
							1012275361,
							1082673936,
							1153301041,
							1224160000,
};

end

function main()
	mydata();
end
