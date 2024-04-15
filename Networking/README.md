# Dirt
 This is a reference sheet for networking with the home lab

- [Dirt](#dirt)
  - [Ethernet Local connection](#ethernet-local-connection)
    - [IPs](#ips)
    - [Interfaces](#interfaces)
  - [NFS server](#nfs-server)
  - [NFS client](#nfs-client)
    - [Nixos client](#nixos-client)


## Ethernet Local connection 

This connection is automatically setup on connecting the two devices using the ethernet cable and selecting link-local from the network settings.

You must manually assign the local ip for each device:

### IPs
- Client: 10.0.0.10/24
- Server: 10.0.0.20/24
### Interfaces
- Client: enp46s0
- Server: enp2s0

The command to assign ip:

`$ sudo ip ad add $IP dev $Interface`

## NFS server

On the server run the following command to start the nfs server

`$ sudo systemctl start nfs-server.service`

## NFS client

### Nixos client

on nixos the following configuration will setup the Nfs connection

```nix
{
  filesystems."/mnt/$FolderName" = {
    device = "server:/$ServerFolder";
    fsType = "nfs";
  };
}

#Backup config
{
  filesystems."/mnt/Backup" = {
    device = "10.0.0.20/24:/Backup";
    fsType = "nfs"; 
    options = ["x-systemd.automount", "noauto"]; #Lazy mounting
  };
}
```
