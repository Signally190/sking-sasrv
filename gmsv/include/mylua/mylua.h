#define __MYLUA__H__
#ifdef __MYLUA__H__

#include "lua.h"

#include "lauxlib.h"
#include "lualib.h"
int myluaload(char *filename);
int remyluaload(char *filename);
int closemyluaload();
void CryptoAllbluesLUA(char *path, int flg, int id);
int dofile(lua_State *L, const char *name);
int docall(lua_State *L, int narg, int clear);
int getArrayInt(lua_State *L, int idx);
LUALIB_API void luaAB_openlibs(lua_State *L);

typedef struct tagMYLua
{
	lua_State *lua;
	char *luapath;
	struct tagMYLua *next;
} MY_Lua;

#endif
