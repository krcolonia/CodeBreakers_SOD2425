extends CanvasLayer

var mainMenuMusic = preload("res://assets/snds/MainMenuMusic.mp3")

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	Music.stop()
	get_tree().change_scene_to_file("res://scenes/menu/splash_screen.tscn")