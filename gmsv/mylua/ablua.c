#include "NewBilu/version.h"
#include "autil.h"
#include "mylua/base.h"
#include "mylua/mylua.h"
#include "util.h"
#include <dirent.h>
#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

#ifdef _ALLBLUES_LUA

extern MY_Lua MYLua;

void LoadAllbluesLUA(char *path) {
  struct dirent *ent = NULL;
  char filename[256];
  DIR *pDir;
  pDir = opendir(path);

  while (NULL != (ent = readdir(pDir))) {
    if (ent->d_name[0] == '.')
      continue;
    if (ent->d_type == 8) {
      if (strcmptail(ent->d_name, ".lua") == 0) {
        char filename[256];
        memset(filename, 0, 256);
        sprintf(filename, "%s/%s", path, ent->d_name);

        myluaload(filename);
      }
    } else {
      sprintf(filename, "%s/%s", path, ent->d_name);
      LoadAllbluesLUA(filename);
    }
  }
}

void ReLoadAllbluesLUA(char *filename) { remyluaload(filename); }

void NewLoadAllbluesLUA(char *filename) {
  char token[256];
  if (strlen(filename) > 0) {
    sprintf(token, "mylua/%s", filename);
    myluaload(token);
  } else {
    LoadAllbluesLUA("mylua");
  }
}

const int getCharBaseValue(lua_State *L, int narg, CharBase *charbase, int num,
                           int bugtype) {
  if (!lua_isnumber(L, narg)) {
    size_t l;
    const char *data = luaL_checklstring(L, narg, &l);

    if (data == NULL || data[0] == '\0') {
      return -1;
    }
    char field[64];
    int line = 1;
    int i;
    int value = 0;
    while (getStringFromIndexWithDelim(data, "|", line, field, sizeof(field)) ==
           TRUE) {
      for (i = 0; i < num; i++) {
        if (strcmp(charbase[i].field, field) == 0) {
          value |= charbase[i].element;
          break;
        }
      }

      if (i == num) {
        if (bugtype == 1) {
          print("\nfield=%s,i=%d", field, i);
        }
        return -1;
      }
      line++;
    }

    return value;
  } else {
    return luaL_checkint(L, narg);
  }
}

#endif
