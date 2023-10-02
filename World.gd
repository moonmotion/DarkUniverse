extends Node2D
 #Comments mostly in the singletons, articles are missed for short explanation. Code was made by me Moon_Motion,
 #Idea around this game was from 2016 when Dark Orbit become dead and private servers become more popular and alive
 #Yet this game still my dream thats wanted to be realised and first entiry im create.
 #From 0 to realised game, theres some monkey code, some prof code and mechanics that i created without knowledge how to write not like indian
 #80% of assets created by myself or by telescopes from observatories on the Earth. Others 20% are free and i have my thanks to autors of them.
 #forsenCD roflanTigran

var spawnpoint = Vector2(0, -3400)
onready var Menu = preload("res://Menu.tscn")

func _input(event):
	if event.is_action_pressed("Cancel"):
		if !Selector.locked:
			if not has_node("Menu"):
				load_menu()

func load_menu():
	var game_is_frozen_lul = Menu.instance()
	if get_tree().get_nodes_in_group("GUI"):
		var hide_gui = get_tree().get_nodes_in_group("GUI")
		hide_gui[0].visible = false
	get_tree().paused = true
	add_child(game_is_frozen_lul)

func load_map(actual_map:PackedScene):
	var map = actual_map.instance()
	add_child(map)

func load_ship(actual_ship:PackedScene):
	var ship = actual_ship.instance()
	add_child(ship)
	if Tracker.new_game:
		ship.set_deferred("global_position", spawnpoint)

func new_game():
	if get_tree().get_nodes_in_group("Map"):
		var quell_map = get_tree().get_nodes_in_group("Map")
		remove_child(quell_map[0])
		var quell_head = get_tree().get_nodes_in_group("Player")
		remove_child(quell_head[0])
	SaveManager.new_game()

func deathscreen_continue():
	if !MapTracker.is_cargo_stolen:
		var cargo = get_tree().get_nodes_in_group("PlayerCargo")
		cargo[0].is_creep_nearby = true
	MapTracker.verlassen_map = true
	MapTracker.distant_klart_route = false
	MapTracker.distant_eero_nebula = false
	yield(get_tree().create_timer(0.2),"timeout")
	if get_tree().get_nodes_in_group("Map"):
			var quell_map = get_tree().get_nodes_in_group("Map")
			remove_child(quell_map[0])
			var quell_head = get_tree().get_nodes_in_group("Player")
			remove_child(quell_head[0])
	MapTracker.map_separator()
	MapTracker.ship_separator()
	MapTracker.dscTrigger = true

func _ready():
	load_menu()
	#MapTracker.map_separator()
	#MapTracker.ship_separator()

func _process(_delta):
	if MapTracker.switch_map:
		load_map(MapTracker.current_map)
		MapTracker.switch_map = false
	if MapTracker.switch_ship:
		load_ship(MapTracker.current_ship)
		MapTracker.switch_ship = false
		Tracker.new_game = false  #For new_game, simple closer
	if SaveManager.loading:
		if get_tree().get_nodes_in_group("Map"):
			var quell_map = get_tree().get_nodes_in_group("Map")
			remove_child(quell_map[0])
			var quell_head = get_tree().get_nodes_in_group("Player")
			remove_child(quell_head[0])
		MapTracker.map_separator()
		MapTracker.ship_separator()
		Tracker.load_trigger = true #Turning on second load trigger after main scenes
		SaveManager.loading = false #Turning off first main load trigger
	if Tracker.new_game:
		new_game()
	if Tracker.load_menu:
		var quell_map = get_tree().get_nodes_in_group("Map")
		remove_child(quell_map[0])
		var quell_head = get_tree().get_nodes_in_group("Player")
		remove_child(quell_head[0])
		load_menu()
		Tracker.load_menu = false
	if Tracker.dscContinue:
		deathscreen_continue()
		Tracker.dscContinue = false #Tracker.dscontinue=false inside the EntityPlayer for load aditional params
