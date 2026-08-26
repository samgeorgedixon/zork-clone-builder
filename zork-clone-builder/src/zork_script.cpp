#include "zork_script.h"

#include <thread>
#include <chrono>

#define SOL_ALL_SAFETIES_ON 1
#include "sol/sol.hpp"

#include "application.h"

std::string fileName = "zork-script.lua";

static std::string command = "";
static bool commandNew = false;
static bool finished = false;

void SetCommand(const std::string& commandToSet) {
	command = commandToSet;

	commandNew = true;
}
void CallLuaToClose() {
	finished = true;
}

std::vector<std::string> lua_GetCommand() {
	while (!commandNew) {
		if (finished) {
			throw std::runtime_error("Lua Execution Closed");
		}
		std::this_thread::sleep_for(std::chrono::milliseconds(10));
	}

	OutputGUIConsole("\n> " + command);

	std::vector<std::string> commandSplit;
	std::string currentWord = "";

	for (int i = 0; i < command.size(); i++) {
		if (command[i] == ' ') {
			if (currentWord.empty()) {
				continue;
			}
			commandSplit.push_back(currentWord);
			currentWord = "";

			continue;
		}
		currentWord.push_back(command[i]);
	}

	if (!currentWord.empty()) {
		commandSplit.push_back(currentWord);
	}

	commandNew = false;
	return commandSplit;
}

void lua_SetName(const std::string& name) {
	SetWindowName(name);
}

void lua_SetAttributes(const sol::table& attributes) {
	std::vector<std::pair<std::string, std::string>> attributesConvert;

	for (int i = 0; i < attributes.size(); i++) {
		std::string name = attributes[i + 1][1].get<std::string>();
		std::string value = attributes[i + 1][2].get<std::string>();

		attributesConvert.push_back({ name, value });
	}

	SetAttributes(attributesConvert);
}

void RunZorkScript() {
	ZORK_LOG("Running Zork Script: %s\n", fileName.c_str());

	OutputGUIConsole("> ./" + fileName);

	sol::state lua;
	lua.open_libraries(sol::lib::base, sol::lib::io, sol::lib::math, sol::lib::table, sol::lib::string);

	sol::table zork = lua.create_named_table("zork");
	zork["GetCommand"] = &lua_GetCommand;
	zork["SetName"] = &lua_SetName;

	zork["Output"] = &OutputGUIConsole;

	zork["SetAttributes"] = &lua_SetAttributes;

	try {
		lua.safe_script_file(fileName);
	}
	catch (const sol::error& e) {
		ZORK_LOG("Error: %s\n", e.what());
	}
}
