#!/usr/bin/env rust-script
//! ```cargo
//! [dependencies]
//! chrono = "0.4.39"
//! dirs = "6.0.0"
//! duct = "0.13.7"
//! pico-args = "0.5.0"
//! serde = { version = "1.0.217", features = ["derive"] }
//! serde_json = "1.0.138"
//! ```

use dirs::video_dir;
use duct::cmd;
use pico_args::Arguments;
use serde::{Deserialize, Serialize};

const HELP: &str = "\
Record your screen in wayland
If you have more than one monitor you'll have to click
on the display you want to record (unless you use `--area`).

USAGE:
  screen_recorder [OPTIONS]

FLAGS:
  -h, --help       Prints help information

OPTIONS:
  --area           Record rectangular selection
  --audio          Record audio
";

#[derive(Clone, Debug, Serialize, Deserialize)]
struct Size {
    height: u16,
    width: u16,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
struct Position {
    x: u16,
    y: u16,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
struct DisplayInfo {
    name: String,
    position: Position,
    size: Size,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut pargs = Arguments::from_env();
    if pargs.contains(["-h", "--help"]) {
        print!("{}", HELP);
        std::process::exit(0);
    }
    let assassination = cmd!("pkill", "-f", "wf-recorder").run();
    if let Ok(_) = assassination {
        cmd!("notify-send", "Finishing recording").run()?;
        return Ok(());
    }
    let raw_displays_info = cmd!("wlr-randr", "--json").pipe(cmd!("jq", "[.[] | {name, position, size: .modes.[] | select(.current == true) | {width, height}}]")).read()?;
    let displays_info: Vec<DisplayInfo> =
        serde_json::from_str(&raw_displays_info).expect("odd output from wlr-randr");
    // should be something like vec![300,400]
    let mut recording_path = video_dir().unwrap();
    let now = chrono::offset::Local::now();
    let custom_datetime_format = now.format("%Y.%m.%d_%H:%M:%S");
    let recording_name = format!("recording_{custom_datetime_format}.mp4");
    recording_path.push(recording_name);

    let mut audio_arg = String::new();
    if pargs.contains("--audio") {
        let audio_device = cmd!("pactl", "list", "sources")
            .pipe(cmd!("grep", "Name"))
            .pipe(cmd!("cut", "-d", ":", "-f2"))
            .pipe(cmd!("cut", "-d", ",", "-f2"))
            .pipe(cmd!("grep", "output"))
            .pipe(cmd!("head", "-n1"))
            .read()
            .expect("couldnt figure out the audio device");
        audio_arg = "--audio=".to_owned() + &audio_device;
    }

    if pargs.contains("--area") {
        let geometry = cmd!("slurp").read()?;
        cmd!(
            "wf-recorder",
            "-f",
            recording_path.clone(),
            audio_arg,
            "-g",
            geometry
        )
        .run()?;
    } else {
        let mut selected_display = String::new();
        if displays_info.len() > 1 {
            let mouse_click_position: Vec<u16> = cmd!("slurp", "-b", "00000000", "-p")
                .read()?
                .split(" ")
                .next()
                .unwrap()
                .split(",")
                .map(|v| {
                    v.parse::<u16>()
                        .expect("non number coordinates when calling slurp")
                })
                .collect();
            let mouse_x = mouse_click_position[0];
            let mouse_y = mouse_click_position[1];
            for display_info in displays_info {
                if mouse_x >= display_info.position.x
                    && mouse_x < display_info.position.x + display_info.size.width
                    && mouse_y >= display_info.position.y
                    && mouse_y < display_info.position.y + display_info.size.height
                {
                    selected_display = display_info.name;
                }
            }
        } else if displays_info.len() == 1 {
            selected_display = displays_info[0].clone().name;
        } else {
            panic!("no displays detected");
        }
        cmd!(
            "wf-recorder",
            "-f",
            recording_path.clone(),
            "--output",
            selected_display,
            audio_arg
        )
        .run()?;
    }
    cmd!(
        "echo",
        "file://".to_owned() + recording_path.to_str().unwrap()
    )
    .pipe(cmd!("wl-copy", "-t", "text/uri-list"))
    .run()
    .expect("couldnt copy video to clipboard");
    Ok(())
}
