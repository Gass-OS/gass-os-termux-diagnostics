<div align="center">

# ⚙️ GASS-OS Termux Diagnostics

**A safe, read-only system snapshot tool for Android + Termux.**

![Shell](https://img.shields.io/badge/Shell-Bash-111111?style=flat-square&logo=gnubash&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Termux-3DDC84?style=flat-square&logo=android&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-777777?style=flat-square)

</div>

Collect useful device, Termux, storage, memory, and graphics environment information when troubleshooting Linux desktop workloads on Android.

## Features

- Read-only diagnostics; it does not install packages or change device settings.
- Detects Android/Termux environment and CPU architecture.
- Reports available commands, disk space, memory information, and selected graphics environment variables.
- Writes a timestamped text report locally.

## Run

```bash
pkg install bash coreutils
git clone https://github.com/Gass-OS/gass-os-termux-diagnostics.git
cd gass-os-termux-diagnostics
bash diagnostics.sh
```

The script saves a report under `reports/`. Review the report before sharing it: system details can be identifying.

## Optional output path

```bash
bash diagnostics.sh "$HOME/termux-diagnostics.txt"
```

## Safety

This script only reads local system information and writes the requested report file. It does not request root, upload data, or make network requests.

## Roadmap

- [ ] Add a user-selectable privacy filter
- [ ] Add checks for Termux:X11 and common desktop dependencies
- [ ] Add sample redacted reports for issue templates

## License

MIT. See [`LICENSE`](LICENSE).
