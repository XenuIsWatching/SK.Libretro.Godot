## SystemManager — autoload singleton that enforces the one-core-at-a-time constraint.
extends Node


## The currently powered-on system, or null
var active_system: Node = null


## Stop whatever system is currently running, then clear it
func stop_active_system() -> void:
	if active_system and active_system.has_method("power_off"):
		active_system.power_off()
	active_system = null


## Register a system as the active one (call after starting content)
func set_active_system(system: Node) -> void:
	active_system = system


## Called by a system when it stops itself (without going through stop_active_system)
func clear_active_system() -> void:
	active_system = null
