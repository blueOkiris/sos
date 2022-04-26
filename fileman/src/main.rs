/*
 * Author: Dylan Turner
 * Description: Entry point for file manager application
 */

use gtk4::{
    Application, ApplicationWindow,
    prelude::{
        WidgetExt, ApplicationExt
    }
};

const APP_ID: &'static str = "com.blueokiris.FileManager";
const APP_TITLE: &'static str = "File Manager";
const WIN_WIDTH: i32 = 1280;
const WIN_HEIGHT: i32 = 720;

fn main() {
    let app = Application::builder()
        .application_id(APP_ID)
        .build();

    app.connect_activate(|app| {
        let win = ApplicationWindow::builder()
            .application(app)
            .width_request(WIN_WIDTH).height_request(WIN_HEIGHT)
            .title(APP_TITLE)
            .build();
        win.show();
    });
}
