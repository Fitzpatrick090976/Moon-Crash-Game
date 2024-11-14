extends Node2D


# WHEN VISIBILITY == FALSE, ROOM IS VISIBLE


var is_alpha_changing: bool = false
var tile_alpha_manager: Dictionary = {}

const LERP_SPEED = 1


func _ready() -> void:
	SignalBus.activate_tilemap.connect(_on_activate_tilemap)
	SignalBus.disable_tilemap.connect(_on_disable_tilemap)
	# INIT ALPHA MANAGER & DEST
	for child in get_children():
		tile_alpha_manager[str(child)] = [1.0, child, 1.0] # DEFAULT VISIBLE
		# 0 -- DEST
		# 1 -- REFERENCE TO SELF
		# 2 -- T


func _on_activate_tilemap(tilemap: TileMapLayer):
	# LOOP THROUGH CHILDREN
	for child in get_children():
		if child == tilemap:
			is_alpha_changing = true
			tile_alpha_manager[str(child)][0] = 0.0 # DEST: INVISIBLE
			tile_alpha_manager[str(child)][2] = 1.0 # RESET T


func _on_disable_tilemap(tilemap: TileMapLayer):
	# LOOP THROUGH CHILDREN
	for child in get_children():
		if child == tilemap:
			is_alpha_changing = true
			tile_alpha_manager[str(child)][0] = 1.0 # DEST: VISIBLE
			tile_alpha_manager[str(child)][2] = 0.0 # RESET T


func _physics_process(delta: float) -> void:
	if is_alpha_changing:
		for tilemap in tile_alpha_manager.keys():
			var dest = tile_alpha_manager[str(tilemap)][0]
			if tile_alpha_manager[str(tilemap)][1].modulate != Color(1, 1, 1, dest):
				if dest == 0.0:
					tile_alpha_manager[str(tilemap)][2] -= LERP_SPEED * delta
					if tile_alpha_manager[str(tilemap)][2] < dest:
						tile_alpha_manager[str(tilemap)][1].modulate = Color(1, 1, 1, dest)
					else:
						tile_alpha_manager[str(tilemap)][1].modulate = Color(1, 1, 1, tile_alpha_manager[str(tilemap)][2])
				elif dest == 1.0:
					tile_alpha_manager[str(tilemap)][2] += LERP_SPEED * delta
					if tile_alpha_manager[str(tilemap)][2] > dest:
						tile_alpha_manager[str(tilemap)][1].modulate = Color(1, 1, 1, dest)
					else:
						tile_alpha_manager[str(tilemap)][1].modulate = Color(1, 1, 1, tile_alpha_manager[str(tilemap)][2])

# EVERY FRAME
	# LOOP THROUGH EACH TILEMAP
		# IF NOT AT ALPHA DEST
			# IF DECREASING
				# DECREMENT VALUE OF TEMP
				# IF TEMP LESS THAN DEST
					# OVERFLOW -- SET MODULATE VALUE TO DEST
				# ELSE
					# SET MODULATE VALUE TO TEMP
			# ELIF INCREASING
				# INCREMENT VALUE OF TEMP
				# IF TEMP GREATER THAN DEST
					# OVERFLOW -- SET MODULATE VALUE TO DEST
				# ELSE
					# SET MODULATE VALUE TO TEMP
