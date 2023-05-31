#!/usr/bin/env bash

# Prerequisite package install.
PACKAGE='cloud-init'

# Ubuntu Server minimized image (Jammy Jellyfish) release [20230420]
USMI_URL='https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img'
USMI_SHA256SUM_URL='https://cloud-images.ubuntu.com/minimal/releases/jammy/release/SHA256SUMS'
USMI_IMAGE_NAME='ubuntu-22.04-minimal-cloudimg-amd64.img'
USMI_SHA256SUM_NAME='SHA256SUMS'

TEPLATE_NAME="ubuntu-jammy-minimal-tpl"
VMID=9000
CORES=2
SOCKETS=2
MEMORY=4096
STORAGE="local-lvm"

CHECK_PACKAGE=$(dpkg --list | grep "${PACKAGE}")
[[ -z "${CHECK_PACKAGE}" ]] && echo "apt-get install ${PACKAGE}"

[[ ! -f "${USMI_IMAGE_NAME}" ]] && wget ${USMI_URL} -O ${USMI_IMAGE_NAME}
[[ ! -f "${USMI_SHA256SUM_NAME}" ]] && wget ${USMI_SHA256SUM_URL} -O ${USMI_SHA256SUM_NAME}

# create a new VM with VirtIO SCSI controller
echo "qm create ${VMID} --name ${TEPLATE_NAME} --memory ${MEMORY} --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci"
qm create ${VMID} --name ${TEPLATE_NAME} --memory ${MEMORY} --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci

# import the downloaded disk to the local-lvm storage, attaching it as a SCSI drive
echo "qm set ${VMID} --scsi0 ${STORAGE}:0,import-from="${PWD}/${USMI_IMAGE_NAME}""
qm set ${VMID} --scsi0 ${STORAGE}:0,import-from=${PWD}/${USMI_IMAGE_NAME}

if [ $? = 0 ]; then
  echo "qm set ${VMID} --ide2 local-lvm:cloudinit"
  qm set ${VMID} --ide2 local-lvm:cloudinit

  echo "qm set 9000 --boot order=scsi0"
  qm set ${VMID} --boot order=scsi0

  echo "qm set ${VMID} --serial0 socket --vga serial0"
  qm set ${VMID} --serial0 socket --vga serial0

  # Setup cores and socket
  echo "qm set ${VMID} --cores ${CORES} --sockets ${SOCKETS}"
  qm set ${VMID} --cores ${CORES} --sockets ${SOCKETS}

  echo "qm template ${VMID}"
  qm template ${VMID}
fi
