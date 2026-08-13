# Disko disk layout for the NixOS desktop.
#
# ⚠️ WARNING ⚠️
# Disko `create` / `destroy` modes erase this disk. `disko --mode destroy`
# wipes every partition on `/dev/nvme0n1` without further confirmation.
# This module is only safe to use on a machine where the target disk is
# exactly `/dev/nvme0n1` and you intend to fully repartition it.
#
# Before using this configuration on another machine, update
# `disko.devices.disk.main.device` below to the correct target disk.
#
# Simple GPT + ext4 layout: no swap, no LUKS encryption, no LVM, no Btrfs.
# Filesystems (and their mounts) are declared here, so
# `nixos-generate-config` must be run with `--no-filesystems` on the target.
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
