package main

import "core:time"
import rl "vendor:raylib"

_player_size: f32 = 20
_player_speed: f32 = 0.6
_player_rotation_speed: f32 = 0.06
_player_width_factor: f32 = 1
_player_max_fuil: f32 = 100

_player_movement_cost: f32 = 0.3
_player_shoot_cost: f32 = 0.2
_player_asteroid_destroy_cost: f32 = 1.5

Player :: struct {
	position: rl.Vector2,
	size:     f32,
	force:    rl.Vector2,
	rotation: f32,
	dead:     bool,
	fuil:     f32,
	max_fuil: f32,
}

player_update :: proc(p: ^Player, delta: time.Duration) {
	if rl.IsKeyPressed(.SPACE) && p.fuil > 0 {
		append(
			&_rockets,
			Rocket{position = p.position, direction = rl.Vector2Rotate(UP, p.rotation)},
		)

		p.fuil -= _player_shoot_cost
	}

	// rotation
	rot_diff: f32
	if rl.IsKeyDown(ROTATE_LEFT) {
		rot_diff -= _player_rotation_speed
	}
	if rl.IsKeyDown(ROTATE_RIGHT) {
		rot_diff += _player_rotation_speed
	}
	if p.fuil > 0 {
		p.rotation += rot_diff
	}

	// movement
	diff: rl.Vector2 = {}
	if rl.IsKeyDown(MOVE_UP) {
		diff += {0, -1}
	}
	if rl.IsKeyDown(MOVE_DOWN) {
		diff += {0, 1}
	}
	if rl.IsKeyDown(MOVE_LEFT) {
		diff += {-1, 0}
	}
	if rl.IsKeyDown(MOVE_RIGHT) {
		diff += {1, 0}
	}

	bounce_if_on_edge(p.position, &p.force, p.size)

	// TODO: clamp fuil
	if p.fuil > 0 {
		// Add movement diff to current force
		change := rl.Vector2Normalize(diff) * _player_speed
		p.force += change

		change_amount := rl.Vector2Length(change)
		p.fuil -= change_amount * _player_movement_cost

	}

	// Air resistance
	p.force *= 0.95

	// apply force 
	p.position += p.force

	//--------------------------------------------------------------------------------------------------
	// Detect asteroid collisions
	//--------------------------------------------------------------------------------------------------
	if !GOD_MODE {
		for asteroid in _asteroids {
			if rl.Vector2Distance(p.position, asteroid.position) <= p.size + asteroid.radius {
				player_die(p)
			}
		}
	}

	// Clamp fuil
	if p.fuil < 0 do p.fuil = 0
}

player_render :: proc(p: Player) {
	if !p.dead {
		rl.DrawTriangle(
			p.position + rl.Vector2Rotate(rl.Vector2Normalize({0, -1}), p.rotation) * p.size,
			p.position + rl.Vector2Rotate(rl.Vector2Normalize({-1, 1}), p.rotation) * p.size,
			p.position + rl.Vector2Rotate(rl.Vector2Normalize({1, 1}), p.rotation) * p.size,
			rl.WHITE,
		)
	}
}

player_die :: proc(p: ^Player) {
	p.dead = true
}
