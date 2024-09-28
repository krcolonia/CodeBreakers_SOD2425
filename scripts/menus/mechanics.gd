extends CanvasLayer

@onready var anim_player = $AnimationPlayer

var inGameMusic = preload("res://assets/snds/InGameMusic.mp3")

func _ready() -> void:
	anim_player.play("fade_in")


func _on_begin_button_up() -> void:
	anim_player.play("fade_out")
	await get_tree().create_timer(1.5).timeout
	Music.stop()
	Music.stream = inGameMusic
	Music.play()
	get_tree().change_scene_to_file("res://scenes/GameUI.tscn")


