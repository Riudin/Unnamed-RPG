class_name CraftingSlot
extends Control

@onready var tooltip_scene: PackedScene = preload("uid://c0noo2eqn5l61") # delete after handling item display differently
var tooltip: ItemTooltip # delete after handling item display differently

@onready var item_icon: TextureRect = $ItemIcon

@export var slot_type_background_texture: Texture2D

static var hovered_slot: CraftingSlot = null

var item: ItemInstance


func _ready() -> void:
	_update_icon()


func _update_icon():
	if item:
		item_icon.texture = item.base.icon
	else:
		item_icon.texture = slot_type_background_texture


func drop_item(i: ItemInstance) -> bool:
	# return false if item is not craftable. there are no non-craftable items yet
	var old := item

	if old:
		if not InventoryManager.add_item(old):
			return false
	
	item = i
	_update_icon()
	
	# delete after handling item display differently
	# tooltip_diplayable = true
	if tooltip:
		tooltip.queue_free()
		tooltip = null
	_on_mouse_entered()

	return true


func _return_to_inventory():
	if not item:
		return
	
	if InventoryManager.add_item(item):
		item = null
		_update_icon()
	

func _gui_input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and event.pressed:
		_return_to_inventory()


func _on_mouse_entered() -> void:
	hovered_slot = self

	# delete after handling item display differently
	if not item:
		return
	
	tooltip = tooltip_scene.instantiate()
	get_tree().current_scene.find_child("UI").add_child(tooltip)
	tooltip.set_item(item)
	call_deferred("_update_tooltip_position")


func _on_mouse_exited() -> void:
	if hovered_slot == self:
		hovered_slot = null

	# delete after handling item display differently
	if tooltip:
		tooltip.queue_free()
		tooltip = null


# delete after handling item display differently
func _update_tooltip_position():
	if tooltip:
		var pos: Vector2
		pos.x = self.global_position.x + 22
		pos.y = self.global_position.y
		
		
		var y_extent = pos.y + tooltip.size.y
		if !get_viewport_rect().has_point(Vector2(0, y_extent)):
			pos.y = pos.y - (tooltip.size.y - 22)
		
		tooltip.global_position = pos


func _physics_process(_delta: float) -> void:
	if hovered_slot != self and tooltip:
		tooltip.queue_free()
		tooltip = null


func _on_reroll_affixes_button_pressed() -> void:
	if not item:
		return
	
	item.reroll_affixes()
	_update_icon()


func _on_increase_rarity_button_pressed() -> void:
	pass # Replace with function body.


func _on_reset_item_button_pressed() -> void:
	pass # Replace with function body.
