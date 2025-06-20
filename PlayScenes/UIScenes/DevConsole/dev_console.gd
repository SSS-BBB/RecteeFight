class_name DevConsole extends CanvasLayer

@onready var _console_texts: RichTextLabel = %ConsoleTexts
@onready var _console_input: LineEdit = %ConsoleInput

signal console_enabled
signal console_disabled

func _ready() -> void:
	UIManager.set_dev_console(self)
	visible = false
	_console_input.keep_editing_on_text_submit = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("show_dev_console"):
		if not visible:
			_enable_console()
		else:
			_run_console()

func _enable_console() -> void:
	visible = true
	get_tree().paused = true
	_console_input.call_deferred("grab_focus")
	console_enabled.emit()

func _disable_console() -> void:
	visible = false
	get_tree().paused = false
	console_disabled.emit()

func _run_console() -> void:
	if _check_console_input():
		_disable_console()

# input from console input
func _check_console_input() -> bool:
	# return true if disable the console, false if not.
	var input_command: String = _console_input.text
	_console_input.text = ""
	
	if input_command.is_empty():
		return true
	if input_command.begins_with("/"):
		return do_command(input_command.substr(1))
	
	# print text to console
	output_text(input_command)
	return false

func do_command(command: String) -> bool:
	var split_command: PackedStringArray = command.split(" ", true, 1)
	var actual_command: String = ""
	var argument: String = ""
	actual_command = split_command[0]
	if split_command.size() > 1:
		# has argument
		argument = split_command[1]
	
	# commands
	if actual_command == "print":
		output_text(argument)
	elif actual_command == "print_warning":
		output_warning(argument)
	elif actual_command == "print_error":
		output_error(argument)
	elif actual_command == "print_player_stats":
		output_player_stats()
	elif actual_command == "change_wave":
		if argument.to_int() <= 0:
			var error_message: String = "DevConsole: argument is less than or equal to zero. cannot change the wave."
			output_error(error_message)
			push_error(error_message)
		else:
			change_wave(argument.to_int())
	elif actual_command == "kill":
		kill(argument)
	else:
		var error_message: String = actual_command + " command" + " is not implemented."
		output_error(error_message)
		push_error(error_message)
	
	return false

func change_wave(wave: int) -> void:
	GameManager.set_wave(wave)

func kill(argument: String) -> void:
	if argument == "basic_robots":
		kill_in_container("basic_robot_container")
	elif argument == "teleport_robots":
		kill_in_container("teleport_robot_container")
	elif argument == "shooting_robots":
		kill_in_container("shooter_robot_container")
	elif argument == "combined_robots":
		kill_in_container("combined_robot_container")
	elif argument == "all":
		kill_in_container("basic_robot_container")
		kill_in_container("teleport_robot_container")
		kill_in_container("shooter_robot_container")
		kill_in_container("combined_robot_container")
	else:
		var error_message: String = "DevConsole: " + argument + " is not implemented to be killed yet."
		push_error(error_message)
		output_error(error_message)

func kill_in_container(group: String) -> int:
	var count: int = 0
	
	var container: Node2D = get_tree().get_first_node_in_group(group)
	if not container:
		var error_message: String = "DevConsole: cannot find container with group name " + group + ". cannot kill nodes in this container."
		push_error(error_message)
		output_error(error_message)
		return 0
	
	for child in container.get_children():
		var child_health_component: HealthComponent = GameManager.find_health_component(child)
		if not child_health_component:
			var warning_message: String = "DevConsole: cannot find health component from " + child.to_string() + ". cannot kill this node."
			push_warning(warning_message)
			output_error(warning_message)
			continue
		child_health_component.force_die()
		count += 1
	
	output_text("Killed " + str(count) + " in container " + group)
	return count

# output to console texts
func output_text(text: String) -> void:
	_console_texts.add_text("\n" + "-" + text)

func output_warning(text: String) -> void:
	_console_texts.append_text("[color=yellow]" + "\n" + "-" +  text + "[/color]")

func output_error(text: String) -> void:
	_console_texts.append_text("[color=red]" + "\n" + "-" +  text + "[/color]")

func output_player_stats() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	if not player:
		var error_message: String = "DevConsole: cannot find player in group player. cannot output player stats."
		output_error(error_message)
		push_error(error_message)
		return
	
	var stats_message: String = "Player Stats\n"
	stats_message += "Current Health: " + str(player.get_health_component().get_current_health()) + "\n"
	stats_message += "Max Health: " + str(player.get_health_component().get_max_health()) + "\n"
	stats_message += "Speed: " + str(player.get_player_control().get_speed()) + "\n"
	stats_message += "Attack Duration: " + str(player.get_melee_attack_component().get_attack_duration()) + "\n"
	stats_message += "Attack Damage: " + str(player.get_melee_attack_component().get_attack_damage()) + "\n"
	stats_message += "--------------------------------------------------"
	output_text(stats_message)
