package main

import "core:math/rand"
import "core:time"
import rl "vendor:raylib"


_asteroid_spawn_interval: time.Duration = 8 * time.Second
_asteroid_speed_factor: f32 = 60
_asteroid_start_radius: f32 = 50
_asteroid_minimal_radius: f32 = 30 // Smaller = Harder
_asteroid_spawn_safe_distance: f32 = 80

AsteroidManager :: struct {
	last_tick: time.Tick,
	count:     int,
}

asteroid_manager_update :: proc(am: ^AsteroidManager) {
	if time.tick_since(am.last_tick) >= _asteroid_spawn_interval {
		am.last_tick = time.tick_now()
		am.count += 1

		append(
			&_asteroids,
			Asteroid {
				position = _resolve_new_asteroid_position(am, _player),
				direction = random_direction(),
				radius = _asteroid_start_radius + rand.float32_range(-10, 10),
				min_radius = _asteroid_minimal_radius,
				speed_factor = _asteroid_speed_factor + f32(am.count),
			},
		)
	}
}

_resolve_new_asteroid_position :: proc(am: ^AsteroidManager, p: Player) -> rl.Vector2 {
	x := rand.float32_range(0, f32(_screenWidth))
	y := rand.float32_range(0, f32(_screenHeight))
	v := rl.Vector2{x, y}

	for rl.Vector2Distance(v, p.position) < _asteroid_spawn_safe_distance {
		x := rand.float32_range(0, f32(_screenWidth))
		y := rand.float32_range(0, f32(_screenHeight))
		v = rl.Vector2{x, y}
	}

	return v
}

/*
    4, 6
    3, 8
    ----
    1,-2
   -1, 2


    |  2                 
    |                    
    |   1                
    |                    
    |                    
    |                    
    |                    
    |                    
    +-----------
*/

//1->2 == 2-1

Asteroid :: struct #packed {
	position:     rl.Vector2,
	direction:    rl.Vector2,
	radius:       f32,
	min_radius:   f32,
	speed_factor: f32,
	// TODO: random color
}

asteroid_update :: proc(a: ^Asteroid, delta: time.Duration) {
	a.position += a.direction * a.speed_factor / a.radius

	for rocket in _rockets {
		distance := rl.Vector2Distance(a.position, rocket.position)
		if distance <= a.radius {
			asteroid_split(a^, rocket)
		}
	}

	bounce_if_on_edge(a.position, &a.direction, a.radius)

	if is_out_of_bounds(a.position) {
		find_and_remove(&_asteroids, a^)
	}
}

asteroid_render :: proc(a: Asteroid) {
	rl.DrawCircleV(a.position, a.radius, rl.GRAY)
}

asteroid_split :: proc(a: Asteroid, r: Rocket) {
	_player.fuil += _player_asteroid_destroy_cost
	find_and_remove(&_asteroids, a)
	find_and_remove(&_rockets, r)
	// TODO: random number of peaces

	if a.radius <= _asteroid_minimal_radius {
		return
	}

	a1 := Asteroid {
		position     = a.position,
		radius       = a.radius * 0.75,
		direction    = random_direction(),
		speed_factor = a.speed_factor,
	}
	a2 := Asteroid {
		position     = a.position,
		radius       = a.radius * 0.75,
		direction    = random_direction(),
		speed_factor = a.speed_factor,
	}

	append(&_asteroids, a1, a2)
}

bounce_if_on_edge :: proc(position: rl.Vector2, direction: ^rl.Vector2, radius: f32) {
	if position[0] > f32(_screenWidth) - radius {
		if direction[0] > 0 {
			direction[0] *= -1
		}
	}
	if position[0] < 0 + radius {
		if direction[0] < 0 {
			direction[0] *= -1
		}
	}
	if position[1] > f32(_screenHeight) - radius {
		if direction[1] > 0 {
			direction[1] *= -1
		}
	}
	if position[1] < 0 + radius {
		if direction[1] < 0 {
			direction[1] *= -1
		}
	}
}
