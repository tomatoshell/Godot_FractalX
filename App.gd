extends AspectRatioContainer
onready var sh = $ColorRect.material
onready var ui = get_node("/root/Control/Cont")
onready var type_select = get_node("/root/Control/Cont/V/Button")
onready var speaker = $SS
func _ready():
	type_select.add_item("Mandel")
	type_select.add_item("Tricorn")
	type_select.add_item("Exp")
	type_select.add_item("Exp-mandel")
	type_select.add_item("Burning ship")
	type_select.add_item("Burning mandel")
	type_select.add_item("Long mandel")
	type_select.add_item("Feather")
	type_select.add_item("Power ferns")
	type_select.add_item("SFX")
	type_select.add_item("ZETA")
	type_select.add_item("Zerg")
	type_select.add_item("Serg")
	type_select.add_item("Logarithm")
	type_select.add_item("Bbox")
	type_select.add_item("Meta")
	type_select.add_item("AltFeather")
	type_select.add_item("Chirikov")
	type_select.add_item("Ln+Exp")
	type_select.add_item("Ln*Exp")
	type_select.add_item("Ln/Exp")
	type_select.add_item("Ln+Exp2")
	type_select.add_item("Ln*Exp2")
	type_select.add_item("Gingerbread")
	type_select.add_item("e^sin(z^2) + c")
	type_select.add_item("Collatz")
	type_select.add_item("1.5set")
	type_select.add_item("Nova")
	type_select.add_item("Oceanic")
	type_select.add_item("Divy")

func _input(event):
	if(event is InputEventMouseButton):
		if(event.button_index == BUTTON_WHEEL_UP):
			$Tween.interpolate_property(sh, "shader_param/zoom", sh.get_shader_param("zoom"), sh.get_shader_param("zoom")*1.1, 0.05)
			$Tween.interpolate_property(sh, "shader_param/ofs", sh.get_shader_param("ofs"), sh.get_shader_param("ofs") + (get_local_mouse_position()/OS.window_size - Vector2(0.5,0.5))*rect_size.normalized()*0.5/sh.get_shader_param("zoom")/1.1, 0.05)
			$Tween.start()
		elif(event.button_index == BUTTON_WHEEL_DOWN):
			$Tween.interpolate_property(sh, "shader_param/zoom", sh.get_shader_param("zoom"), sh.get_shader_param("zoom")/1.1, 0.05)
			$Tween.start()
		elif(event.button_index == BUTTON_LEFT):
			#Audio
			if event.pressed:
				var pos = sh.get_shader_param("ofs") + (get_local_mouse_position()/OS.window_size - Vector2(0.5,0.5))*rect_size.normalized()*4.5/sh.get_shader_param("zoom")
				print(pos)
				speaker.to_sound(pos, sh.get_shader_param("type"))
			else: speaker.stop_sound()
	if(event.is_action_pressed("ui_cancel")):
		ui.visible = !ui.visible

func _physics_process(delta):
	if(Input.is_action_pressed("ui_left")):
		$Tween.interpolate_property(sh, "shader_param/ofs", sh.get_shader_param("ofs"), sh.get_shader_param("ofs") + Vector2(-0.05,0)/sh.get_shader_param("zoom"), 0.05)
		$Tween.start()
	elif(Input.is_action_pressed("ui_right")):
		$Tween.interpolate_property(sh, "shader_param/ofs", sh.get_shader_param("ofs"), sh.get_shader_param("ofs") + Vector2(0.05,0)/sh.get_shader_param("zoom"), 0.05)
		$Tween.start()
	elif(Input.is_action_pressed("ui_up")):
		$Tween.interpolate_property(sh, "shader_param/ofs", sh.get_shader_param("ofs"), sh.get_shader_param("ofs") + Vector2(0,-0.05)/sh.get_shader_param("zoom"), 0.05)
		$Tween.start()
	elif(Input.is_action_pressed("ui_down")):
		$Tween.interpolate_property(sh, "shader_param/ofs", sh.get_shader_param("ofs"), sh.get_shader_param("ofs") + Vector2(0,0.05)/sh.get_shader_param("zoom"), 0.05)
		$Tween.start()

func _on_type_selected(index):
	sh.set_shader_param("type", index)

func _on_Visual_value_changed(value):
	sh.set_shader_param("visual", int(value))

func _on_Zoom_pressed():
	sh.set_shader_param("zoom", 1.0)
	sh.set_shader_param("ofs", Vector2(0,0))

