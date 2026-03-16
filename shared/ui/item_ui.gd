class_name ItemUI
extends Control


@onready var icon: TextureRect = %Icon

@export var tooltip_scene: PackedScene
var tooltip: ItemTooltip

var item: ItemInstance
var grid_pos: Vector2i
var dragging := false
var drag_offset := Vector2.ZERO
var initial_pos = Vector2.ZERO
var focus = false

const CELL_SIZE := 22

# @export var click_distance = 2


func setup(i: ItemInstance):
	item = i
	if icon:
		icon.texture = item.base.icon


func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() - drag_offset


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			initial_pos = event.global_position
			dragging = true
			set_z_index(100)
			drag_offset = get_global_mouse_position() - global_position
			InventoryManager.clear_item(item)

			_on_mouse_exited() # Workaround to hide Tooltip, may cause bugs
			
		else:
			dragging = false
			set_z_index(0)
			_drop()
			_on_mouse_entered() # Workaround to show Tooltip again. Might cause bugs

			
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
	
	
func _update_tooltip_position():
	if tooltip:
		var pos: Vector2
		pos.x = self.global_position.x - tooltip.size.x
		pos.y = self.global_position.y
		tooltip.global_position = pos


# Leave that here because we will need click functionality later

# func _click():
# 	if !focus:
# 		_focus()
# 	else:
# 		_unfocus()

		
# func _focus():
# 	if !focus:
# 		var inventory_ui := get_parent() as InventoryUI
# 		var current_slot = inventory_ui._get_slot_at(grid_pos)
# 		current_slot._highlight()
# 		inventory_ui.current_focus_item = self
# 		focus = true
	

# func _unfocus():
# 	if focus:
# 		var inventory_ui := get_parent() as InventoryUI
# 		var current_slot = inventory_ui._get_slot_at(grid_pos)
# 		current_slot._unhighlight()
# 		inventory_ui.current_focus_item = null
# 		focus = false


func _on_mouse_entered() -> void:
	if dragging:
		return
	
	tooltip = tooltip_scene.instantiate()
	get_tree().current_scene.find_child("UI").add_child(tooltip)
	tooltip.set_item(item)
	call_deferred("_update_tooltip_position")


func _on_mouse_exited() -> void:
	if tooltip:
		tooltip.queue_free()
		tooltip = null
