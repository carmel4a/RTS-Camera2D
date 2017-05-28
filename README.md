# RTS Camera2d :movie_camera:

RTS Camera2d plugin adds simple camera node to Godot Engine. You can control
camera using arrow keys, by dragging while holding mouse button or by moving
mouse cursor near to the screen edge. Despite the name, this node can be useful
in any game genre, not only RTS :wink:

# Installation

Use AssetLib or download archive from [Github releases][releases] and extract `addons` directory to
your project directory. Activate plugin in *Scene > Project Settings > Plugins*

[releases]: https://github.com/carmel4a/RTS-Camera2D/releases "releases"

# Usage

Create *RTS-Camera2D* node on your scene. Make sure to check the `Current` property on
in inspector. You can adjust behavior of the node using following properties

| Property       | Usage                                                                 |
| ----           | ----                                                                  |
| Key            | Move camera using keys binded to ui_* actions) like                   |
| Drag           | Move camera using mouse (right mouse button by default)               |
| Edge           | Move camera when cursor is close to edge screen                       |
| Wheel          | Zoom in/out using scroll wheel                                        |
| Zoom Out Limit | How far you can zoom out                                              |
| Camera speed   | self-explanatory                                                      |
| Camera margin  | how near to the window edge (in px) the mouse must be to move a view. |

# Compatibly

This plugin was tested in Godot Engine v2.1.3
