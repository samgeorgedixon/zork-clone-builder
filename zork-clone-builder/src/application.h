#pragma once
#include "core.h"

#include <string>
#include <vector>

void SetWindowName(const std::string& name);
void OutputGUIConsole(const std::string& text);
void SetAttributes(const std::vector<std::pair<std::string, std::string>>& newAttributes);

void Setup();
void Run();
void Close();
