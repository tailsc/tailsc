@tool
extends Node3D

@export var equipment: Equipment:
	set(value):
		equipment = value
		if Engine.is_editor_hint():
			_load_weapon()

@onready var equipment_mesh: MeshInstance3D = $EquipmentMesh
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_load_weapon()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("rifle"):
		_change_equipment("res://Resources/Rifle.tres")

	if event.is_action_pressed("hammer"):
		_change_equipment("res://Resources/Hammer.tres")

func _change_equipment(resource_path: String) -> void:
	if animation_player.is_playing():
		await animation_player.animation_finished

	equipment = load(resource_path)
	_load_weapon()
	animation_player.play("new_animation")

func _load_weapon() -> void:
	if equipment and equipment_mesh:
		equipment_mesh.mesh = equipment.mesh

func _on_button_pressed() -> void:
	if equipment and equipment.level < equipment.cost.size():
		var upgrade_cost = equipment.cost[equipment.level]
		if Global.currency >= upgrade_cost:
			Global.currency -= upgrade_cost
			equipment._apply_upgrade()
			equipment.level += 1
		else:
			print("Not enough currency to upgrade.")
	else:
		print("No more upgrades available.")
