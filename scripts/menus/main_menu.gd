extends CanvasLayer

@onready var anim_player = $AnimationPlayer

var mainMenuMusic = preload("res://assets/snds/MainMenuMusic.mp3")

func _ready() -> void:
	anim_player.play("fade_in")

func _process(_delta: float) -> void:
	if !Music.is_playing():
		Music.stream = mainMenuMusic
		Music.play()

func _on_start_button_up() -> void:
	anim_player.play("fade_out")
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/menu/mechanics.tscn")

func _on_exit_button_up() -> void:
	get_tree().quit()

