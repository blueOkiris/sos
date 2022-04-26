/*
 * Author: Dylan Turner
 * Description: Entry point for application launcher application
 */

use gtk4::{
    Application, ApplicationWindow,
    prelude::{
        WidgetExt, ApplicationExt, ApplicationExtManual
    }
};

const APP_ID: &'static str = "com.blueokiris.AppLauncher";
const APP_TITLE: &'static str = "App Launcher";
const WIN_WIDTH: i32 = 1280;
const WIN_HEIGHT: i32 = 720;

fn main() {
    let app = Application::builder()
        .application_id(APP_ID)
        .build();

    app.connect_activate(|app| {
        let win = ApplicationWindow::builder()
            .application(app)
            .title(APP_TITLE)
            .build();
        win.show();
    });

    app.run();
    app.quit();
}
