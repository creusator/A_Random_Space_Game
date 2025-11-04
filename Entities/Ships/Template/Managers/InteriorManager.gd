class_name InteriorManager
extends Node2D

var active_zones: Array[InteriorComponent] = []
var original_parent: Node = null

func _ready() -> void:
	initialize_interior_zones()

func initialize_interior_zones() -> void:
	for child in get_children():
		if child is InteriorComponent:
			child.room_area.body_entered.connect(_on_zone_entered.bind(child))
			child.room_area.body_exited.connect(_on_zone_exited.bind(child))

func _on_zone_entered(body: Node, zone: InteriorComponent) -> void:
	if original_parent == null:
		original_parent = body.get_parent()
	
	if zone not in active_zones:
		active_zones.append(zone)
		call_deferred("_update_parent", body)

func _on_zone_exited(body: Node, zone: InteriorComponent) -> void:
	active_zones.erase(zone)
	call_deferred("_update_parent", body)

func _update_parent(body: Node) -> void:
	var target_parent
	if active_zones.size() > 0:
		target_parent = active_zones.back() 
	else :
		target_parent = original_parent
	
	if body.get_parent() != target_parent:
		body.reparent(target_parent)
		body.owner = target_parent
		print("→ Joueur déplacé vers : %s" % target_parent.name)
