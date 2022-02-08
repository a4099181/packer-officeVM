# HyperV support for packer-officeVM

HyperV is not a default provider. That is why it should be declared to use.
If you want to use HyperV you have to add `-provider` argument when invoking [build.ps1](build.ps1) script.

## Usage tip:

#### From powershell console:

```
PS packer-officeVM> .\build.ps1 <your-iso-file-path> -provider hyperv
```

#### From Windows command-line:

```
packer-officeVM> powershell -File build.ps1 <your-iso-file-path> -provider hyperv
```

#### With specified OS template:

```
packer-officeVM> powershell -File build.ps1 <your-iso-file-path> -os windows10_1607 -provider hyperv
```

> Please note, that `os` argument value is a name of the folder that contains expected `template.json` file.

> If `os` argument is not provided (just as in two first examples), then default value is used.
> The default value is `windows10_1703`. This template expects ISO file of the Windows 10 Creators Update.

#### Sample output of the command above:

```
hyperv-iso output will be in this color.

Warnings for build 'hyperv-iso':

* Hyper-V might fail to create a VM if there is not enough free memory in the system.

==> hyperv-iso: Creating temporary directory...
==> hyperv-iso: Downloading or copying ISO
    hyperv-iso: Downloading or copying: file:///.../windows.iso
==> hyperv-iso: Creating floppy disk...
    hyperv-iso: Copying files flatly from floppy_files
    hyperv-iso: Copying file: .\windows-10.1703\pl-PL\hyperv\Autounattend.xml
    hyperv-iso: Copying file: .\scripts\Enable-WinRM.ps1
    hyperv-iso: Copying file: .\scripts\Remove-AppxPackage.ps1
    hyperv-iso: Copying file: .\scripts\Switch-ToPrivateNetwork.ps1
    hyperv-iso: Copying file: .\windows-10.1703\LayoutModification.xml
    hyperv-iso: Copying file: C:\Users\***\.ssh\id_rsa
    hyperv-iso: Copying file: C:\Users\***\.ssh\known_hosts
    hyperv-iso: Done copying files from floppy_files
    hyperv-iso: Collecting paths from floppy_dirs
    hyperv-iso: Resulting paths from floppy_dirs : []
    hyperv-iso: Done copying paths from floppy_dirs
==> hyperv-iso: Creating switch 'PackerExternal' if required...
==> hyperv-iso:     switch 'PackerExternal' already exists. Will not delete on cleanup...
==> hyperv-iso: Creating virtual machine...
==> hyperv-iso: Enabling Integration Service...
==> hyperv-iso: Setting boot drive to os dvd drive .../windows.iso ...
==> hyperv-iso: Mounting os dvd drive .../windows.iso ...
==> hyperv-iso: Mounting floppy drive...
==> hyperv-iso: Skipping mounting Integration Services Setup Disk...
==> hyperv-iso: Mounting secondary DVD images...
==> hyperv-iso: Configuring vlan...
==> hyperv-iso: Starting the virtual machine...
==> hyperv-iso: Waiting 5m0s for boot...
==> hyperv-iso: Host IP for the HyperV machine: 169.254.50.134
==> hyperv-iso: Typing the boot command...
==> hyperv-iso: Waiting for WinRM to become available...
==> hyperv-iso: Connected to WinRM!
==> hyperv-iso: Provisioning with windows-shell...
==> hyperv-iso: Provisioning with shell script: C:\Users\***\AppData\Local\Temp\packer-windows-shell-provisioner646820827
    hyperv-iso:
    hyperv-iso: C:\Users\vagrant>powershell -ExecutionPolicy ByPass -NonInteractive -Command "Get-ChildItem A: -Include id_*, known_hosts -File -Recurse | % { Copy-Item $_.FullName .\.ssh\$($_.Name.ToLower()) }"
    hyperv-iso: id_rsa
    hyperv-iso: known_hosts
==> hyperv-iso: Gracefully halting virtual machine...
==> hyperv-iso: Waiting for vm to be powered down...
==> hyperv-iso: Unmount/delete secondary dvd drives...
==> hyperv-iso: Unmount/delete Integration Services dvd drive...
==> hyperv-iso: Unmount/delete os dvd drive...
==> hyperv-iso: Delete os dvd drives controller 0 location 1 ...
==> hyperv-iso: Unmount/delete floppy drive (Run)...
==> hyperv-iso: Exporting vm...
==> hyperv-iso: Compacting disks...
==> hyperv-iso: Coping to output dir...
==> hyperv-iso: Cleanup floppy drive...
==> hyperv-iso: Unregistering and deleting virtual machine...
==> hyperv-iso: Deleting temporary directory...
==> hyperv-iso: Running post-processor: vagrant
==> hyperv-iso (vagrant): Creating Vagrant box for 'hyperv' provider
    hyperv-iso (vagrant): Copying: output-hyperv-iso\Virtual Hard Disks\windows-10.1703.vhdx
    hyperv-iso (vagrant): Copyed output-hyperv-iso\Virtual Hard Disks\windows-10.1703.vhdx to C:\Users\***\AppData\Local\Temp\...
    hyperv-iso (vagrant): Copying: output-hyperv-iso\Virtual Machines\42D1F2C1-80D4-4CE6-9490-F212FD551B9F.VMRS
    hyperv-iso (vagrant): Copyed output-hyperv-iso\Virtual Machines\42D1F2C1-80D4-4CE6-9490-F212FD551B9F.VMRS to C:\Users\***\AppData\Local\Temp\...
    hyperv-iso (vagrant): Copying: output-hyperv-iso\Virtual Machines\42D1F2C1-80D4-4CE6-9490-F212FD551B9F.vmcx
    hyperv-iso (vagrant): Copyed output-hyperv-iso\Virtual Machines\42D1F2C1-80D4-4CE6-9490-F212FD551B9F.vmcx to C:\Users\***\AppData\Local\Temp\...
    hyperv-iso (vagrant): Copying: output-hyperv-iso\Virtual Machines\box.xml
    hyperv-iso (vagrant): Copyed output-hyperv-iso\Virtual Machines\box.xml to C:\Users\***\AppData\Local\Temp\...
    hyperv-iso (vagrant): Compressing: Vagrantfile
    hyperv-iso (vagrant): Compressing: Virtual Hard Disks\windows-10.1703.vhdx
    hyperv-iso (vagrant): Compressing: Virtual Machines\42D1F2C1-80D4-4CE6-9490-F212FD551B9F.VMRS
    hyperv-iso (vagrant): Compressing: Virtual Machines\42D1F2C1-80D4-4CE6-9490-F212FD551B9F.vmcx
    hyperv-iso (vagrant): Compressing: Virtual Machines\box.xml
    hyperv-iso (vagrant): Compressing: metadata.json
Build 'hyperv-iso' finished.

==> Builds finished. The artifacts of successful builds are:
--> hyperv-iso: 'hyperv' provider box: packed\windows-10.1703.hyperv.box
```

#### HyperV notes

* Before building a box configure network switch.
  It is recommended to create **external switch** (named `PackerExternal`) to avoid public network on the guest machine.
  Advanced users familiar with Hyper-V networking may choose any other option wanted,
  but it is tricky to achieve working private network with on-line connection on private or internal switches.
* Be careful about [Hyper-V synced folder limitations](https://www.vagrantup.com/docs/synced-folders/smb.html#limitations)
* Consider [preventing idle disconnects](https://www.vagrantup.com/docs/synced-folders/smb.html#preventing-idle-disconnects)
