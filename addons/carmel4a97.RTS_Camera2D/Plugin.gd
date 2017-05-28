tool

extends EditorPlugin

func _enter_tree():
	
	 add_custom_type("RTS-Camera2D", "Camera2D", preload("RTS-Camera2D.gd"), preload("node_icon.png"))

func _exit_tree():
	
	remove_custom_type("RTS-Camera2D")
