package main

import "core:time"
import rl "vendor:raylib"

Asteroid :: struct #packed {
	position:  rl.Vector2,
	direction: rl.Vector2,
	radius:    f32,
}

asteroid_update :: proc(a: ^Asteroid, delta: f32) {

}

asteroid_render :: proc(a: Asteroid) {

}
