# adb2recGUI

📱 Adb2Rec-GUI: Mobile Forensics Toolkit

Author: Antonio 'Visi@n' Broi
Email: antonio@tsurugi-linux.org
Website: https://tsurugi-linux.org
License: MIT License
Version: 1.0 (2025-04-05)
🔍 Description

Adb2Rec-GUI is a powerful graphical toolkit written in Python designed to facilitate Android mobile forensic operations over ADB (Android Debug Bridge).
With a simple and intuitive GUI, investigators and security professionals can:

    Connect Android devices via USB cable or Wi-Fi

    Take screenshots and screen recordings

    Capture screenshots in different scroll positions (up/down)

    Compress and hash evidence files (MD5, SHA256)

    Organize all outputs into structured directories using device-specific IDs

    Display multilingual ASCII banners and utilities for enhanced CLI interaction

The tool is developed for environments such as Tsurugi Linux and forensic-ready workstations, but can be adapted for other systems.
🧠 Key Features

    ✅ ADB cable and Wi-Fi pairing support

    📸 Screenshot modes (normal, scroll-up, scroll-down)

    🎥 Screen recording support

    📦 Automatic compression and cryptographic hashing

    🔐 Creates device-specific evidence folders

    🌍 Multilanguage translation support (Google Translate API integration)

    🐧 ASCII art and cowthink terminal enhancements

    🧪 Forensic integrity and automation focus

🖥️ GUI Overview

The interface offers a series of buttons to:

    Connect ADB via cable or Wi-Fi

    Capture and stop screenshots

    Record and stop screen recording

    Compress and hash all acquired files

All output is saved under:

~/02.computer_vision/04.video2ocr/

Organized in subfolders:

    screenshot/

    screenrecord/

    compressfiles/

    hashfiles/

    [ANDROID_ID]/ (final organized output)

🔧 Prerequisites

Make sure the following tools and libraries are available on your system:

    adb (Android Debug Bridge)

    jp2a, cowthink (for CLI decoration)

    googletrans (Python translation API)

    Bash scripts:

        /usr/local/bin/screenshot.sh

        /usr/local/bin/screenshot.sh up

        /usr/local/bin/screenshot.sh down

        /usr/local/bin/screenrecord.sh

    Python packages:

    pip install googletrans==4.0.0rc1

🚀 Getting Started

    Clone the repository

git clone https://github.com/yourusername/adb2rec-gui.git
cd adb2rec-gui

Ensure your Python environment

python3 script_name.py

Run the script and start capturing

    ./adb2rec-gui.py

📁 Directory Structure

├── screenshot/
├── screenrecord/
├── compressfiles/
├── hashfiles/
└── [ANDROID_ID]/

👨‍💻 About the Author

Antonio 'Visi@n' Broi is a cybersecurity and digital forensics specialist, creator of tools for mobile and network analysis under the Tsurugi Linux Project.
He is known for his commitment to building accessible, open-source forensic instruments.
📜 License

This project is licensed under the MIT License.
See LICENSE for more information.
📷 Screenshot


Example CLI banner used in the tool
