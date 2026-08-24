#include "rendering.h"

#include <string>

#include "sdl3/SDL.h"
#include "imgui/imgui_manager.h"

SDL_Window* window;
SDL_Renderer* renderer;
SDL_Event event;

void SetupRendering(const std::string windowName, const int windowWidth, const int windowHeight) {
	SDL_Init(SDL_INIT_VIDEO);
	SDL_CreateWindowAndRenderer(windowName.c_str(), windowWidth, windowHeight, 0, &window, &renderer);

	SDL_SetRenderVSync(renderer, 1);
	SDL_SetRenderScale(renderer, 1, 1);

	ImGuiSetup(window, renderer);
}

void CloseRendering() {
	ImGuiEnd();

	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);

	SDL_Quit();
}

bool StartFrame() {
	bool finished = false;

	while (SDL_PollEvent(&event)) {
		if (event.type == SDL_EVENT_QUIT) {
			finished = true;
		}
		ImGui_ImplSDL3_ProcessEvent(&event);
	}

	SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
	SDL_RenderClear(renderer);

	ImGuiStartFrame();

	return finished;
}

void CloseFrame() {
	ImGuiRender(window, renderer);

	SDL_RenderPresent(renderer);
}

ImGuiWindowFlags SetFullscreen() {
	ImGuiWindowFlags window_flags = ImGuiWindowFlags_MenuBar | ImGuiWindowFlags_NoDocking;

	const ImGuiViewport* viewport = ImGui::GetMainViewport();

	ImGui::SetNextWindowPos(viewport->WorkPos);
	ImGui::SetNextWindowSize(viewport->WorkSize);
	ImGui::SetNextWindowViewport(viewport->ID);

	ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 0.0f);
	ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 0.0f);

	window_flags |= ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove;
	window_flags |= ImGuiWindowFlags_NoBringToFrontOnFocus | ImGuiWindowFlags_NoNavFocus;

	ImGui::PopStyleVar(2);
	return window_flags;
}

void SetRenderedWindowName(const std::string& windowName) {
	SDL_SetWindowTitle(window, windowName.c_str());
}
