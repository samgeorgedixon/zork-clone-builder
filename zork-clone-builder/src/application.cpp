#include "application.h"

#include <string>
#include <vector>
#include <thread>

#include "imgui/imgui_manager.h"

#include "rendering.h"
#include "zork_script.h"

static bool finished = false;
static bool showImGui = true;
static bool scrollBottom = false;

static std::string windowName = "Zork Clone Builder";
static bool windowNameChanged = false;

static std::vector<std::string> output;
static char input[256] = "";

void SetWindowName(const std::string& name) {
	windowName = "Zork Clone Builder - " + name;
	windowNameChanged = true;
}

void Setup() {
	SetupRendering(windowName, 400, 600);
}

void MenuGUI() {
	if (ImGui::BeginMenuBar()) {
		if (ImGui::BeginMenu("File")) {
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

	ImGui::BeginChild("Output", ImVec2(0, -ImGui::GetFrameHeightWithSpacing() - 10), true);

	for (int i = 0; i < output.size(); i++) {
		ImGui::TextUnformatted(output[i].c_str());
	}
	if (scrollBottom) {
		ImGui::SetScrollHereY(1.0f);
		scrollBottom = false;
	}
	ImGui::EndChild();

	ImGui::Spacing();
	ImGui::Separator();

	if (ImGui::InputText("##input", input, sizeof(input), ImGuiInputTextFlags_EnterReturnsTrue)) {
		std::string command = input;

		if (!command.empty()) {
			output.push_back("> " + command);

			SetCommand(command);

			scrollBottom = true;

			input[0] = '\0';
		}

		ImGui::SetKeyboardFocusHere(-1);
	}

	ImGui::End();
}

void Run() {
	std::thread luaZorkScript(RunZorkScript);

	while (!finished) {
		if (windowNameChanged) {
			SetRenderedWindowName(windowName);
			windowNameChanged = false;
		}
		
		finished = StartFrame();

		RenderGUI();

		CloseFrame();
	}

	CallLuaToClose();
	
	luaZorkScript.join();
}

void Close() {
	CloseRendering();
}
