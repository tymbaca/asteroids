package main

import "core:math/rand"
import rl "vendor:raylib"

UP := rl.Vector2{0, -1}

find_and_remove :: proc(arr: ^$D/[dynamic]$T, target: T) {
	for got, i in arr {
		if got == target {
			unordered_remove(arr, i)
		}
	}
}

random_direction :: proc() -> rl.Vector2 {
	return rl.Vector2Normalize({rand.float32_range(-1, 1), rand.float32_range(-1, 1)})
}
