### UI Manager
extends Node

signal dev_console_added

var _dev_console: DevConsole

func _check_dev_console(inability: String) -> bool:
	if _dev_console:
		return true
	
	push_error("UIManager: _dev_console is not initialized. cannot " + inability)
	return false

func _show_dev_console_if_not_visisble() -> void:
	if _dev_console.visible:
		return
	
	var show_dev_console_event: InputEvent = InputEventAction.new()
	show_dev_console_event.action = "show_dev_console"
	show_dev_console_event.pressed = true
	Input.parse_input_event(show_dev_console_event)

func show_text(text: String) -> void:
	if not _check_dev_console("show text" + text + " to dev console"):
		return
	
	_dev_console.output_text(text)
	_show_dev_console_if_not_visisble()

func show_warning(text: String) -> void:
	if not _check_dev_console("show warning text" + text + " to dev console"):
		return
	
	_dev_console.output_warning(text)

func show_error(text: String) -> void:
	if not _check_dev_console("show error text" + text + " to dev console"):
		return
	
	_dev_console.output_error(text)
	_show_dev_console_if_not_visisble()

func show_player_stats() -> void:
	if not _check_dev_console("show player stats"):
		return
	
	_dev_console.output_player_stats()

func set_dev_console(console: DevConsole) -> void:
	_dev_console = console
	dev_console_added.emit()
