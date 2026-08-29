#include "application.h"

#include <string>
#include <vector>
#include <thread>

#include "imgui/imgui_manager.h"

#include "rendering.h"
#include "zork_script.h"

bool reloadZorkScript = false;
static bool finished = false;
static bool showImGui = true;
static bool scrollBottom = false;

const int windowWidth = 400, windowHeight = 600;
static std::string windowName = "Zork Clone Builder";
static bool windowNameChanged = false;

static std::vector<std::string> output;
static char input[256] = "";

static std::vector<std::pair<std::string, std::string>> attributes;

void SetWindowName(const std::string& name) {
	windowName = "Zork Clone Builder - " + name;
	windowNameChanged = true;
}
void OutputGUIConsole(const std::string& text) {
	output.push_back(text);
	scrollBottom = true;
}
void SetAttributes(const std::vector<std::pair<std::string, std::string>>& newAttributes) {
	attributes = newAttributes;
}

void Setup() {
	SetupRendering(windowName, windowWidth, windowHeight);
}

void DisplayAttributes() {
	if (attributes.empty()) {
		return;
	}
	ImGui::BeginTable("Table", attributes.size(), ImGuiTableFlags_SizingStretchProp);

	for (int i = 0; i < attributes.size(); i++) {
		ImGui::TableNextColumn();
		ImGui::Text("%s: %s", attributes[i].first.c_str(), attributes[i].second.c_str());
	}

	ImGui::EndTable();
}

void MenuGUI() {
	if (ImGui::BeginMenuBar()) {
		if (ImGui::BeginMenu("File")) {
			if (ImGui::MenuItem("Open Zork Script", NULL, false, finished != true)) {
				std::string fileName = OpenFileDialog("Zork Script (*.lua)\0 * .lua\0All Files (*.*)\0*.*\0");
				
				if (!fileName.empty()) {
					reloadZorkScript = true;
					CallLuaToClose();
					SetFileName(fileName);
				}
			}
			if (ImGui::MenuItem("Exit", NULL, false, finished != true)) {
				finished = true;
			}
			ImGui::EndMenu();
		}

		ImGui::EndMenuBar();
	}
}

void RenderGUI() {
	ImGui::Begin(windowName.c_str(), &showImGui, SetFullscreen());

	MenuGUI();

	ImGui::BeginChild("Output", ImVec2(0, -ImGui::GetFrameHeightWithSpacing() - 40), true);

	for (int i = 0; i < output.size(); i++) {
		ImGui::TextWrapped("%s", output[i].c_str());
	}
	if (scrollBottom) {
		ImGui::SetScrollHereY(1.0f);
		scrollBottom = false;
	}
	ImGui::EndChild();

	ImGui::Spacing();
	ImGui::Separator();

	DisplayAttributes();
	
	ImGui::Separator();
	ImGui::Spacing();

	if (ImGui::InputText("##input", input, sizeof(input), ImGuiInputTextFlags_EnterReturnsTrue)) {
		std::string command = input;

		SetCommand(command);

		scrollBottom = true;

		input[0] = '\0';

		ImGui::SetKeyboardFocusHere(-1);
	}

	ImGui::End();
}

void Run() {
	std::thread luaZorkScript(RunZorkScript);

	while (!finished && !reloadZorkScript) {
		if (windowNameChanged) {
			SetRenderedWindowName(windowName);
			windowNameChanged = false;
		}
		
		finished = StartFrame();

		RenderGUI();

		CloseFrame();
	}

	if (!reloadZorkScript) {
		CallLuaToClose();
	}
	
	luaZorkScript.join();
	
	if (reloadZorkScript) {
		reloadZorkScript = false;
		Run();
	}
}

void Close() {
	CloseRendering();
}
