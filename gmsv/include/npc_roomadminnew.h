#ifndef __NPC_ROOMADMINNEW_H__
#define __NPC_ROOMADMINNEW_H__

#include "common.h"

void NPC_RoomAdminNewTalked(int meindex, int talkerindex, char *msg, int color);
void NPC_RoomAdminNewLoop(int meindex);
BOOL NPC_RoomAdminNewInit(int meindex);

BOOL NPC_RankingInit(int meindex);
void NPC_RankingTalked(int meindex, int talkerindex, char *msg, int color);

BOOL NPC_PrintpassmanInit(int meindex);
void NPC_PrintpassmanTalked(int meindex, int talkerindex, char *msg, int color);

typedef struct npc_roomadminnew_tag {
  int expire;
  char cdkey[CDKEYLEN];
  char charaname[32];
  char passwd[9];
} NPC_ROOMINFO;

typedef struct npc_roomadminnew_ranking_tag {
	int gold;			  /*   诳嗯喊 */
	int biddate;		  /*   诳凛棉 */
	char cdkey[CDKEYLEN]; /*   午仄凶谛及    平□ */
	char charaname[32];	  /*   午仄凶谛及  蟆 */
	char owntitle[32];	  /* 惫寞*/

} NPC_RANKING_INFO;

#endif /*__NPC_ROOMADMINNEW_H__*/

BOOL NPC_RoomAdminNew_ReadFile(char *roomname, NPC_ROOMINFO *data);
