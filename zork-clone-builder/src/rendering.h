#pragma once
#include "core.h"

#include <string>

#include "imgui/imgui_manager.h"

void SetupRendering(const std::string windowName, const int windowWidth, const int windowHeight);
void CloseRendering();

bool StartFrame();
void CloseFrame();

ImGuiWindowFlags SetFullscreen();
void SetRenderedWindowName(const std::string& windowName);

std::string OpenFileDialog(const char* filter);
