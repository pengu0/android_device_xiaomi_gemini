#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

DEVICE=gemini
VENDOR=xiaomi

INITIAL_COPYRIGHT_YEAR=2016

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

JDC_ROOT="$MY_DIR"/../../..

HELPER="$JDC_ROOT"/vendor/aosp/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Initialize the helper
setup_vendor "$DEVICE" "$VENDOR" "$JDC_ROOT"

# Copyright headers and guards
write_headers

write_makefiles "$MY_DIR"/proprietary-files.txt

cat << EOF >> "$ANDROIDMK"
\$(shell mkdir -p \$(PRODUCT_OUT)/system/vendor/lib/egl && pushd \$(PRODUCT_OUT)/system/vendor/lib > /dev/null && ln -s egl/libEGL_adreno.so libEGL_adreno.so && popd > /dev/null)
\$(shell mkdir -p \$(PRODUCT_OUT)/system/vendor/lib64/egl && pushd \$(PRODUCT_OUT)/system/vendor/lib64 > /dev/null && ln -s egl/libEGL_adreno.so libEGL_adreno.so && popd > /dev/null)

EOF

# Finish
write_footers