use enigo::{
    Button, Coordinate,
    Direction::{Press, Release},
    Enigo, Key, Keyboard, Mouse, Settings,
};
use libc::c_char;
use std::ffi::CStr;

#[no_mangle]
pub extern "C" fn move_mouse_abs(x: i32, y: i32) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    enigo.move_mouse(x, y, Coordinate::Abs);
}

#[no_mangle]
pub extern "C" fn move_mouse_rel(x: i32, y: i32) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    enigo.move_mouse(x, y, Coordinate::Rel);
}

#[no_mangle]
pub extern "C" fn press_mouse_button(button: i32) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    let button = match button {
        1 => Button::Left,
        2 => Button::Right,
        _ => Button::Left,
    };
    enigo.button(button, Press);
}

#[no_mangle]
pub extern "C" fn release_mouse_button(button: i32) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    let button = match button {
        1 => Button::Left,
        2 => Button::Right,
        _ => Button::Left,
    };
    enigo.button(button, Release);
}

#[no_mangle]
pub extern "C" fn enter_text(text: *const c_char) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    let c_str = unsafe { CStr::from_ptr(text) };
    let r_str = c_str.to_str().unwrap();
    enigo.text(r_str);
}

#[no_mangle]
pub extern "C" fn simulate_key(key: *const c_char) {
    let key_str = unsafe { CStr::from_ptr(key).to_str().unwrap() };
    let mut enigo = Enigo::new(&Settings::default()).unwrap();

    match key_str {
        "Control" => enigo.key(Key::Control, Press).unwrap(),
        "Shift" => enigo.key(Key::Shift, Press).unwrap(),
        "Alt" => enigo.key(Key::Alt, Press).unwrap(),
        "Meta" => enigo.key(Key::Meta, Press).unwrap(),
        "Delete" => enigo.key(Key::Delete, Press).unwrap(),
        "CapsLock" => enigo.key(Key::CapsLock, Release).unwrap(),
        _ => (),
    }
}

#[no_mangle]
pub extern "C" fn release_key(key: *const c_char) {
    let key_str = unsafe { CStr::from_ptr(key).to_str().unwrap() };
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    match key_str {
        "Control" => enigo.key(Key::Control, Release).unwrap(),
        "Shift" => enigo.key(Key::Shift, Release).unwrap(),
        "Alt" => enigo.key(Key::Alt, Release).unwrap(),
        "CapsLock" => enigo.key(Key::CapsLock, Release).unwrap(),
        _ => (),
    }
}
