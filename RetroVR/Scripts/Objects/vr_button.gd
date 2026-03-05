## VRButton — Area3D that emits button_pressed when a VR controller touches it.
## Attach to any Area3D that has a child MeshInstance3D named "ButtonMesh".
## The mesh depresses visually on contact and resets when the controller leaves.
class_name VRButton
extends Area3D


signal button_pressed


# Count of bodies currently inside, to handle simultaneous entries gracefully
var _press_count: int = 0

# Original local position of ButtonMesh, cached at _ready
var _mesh_origin: Vector3

@onready var _mesh: MeshInstance3D = $ButtonMesh


func _ready() -> void:
	_mesh_origin = _mesh.position
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(_body: Node3D) -> void:
	_press_count += 1
	if _press_count == 1:
		# Depress the button mesh 8mm inward (downward relative to button face)
		_mesh.position = _mesh_origin + Vector3(0, -0.008, 0)
		button_pressed.emit()


func _on_body_exited(_body: Node3D) -> void:
	_press_count = max(0, _press_count - 1)
	if _press_count == 0:
		_mesh.position = _mesh_origin
