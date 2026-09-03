# Zork Clone Builder

Here, I have designed a builder for the game Zork to allow anyone to make custom clones easily by editing a simple .lua file for my summer college homework assignment.

However, you could use this builder to make a variety of text-based adventure games and not just Zork clones.

<img width="400" height="629" alt="Image" src="https://github.com/user-attachments/assets/8bc32593-6bdf-4ad3-b1f5-66ba1f550850"/>

## Example Game

I have included an example Zork game (exploring based) i wrote as zork-script.lua which you can try as the default game for this builder.

Or you can load your own lua script: File -> Open Zork Script

## Usage

There is a windows x86-64 installer available under [releases](https://github.com/samgeorgedixon/zork-clone-builder/releases).

Or feel free to build from source using premake by replacing the target.

```shell
dep\premake\premake5.exe <target>
```

However, only windows is supported currently.
