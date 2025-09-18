/*
** Lua thread lock implementation
** Global critical section shared by all Lua states
*/

#ifdef _WIN32

#include <windows.h>

/* Global critical section - shared by all Lua states */
CRITICAL_SECTION lua_global_lock;
int lua_lock_initialized = 0;

void lua_initgloballock(void) {
    if (!lua_lock_initialized) {
        InitializeCriticalSection(&lua_global_lock);
        lua_lock_initialized = 1;
    }
}

void lua_destroygloballock(void) {
    if (lua_lock_initialized) {
        DeleteCriticalSection(&lua_global_lock);
        lua_lock_initialized = 0;
    }
}

/* Helper functions for locking */
void LuaLock(void* L) {
    (void)L;  /* unused */
    if (lua_lock_initialized) {
        EnterCriticalSection(&lua_global_lock);
    }
}

void LuaUnlock(void* L) {
    (void)L;  /* unused */
    if (lua_lock_initialized) {
        LeaveCriticalSection(&lua_global_lock);
    }
}

void LuaLockInitial(void* L) {
    (void)L;  /* unused */
    lua_initgloballock();
}

#endif /* _WIN32 */