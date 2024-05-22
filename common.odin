package main

import rl "vendor:raylib"

UP := rl.Vector2{0, -1}

find_and_remove :: proc(arr: ^$D/[dynamic]$T, target: T) {
	for got, i in arr {
		if got == target {
			unordered_remove(arr, i)
		}
	}
}
