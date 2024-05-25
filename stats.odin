package main

import "core:fmt"
import "core:time"
import rl "vendor:raylib"

PADDING: f32 : 10
IPADDING := i32(PADDING)

FUIL_RECT_WIDTH: f32 : 100
FUIL_RECT_HEIGTH: f32 : 10
FUIL_RECT := rl.Rectangle {
	x      = f32(_screenWidth) - FUIL_RECT_WIDTH - PADDING,
	y      = PADDING,
	width  = FUIL_RECT_WIDTH,
	height = FUIL_RECT_HEIGTH,
}

_score_update_sound: rl.Sound
_beat_score_record_sound: rl.Sound

update_score :: proc(delta: time.Duration) {
	_score += 1

	if _score % 500 == 0 {
		rl.PlaySound(_score_update_sound)
	}
	if _score == _best_score {
		rl.PlaySound(_beat_score_record_sound)
	}
}

draw_stats :: proc() {
	/*
	// DEBUG
	stats := fmt.caprintf("asteroids: %s\nrockets: %s", _asteroids, _rockets)
	defer delete(stats)
	rl.DrawText(stats, 5, _screenHeight - 25, 10, rl.RAYWHITE)
	rl.DrawFPS(_screenWidth - 30, 10)
    */

	// FUIL
	draw_max_fuil_rect()
	draw_cur_fuil_rect()

	score := fmt.caprintf("SCORE: %d", _score)
	bscore := fmt.caprintf("BEST SCORE: %d", _best_score)
	defer delete(score)
	defer delete(bscore)
	rl.DrawText(score, IPADDING, IPADDING, 15, rl.WHITE)
	rl.DrawText(bscore, IPADDING, 30, 10, rl.GRAY)
}

draw_max_fuil_rect :: proc() {

	rl.DrawRectanglePro(FUIL_RECT, {}, 0, rl.DARKPURPLE)
}

draw_cur_fuil_rect :: proc() {
	left_coef := _player.fuil / _player.max_fuil
	rect := FUIL_RECT
	rect.width *= left_coef
	rl.DrawRectanglePro(rect, {}, 0, rl.ORANGE)
}
