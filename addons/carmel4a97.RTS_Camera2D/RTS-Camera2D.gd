# Copyright 2017 Kamil Lewan <carmel4a97@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends Camera2D

# Camera control settings:
# key - by keyboard
# drag - by clicking mouse button, right mouse button by default;
# edge - by moving mouse to the window edge
# wheel - zoom in/out by mouse wheel
@export var key: bool = true
@export var drag: bool = true
@export var edge: bool = false
@export var wheel: bool = true

@export var zoom_out_limit: int = 100

# Camera speed in px/s.
@export var camera_speed: int = 450 

# Initial zoom value taken from Editor.
var camera_zoom = get_zoom()

# Value meaning how near to the window edge (in px) the mouse must be,
# to move a view.
@export var camera_margin: int = 50

# It changes a camera zoom value in units... (?, but it works... it probably
# multiplies camera size by 1+camera_zoom_speed)
const camera_zoom_speed: Vector2 = Vector2(0.5, 0.5)

# Vector of camera's movement / second.
var camera_movement: Vector2 = Vector2()

# Previous mouse position used to count delta of the mouse movement.
var _prev_mouse_pos: Vector2 = Vector2.ZERO

# INPUTS

# Right mouse button was or is pressed.
var __rmbk = false
# Move camera by keys: left, top, right, bottom.
var __keys = [false, false, false, false]

func _ready():
	set_drag_horizontal_enabled(false)
	set_drag_vertical_enabled(false)
	set_position_smoothing_enabled(true)
	set_position_smoothing_speed(4)

func _physics_process(delta):
	
	# Move camera by keys defined in InputMap (ui_left/top/right/bottom).
	if key:
		if __keys[0]:
			camera_movement.x -= camera_speed * delta
		if __keys[1]:
			camera_movement.y -= camera_speed * delta
		if __keys[2]:
			camera_movement.x += camera_speed * delta
		if __keys[3]:
			camera_movement.y += camera_speed * delta
	
	# Move camera by mouse, when it's on the margin (defined by camera_margin).
	if edge:
		var rec = get_viewport().get_visible_rect()
		var v = get_local_mouse_position() + rec.size/2
		if rec.size.x - v.x <= camera_margin:
			camera_movement.x += camera_speed * delta
		if v.x <= camera_margin:
			camera_movement.x -= camera_speed * delta
		if rec.size.y - v.y <= camera_margin:
			camera_movement.y += camera_speed * delta
		if v.y <= camera_margin:
			camera_movement.y -= camera_speed * delta
	
	# When RMB is pressed, move camera by difference of mouse position
	if drag and __rmbk:
		camera_movement = _prev_mouse_pos - get_local_mouse_position()
	
	# Update position of the camera.
	position += camera_movement * get_zoom()
	
	# Clamp camera to bounds - used so that we cannot keep scrolling forever.
	var zoom = get_zoom()
	var viewport = get_viewport_rect()
	var actual_left_limit = viewport.end.x * zoom.x / 2
	var actual_top_limit = viewport.end.y * zoom.y / 2
	
	position.x = clamp(position.x, actual_left_limit, limit_right - actual_left_limit)
	position.y = clamp(position.y, actual_top_limit, limit_bottom - actual_top_limit)
	
	# Set camera movement to zero, update old mouse position.
	camera_movement = Vector2(0,0)
	_prev_mouse_pos = get_local_mouse_position()

func _unhandled_input( event ):
	if event is InputEventMouseButton:
		if drag and\
			event.button_index == MOUSE_BUTTON_RIGHT:
			# Control by right mouse button.
			if event.pressed: __rmbk = true
			else: __rmbk = false
		# Check if mouse wheel was used. Not handled by ImputMap!
		if wheel:
			# Checking if future zoom won't be under 0.
			# In that cause engine will flip screen.
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and\
			camera_zoom.x - camera_zoom_speed.x > 0 and\
			camera_zoom.y - camera_zoom_speed.y > 0:
				camera_zoom -= camera_zoom_speed
				set_zoom(camera_zoom)
				# Checking if future zoom won't be above zoom_out_limit.
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and\
			camera_zoom.x + camera_zoom_speed.x < zoom_out_limit and\
			camera_zoom.y + camera_zoom_speed.y < zoom_out_limit:
				camera_zoom += camera_zoom_speed
				set_zoom(camera_zoom)
	# Control by keyboard handled by InpuMap.
	if event.is_action_pressed("ui_left"):
		__keys[0] = true
	if event.is_action_pressed("ui_up"):
		__keys[1] = true
	if event.is_action_pressed("ui_right"):
		__keys[2] = true
	if event.is_action_pressed("ui_down"):
		__keys[3] = true
	if event.is_action_released("ui_left"):
		__keys[0] = false
	if event.is_action_released("ui_up"):
		__keys[1] = false
	if event.is_action_released("ui_right"):
		__keys[2] = false
	if event.is_action_released("ui_down"):
		__keys[3] = false
