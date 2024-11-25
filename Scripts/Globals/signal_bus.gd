extends Node

signal show_dialogue(key: String, path: String)

signal choice_selected(response_key: String)

signal init_dialogue()

signal terminate_dialogue()

signal init_cutscene()

signal terminate_cutscene()

signal lerp_player(dest_position: Vector2)

signal lerp_camera(dest_position: Vector2)

signal lerp_player_finished()

signal lerp_camera_finished()

signal get_player_position(player_position: Vector2)

signal activate_tilemap(tilemap: TileMapLayer)

signal disable_tilemap(tilemap: TileMapLayer)

signal level_start()

signal level_end()

signal transition_to_level()

signal update_character_key_manager(update: String, dest: String)
