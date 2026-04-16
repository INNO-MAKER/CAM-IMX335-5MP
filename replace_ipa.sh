#!/bin/bash
# =============================================================================
# replace_ipa.sh
# Function: Auto-detect Raspberry Pi 4 / Pi 5 and overwrite the matching
#           libcamera IPA module only:
#               Pi 4  -> ipa_rpi_vc4.so
#               Pi 5  -> ipa_rpi_pisp.so
#           Required .so files must sit in the SAME directory as this script.
# Usage:  sudo ./replace_ipa.sh
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ---- 0. Root ----
[ "$EUID" -ne 0 ] && error "Please run as root (use sudo)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---- 1. Auto-detect board ----
MODEL="$(tr -d '\0' < /proc/device-tree/model 2>/dev/null || echo unknown)"
case "$MODEL" in
    *"Raspberry Pi 5"*) BOARD=pi5 ; IPA_NAME=ipa_rpi_pisp.so ;;
    *"Raspberry Pi 4"*) BOARD=pi4 ; IPA_NAME=ipa_rpi_vc4.so  ;;
    *) error "Unsupported board: $MODEL  (only Pi4 / Pi5 supported)" ;;
esac
info "Detected board: $MODEL  ->  $IPA_NAME"

# ---- 2. Locate source IPA file (next to script) ----
IPA_SRC="$SCRIPT_DIR/$IPA_NAME"
IPA_SIG="$SCRIPT_DIR/${IPA_NAME}.sign"
[ -f "$IPA_SRC" ] || error "IPA file missing: $IPA_SRC  (put it next to the script)"

# ---- 3. Find libcamera IPA install directory on the system ----
CANDIDATES=(
    "/usr/lib/aarch64-linux-gnu/libcamera"
    "/usr/libexec/libcamera"
    "/usr/local/libexec/libcamera"
    "/usr/local/lib/aarch64-linux-gnu/libcamera"
)
TARGETS=()
for d in "${CANDIDATES[@]}"; do
    [ -f "$d/$IPA_NAME" ] && TARGETS+=("$d")
done
if [ ${#TARGETS[@]} -eq 0 ]; then
    warn "Existing $IPA_NAME not found in any common location."
    warn "Falling back to /usr/lib/aarch64-linux-gnu/libcamera"
    TARGETS=("/usr/lib/aarch64-linux-gnu/libcamera")
    mkdir -p "${TARGETS[0]}"
fi
info "Target install dir(s):"
for t in "${TARGETS[@]}"; do echo "  - $t"; done

# ---- 4. Backup ----
TS="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="/var/backups/libcamera-ipa-${TS}"
mkdir -p "$BACKUP_DIR"
info "Backing up current files to: $BACKUP_DIR"
for t in "${TARGETS[@]}"; do
    [ -f "$t/$IPA_NAME" ]      && cp -a "$t/$IPA_NAME"      "$BACKUP_DIR/$(echo "$t" | tr '/' '_')__$IPA_NAME"
    [ -f "$t/${IPA_NAME}.sign" ] && cp -a "$t/${IPA_NAME}.sign" "$BACKUP_DIR/$(echo "$t" | tr '/' '_')__${IPA_NAME}.sign"
done

# ---- 5. Copy new IPA + handle signature ----
info "Installing new IPA..."
for t in "${TARGETS[@]}"; do
    cp -f "$IPA_SRC" "$t/$IPA_NAME"
    chmod 0644 "$t/$IPA_NAME"
    echo "  + $t/$IPA_NAME"
    if [ -f "$IPA_SIG" ]; then
        cp -f "$IPA_SIG" "$t/${IPA_NAME}.sign"
        chmod 0644 "$t/${IPA_NAME}.sign"
        echo "  + $t/${IPA_NAME}.sign"
    elif [ -f "$t/${IPA_NAME}.sign" ]; then
        # Remove stale signature so libcamera falls back to isolated mode
        rm -f "$t/${IPA_NAME}.sign"
        echo "  - removed stale $t/${IPA_NAME}.sign (isolated mode)"
    fi
done

# ---- 6. Stop any running camera processes ----
pkill -f rpicam- 2>/dev/null || true

# ---- 7. Verify ----
echo ""
info "Verification:"
for t in "${TARGETS[@]}"; do
    ls -l "$t/$IPA_NAME" "$t/${IPA_NAME}.sign" 2>/dev/null | sed 's/^/  /'
done
echo ""
info "Functional test:"
rpicam-hello --list-cameras 2>/dev/null || warn "rpicam-hello failed - try rebooting"

echo ""
echo "========================================="
echo "Done. Backup: $BACKUP_DIR"
echo "Restore: sudo cp -a $BACKUP_DIR/<file> <original_path>/"
echo "========================================="
