extends CanvasLayer

signal dialogueFinished

export(String, FILE, "*.json") var d_file

var dialogue = []
var currentDialogueID = 0
var d_active = false

func _ready():
	$NinePatchRect.visible = false

func start():
	
	if d_active:
		return
	get_tree().paused = true
	d_active = true
	$NinePatchRect.visible = true
	
	dialogue = load_dialogue()
	currentDialogueID = -1
	next_script()

func load_dialogue():
	var file = File.new()
	if file.file_exists(d_file):
		file.open(d_file, file.READ)
		return parse_json(file.get_as_text())

func _input(event):
	if not d_active:
		return
	if owner.name == "nekoSlime" and (owner.state == 8 or owner.state == 10) and currentDialogueID >= len(dialogue):
		return
	if event.is_action_pressed("interact"):
		next_script()

func next_script():
	currentDialogueID += 1
	
	if currentDialogueID >= len(dialogue):
		$Timer.start()
		$NinePatchRect.visible = false
		get_tree().paused = false
		emit_signal("dialogueFinished")
		return
	
	$NinePatchRect/Name.text = dialogue[currentDialogueID]["name"]
	$NinePatchRect/Chat.text = dialogue[currentDialogueID]["text"]


func _on_Timer_timeout():
	d_active = false
