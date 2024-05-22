package main

import "core:fmt"
import rl "vendor:raylib"

draw_stats :: proc() {
	stats := fmt.caprintf("asteroids: %s\nrockets: %s", _asteroids, _rockets)
	defer delete(stats)
	rl.DrawText(stats, 0, 0, 10, rl.RAYWHITE)
}
