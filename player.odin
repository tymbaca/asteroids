package main

import rl "vendor:raylib"

_player_size: f32 = 20
_player_speed: f32 = 0.6
_player_rotation_speed: f32 = 0.1
_player_width_factor: f32 = 1

Player :: struct {
	position: rl.Vector2,
	force:    rl.Vector2,
	rotation: f32,
}

player_update :: proc(p: ^Player, delta: f32) {
	if rl.IsKeyPressed(.SPACE) {
		append(
			&_rockets,
			Rocket{position = p.position, direction = rl.Vector2Rotate(UP, p.rotation)},
		)
	}

	// movement
	diff: rl.Vector2 = {}
	if rl.IsKeyDown(.W) {
		diff += {0, -1}
	}
	if rl.IsKeyDown(.S) {
		diff += {0, 1}
	}
	if rl.IsKeyDown(.A) {
		diff += {-1, 0}
	}
	if rl.IsKeyDown(.D) {
		diff += {1, 0}
	}

	// rotation
	rot_diff: f32
	if rl.IsKeyDown(.H) {
		rot_diff -= _player_rotation_speed
	}
	if rl.IsKeyDown(.L) {
		rot_diff += _player_rotation_speed
	}
	p.rotation += rot_diff

	// Add movement diff to current force
	p.force += rl.Vector2Normalize(diff) * _player_speed

	// Air resistance
	p.force *= 0.95

	// apply force 
	p.position += p.force
}

player_render :: proc(p: Player) {
	rl.DrawTriangle(
		p.position + rl.Vector2Rotate(rl.Vector2Normalize({0, -1}), p.rotation) * _player_size,
		p.position + rl.Vector2Rotate(rl.Vector2Normalize({-1, 1}), p.rotation) * _player_size,
		p.position + rl.Vector2Rotate(rl.Vector2Normalize({1, 1}), p.rotation) * _player_size,
		rl.WHITE,
	)
}
