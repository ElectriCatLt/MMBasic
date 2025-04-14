# Navigator for PicoMiteVGA - README

## Overview
Navigator is a file navigation and utility tool designed for file operations on the PicoMiteHDMI platform. 
It was originally intended NOT AS file manager. It provides a interface for quick navigation and direct interaction with files: 
loading and saving contents (EDIT`ed using the built-in editor and saved F1/F2), viewing text files, copying/ repetitve pasting, renaming files etc. 
It works mostly  with the filesystem without loading everything into RAM.

---

## Features
- Simple, fast interface for quick navigation
- Loading and saving contents  to drive A: or B: as file 
- Multiple file selection and multi-paste functionality
- Basic text file viewer
- Directory browsing on-the-fly (no full preloading)
- File renaming (with and without extension)
- Directory creation
- File delete (single file only, for safety)
- Keyboard shortcut-based interface
- Optional visual environment (e.g., space/starfield)

---

## Current Limitations
- Multiple file delete/move is **not** implemented due to safety reasons
- No HEX viewer/editor (planned for future release)
- Requires USB keyboard and HDMI/VGA (tested on USB/HDMI/2350 systems)
- Not tested on PS/2 systems yet
- Uses library space, which can lead to variable reinitialization issues (see Workarounds)

---

## Usage
### Setup
1. Load the program.
2. Use `LIBRARY SAVE` to store it.
3. Assign it to a function key:
<CODE>
OPTION F5 "clear"+chr$(58)+"navigator"+chr$(13)
</CODE>

> ⚠️ **Do not save Navigator into a FLASH SLOT** — saving contents from the inbuilt EDITOR will not work correctly.

---

## Keyboard Commands
### Navigation:
- **Arrow Keys** – Move selection
- **Home/End** – Jump to top/bottom of current page
- **PgUp/PgDn** – Jump ±5 files in list
- **Ctrl+Home** – Jump to top of directory
- **Ctrl+Shift+Home** – Jump to root of active drive
- **TAB** – Swap drives A: <> B:
- **SPACE** – Halt scrolling of long filenames

### File Operations:
- **ENTER** – Perform file actions (load to editor, rename, minimal info, backup etc.)
- **F1** – Quick Save (save inbuilt EDITOR`s contents directly to file)
- **F2** – Name & Save (prompt for filename before saving editor content)
- **F3** – View text file (lines >255 characters will cause error and stop prog. for example BIN files. Will be added BIN reading with HEX file viewer)
- **INS** – Select/deselect multiple files
- **F5** – Copy/Paste: first press copies selected files, next presses paste them repeatedly until another operation or INS is triggered
- **F6** – Full Rename (including file extension)
- **F7** – Create new directory
- **F8** – Delete file (single file only)

### Other:
- **PrntScr** – Save screen image to active directory
- **Long ESC** – Exit Navigator
- **Short ESC** – Exit submenus

---

## Workarounds for Variable Initialization Errors
Navigator uses library space and may cause "variable already declared" errors. To avoid this:

- Exit and re-enter the editor using **F4**, or
- Use the `CLEAR` command before launching Navigator, or
- Use a custom function key that clears memory first:
<CODE>
OPTION F5 "clear"+chr$(58)+"navigator"+chr$(13)
</CODE>

---

## Compatibility
- Tested on: USB/HDMI/2350 systems
- Resolution: Works with `OPTION RESOLUTION 640` (default) and `RESOLUTION 800`
- Fonts: Designed for 6x8 and 8x12 fonts

---

## Final Notes
Navigator was created to suit the author's personal needs. If you enjoy using it — great! If not — no worries.

> If you *do* enjoy it, please consider helping stray cats. 🐾

---

(c) 2025 - Released for the PicoMiteVGA community with curiosity and love.

