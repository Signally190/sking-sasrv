function ItemBoxToItemBox( charaindex)
	if StackData[charaindex+1] == nil then
		StackData[charaindex+1] = os.time(); 
	end
	if os.time() < StackData[charaindex+1] then
		char.TalkToCli(charaindex, -1, "【温馨提示】当前叠加功能正在冷却！", "黄色")
		return 1;
	end
	StackData[charaindex+1] = os.time()+10;
	local itemmaxnum = char.getMyMaxPilenum(charaindex);
	local flg=false;
	for i = 9,22 do
		local fromindex = char.getItemIndex(charaindex,i);
		if fromindex > -1 then
			if item.getInt(fromindex,"重叠") == 1 then
				local frompilenum = item.getInt(fromindex,"堆叠");
				if frompilenum < itemmaxnum then
					for b=i+1,23 do
						local toindex = char.getItemIndex(charaindex,b);
						if toindex>-1 then
							if item.getInt(toindex,"堆叠") < itemmaxnum then
								if item.getInt(fromindex,"序号") == item.getInt(toindex,"序号") then
									char.PileItemFromItemBoxToItemBox(charaindex,b,i)
									frompilenum = item.getInt(fromindex,"堆叠");
									flg=true;
									if frompilenum >= itemmaxnum then
										break;
									end
								end
							end
						end
					end
				end
			end
		end
	end
	if flg then
		for i=9,23 do
			item.UpdataHaveItemOne(charaindex,i);
		end
	end
	char.TalkToCli(charaindex, -1, "叠加成功！", "黄色");
end

function CharTalkFunction2( charaindex, message, color)
	NoStr = {
			 "香港"
			 ,"大陆"
			 ,"台湾"
			 ,"习近平"
			 ,"操你妈"
			 ,"垃圾"
			 ,"台独"
			 ,"港独"
			 ,"共产党"
			 ,"国民党"
			 ,"台独"
			 ,"港独"
			 ,"大陸"
			 ,"台灣"
			 ,"習近平"
			 ,"操你媽"
			 ,"臺独"
			 ,"港独"
			 ,"共产黨"
			 ,"國民黨"
			 ,"中国"
			 ,"内服"
			 ,"中國"
			 }
	for i = 1, table.getn(NoStr) do
		str, len = string.gsub(message, NoStr[i], "");
		if len > 0 then
			return 1;
		end
	end
	local field = other.getString(message, " ", 1);
	if field == "P|[gm" then
		return 0;
	end
	
	local Nojz = {"buy","买","卖","sell","/safe"};
	for i=1,table.getn(Nojz) do
		local fieldnum = string.find(field,Nojz[i]);
		if fieldnum ~= nil then
			return 0;
		end
	end	
	--if char.getInt( charaindex, "等级" ) < 30 and char.getInt( charaindex, "转数" ) == 0 then
		--char.TalkToCli(charaindex, -1, "您的等级小于30级,目前只能说hi！", "红色");
		--return 1;
	--end
	return 0;
end

