package main

import "core:time"
import rl "vendor:raylib"

_out_of_bounds_distance: f32 = 1000
_rocket_speed: f32 = 15
_rocket_size: f32 = 2

Rocket :: struct {
	position:  rl.Vector2,
	direction: rl.Vector2,
}

rocket_update :: proc(r: ^Rocket, delta: time.Duration) {
	r.position += r.direction * _rocket_speed

	if is_out_of_bounds(r.position) {
		find_and_remove(&_rockets, r^)
	}
}

is_out_of_bounds :: proc(pos: rl.Vector2) -> bool {
	if pos[0] < -_out_of_bounds_distance || pos[0] > _out_of_bounds_distance {
		return true
	}
	if pos[1] < -_out_of_bounds_distance || pos[1] > _out_of_bounds_distance {
		return true
	}

	return false
}

rocket_render :: proc(r: Rocket) {
	rl.DrawCircleV(r.position, _rocket_size, rl.WHITE)
}
