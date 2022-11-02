# packer-officeVM

## What is it for?

Simply, in a couple of words. It converts Windows ISO file into [vagrant's](http://www.vagrantup.com) box.

## Importance!

The primary goal of this project is to support [vagrant-officeVM](https://github.com/a4099181/vagrant-officeVM).
These two projects forms one small ecosystem.

## Requirements

There is only one requirement: [packer](http://www.packer.io).

Please [download](https://www.packer.io/downloads.html) it and install on your own.

> After install be sure, that `packer.exe` is accessible in `PATH` environment variable.

## Usage tip

This project supports two hypervisors: [Hyper-V](hyperv.md) and [Virtualbox](virtualbox.md).

Choose the one you want. Detailed instructions are described at [hyperv.md](hyperv.md) and [virtualbox.md](virtualbox.md).

#### What's in the box:

* Windows installed,
* single user: `vagrant` with password `vagrant`,
* VirtualBox Guest additions installed,
* WinRM access enabled,
* Linux Subsystem for Windows installed,
* Developer Mode enabled,
* SSH Private/Public Keys may be uploaded. [Read this](#ssh-keys-support) to understand it.

#### Localization:

Setup file for Windows installer is localized. It contains some elements where strict region ID is specified.
`Autounattend.xml` is located under a regional folder just to make a space for other languages.

Build operation supports additional argument `locale` to indicate wanted language.
So it is possible to run:

```
PS packer-officeVM> .\build.ps1 <your-iso-file-path> -locale pl-PL
```

> Supported languages it is a list of subfolders of the target Windows version folder.

> Currently polish is the only one supported language :) (maybe for some time only).
> It's a default one also when no `locale` is provided.

#### SSH Keys support

> `windows-10.1607` template is not supported.

##### The rules of concept are simple:

- place your SSH keys at `%USERPROFILE%\.ssh` folder at host OS,
- take care of the content of the `known_hosts` file to ensure non-interactive connection success,
- the name of your SSH keys file should starts with `id_`,
- all files `%USERPROFILE%\.ssh\id_*` with `known_hosts` packer copies into the virtual floppy,
- after successful Windows installation all files `A:\id_*` and `A:\known_hosts` are copied to `C:\Users\vagrant\.ssh` folder.

That's all at this stage. The next steps should be done on `vagrant up` at `Vagrantfile`.

> Remember, that your box contains your SSH Private Key. Do not share the box.

If you don't use SSH keys, then ignore it. [Packer] will ignore it also.

##### What you can do with uploaded SSH keys?

My real life examples:

1. `Bash on Ubuntu on Windows` - link uploaded `.ssh` folder with user profile and enjoy git with SSH authentication:

   ```shell
   ~ $ ln -s /mnt/c/Users/vagrant/.ssh .ssh
   ```

2. `Git for Windows` - `%USERPROFILE%` folder is also user profile folder within `Git Bash`. With SSH keys uploaded you can clone repositories using SSH protocol already on non-interactive provisioning.

3. `Git for Windows Portable` - the same as `Git for Windows`.

[packer]: http://www.packer.io