function CharTalkFunction( charaindex, message, color)	
	local field = other.getString(message, " ", 1);
	if field == "/XQ" then
		if other.getString(message, " ", 2) == nil then
			return 1;
		end
		--星球频道配置(1间隔时间,2要求转数,3扣除货币(1石币,2声望,3活力,4金币))
		local XQConfig = {60,5,{0,100,0,0}};
		if char.getInt(charaindex ,"转数") < XQConfig[2] then
			char.TalkToCli(charaindex, -1, "你的转数不足"..XQConfig[2].."转，无法使用星球频道！" , "红色");
			return 1;
		end
		if XQConfig[3][1] > 0 then
			if char.getInt(charaindex ,"石币") < XQConfig[3][1] then
				char.TalkToCli(charaindex, -1, "你的石币不足"..XQConfig[3][1].."，无法使用星球频道！" , "红色");
				return 1;
			end
		end
		if XQConfig[3][2] > 0 then
			if (char.getInt(charaindex ,"声望")/100) < XQConfig[3][2] then
				char.TalkToCli(charaindex, -1, "你的声望不足"..XQConfig[3][2].."，无法使用星球频道！" , "红色");
				return 1;
			end
		end
		if XQConfig[3][3] > 0 then
			if char.getInt(charaindex ,"活力") < XQConfig[3][3] then
				char.TalkToCli(charaindex, -1, "你的活力不足"..XQConfig[3][3].."，无法使用星球频道！" , "红色");
				return 1;
			end
		end
		if XQConfig[3][4] > 0 then
			local tmpoint = sasql.getVipPoint(charaindex);
			if tmpoint < XQConfig[3][4] then
				char.TalkToCli(charaindex, -1, "你的金币不足"..XQConfig[3][4].."，无法使用星球频道！" , "红色");
				return 1;
			end
		end
		local tmmytime = char.getWorkInt(charaindex,"星球频道时");
		local tmjgtime = tmmytime - os.time();
		if tmjgtime > 0 then
			char.TalkToCli(charaindex, -1, "星球频道间隔还有"..tmjgtime.."秒！" , "红色");
			return 1;
		end
		local delmsg = "扣除";
		local delcf = false;
		if XQConfig[3][1] > 0 then
			local tmpoint = char.getInt(charaindex ,"石币");
			char.setInt(charaindex ,"石币",tmpoint-XQConfig[3][1]);
			delmsg = delmsg .. "石币:"..XQConfig[3][1].." ";
			delcf = true;
		end
		if XQConfig[3][2] > 0 then
			local tmpoint = char.getInt(charaindex ,"声望");
			char.setInt(charaindex ,"声望",tmpoint-(XQConfig[3][2]*100));
			delmsg = delmsg .. "声望:"..XQConfig[3][2].." ";
			delcf = true;
		end
		if XQConfig[3][3] > 0 then
			local tmpoint = char.getInt(charaindex ,"活力");
			char.setInt(charaindex ,"活力",tmpoint-XQConfig[3][3]);
			delmsg = delmsg .. "活力:"..XQConfig[3][3].." ";
			delcf = true;
		end
		if XQConfig[3][4] > 0 then
			local tmpoint = sasql.getVipPoint(charaindex);
			sasql.setVipPoint(charaindex,tmpoint-XQConfig[3][4]);
			delmsg = delmsg .. "金币:"..XQConfig[3][4];
			delcf = true;
		end
		if delcf == true then
			char.TalkToCli(charaindex, -1, delmsg , "红色");
		end
		local tmmessage = string.format("[星]%s：%s", char.getChar(charaindex, "名字"),other.getString(message, " ", 2));
		char.talkToAllServer(tmmessage,1);
		char.setWorkInt(charaindex,"星球频道时",os.time()+XQConfig[1]);
		return 1;
	elseif field == "/safe" then
		token = "SELECT `SafePasswd` FROM `CSA_Login` "
				.. " WHERE `Name` = '" .. char.getChar(charaindex, "账号") .. "'";
		ret = sasql.query(token);
		if ret == 1 then
			sasql.free_result();
			sasql.store_result();
			num = sasql.num_rows();
			if num > 0 then
				sasql.fetch_row(0);
				if sasql.data(1) ~= other.getString(message, " ", 2) then
					char.TalkToCli(charaindex, -1, "安全码错误，无法给您解锁", "黄色");
					return 1;
				end
				char.setInt(charaindex,"安全锁",0);
				char.TalkToCli(charaindex, -1, "安全锁已经成功解锁！", "黄色");
			end
		end
		return 1
	elseif field == "/体力" or field == "/tl" then
		if other.getString(message, " ", 2) == nil then
			return 1
		end
		local uppoint = other.atoi(other.getString(message, " ", 2))
		if uppoint < 1 then
			char.TalkToCli(charaindex, -1, "您输入的数值过小哦！", "黄色")
			return 1
		end
		local myuppoint = char.getInt(charaindex,"技能点")
		if myuppoint < uppoint then
			char.TalkToCli(charaindex, -1, "您的升级点数不足！", "黄色")
			return 1
		end
		char.setInt(charaindex,"技能点",myuppoint-uppoint)
		char.setInt(charaindex,"体力",char.getInt(charaindex,"体力") + uppoint*100)
		char.TalkToCli(charaindex, -1, "您成功增加" .. uppoint .. "点体力。", "黄色")
		char.complianceParameter(charaindex)
		char.Skillupsend(charaindex)
		char.sendStatusString(charaindex,"P")
		return 1
	elseif field == "/腕力" or field == "/wl" then
		if other.getString(message, " ", 2) == nil then
			return 1
		end
		local uppoint = other.atoi(other.getString(message, " ", 2))
		if uppoint < 1 then
			char.TalkToCli(charaindex, -1, "您输入的数值过小哦！", "黄色")
			return 1
		end
		local myuppoint = char.getInt(charaindex,"技能点")
		if myuppoint < uppoint then
			char.TalkToCli(charaindex, -1, "您的升级点数不足！", "黄色")
			return 1
		end
		char.setInt(charaindex,"技能点",myuppoint-uppoint)
		char.setInt(charaindex,"腕力",char.getInt(charaindex,"腕力") + uppoint*100)
		char.TalkToCli(charaindex, -1, "您成功增加" .. uppoint .. "点腕力。", "黄色")
		char.complianceParameter(charaindex)
		char.Skillupsend(charaindex)
		char.sendStatusString(charaindex,"P")
		return 1
	elseif field == "/耐力" or field == "/nl" then
		if other.getString(message, " ", 2) == nil then
			return 1
		end
		local uppoint = other.atoi(other.getString(message, " ", 2))
		if uppoint < 1 then
			char.TalkToCli(charaindex, -1, "您输入的数值过小哦！", "黄色")
			return 1
		end
		local myuppoint = char.getInt(charaindex,"技能点")
		if myuppoint < uppoint then
			char.TalkToCli(charaindex, -1, "您的升级点数不足！", "黄色")
			return 1
		end
		char.setInt(charaindex,"技能点",myuppoint-uppoint)
		char.setInt(charaindex,"耐力",char.getInt(charaindex,"耐力") + uppoint*100)
		char.TalkToCli(charaindex, -1, "您成功增加" .. uppoint .. "点耐力。", "黄色")
		char.complianceParameter(charaindex)
		char.Skillupsend(charaindex)
		char.sendStatusString(charaindex,"P")
		return 1
	elseif field == "/速度" or field == "/sd" then
		if other.getString(message, " ", 2) == nil then
			return 1
		end
		local uppoint = other.atoi(other.getString(message, " ", 2))
		if uppoint < 1 then
			char.TalkToCli(charaindex, -1, "您输入的数值过小哦！", "黄色")
			return 1
		end
		local myuppoint = char.getInt(charaindex,"技能点")
		if myuppoint < uppoint then
			char.TalkToCli(charaindex, -1, "您的升级点数不足！", "黄色")
			return 1
		end
		char.setInt(charaindex,"技能点",myuppoint-uppoint)
		char.setInt(charaindex,"速度",char.getInt(charaindex,"速度") + uppoint*100)
		char.TalkToCli(charaindex, -1, "您成功增加" .. uppoint .. "点速度。", "黄色")
		char.complianceParameter(charaindex)
		char.Skillupsend(charaindex)
		char.sendStatusString(charaindex,"P")
		return 1
	elseif field == "/pet" then
		--print(message);
		if other.getString(message, " ", 2) == nil then
			return 1;
		end
		local petid = other.atoi(other.getString(message, " ", 2))
		if petid < 1 or petid > 5 then
			char.TalkToCli(charaindex, -1, "【错误提示】请输入宠物栏位1-5。", "红色")
			return 1;
		end
		local petindex;
		local pos=-1;
		local h=0;
		for i=0,4 do 
			petindex = char.getCharPet(charaindex, i);
			if char.check(petindex) == 1 then
				h = h+1;
				if h == petid then
					pos = h;
					break;
				end
			end
		end
		if pos == -1 then
			char.TalkToCli(charaindex, -1, "【错误提示】该宠物栏是空的哦！", "红色")
			return 1
		end
		local LevelUpPoint = char.getInt(petindex, "能力值");
		local vital = char.getRightTo8(LevelUpPoint, 1)
		local str = char.getRightTo8(LevelUpPoint, 2)
		local tgh = char.getRightTo8(LevelUpPoint, 3)
		local dex = char.getRightTo8(LevelUpPoint, 4)
		local array = char.getInt(petindex, "宠ID");
		local tempno = pet.getEnemyTempArrayFromTempNo(array);
		if char.getInt(petindex,"宠ID") == 718 or char.getInt(petindex,"宠ID") == 401 then
			local token = "                 『[style c=5]能力值查看[/style]』"
						.."\n"..char.getChar(petindex, "名字") .. " Lv" .. char.getInt(petindex, "等级") .. " 的四围档次如下："
						.."\n"
						.."\n"..string.format("[style c=1]体力：[/style]%-10d极品值：%d\n",vital,50)
						.."\n"..string.format("[style c=1]腕力：[/style]%-10d极品值：%d\n",str,50)
						.."\n"..string.format("[style c=1]耐力：[/style]%-10d极品值：%d\n",tgh,50)
						.."\n"..string.format("[style c=1]速度：[/style]%-10d极品值：%d\n",dex,50);
						
						string.format("[style c=1]体力：[/style]%-10d极品值：%d\n[style c=6]腕力：[/style]%-10d极品值：%d\n[style c=5]耐力：[/style]%-10d极品值：%d\n[style c=4]速度：[/style]%-10d极品值：%d\n[style c=10]四项为50则是满石（转宠只和MM档次有关）[/style]\n", vital, 50, str, 50,  tgh, 50, dex, 50)
			lssproto.windows(charaindex, "对话框", 8, 0, -1, token);
		else
			local token = "                 『[style c=5]" .. char.getChar(petindex, "名字") .. "[/style]』\n" .. char.getChar(petindex, "名字") .. " Lv" .. char.getInt(petindex, "等级") .. " 的四围档次如下：\n你的宠物        未转参考值\n"
			token = token .. string.format("[style c=1]体力：[/style]%-10d极品值：%d\n[style c=6]腕力：[/style]%-10d极品值：%d\n[style c=5]耐力：[/style]%-10d极品值：%d\n[style c=4]速度：[/style]%-10d极品值：%d\n[style c=10]宠物档次越高，转生后档次会越高[/style]\n", vital,pet.getInt(tempno, "体力")+2, str,pet.getInt(tempno, "腕力")+2,  tgh, pet.getInt(tempno, "耐力")+2, dex, pet.getInt(tempno, "速度")+2)
			lssproto.windows(charaindex, "对话框", "YES", 0, -1, token)
		end      
		return 1;
	elseif field == "/离线挂机" or field == "/lxgj"  then
		local parameter = {charaindex}
		other.CallFunction("OffLine", "mylua/other/OfflineTime.lua", parameter);
		return 1
	elseif field == "/编号" or field == "/bh"  then
		if char.getWorkInt(charaindex,"组队") == 1 then
			char.TalkToCli(charaindex, -1, "您的组队编号为:"..charaindex, "红色");
		else
			char.TalkToCli(charaindex, -1, "该功能只有队长可使用！", "红色");
		end
		return 1;
	elseif field =="/抗性" or field == "/kx" then
		if other.getString(message, " ", 2) == nil then
			return 1;
		end
		local petid = other.atoi(other.getString(message, " ", 2));
		if petid < 0 or petid > 5 then
			char.TalkToCli(charaindex, -1, "【错误提示】请输入宠物栏位1-5，0为人物抗性信息", "红色");
			return 1;
		end
		local pindex = -1
		if petid == 0 then
			pindex = charaindex;
		else
			pindex = char.getCharPet(charaindex, petid - 1);
			if char.check(pindex) ~= 1 then
				char.TalkToCli(charaindex, -1, "【错误提示】该宠物栏是空的哦！", "红色");
				return 1;
			end
		end

		char.TalkToCli(charaindex, -1, "[" .. char.getChar( pindex, "名字" ) .. "]魔法抗性明细如下:", "红色");
		char.TalkToCli(charaindex, -1, "        地   水   火   风", "红色");
		char.TalkToCli(charaindex, -1, "抗性值: " .. string.format("%-4s", char.getInt(pindex, "地魔法抗性")) .." "..  string.format("%-4s", char.getInt(pindex, "水魔法抗性")) .." ".. string.format("%-4s", char.getInt(pindex, "火魔法抗性")) .." ".. string.format("%-4s", char.getInt(pindex, "风魔法抗性")), "红色");
		char.TalkToCli(charaindex, -1, "经验值: " .. string.format("%-4s", char.getInt(pindex, "地魔法抗性经验值")) .." "..  string.format("%-4s", char.getInt(pindex, "水魔法抗性经验值")) .." ".. string.format("%-4s", char.getInt(pindex, "火魔法抗性经验值")) .." ".. string.format("%-4s", char.getInt(pindex, "风魔法抗性经验值")), "红色");

		return 1
	elseif field == "/离线挂机" or field == "/lxgj"  then
		if char.getInt(charaindex, "离线时间") > 0 then
			local parameter = {charaindex};
			other.CallFunction("OffLine", "mylua/other/OfflineTime.lua", parameter);
		else
			char.TalkToCli(charaindex, -1, "你没有离线时间！", "黄色");
		end
		return 1;
	elseif field == "/原地遇敌" or field == "/ydyd"  then
		char.Encounter(charaindex);
		return 1;
	elseif field == "/取消遇敌" or field == "/qxyd"  then
		char.StopEncounter(charaindex);
		return 1;
	elseif field == "/叠加" or field == "/dj" then
		ItemBoxToItemBox(charaindex);--叠加道具
		return 1;
	elseif field == "/防卡" then
		local fd = char.getFd(charaindex);--获取FD
		--lssproto.show(charaindex,char.getWorkInt(charaindex,"对象"));
		net.echosend(fd);
		char.WarpToSpecificPoint(charaindex, char.getInt(charaindex, "地图号"), char.getInt(charaindex, "坐标X"), char.getInt(charaindex, "坐标Y"));
		return 1;
	elseif field == "/bj" then
		local foorid = {1042,2032,3032,4032,5032,6032,7032,8032,9032,7532};
		local bjcf = false;
		for i=1,table.getn(foorid) do
			if char.getInt(charaindex,"地图号") == foorid[i] then
				bjcf = true;
				break ;
			end
		end
		if bjcf == true then
			if char.getWorkInt(charaindex,"战斗索引") < 0 then
				char.setInt(charaindex,"HP",char.getWorkInt(charaindex,"最大HP"));
				char.setInt(charaindex,"MP",char.getWorkInt(charaindex,"最大MP"));
				for i=0,4 do
					petindex = char.getCharPet(charaindex, i);
					if char.check(petindex) == 1 then
						char.setInt(petindex,"HP",char.getWorkInt(petindex,"最大HP"));
						char.sendStatusString(charaindex,"K" .. i);
					end
				end
				char.sendStatusString(charaindex,"P");
				local parameter = {charaindex};
				other.CallFunction("ShowHead", "mylua/npc/fmbattleshop/fmbattleshop.lua", parameter);
			else
				char.TalkToCli(charaindex, -1, "此功能在战斗中无法使用。", "黄色");
			end
		else
			char.TalkToCli(charaindex, -1, "此功能只能在族战地图中使用。", "黄色");
		end
		return 1;
	elseif field == "/my" then
		char.TalkToCli(charaindex, -1, "帐号："..char.getChar(charaindex,"帐号"), "黄色");
		char.TalkToCli(charaindex, -1, "Save："..char.getInt(charaindex,"存档"), "黄色");
		return 1;
	end
	
	return 0;
