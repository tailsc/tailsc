extends Node2D

# NODES
@onready var player_camera:Node3D = $camera_base
@onready var player_camera_visibleunits_Area3D:Area3D = $camera_base/visibleunits_area3D
@onready var ui_dragbox:NinePatchRect = $ui_dragbox

# Variables
@onready var BoxSelectionUnits_Visible:Dictionary = {}
# unit_id : unit_node
@onready var selection:Array = [] # Units selected at the moment.

# CONSTANTS
const min_drag_squared:int = 128

# Internal Variable
var mouse_left_click:bool = false
var drag_rectangle_area:Rect2

func _ready() -> void:
	initialize_interface()
	

func unit_entered(unit:Node3D) -> void:
	var unit_id:int = unit.get_instance_id()
	if selectable_units.keys().has(unit_id): return
	selectable_units[unit_id] = unit
	selection_update_units_selectable() 

func unit_exited(unit:Node3D) -> void:
	var unit_id:int = unit.get_instance_id()
	if !selectable_units.keys().has(unit_id): return
	selectable_units.erase(unit_id)
	selection_update_units_selectable() 

func initialize_interface() -> void:
	ui_dragbox.visible = false
	player_camera_visibleunits_Area3D.body_entered.connect(unit_entred)
	player_camera_visibleunits_Area3D.body_exited.connect(unit_exited)
	
func selection_single_cast(mouse_2D_pos:Vector2,shirt:bool = false) -> void:
	for unit in selectable_units_array:
		var unit_2D_pos:Vectir2 = player_camera.unproject_position( (unit as Node3D).transform.origin + Vector3(0,0.85,0) )
		
		if (mouse_2D_pos.distance_to(unit_2D_pos)) < 10.5:
			if shift:
				selection_add(unit)
				return # Add one unit.
			else:
				selection_select_array([unit])
				return # Use select array to select a single unit.

#func _input(event: InputEvent) -> void:
#	if Input.is_action_just_pressed("mouse_leftclick"):
#		var mouse_pos:Vector2 = get_viewport().get_mouse_position()
#		var camera:Camera3D = get_viewport().get_camera_3d()
#		var camera_raycast_coords:Vector3 = module_camera.get_vector3_from_camera_raycast(camera,mouse_pos)
#		if camera_raycast_coords != Vector3.ZERO:
#			camera_raycast_coords += Vector3(randf_range(-1.5,1.5),0,randf_range(-1.5,1.5))
#			nav_agent.set_target_position(camera_raycast_coords)
#			nav_path_goal_position = camera_raycast_coords

func _input(event:InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_leftclick"): # Runs once
		drag_rectangle_area.position = get_global_mouse_position()
		ui_dragbox.position = drag_rectangle_area.position
		mouse_left_click = true
	if Input.is_action_just_released("mouse_leftclick"): # runs once
		mouse_left_click = false
		ui_dragbox.visible = false
		
		var shift:bool = Input.is_action_pressed("shift")
		
		if drag_rectangle_area.size.length_squared() > min_drag_squared:
			selection_drag_box_cast(shift)
		else: # Singe selection units
			selection_single_cast( get_global_mouse_position(), shift )

func _process(delta: float) -> void:
	if mouse_left_click:
		
		drag_rectangle_area.size = get_global_mouse_position() - drag_rectangle_area.position
		update_ui_dragbox()
		
		if !ui_dragbox.visible:
			if drag_rectangle_area.size.length_squared() > min_drag_squared:
				ui_dragbox.visible = true

# Actually select units
func dragbox_cast_selection() -> void:
	for unit in BoxSelectionUnits_Visible.values():
		#temp fix 
		if unit is CharacterBody3D:
			if drag_rectangle_area.abs().has_point( player_camera.get_Vector2_from_Vector3(unit.transform.origin) ):
				unit.selected()
			else:
				unit.deselect()

func update_ui_dragbox() -> void:
	
	ui_dragbox.size = abs(drag_rectangle_area.size)
	# Detect When to scale the dragbox backwards. (because ninepatch only allow positive size)
	#Detect X swap
	if drag_rectangle_area.size.x < 0:
		ui_dragbox.scale.x = -1
	else: ui_dragbox.scale.x = 1
	# Detect Y Swap
	if drag_rectangle_area.size.y < 0:
		ui_dragbox.scale.y = -1
	else: ui_dragbox.scale.y = 1
