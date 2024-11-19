extends Node

signal show_dialogue(key: String, path: String)

signal choice_selected(response_key: String)

signal terminate_dialogue()

signal get_player_position(player_position: Vector2)

signal activate_tilemap(tilemap: TileMapLayer)

signal disable_tilemap(tilemap: TileMapLayer)
