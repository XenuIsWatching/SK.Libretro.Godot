## RetroSystem — pickable retro console that loads a libretro core and renders to a connected TV.
class_name RetroSystem
extends XRToolsPickable


## The libretro core filename (without extension), e.g. "fceumm"
@export var core_name: String = ""

## Path to directory containing the core DLL
@export_dir var core_directory: String = ""

## Human-readable label shown in UI
@export var system_label: String = ""


# Runtime state
var rom_path: String = ""
var connected_tv: RetroTV = null
var is_powered_on: bool = false


@onready var _cartridge_slot: XRToolsSnapZone = $CartridgeSlot
@onready var _cable_attach_point: XRToolsSnapZone = $CableAttachPoint
@onready var _libretro: Libretro = $Libretro
@onready var _power_button: VRButton = $PowerButton
@onready var _reset_button: VRButton = $ResetButton


func _ready() -> void:
	super._ready()
	_cartridge_slot.has_picked_up.connect(_on_cartridge_inserted)
	_cartridge_slot.has_dropped.connect(_on_cartridge_removed)
	_cable_attach_point.has_picked_up.connect(_on_cable_snapped)
	_cable_attach_point.has_dropped.connect(_on_cable_removed)
	_power_button.button_pressed.connect(toggle_power)
	_reset_button.button_pressed.connect(reset)


## Called by the TV's cable plug when it connects to a TV
func on_tv_connected(tv: RetroTV) -> void:
	connected_tv = tv


## Called by the TV's cable plug when it disconnects
func on_tv_disconnected() -> void:
	if is_powered_on:
		power_off()
	connected_tv = null


# --- Cable attach point callbacks ---

func _on_cable_snapped(cable_end: Node3D) -> void:
	# The system end of the cable snapped in — nothing to do yet,
	# the TV connection is handled by the plug end snapping into the TV's CompositePort
	pass


func _on_cable_removed() -> void:
	# Cable disconnected from system — also disconnect from TV
	if is_powered_on:
		power_off()
	connected_tv = null


## Power on: start this system's libretro core
func power_on() -> void:
	if is_powered_on:
		return
	if connected_tv == null:
		push_warning("RetroSystem: no TV connected, cannot power on")
		return
	if rom_path.is_empty():
		push_warning("RetroSystem: no cartridge inserted, cannot power on")
		return

	_libretro.StartContent(connected_tv.get_screen_mesh(), core_directory, core_name, rom_path)
	is_powered_on = true


## Power off: stop the running core
func power_off() -> void:
	if not is_powered_on:
		return
	_libretro.StopContent()
	is_powered_on = false


## Toggle power (used by the power button)
func toggle_power() -> void:
	if is_powered_on:
		power_off()
	else:
		power_on()


## Hard reset: stop and restart with the same content
func reset() -> void:
	if is_powered_on:
		power_off()
		power_on()


# --- Cartridge slot callbacks ---

func _on_cartridge_inserted(cartridge: Node3D) -> void:
	if cartridge.has_method("get_rom_path"):
		rom_path = cartridge.get_rom_path()


func _on_cartridge_removed() -> void:
	if is_powered_on:
		power_off()
	rom_path = ""