end

function WindowTalked ( meindex, charaindex, seqno, select, data)
	if seqno== 1 then
		if select == 1 then
			local words = char.getWorkChar(charaindex,"NPC临时1")
			local color = char.getWorkInt(charaindex,"NPC临时1")
			if sasql.getVipPoint(charaindex) >= worldpay then
				if char.getInt(charaindex, "家族索引") > -1 then
					char.talkToServerEx(-1,"[星球]{" .. char.getChar(charaindex, "家族") .. "}" ..  char.getChar(charaindex, "名字") .. "：" .. words,color,worldsize)
				else
					char.talkToServerEx(-1,"[星球]" .. char.getChar(charaindex, "名字") .. "：" .. words,color,worldsize)
				end
				sasql.setVipPoint(charaindex,sasql.getVipPoint(charaindex)-worldpay)
			else
				char.TalkToCli(charaindex, -1, "【声望不足】使用星球频道要求:每次消耗"..worldpay.."点声望", "红色")
			end
			char.setWorkChar(charaindex,"NPC临时1","")
		end
	end
end

function Create(name, metamo, floor, x, y, dir)
	--创建NPC(NPC名字，图像号，地图号，坐标X，坐标Y，方向号)将返回一个NPC索引
	npcindex = npc.CreateNpc(name, metamo, floor, x, y, dir)
	char.setFunctionPointer(npcindex, "窗口事件", "WindowTalked", "")
