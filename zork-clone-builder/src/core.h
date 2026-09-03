#pragma once
#include <iostream>

#ifdef ZORK_DISABLE_LOGGING
	#define ZORK_LOG(x)
#else
	#define ZORK_LOG(...) printf(__VA_ARGS__)
#endif
