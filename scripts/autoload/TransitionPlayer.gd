extends CanvasLayer

@onready var anim_player = $AnimationPlayer

func play_transition(name: String) -> void:
	anim_player.play(name)