end

function mydata()
	worldcooldown = 5;
	worldpay = 200;	--星球说话金币
	worldsize = 14;	--字体大小
	StackData = {};
	NoWdTalkDataMac={"!@#$%E-d73a82b308dd4e1056c08d0f4db78769",""};
end


function setAllServerTalk(charaindex, strdata)
	if strdata == "on" then
		ServerTalkFlag = true;
		char.talkToServer(-1, "管理员打开了世界频道，请注意不要地域攻击，和谐游戏。", "红色")
		char.talkToServer(-1, "管理员打开了世界频道，请注意不要地域攻击，和谐游戏。", "红色")
		char.talkToServer(-1, "管理员打开了世界频道，请注意不要地域攻击，和谐游戏。", "红色")
		char.talkToServer(-1, "管理员打开了世界频道，请注意不要地域攻击，和谐游戏。", "红色")
		char.talkToServer(-1, "管理员打开了世界频道，请注意不要地域攻击，和谐游戏。", "红色")
	else
		ServerTalkFlag= false;
		char.talkToServer(-1, "管理员暂时关闭了世界频道。", "红色")
		char.talkToServer(-1, "管理员暂时关闭了世界频道。", "红色")
		char.talkToServer(-1, "管理员暂时关闭了世界频道。", "红色")
		char.talkToServer(-1, "管理员暂时关闭了世界频道。", "红色")
		char.talkToServer(-1, "管理员暂时关闭了世界频道。", "红色")
	end
end

function main()
	ServerTalkFlag = true;
	mydata()
	Create("CharTalkFunction",100000,777,32,14,6);
	magic.addLUAListFunction("setAllServerTalk", "setAllServerTalk", "", 1, "[gm setServerTalk on/off]")
end

