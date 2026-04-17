# CAM-IMX335-5MP

![CAM-IMX335-5MP](images/imx335.png)

The **CAM-IMX335-5MP** is a high-performance 5-Megapixel camera module designed for Raspberry Pi, featuring the Sony IMX335 image sensor. This repository provides the necessary drivers, Image Processing Algorithm (IPA) modules, and installation scripts to enable full support for the IMX335 sensor on Raspberry Pi 4 and Raspberry Pi 5 platforms.

## Features

- **Sensor**: Sony IMX335 5MP CMOS Image Sensor
- **Compatibility**: Fully compatible with Raspberry Pi 4 and Raspberry Pi 5
- **Software Support**: Integrates with the official `libcamera` stack and `rpicam-apps`
- **Installation**: Provides both online and offline installation methods

## Repository Contents

- `CAM-IMX335-5MP UserManual.pdf`: Comprehensive user manual with detailed hardware specifications and software setup instructions.
- `build_offline_complete.tar.gz`: Offline build package containing libcamera and rpicam-apps source code.
- `build_offline_complete_trixie.sh`: Automated build and installation script for Raspberry Pi OS (Trixie).

## Quick Start

### 1. Hardware Connection

Connect the CAM-IMX335-5MP module to the MIPI CSI camera port on your Raspberry Pi using the provided ribbon cable. Ensure the contacts are facing the correct direction according to your Raspberry Pi model.

### 2. Software Installation

This recommended method builds libcamera and rpicam-apps from offline source packages to ensure compatibility and avoid system update issues.

#### Installation Steps

1. Update system packages:
   ```bash
   sudo apt-get update
   sudo apt-get dist-upgrade
   ```

2. Clone the repository:
   ```bash
   sudo git clone https://github.com/INNO-MAKER/CAM-IMX335-5MP.git
   cd CAM-IMX335-5MP
   ```

3. Set permissions for all files:
   ```bash
   sudo chmod -R a+rwx *
   ```

4. Extract the offline build package:
   ```bash
   sudo tar -zxvf build_offline_complete.tar.gz
   cd build_offline_complete
   ```

5. Run the build and installation script:
   ```bash
   sudo ./build_offline_complete_trixie.sh
   ```

The script will compile libcamera with IMX335 support and install rpicam-apps. After completion, proceed to configure `/boot/config.txt` as described in the Testing the Camera section.

#### Alternative: Pre-compiled Installation

For advanced users who prefer a simpler installation, refer to the `CAM-IMX335-5MP UserManual.pdf` for alternative installation methods.

### 3. Camera Configuration

Edit your `/boot/firmware/config.txt` (Pi 5) or `/boot/config.txt` (Pi 4) and add one of the following configurations:

**Default (CSI1 port)**:
```ini
camera_auto_detect=0
dtoverlay=imx335
```

**Use CSI0 port**:
```ini
camera_auto_detect=0
dtoverlay=imx335,cam0  # for csi0
```

**Use CSI1 port (explicit)**:
```ini
camera_auto_detect=0
dtoverlay=imx335,cam1  # for csi1
```

Reboot your Raspberry Pi for the changes to take effect:
```bash
sudo reboot
```

### 4. Testing the Camera

After installation and rebooting, you can test the camera using the standard `rpicam-apps`:

```bash
# List available cameras to verify detection
rpicam-hello --list-cameras

# Open a preview window
rpicam-hello -t 0

# Capture a JPEG image
rpicam-still -o test.jpg
```

## Documentation

For detailed specifications, advanced configuration, and troubleshooting, please consult the [CAM-IMX335-5MP UserManual.pdf](./CAM-IMX335-5MP%20UserManual.pdf).

## License

Please refer to the individual source files and packages for licensing information. The `libcamera` components are subject to their respective open-source licenses.
