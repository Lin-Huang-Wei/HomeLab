#!/usr/bin/env bash

# Coloer setting
RED=$(tput -Txterm setaf 1)
GREEN=$(tput -Txterm setaf 2)
YELLOW=$(tput -Txterm setaf 3)
BLUE=$(tput -Txterm setaf 4)
MAGENTA=$(tput -Txterm setaf 5)
CYAN=$(tput -Txterm setaf 6)
WHITE=$(tput -Txterm setaf 7)
RESET=$(tput -Txterm sgr0)

# Create the qemu folder
QEMU_FOLDER='/var/lib/vz/template/qemu/'

TEPLATE_NAME="rhel8-ootpa-tpl"
VMID=9003
CORES=2
SOCKETS=2
MEMORY=4096
STORAGE="local-lvm"

REHL_QCOW2='rhel-8.8-x86_64-kvm.qcow2'
PACKAGES_LIST=(qemu-guest-agent)

# Let the user enter root password
read -sp "Please enter the root password: " ROOT_PASSWD
echo

function INFO() {
  printf "${GREEN}[INFO] ${RESET}%s\n" "${1}"
}

[[ ! -d ${QEMU_FOLDER} ]] && INFO "Create the directory ${QEMU_FOLDER}"
[[ -d ${QEMU_FOLDER} ]] && INFO "The directory ${QEMU_FOLDER} exists"

pushd "${QEMU_FOLDER}" >> 2&>1

  INFO "Change dirctory into ${QEMU_FOLDER}"
  [[ -f "${REHL_QCOW2}" ]] && INFO "Update the root password"
  INFO "virt-customize -a ${REHL_QCOW2} --root-password password:${ROOT_PASSWD}"
  virt-customize -a "${REHL_QCOW2}" --root-password "password:${ROOT_PASSWD}"

  # for ((i=0; i<${#PACKAGES_LIST[@]}; i++))
  # do
  #   INFO "virt-customize -a ${REHL_QCOW2} --install ${PACKAGES_LIST[$i]}"
  #   virt-customize -a "${REHL_QCOW2}" --install "${PACKAGES_LIST[$i]}"
  # done

  # create a new VM with VirtIO SCSI controller
  INFO "qm create ${VMID} --name ${TEPLATE_NAME} --memory ${MEMORY} --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci"
  qm create ${VMID} --name ${TEPLATE_NAME} --memory ${MEMORY} --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci

  # Import qcow2 into local-lvm storage
  INFO "qm importdisk ${VMID} ${REHL_QCOW2} ${STORAGE}"
  qm importdisk ${VMID} ${REHL_QCOW2} ${STORAGE}

  # Update unused0:${STORAGE}:vm-${VIMD}-disk-0 to normal disk
  INFO "qm set ${VMID} --scsi0 ${STORAGE}:vm-${VMID}-disk-0"
  qm set ${VMID} --scsi0 ${STORAGE}:vm-${VMID}-disk-0

  # # Resize ${STORAGE}:vm-${VMID}-disk-0
  # INFO "qm resize ${VMID} scsi0 40G"
  # qm resize ${VMID} scsi0 40G
 
  # Add Cloud-init
  INFO "qm set  ${VMID} --ide2 ${STORAGE}:cloudinit"
  qm set  ${VMID} --ide2 ${STORAGE}:cloudinit

  # Update the boot option from virti0
  INFO "qm set ${VMID} --boot order=scsi0"
  qm set ${VMID} --boot order=scsi0

  # Open a terminal using a serial device
  INFO "qm set ${VMID} --serial0 socket --vga serial0"
  qm set ${VMID} --serial0 socket --vga serial0

  # Update the CPU cores and sockets
  INFO "qm set ${VMID} --cores ${CORES} --sockets ${SOCKETS}"
  qm set ${VMID} --cores ${CORES} --sockets ${SOCKETS}

  # Turnes VM into a template
  INFO "qm template ${VMID}"
  qm template ${VMID}

popd >> 2&>1