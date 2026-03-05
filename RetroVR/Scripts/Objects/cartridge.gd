## RetroCartridge — pickable cartridge carrying a ROM file path.
## Must be in the "cartridge" group to snap into a RetroSystem's CartridgeSlot.
class_name RetroCartridge
extends XRToolsPickable


## The full path to the ROM file this cartridge represents
@export_global_file var rom_path: String = ""

## Display label (game name, shown in spawn menu later)
@export var game_label: String = ""


## Returns the ROM path — called by RetroSystem when the cartridge snaps in
func get_rom_path() -> String:
	return rom_path
