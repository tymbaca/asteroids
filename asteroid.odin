package main

import "core:math/rand"
import "core:time"
import rl "vendor:raylib"

_asteroid_spawn_interval: time.Duration = 4 * time.Second
_asteroid_speed_factor: f32 = 40
_asteroid_start_radius: f32 = 80

AsteroidManager :: struct {
	last_tick: time.Tick,
}

asteroid_manager_update :: proc(am: ^AsteroidManager) {
	if time.tick_since(am.last_tick) >= _asteroid_spawn_interval {
		am.last_tick = time.tick_now()

		append(
			&_asteroids,
			Asteroid {
				position = _resolve_new_asteroid_position(am, _player),
				direction = random_direction(),
				radius = _asteroid_start_radius + rand.float32_range(-50, 5),
			},
		)
	}
}

_resolve_new_asteroid_position :: proc(am: ^AsteroidManager, p: Player) -> rl.Vector2 {
	x := rand.float32_range(0, f32(_screenWidth))
	y := rand.float32_range(0, f32(_screenHeight))
	return {x, y}
}

Asteroid :: struct #packed {
	position:  rl.Vector2,
	direction: rl.Vector2,
	radius:    f32,
	// TODO: random color
}

asteroid_update :: proc(a: ^Asteroid, delta: time.Duration) {
	a.position += a.direction * _asteroid_speed_factor / a.radius

	for rocket in _rockets {
		distance := rl.Vector2Distance(a.position, rocket.position)
		if distance <= a.radius {
			asteroid_split(a^)
		}
	}

	if is_out_of_bounds(a.position) {
		find_and_remove(&_asteroids, a^)
	}
}

asteroid_render :: proc(a: Asteroid) {
	rl.DrawCircleV(a.position, a.radius, rl.GRAY)
}

asteroid_split :: proc(a: Asteroid) {
	find_and_remove(&_asteroids, a)
	a1 := Asteroid {
		position  = a.position,
		radius    = a.radius / 2,
		direction = random_direction(),
	}
	a2 := Asteroid {
		position  = a.position,
		radius    = a.radius / 2,
		direction = random_direction(),
	}

	append(&_asteroids, a1, a2)
}
