/*
** Lua user configuration for thread locking
** Uses Windows Critical Sections for synchronization
*/

#ifndef LUAUSER_H
#define LUAUSER_H

#ifdef _WIN32

/* Forward declarations to avoid including Windows.h everywhere */
struct _RTL_CRITICAL_SECTION;
typedef struct _RTL_CRITICAL_SECTION* LPCRITICAL_SECTION;

/* External declarations from lualock.c */
extern struct _RTL_CRITICAL_SECTION lua_global_lock;
extern int lua_lock_initialized;

void lua_initgloballock(void);
void lua_destroygloballock(void);

/* Helper functions implemented in lualock.c */
void LuaLock(void* L);
void LuaUnlock(void* L);
void LuaLockInitial(void* L);

/* Lock macros */
#define lua_lock(L) LuaLock(L)
#define lua_unlock(L) LuaUnlock(L)
#define luai_userstateopen(L) LuaLockInitial(L)

#endif /* _WIN32 */

#endif /* LUAUSER_H */