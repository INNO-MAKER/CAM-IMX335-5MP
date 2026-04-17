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
- `build_online_complete.tar.gz`: Package for online installation (compiles from source).
- `build_offline_complete.tar.gz`: Package for offline installation (pre-compiled binaries).
- `ipa_rpi_pisp.so` / `ipa_rpi_pisp.so.sign`: Pre-compiled IPA module for Raspberry Pi 5.
- `ipa_rpi_vc4.so` / `ipa_rpi_vc4.so.sign`: Pre-compiled IPA module for Raspberry Pi 4.

## Quick Start

### 1. Hardware Connection

Connect the CAM-IMX335-5MP module to the MIPI CSI camera port on your Raspberry Pi using the provided ribbon cable. Ensure the contacts are facing the correct direction according to your Raspberry Pi model.

### 2. Software Installation

This installation method directly installs pre-compiled files to ensure compatibility and avoid system update issues.

#### Installation Steps

1. Clone the repository:
   ```bash
   sudo git clone https://github.com/INNO-MAKER/CAM-IMX335-5MP.git
   cd CAM-IMX335-5MP
   ```

2. Set permissions for all files:
   ```bash
   sudo chmod -R a+rwx *
   ```

3. Run the IPA installation script:
   ```bash
   sudo ./replace_ipa.sh
   ```

The script will automatically detect whether you are using a Raspberry Pi 4 or Pi 5 and install the corresponding IPA module (`ipa_rpi_vc4.so` for Pi 4 or `ipa_rpi_pisp.so` for Pi 5).

#### Alternative: Full Compilation from Source

For advanced users who need to compile from source, refer to the `CAM-IMX335-5MP UserManual.pdf` included in this repository for detailed instructions using the online or offline build packages.

### 3. Testing the Camera

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
