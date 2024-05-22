package main

import "core:time"
import rl "vendor:raylib"

_screenWidth: i32 = 640
_screenHeight: i32 = 480

// TODO: sometimes pack the array
_rockets: [dynamic]Rocket
_asteroids: [dynamic]Asteroid
_asteroid_manager := AsteroidManager {
	last_tick = time.tick_now(),
}
_player := Player {
	position = {320, 240},
}


main :: proc() {
	rl.InitWindow(_screenWidth, _screenHeight, "asteroids")
	rl.SetTargetFPS(60)

	stopwatch := time.Stopwatch{}
	for !rl.WindowShouldClose() {
		delta := time.stopwatch_duration(stopwatch)
		time.stopwatch_reset(&stopwatch)
		time.stopwatch_start(&stopwatch)

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
