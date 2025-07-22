use enigo::{Axis, Button, Coordinate, Key};

pub fn get_mouse_button_by_index(index: i32) -> Button {
    match index {
        1 => Button::Left,
        3 => Button::Middle,
        2 => Button::Right,
        4 => Button::Back,
        5 => Button::Forward,
        6 => Button::ScrollUp,
        7 => Button::ScrollDown,
        8 => Button::ScrollLeft,
        9 => Button::ScrollRight,
        _ => Button::Left,
    }
}

pub fn get_direction_by_index(index: i32) -> enigo::Direction {
    match index {
        0 => enigo::Direction::Press,
        1 => enigo::Direction::Release,
        2 => enigo::Direction::Click,
        _ => enigo::Direction::Press,
    }
}

pub fn get_coordinate_by_index(index: i32) -> Coordinate {
    match index {
        0 => Coordinate::Abs,
        1 => Coordinate::Rel,
        _ => Coordinate::Abs,
    }
}

pub fn get_axis_by_index(index: i32) -> Axis {
    match index {
        0 => Axis::Horizontal,
        1 => Axis::Vertical,
        _ => Axis::Vertical,
    }
}
