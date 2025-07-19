use enigo::{Enigo, Key, Keyboard, Mouse, Settings};

use crate::helpers::{
    get_axis_by_index, get_coordinate_by_index, get_direction_by_index, get_key_by_index,
    get_mouse_button_by_index,
};

#[flutter_rust_bridge::frb(sync)]
pub fn move_mouse_base(x: i32, y: i32, coordinate: i32) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    let coordinate = get_coordinate_by_index(coordinate);
    enigo.move_mouse(x, y, coordinate);
}

#[flutter_rust_bridge::frb(sync)]
pub fn press_mouse_button_base(button: i32, direction: i32) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    let button = get_mouse_button_by_index(button);
    let direction = get_direction_by_index(direction);
    enigo.button(button, direction);
}

#[flutter_rust_bridge::frb(sync)]
pub fn enter_text_base(text: &str) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    enigo.text(text);
}

#[flutter_rust_bridge::frb(sync)]
pub fn simulate_key_base(key: i32, direction: i32, unicode: Option<char>) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    let direction = get_direction_by_index(direction);
    let key = get_key_by_index(key);
    if unicode.is_some() {
        enigo
            .key(Key::Unicode(unicode.unwrap()), direction)
            .unwrap();
    } else {
        enigo.key(key, direction).unwrap()
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn scroll_mouse_base(distance: i32, axis: i32) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    let axis = get_axis_by_index(axis);
    enigo.scroll(distance, axis).unwrap();
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
