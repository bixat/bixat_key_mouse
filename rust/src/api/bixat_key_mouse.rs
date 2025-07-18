use enigo::{
    Button, Coordinate,
    Direction::{Press, Release},
    Enigo, Key, Keyboard, Mouse, Settings,
};

#[flutter_rust_bridge::frb(sync)]
pub fn move_mouse_abs(x: i32, y: i32) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    enigo.move_mouse(x, y, Coordinate::Abs);
}

#[flutter_rust_bridge::frb(sync)]
pub fn move_mouse_rel(x: i32, y: i32) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    enigo.move_mouse(x, y, Coordinate::Rel);
}

#[flutter_rust_bridge::frb(sync)]
pub fn press_mouse_button(button: i32) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    let button = match button {
        1 => Button::Left,
        2 => Button::Right,
        _ => Button::Left,
    };
    enigo.button(button, Press);
}

#[flutter_rust_bridge::frb(sync)]
pub fn release_mouse_button(button: i32) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    // TODO: Handle it automatically.
    let button = match button {
        1 => Button::Left,
        2 => Button::Right,
        3 => Button::Middle,
        4 => Button::Back,
        5 => Button::Forward,
        6 => Button::ScrollUp,
        7 => Button::ScrollDown,
        8 => Button::ScrollLeft,
        9 => Button::ScrollRight,
        _ => Button::Left,
    };
    enigo.button(button, Release);
}

#[flutter_rust_bridge::frb(sync)]
pub fn enter_text(text: &str) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    enigo.text(text);
}

#[flutter_rust_bridge::frb(sync)]
pub fn simulate_key(key: &str) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();

    match key {
        "Control" => enigo.key(Key::Control, Press).unwrap(),
        "Shift" => enigo.key(Key::Shift, Press).unwrap(),
        "Alt" => enigo.key(Key::Alt, Press).unwrap(),
        "Meta" => enigo.key(Key::Meta, Press).unwrap(),
        "Delete" => enigo.key(Key::Delete, Press).unwrap(),
        "CapsLock" => enigo.key(Key::CapsLock, Release).unwrap(),
        _ => (),
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn release_key(key: &str) {
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    match key {
        "Control" => enigo.key(Key::Control, Release).unwrap(),
        "Shift" => enigo.key(Key::Shift, Release).unwrap(),
        "Alt" => enigo.key(Key::Alt, Release).unwrap(),
        "CapsLock" => enigo.key(Key::CapsLock, Release).unwrap(),
        _ => (),
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
