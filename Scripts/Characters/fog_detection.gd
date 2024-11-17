extends Area2D


# NEUTRAL (1 CURR OVERLAPPING, 1 PREV OVERLAPPING)
# TO_NEW (2 CURR OVERLAPPING, 1 PREV OVERLAPPING)
# TRANSITION (2 CURR OVERLAPPING, 2 PREV OVERLAPPING)
# FROM_PREV (1 CURR OVERLAPPING, 2 PREV OVERLAPPING)
enum CollisionState {NEUTRAL, TO_NEW, TRANSITION, FROM_PREV, INIT = -1}


var curr_collision_state: CollisionState
var curr_overlap_bodies: int = 0
var prev_overlap_bodies: int = 0
var regular_body: TileMapLayer
var new_body: TileMapLayer


func _ready() -> void:
	# ACTIVATE INIT BODY
	pass


func _physics_process(delta: float) -> void:	
	curr_overlap_bodies = get_overlapping_bodies().size()
	if curr_overlap_bodies == 1 and prev_overlap_bodies == 1:
		curr_collision_state = CollisionState.NEUTRAL
		regular_body = get_overlapping_bodies()[0]
		# DO NOTHING
	elif curr_overlap_bodies == 2 and prev_overlap_bodies == 1:
		curr_collision_state = CollisionState.TO_NEW
		# FIND NEW BODY
		for body in get_overlapping_bodies():
			if body != regular_body:
				new_body = body
		# ACTIVATE NEW BODY
		SignalBus.activate_tilemap.emit(new_body)
	elif curr_overlap_bodies == 2 and prev_overlap_bodies == 2:
		curr_collision_state = CollisionState.TRANSITION
		# DO NOTHING
	elif curr_overlap_bodies == 1 and prev_overlap_bodies == 2:
		curr_collision_state = CollisionState.FROM_PREV
		# DISABLE PREV BODY
		SignalBus.disable_tilemap.emit(regular_body)
	elif curr_overlap_bodies == 1 and prev_overlap_bodies == 0:
		curr_collision_state = CollisionState.INIT
		regular_body = get_overlapping_bodies()[0]
		SignalBus.activate_tilemap.emit(regular_body)
	
	
	prev_overlap_bodies = curr_overlap_bodies
