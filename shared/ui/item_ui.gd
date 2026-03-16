class_name ItemUI
extends Control


@onready var icon: TextureRect = %Icon

var item: ItemInstance
var grid_pos: Vector2i
var dragging := false
var drag_offset := Vector2.ZERO
var initial_pos = Vector2.ZERO
var focus = false

const CELL_SIZE := 22

@export var click_distance = 2


func setup(i: ItemInstance):
	item = i
	if icon:
		icon.texture = item.base.icon


func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() - drag_offset

		#var inventory_ui := get_parent() as InventoryUI
		# inventory_ui.update_drag_preview(
		# 	item,
		# 	inventory_ui.get_local_mouse_position()
		# )


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			initial_pos = event.global_position
			dragging = true
			set_z_index(100)
			drag_offset = get_global_mouse_position() - global_position
			InventoryManager.clear_item(item)
			
		elif event.is_released() and dragging:
			var distance = event.global_position.distance_to(initial_pos)
			if distance < click_distance:
				dragging = false
				_click()
			else:
				_unfocus()
				dragging = false
				set_z_index(0)
				_drop()
				
		
	#else:
		#dragging = false
		#set_z_index(0)
		#_drop()

			


func _drop():
	var inventory_ui := get_parent() as InventoryUI
	
	var local := inventory_ui.get_local_mouse_position()
	var target := (local / CELL_SIZE).floor()

	if InventoryManager.can_place(item, target):
		InventoryManager.place(item, target)
		grid_pos = target
	else:
		InventoryManager.place(item, grid_pos)
	
	position = grid_pos * CELL_SIZE
	
	
	
func _click():
	if !focus:
		_focus()
	else:
		_unfocus()

		
func _focus():
	if !focus:
		var inventory_ui := get_parent() as InventoryUI
		var current_slot = inventory_ui._get_slot_at(grid_pos)
		current_slot._highlight()
		inventory_ui.current_focus_item = self
		focus = true
	

func _unfocus():
	if focus:
		var inventory_ui := get_parent() as InventoryUI
		var current_slot = inventory_ui._get_slot_at(grid_pos)
		current_slot._unhighlight()
		inventory_ui.current_focus_item = null
		focus = false
	
