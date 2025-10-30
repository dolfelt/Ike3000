extends Node2D

@export var noise_height_map : NoiseTexture2D
@export var noise_object_map : NoiseTexture2D

@onready var tilemap: TileMapLayer = $LandTileMap
@onready var obj_tilemap: TileMapLayer = $ObjectTileMap

var noise: Noise
var object_noise: Noise

var width = 25;
var height: int = 400;

const TILE_WATER = Vector2i(6,3)
const TILE_LAND = Vector2i(2,4)

const TILE_BUSH = Vector2i(0,3)
const TILE_TREE = Vector2i(0,4)
const TILE_TREES = Vector2i(0,5)

const TILES_TREES = [TILE_BUSH, TILE_TREE, TILE_TREE, TILE_TREE, TILE_TREES, TILE_TREES]

const TERRAIN_LAND = 0;
var water_arr = []
var land_arr = []

func _ready() -> void: 
	noise = noise_height_map.noise
	object_noise = noise_object_map.noise
	generate_world()

func generate_world():
	for x in range(width):
		for y in range(height):
			var vec: Vector2i = Vector2i(x, -y)
			var noise_val:float = noise.get_noise_2d(vec.x, vec.y)
			var tile = get_noise_tile(noise_val)

			if tile == TILE_WATER:
				tilemap.set_cell(vec, 0, tile)
			elif tile == TILE_LAND:
				land_arr.append(vec)

				if noise_val < -0.1: 
					# Check for object placement
					var obj_noise_val:float = object_noise.get_noise_2d(vec.x, vec.y)
					if obj_noise_val > 0.75:
						obj_tilemap.set_cell(vec, 0, TILES_TREES.pick_random())

				# tilemap.set_cell(Vector2i(x,-y), 0, TILE_LAND)
				
	tilemap.set_cells_terrain_connect(land_arr, 0, TERRAIN_LAND)

func get_noise_tile(noise_val: float) -> Vector2i:
	
	# Return land if less than 0
	if noise_val < 0.0:
		return TILE_LAND

	return TILE_WATER

# func checkAdjCells(vec: Vector2i) -> bool:
# 	var center_tile = get_noise_tile(vec)

# 	# Define 8 directions: N, NE, E, SE, S, SW, W, NW
# 	var directions = [
# 		Vector2i(0, 1),   # N
# 		Vector2i(1, 1),   # NE
# 		Vector2i(1, 0),   # E
# 		Vector2i(1, -1),  # SE
# 		Vector2i(0, -1),  # S
# 		Vector2i(-1, -1), # SW
# 		Vector2i(-1, 0),  # W
# 		Vector2i(-1, 1)   # NW
# 	]

# 	# Check if all 8 adjacent cells have the same tile
# 	for dir in directions:
# 		var adj_vec = vec + dir
# 		if get_noise_tile(adj_vec) != center_tile:
# 			return false

# 	return true
