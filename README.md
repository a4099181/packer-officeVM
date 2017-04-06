# packer-officeVM

## What is it for?

Simply, in a couple of words. It converts Windows ISO file into [vagrant's](http://www.vagrantup.com) box.

## Requirements

There is only one requirement: [packer](http://www.packer.io).

Please [download](https://www.packer.io/downloads.html) it and install on your own.

> After install be sure, that `packer.exe` is accessible in `PATH` environment variable.

## Usage tip:

#### From powershell console:

```
PS packer-officeVM> .\build.ps1 <your-iso-file-path>
```

#### From Windows command-line:

```
packer-officeVM> powershell -File build.ps1 <your-iso-file-path>
```

#### With specified OS template:

```
packer-officeVM> powershell -File build.ps1 <your-iso-file-path> -os windows10_1607
```

> Please note, that `os` argument value is a name of the folder that contains expected `template.json` file.

> If `os` argument is not provided (just as in two above examples), then default value is used.
> The default value is `windows10_1703`. This template expects ISO file of the Windows 10 Creators Update.

#### Sample output of the command above:

```
virtualbox-iso output will be in this color.

==> virtualbox-iso: Downloading or copying Guest additions
    virtualbox-iso: Downloading or copying: file:///.../Oracle/VirtualBox/VBoxGuestAdditions.iso
==> virtualbox-iso: Downloading or copying ISO
    virtualbox-iso: Downloading or copying: file:///.../windows_10.iso
==> virtualbox-iso: Creating floppy disk...
    virtualbox-iso: Copying: .\windows10_1607\Autounattend.xml
==> virtualbox-iso: Creating virtual machine...
==> virtualbox-iso: Creating hard drive...
==> virtualbox-iso: Attaching floppy disk...
==> virtualbox-iso: Creating forwarded port mapping for communicator (SSH, WinRM, etc) (host port 3825)
==> virtualbox-iso: Executing custom VBoxManage commands...
    virtualbox-iso: Executing: modifyvm windows10_1607 --memory 2048
    virtualbox-iso: Executing: modifyvm windows10_1607 --cpus 2
==> virtualbox-iso: Starting the virtual machine...
    virtualbox-iso: The VM will be run headless, without a GUI. If you want to
    virtualbox-iso: view the screen of the VM, connect via VRDP without a password to
    virtualbox-iso: 127.0.0.1:5962
==> virtualbox-iso: Waiting 5m0s for boot...
==> virtualbox-iso: Typing the boot command...
==> virtualbox-iso: Waiting for WinRM to become available...
==> virtualbox-iso: Connected to WinRM!
==> virtualbox-iso: Uploading VirtualBox version info (5.1.14)
==> virtualbox-iso: Gracefully halting virtual machine...
    virtualbox-iso: Removing floppy drive...
==> virtualbox-iso: Preparing to export machine...
    virtualbox-iso: Deleting forwarded port mapping for the communicator (SSH, WinRM, etc) (host port 3825)
==> virtualbox-iso: Exporting virtual machine...
    virtualbox-iso: Executing: export windows10_1607 --output output-virtualbox-iso\windows10_1607.ovf
==> virtualbox-iso: Unregistering and deleting virtual machine...
==> virtualbox-iso: Running post-processor: vagrant
==> virtualbox-iso (vagrant): Creating Vagrant box for 'virtualbox' provider
    virtualbox-iso (vagrant): Copying from artifact: output-virtualbox-iso\windows10_1607-disk1.vmdk
    virtualbox-iso (vagrant): Copying from artifact: output-virtualbox-iso\windows10_1607.ovf
    virtualbox-iso (vagrant): Renaming the OVF to box.ovf...
    virtualbox-iso (vagrant): Compressing: Vagrantfile
    virtualbox-iso (vagrant): Compressing: box.ovf
    virtualbox-iso (vagrant): Compressing: metadata.json
    virtualbox-iso (vagrant): Compressing: windows10_1607-disk1.vmdk
Build 'virtualbox-iso' finished.

==> Builds finished. The artifacts of successful builds are:
--> virtualbox-iso: 'virtualbox' provider box: packed\windows10_1607.virtualbox.box
```
