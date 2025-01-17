function Loop(meindex)
	if char.getWorkInt(meindex, "组队") == 0 or char.getWorkInt(meindex, "组队") == 1 then
		char.DischargeParty(meindex, 1);
		char.TalkToRound(meindex, "时间到了，我走人咯！", "白色");
		npc.DelNpc(meindex);
	end
end

--建立函数Npc_test_Create()
function Create(index, fl, x, y, lv)
	metamo = 101000 + math.random(0, 11) * 10 + math.random(0, 7);
	npcindex1 = npc.CreateSpecialNpc("Max陪练员", metamo, fl, x, y, 0, 352, lv);
	char.setFlg(npcindex1, "组队", 1);
	char.setWorkInt(npcindex1, "离线", 1);
	char.setInt(npcindex1, "等级", lv);
	char.copyChar(index, npcindex1);
	char.setInt(npcindex1, "体力",char.getInt(npcindex1, "体力") + math.random(100, 800));
	char.complianceParameter(npcindex1);
	char.setInt(npcindex1, "HP", char.getWorkInt(npcindex1, "最大HP"));
	char.setInt(npcindex1, "转数", char.getInt(index, "转数"));
	petindex = char.getCharPet(index, char.getInt(index, "战宠"));
	if char.check(petindex) == 1 then
		pindex = char.createPet(57, 1);
		if char.check(pindex) == 1 then
			char.setWorkInt(pindex, "离线", 1);
			petid = char.setCharPet(npcindex1, pindex);
			if petid > -1 then
				char.setChar(pindex, "名字", "陪练专用战宠");
				char.setInt(pindex, "类型", "帮宠");
				char.setInt(npcindex1, "战宠", petid);
				char.copyChar(petindex, pindex);
				char.setInt(pindex, "体力",char.getInt(pindex, "体力") + math.random(100, 800));
				char.complianceParameter(pindex);
				char.setInt(pindex, "HP", char.getWorkInt(pindex, "最大HP"));
			end
		end
	end

	petindex = char.getCharPet(index, char.getInt(index, "骑宠"));
	if char.check(petindex) == 1 then
		pindex = char.createPet(310, 1);
		if char.check(pindex) == 1 then
			petid = char.setCharPet(npcindex1, pindex);
			if petid > -1 then
				char.setChar(pindex, "名字", "陪练专用骑宠");
				char.setInt(pindex, "类型", "帮宠");
				char.setInt(npcindex1, "骑宠", petid);
				char.copyChar(petindex, pindex);
				char.setInt(pindex, "体力",char.getInt(pindex, "体力") + math.random(100, 800));
				char.complianceParameter(pindex);
				char.setInt(pindex, "HP", char.getWorkInt(pindex, "最大HP"));
			end
		end
	else
		char.setInt(npcindex1, "骑宠", -1);
	end

	char.setInt(npcindex1, "循环事件时间", 3000);
	char.setFunctionPointer(npcindex1, "循环事件", "Loop", "");
	char.ToAroundChar(npcindex1);
	return npcindex1;
end

function Accompany(charaindex)
	local floorid = char.getInt(charaindex,"地图号");
	if floorid  >= 8200 and floorid <= 8213 then
		char.TalkToCli(charaindex, -1, "该地图不可召唤陪练！", 6);
		return;
	end
	--if config.getGameservername() ~= "四线" then
		--char.TalkToCli(charaindex, -1, "陪练只能在单号线召唤！", 6);
		--return;
	--end
	pnum = 0;
	for i = 1, 3 do
		pindex = char.getWorkInt(charaindex, "队员" .. i);
		if char.check(pindex) == 1 then
			pnum = pnum + 1;
		end
	end
	if pnum < 3 then
		npcindex = Create(charaindex, char.getInt(charaindex, "地图号"), char.getInt(charaindex, "坐标X"), char.getInt(charaindex, "坐标Y"), math.max(char.getInt(charaindex, "等级"), 120));
		if char.check(npcindex) == 0 then
			return;
		end
		char.JoinParty(charaindex,npcindex);
	else
		char.TalkToCli(charaindex, -1, "你的队全足够人数练级了,无需陪练帮你咯", 6);
	end
end

function AccompanyItemCall(itemindex, charaindex, toindex, haveitemindex)
	Accompany(charaindex);
end

function mydata()
	offlinetime = 36000;
end

function main()
	mydata()
	item.addLUAListFunction( "ITEM_ACCOMPANY", "AccompanyItemCall", "");
end
