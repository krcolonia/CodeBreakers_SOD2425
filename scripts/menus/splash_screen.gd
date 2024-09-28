extends CanvasLayer

@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	anim_player.play("fade_in")
	await get_tree().create_timer(1.5).timeout
	anim_player.play("splash_anim")
	await get_tree().create_timer(4.0).timeout
	anim_player.play("fade_out")
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")