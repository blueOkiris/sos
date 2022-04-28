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

fn main() {
    let app = Application::builder()
        .application_id(APP_ID)
        .build();

    app.connect_activate(|self_app| {
        let win = ApplicationWindow::builder()
            .application(self_app)
            .title(APP_TITLE).fullscreened(true)
            .build();
        win.show();
    });

    app.run();
    app.quit();
}
