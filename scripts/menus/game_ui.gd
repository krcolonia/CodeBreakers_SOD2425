extends CanvasLayer

@onready var anim_player = $AnimationPlayer

@onready var question_label = $QuestionNo

@onready var tries_label = $TriesLabel
@onready var points_label = $PointsLabel

@onready var code_edit = $MarginContainer/VBoxContainer/CodeEdit

@onready var loading_panel = $LoadingCodePanel
@onready var loading_text = $LoadingCodePanel/MarginContainer/RichTextLabel

var problems = [
# ? Problem 1
"package codeBreakers;

public class Main {
    public static void main(String[] args) {
        System.out.println(\"Hello, World!\")
    }
}",

# ? Problem 2
"package codeBreakers;

public class Main {
    public static void main(String[] args) {
        int result = addNumbers(5, 3);
        System.out.println(result);
    }

    public static int addNumbers(int a, int b) {
        int result = a + b;
    }
}",

# ? Problem 3
"packade codeBreakers

public class Main {
    public static void main(String[] args) {
        int[] numbers = {1, 2, 3};
		/* The number that should print should be 3 */
        System.out.println(numbers[3]);
    }
}",

# ? Problem 4
"package codeBreakers;

public class Main {
    public static void main(String[] args) {
        int number = 5;
        System.out.println(Number);
    }
}",

# ? Problem 5
"package codeBreakers;

public class Main {
    public static void main(String[] args) {
        String str1 = \"hello\";
        String str2 = \"hello\";
        
        if (str1 == str2) {
            System.out.println(\"Strings are equal\");
        } else {
            System.out.println(\"Strings are not equal\");
        }
    }
}"
]

var output_string = [
# ? Output 1
"Hello, World!",

# ? Output 2
"8",

# ? Output 3
"3",

# ? Output 4
"5",

# ? Output 5
"Strings are equal"
]

var current = 0

var points = 0

func _ready() -> void:
	GameVariables.tries = 3
	question_label.text = "#" + str(current + 1)
	code_edit.text = problems[current]
	tries_label.text = "Tries Left: %s" % str(GameVariables.tries)
	points_label.text = "Points: %s" % str(points)
	anim_player.play("fade_in")
	await get_tree().create_timer(1.5).timeout

func _process(_delta: float) -> void:
		if GameVariables.tries == 0:
			get_tree().change_scene_to_file("res://scenes/menu/GameOver.tscn")
		

var code = "user://CodeBreakers/CodeBreakers.java"
var compile_code = OS.get_user_data_dir() + "/CodeBreakers/CodeBreakers.java"

var compile_thread: Thread

func _on_run_code_button_up() -> void:
	loading_panel.visible = true
	await get_tree().create_timer(0.5).timeout

	var file
	
	file = FileAccess.open(code, FileAccess.WRITE)

	file.store_string(code_edit.text)
	file.close()

	compile_thread = Thread.new()
	compile_thread.start(_compile_thread_func)

	await compile_thread.wait_to_finish()
	var stdout = []
	OS.execute("java", [compile_code], stdout)

	print("\nOutput:\n" + str(stdout) + "\nSolution:\n" + output_string[current])

	if (str(stdout[0]).strip_edges(true, true) in output_string[current]):
		if current == 4:
			get_tree().change_scene_to_file("res://scenes/menu/WinScreen.tscn")
		else:
			loading_text.text = "Correct Answer"
			await get_tree().create_timer(2.0).timeout
			loading_panel.visible = false
			loading_text.text = "Compiling..."
			current += 1
			points += 20
			question_label.text = "#" + str(current + 1)
			code_edit.text = problems[current]
			points_label.text = "Points: %s" % str(points)
			
	else:
		GameVariables.tries -= 1
		tries_label.text = "Tries Left: %s" % str(GameVariables.tries)
		loading_text.text = "Incorrect Answer"
		await get_tree().create_timer(2.0).timeout
		loading_panel.visible = false
		loading_text.text = "Compiling..."


func _compile_thread_func():
	OS.execute("javac", [compile_code])