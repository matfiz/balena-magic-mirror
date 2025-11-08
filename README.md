# balena-magic-mirror
Balena implementation of [MagicMirror²](https://magicmirror.builders/) optimized for Raspberry Pi devices, including the WaveShare 13.3" Magic Mirror.

Using [balena](https://www.balena.io/) makes MagicMirror (MM) super easy to set up and maintain when your Pi is less accessible/mounted behind a mirror:
- A captive portal for setting/resetting WiFi credentials via another device
- Remotely update the OS and MM application
- Easily deploy and maintain a fleet of MagicMirrors
- balenaCloud control of the device and environment variables, ssh access

## Hardware Compatibility
This implementation is tested and optimized for:
- **Raspberry Pi 3/3A+/3B+**: Recommended for standard installations
- **WaveShare 13.3" Magic Mirror**: Full support including:
  - 1920x1080 IPS display with automatic resolution configuration
  - Capacitive touchscreen support (up to 10-point touch)
  - WM8960 sound card for microphone input (voice assistant ready)
  - Optimized display settings for mirror installations

## Getting Started
Create a [free balenaCloud account](https://dashboard.balena-cloud.com/signup?) and the use the deploy button below to create a new MagicMirror fleet. Then add a new device (make sure to select "WiFi + Ethernet" if you want your mirror to use WiFi), burn the SD card with [Etcher](https://www.balena.io/etcher/), insert in your Raspberry Pi and apply power. Make sure a display of some sort is connected to your device's HDMI port.

[![balena deploy button](https://www.balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/matfiz/balena-magic-mirror)

Initially the display may be distorted because the GPU memory default is too low. In your "Device Configuration" tab in the balenaCloud dashboard, click "activate" for "Define device GPU memory in megabytes." and add the value 192 (or higher). The device will reboot and the display should correct itself.

## Configuration
At startup there will be no config so MM will display its generic startup message. You can enable the sample config by going to the balenaCloud terminal, selecting the magicmirror container, and initiating an ssh connection. Then type the following to enable the sample config file:
```
cd config
cp config.js.sample config.js
```
Restart the magicmirror container from the "services" area of the dashboard so the config changes can take effect.
Once the ssh reconnects, refresh the browser to view the new changes by typing:
```
curl -X POST http://localhost:5011/refresh
```

Power users will want to use the above method to change the contents of the config file to suit one's taste. The Nano text editor has been installed to ease that process somewhat. (The web terminal also supports copy and paste via the right click menu.) The following folders in MagicMirror are persisted between container restarts, so any changes should be maintained:
- `/opt/magic_mirror/config`
- `/opt/magic_mirror/modules`
- `/opt/magic_mirror/css`

## Voice Assistant Support (WaveShare Devices)
For WaveShare Magic Mirror devices with the WM8960 sound card, you can add voice assistant capabilities:

1. **Install voice modules** via the MagicMirror terminal (ssh into the magicmirror container):
   ```
   cd modules
   git clone [your preferred voice assistant module]
   ```

2. **Popular voice assistant modules**:
   - MMM-AssistantMk2 (Google Assistant)
   - MMM-Hotword (wake word detection)
   - MMM-voice (basic voice commands)

3. **Audio configuration**: The browser block is configured with GPU support and the device should automatically detect the WM8960 sound card. You may need to configure ALSA settings via device configuration if needed.

## How it works
This project uses the actively-maintained [karsten13/magicmirror](https://hub.docker.com/r/karsten13/magicmirror/) Docker image running MagicMirror² v2.33.0+ in server-only mode (no Electron browser). The Nano text editor is installed for easy configuration editing via the Balena terminal. MagicMirror serves its content on http://localhost:8080

We then use the balena [browser block](https://github.com/balenablocks/browser) to display the content being served by MagicMirror in kiosk mode. The browser is configured for:
- Full HD display (1920x1080) optimized for WaveShare devices
- GPU acceleration for smooth rendering
- Touch input support
- Hidden cursor for clean mirror appearance

See the browser block link for more options you can adjust.

The [WiFi Connect](https://github.com/balenablocks/wifi-connect) block provides a utility for dynamically setting the WiFi configuration on the device via a captive portal. See the link for more options regarding WiFi Connect.

