package main

import rl "vendor:raylib"

_rocket_speed: f32 = 15
_rocket_size: f32 = 5

Rocket :: struct {
	position:  rl.Vector2,
	direction: rl.Vector2,
	// time_lived: time.Duration
}

rocket_update :: proc(r: ^Rocket, delta: f32) {
	r.position += r.direction * _rocket_speed
}

rocket_render :: proc(r: Rocket) {
	rl.DrawCircleV(r.position, _rocket_size, rl.WHITE)
}
