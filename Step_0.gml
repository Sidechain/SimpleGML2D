/// Platform physics


// Keyboard input
var rkey = keyboard_check(vk_right)
var lkey = keyboard_check(vk_left)
var jkey = keyboard_check_pressed(vk_up)
var dkey = keyboard_check_direct(vk_shift)
var restartkey = keyboard_check_pressed(vk_escape)
var downkey = keyboard_check(vk_down)



// Restart scene
if (restartkey) {
	room_restart()
}

// Jumping
//if (jkey) {	
	//if (is_on_ground) {		
	//vspd = -jspd
	//} else if (grace_jump_time > 0) {
	//vspd = -jspd
	//}
//}

// Check for ground and fall
if(place_meeting(x, y+1, obj_solid)) {
		//airjump = 0		
		//vspd = 0
		is_on_ground = true
		grace_timer = grace_jump_time
		if(jkey) {
			grace_timer = -1
			vspd = -jspd
			}		
} else {
		is_on_ground = false
		grace_timer--
			if (jkey && grace_timer > 0) {
			vspd = -jspd
		}
	}
	// Gravity
	if (vspd < 10) {
		vspd += grav
	}
	
	if (keyboard_check_released(vk_up) && vspd <-4) {
		vspd = -4
	}
	
	// Check for airjump
	/*if (airjump > 0) {
		if (jkey) {
			vspd = -jspd
			airjump -= 1
		}
	}*/

// Moving to the right
if (rkey) {
	if (hspd < spd) {
		hspd += fric
	} else { 
		hspd = spd
	}
}

// Moving to the left
if (lkey) {
	if(hspd > -spd) {
		hspd -= fric
	} else {
		hspd = -spd
	}

}

// Dashing
if (dkey) {
	spd = 8
	}
	else {
	spd = 4
	}

// Falling faster
if (downkey && (vspd < maxvspd)) {
	vspd += 1	
}


// Left wall jump
	if(place_meeting(x-1, y, obj_solid) && !place_meeting(x, y+40, obj_solid) && jkey /* && lkey*/ ) {
	vspd = -jspd*0.75
	hspd = spd*3
}
	
// Right wall jump
	if(place_meeting(x+1, y, obj_solid) && !place_meeting(x, y+40, obj_solid) && jkey /*&& rkey*/) {
	vspd = -jspd*0.75
	hspd = -spd*3
}

// Wall sliding left
	if(place_meeting(x-1, y, obj_wall_slide) && lkey) {
	vspd = vspd*0.5
}

// Wall sliding left
	if(place_meeting(x+1, y, obj_wall_slide) && rkey) {
	vspd = vspd*0.5
}


// Check for not moving
if ((!rkey && !lkey) || (rkey && lkey)) {
	if (hspd != 0) {
		if (hspd < 0) {
			hspd += fric
		} else {
			hspd -= fric
		}
	}
}

// Horizontal collisions
if (place_meeting(x+hspd, y, obj_solid)) {
	while (!place_meeting(x+sign(hspd), y, obj_solid)) {
		x+= sign(hspd)
	}
	hspd = 0;
}

// Move horizontally
x += hspd

// Vertical collisions
if (place_meeting(x, y+vspd, obj_solid)) {
	while (!place_meeting(x, y+sign(vspd), obj_solid)) {
		y += sign(vspd)
	}
	vspd = 0;
}

// Move vertically
y += vspd


// Control the sprites
if (yprevious !=y) {
	sprite_index = spr_player_jump
	image_speed = 0
	image_index = y>yprevious
} else {
	if (xprevious != x) {
		sprite_index = spr_player_walk
		image_speed = .3
	} else {
		sprite_index = spr_player_stand
	}
}

if((hspd = 0) && (vspd = 0)) {
	sprite_index = spr_player_stand
}

if ((vspd = 0) && dkey) {
	sprite_index = spr_player_dash
}

if ((vspd > 0) && downkey) {
	sprite_index = spr_player_falling
}


// Control direction facing
if (xprevious < x) {
	image_xscale =1
} else if (xprevious > x) {
	image_xscale = -1
}