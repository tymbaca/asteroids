package main

import "core:fmt"
import "core:time"
import rl "vendor:raylib"

_screenWidth: i32 = 640
_screenHeight: i32 = 480

_score: i32 = 0
_best_score: i32 = 0

_rockets: [dynamic]Rocket

_asteroids: [dynamic]Asteroid

_asteroid_manager := _default_asteroid_manager
_default_asteroid_manager := AsteroidManager {
	last_tick = time.tick_now(),
}

_player := _default_player
_default_player := Player {
	position      = {320, 240},
	size          = _player_size,
	hitbox_radius = _player_hitbox_radius,
	max_fuil      = _player_max_fuil,
	fuil          = _player_max_fuil,
}


main :: proc() {
	rl.InitWindow(_screenWidth, _screenHeight, "asteroids")
	rl.SetTargetFPS(60)

	tick := time.tick_now()
	for !rl.WindowShouldClose() {
		delta := time.tick_since(tick)
		tick := time.tick_now()

		update_game(delta)
		render_game()
	}
}

update_game :: proc(delta: time.Duration) {
	update(&_player, delta)
	update(&_asteroid_manager)

	for &rocket in _rockets {
		update(&rocket, delta)
	}

	for &asteroid in _asteroids {
		update(&asteroid, delta)
	}

	if !_player.dead {
		update_score(delta)
	}

	if _player.dead && rl.IsKeyPressed(.ENTER) {
		restart_game()
	}
}

render_game :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)

	render(_player)

	for rocket in _rockets {
		render(rocket)
	}

	for asteroid in _asteroids {
		render(asteroid)
	}

	if _player.dead {
		rl.DrawText("GAME OVER", _screenWidth / 2 - 100, _screenHeight / 2, 30, rl.WHITE)
	}

	draw_stats()

	rl.EndDrawing()
}

update :: proc {
	player_update,
	rocket_update,
	asteroid_update,
	asteroid_manager_update,
}

render :: proc {
	player_render,
	rocket_render,
	asteroid_render,
}

restart_game :: proc() {
	if _score > _best_score {
		_best_score = _score
	}
	_score = 0

	_player = _default_player
	_asteroid_manager = _default_asteroid_manager
	clear(&_asteroids)
	clear(&_rockets)
}
