extends CanvasLayer

var selected_menu = 0
var can_load = false

func _ready():
	var file = File.new()
	if file.file_exists("user://saves/savegame.json"):
		can_load = true 
	file.close()
	if not can_load:
		$Continue.visible = false
		$Load.visible =  false
		$Save.visible = false
		$New_Game.rect_position = Vector2(790,25)
		$Options.rect_position = Vector2(790,105)
	else:
		$Continue.visible = true
		$Load.visible =  true
		$Save.visible = true
		$Load.rect_position = Vector2(790, 185)
		$New_Game.rect_position = Vector2(790, 265)
		$Options.rect_position = Vector2(790, 345)
		#$SavedAnimation.seek(0)
	
func gui_reveal():
	if get_tree().get_nodes_in_group("GUI"):
		var hide_gui = get_tree().get_nodes_in_group("GUI")
		hide_gui[0].visible = true

func change_color1():
	$New_Game.add_color_override("font_color", Color("ffffff"))
	$Options.add_color_override("font_color", Color("ffffff"))
	$Exit.add_color_override("font_color", Color("ffffff"))
	match selected_menu:
		0:
			$New_Game.add_color_override("font_color", Color("ebfb40"))
			$menu_parsing.play()
		1:
			$Options.add_color_override("font_color", Color("ebfb40"))
			$menu_parsing.play()
		2:
			$Exit.add_color_override("font_color", Color("ebfb40"))
			$menu_parsing.play()


func change_color2():
	$Continue.add_color_override("font_color", Color("ffffff"))
	$Save.add_color_override("font_color", Color("ffffff"))
	$Load.add_color_override("font_color", Color("ffffff"))
	$New_Game.add_color_override("font_color", Color("ffffff"))
	$Options.add_color_override("font_color", Color("ffffff"))
	$Exit.add_color_override("font_color", Color("ffffff"))
	match selected_menu:
		0:
			$Continue.add_color_override("font_color", Color("ebfb40"))
		1:
			$Save.add_color_override("font_color", Color("ebfb40"))
		2:
			$Load.add_color_override("font_color", Color("ebfb40"))
		3:
			$New_Game.add_color_override("font_color", Color("ebfb40"))
		4:
			$Options.add_color_override("font_color", Color("ebfb40"))
		5:
			$Exit.add_color_override("font_color", Color("ebfb40"))

func _input(_event):
	if not can_load:
		$menu_parsing.play()
		if Input.is_action_just_pressed("ui_down"):
			selected_menu = (selected_menu + 1) % 3
			change_color1()
		elif Input.is_action_just_pressed("ui_up"):
			$menu_parsing.play()
			if selected_menu > 0:
				selected_menu = (selected_menu - 1) % 3
			else:
				selected_menu = 2
			change_color1()
		elif Input.is_action_just_pressed("ui_accept"):
			$menu_choosing.play()
			match selected_menu:
				0:
					Tracker.new_game = true
					get_tree().paused = false
					self.queue_free()
				1:
					pass
				2:
					get_tree().quit()

	if can_load:
		if Input.is_action_just_pressed("ui_down"):
			selected_menu = (selected_menu + 1) % 6
			$menu_parsing.play()
			change_color2()
		elif Input.is_action_just_pressed("ui_up"):
			$menu_parsing.play()
			if selected_menu > 0:
				selected_menu = (selected_menu - 1) % 6
			else:
				selected_menu = 5
			change_color2()
		elif Input.is_action_just_pressed("ui_accept"):
			$menu_choosing.play()
			yield(get_tree().create_timer(0.1),"timeout")
			match selected_menu:
				0:
					if get_tree().get_nodes_in_group("Player"):
						get_tree().paused = false
						gui_reveal()
						self.queue_free()
					else:
						SaveManager.load_game()
						get_tree().paused = false
						gui_reveal()
						self.queue_free()
				1:
					if get_tree().get_nodes_in_group("Player"):
						$SavedAnimation.play("Saved")
						SaveManager.save_game()
				2:
					if can_load:
						SaveManager.load_game()
						get_tree().paused = false
						self.queue_free()
						gui_reveal()
					else:
						pass
				3:
					Tracker.new_game = true
					get_tree().paused = false
					self.queue_free()
				4:
					pass
				5:
					get_tree().quit()

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = false
		$menu_choosing.play()
		gui_reveal()
		self.queue_free()
