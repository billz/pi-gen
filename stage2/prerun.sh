#!/bin/bash -e

if [ ! -d "${ROOTFS_DIR}" ]; then
	copy_previous
fi

echo "127.0.0.1 $(hostname)" >> /etc/hosts
