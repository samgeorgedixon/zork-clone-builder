#pragma once
#include "sdl3/SDL.h"
#include "imgui/imgui.h"
#include "imgui_impl_sdlrenderer3.h"
#include "imgui_impl_sdl3.h"

void SetImGuiStyle(bool styleDark);

void ImGuiSetup(SDL_Window* window, SDL_Renderer* renderer, bool styleDark);
void ImGuiEnd();

void ImGuiStartFrame();
void ImGuiRender(SDL_Window* window, SDL_Renderer* renderer);
