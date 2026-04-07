@tool # just so we can see the icons
class_name EquipmentSlot
extends Control


@onready var tooltip_scene: PackedScene = preload("uid://c0noo2eqn5l61") # delete after handling item display differently
var tooltip: ItemTooltip # delete after handling item display differently
# var tooltip_diplayable: bool = false # delete after handling item display differently

@onready var item_icon: TextureRect = $ItemIcon

@export var slot_type: LootEnums.ItemType
@export var player: Player

@export var slot_type_background_texture: Texture2D

static var hovered_slot: EquipmentSlot = null

var equipped_item: ItemInstance
@export var slot_index: int = 0 # For multi-slot items (rings, skills)


func _ready() -> void:
	_update_icon()

	SaveManager.game_loaded.connect(_on_game_loaded)


func _update_icon():
	if equipped_item:
		item_icon.texture = equipped_item.base.icon
	else:
		item_icon.texture = slot_type_background_texture


func drop_item(item: ItemInstance) -> bool:
	if item.base.type != slot_type:
		return false

	var old := equipped_item

	if old:
		if not InventoryManager.add_item(old):
			return false

	equipped_item = item
	_update_icon()

	player.equip_item(item, slot_index)
	
	# delete after handling item display differently
	if tooltip:
		tooltip.queue_free()
		tooltip = null
	_on_mouse_entered()

	return true


func _unequip():
	if not equipped_item:
		return
	
	if InventoryManager.add_item(equipped_item):
		equipped_item = null
		
		player.unequip_item(slot_type, slot_index)
		player.recalculate_stats()

		_update_icon()


func _on_mouse_entered() -> void:
	hovered_slot = self

	# delete after handling item display differently
	if not equipped_item:
		return
	
	tooltip = tooltip_scene.instantiate()
	get_tree().current_scene.find_child("UI").add_child(tooltip)
	tooltip.set_item(equipped_item)
	call_deferred("_update_tooltip_position")


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


func _gui_input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and event.pressed:
		_unequip()


func _on_mouse_exited() -> void:
	if hovered_slot == self:
		hovered_slot = null

	# delete after handling item display differently
	if tooltip:
		tooltip.queue_free()
		tooltip = null


func _physics_process(_delta: float) -> void:
	if hovered_slot != self and tooltip:
		tooltip.queue_free()
		tooltip = null


func refresh_from_stats():
	equipped_item = player.equipment_component.get_item(slot_type, slot_index)

	_update_icon()


func _on_game_loaded():
	refresh_from_stats()
