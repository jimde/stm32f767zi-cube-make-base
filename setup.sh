#!/bin/bash

STM32F7_REPO=https://github.com/STMicroelectronics/STM32CubeF7.git
STM32F7_BRANCH=v1.16.1
STM32F7_DIR=STM32CubeF7

WORKSPACE_ROOT=$(pwd)

if [[ ! -z "${1}" ]]; then
    if [[ "${1}" == "--clean" ]]; then
        echo "> cleaning workspace"
        echo "> removing STM32 repo"
        rm -rf ${STM32F7_DIR}
    fi
fi

if [[ ! -d "${STM32F7_DIR}" ]]; then
    # shallow clone STM32 repo at branch/tag, STM32F7_BRANCH
    echo "> cloning STM32F7 repo"
    git clone --depth 1 --branch ${STM32F7_BRANCH} ${STM32F7_REPO} ${STM32F7_DIR}
else
    echo "> STM32 repo already cloned. skipping"
fi

echo "> checking prerequisites"

PREREQUISITES=(
    arm-none-eabi-gcc-9.2.1
    make
    git
    JLinkExe
    Ozone
)

for p in "${PREREQUISITES[@]}"; do
    which ${p} 1>/dev/null 2>/dev/null && echo "  + found:   ${p}" || echo "  - MISSING: ${p}"
done
