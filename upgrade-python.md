# Upgrade Python installation

This guide documents how to upgrade the Python installation on a TXT 4.0 to the latest version (currently [Python 3.11](https://www.python.org/downloads/)) _without_ touching the delivered installation (currently Python 3.5).

The guide consists of two major steps:

1. Install Python from Source (on the SD-card)
2. Configure the Python Installation

For parts of step 2, it is assumed that there exists a user with sudo privileges, who we call `david` in the following.

## 1) Install Python from Source

The first step is mostly based on [this article](https://opensource.com/article/20/4/install-python-linux) and additionally configures a custom installation path on the SD-card.

### Step 1.1: Create the Installation Directory

Create an installation directory on the SD card. Here, the SD-card is called `mmcblk1`, which will likely differ from your setup.

```bash
cd /opt/ft/workspaces/ext_sd/mmcblk1
mkdir python-3.11
```

Thus, the installation directory will be `/opt/ft/workspaces/ext_sd/mmcblk1/python-3.11`. Of course, you may choose a different directory.

Verify, if the user `david` owns this directory and has read, write and execute permissions using the `ls -al` command.
Change the ownership (using `chown`) or add permission (using `chmod`) if necessary.

### Step 1.2: Download Python Source

Download the Gzipped source tarball from [Python Downloads](https://www.python.org/downloads/source/) and extract the tarball.

```bash
wget https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz
tar -xf Python-3.11.1.tgz
```

### Step 1.3: Configure Makefile

Check ownership and permissions of the source directory (same procedure as [Step 1.1](#step-11-create-the-installation-directory)), then navigate to the Python source directory.

Run the `./configure` script and pass the custom installation directory using the `--prefix` option. This script configures a custom Makefile and sets the installation directory properly. Read more [here](https://www.iram.fr/IRAMFR/GILDAS/doc/html/gildas-python-html/node36.html).

```bash
cd Python-3.11.1
./configure --enable-shared --prefix=/opt/ft/workspaces/ext_sd/mmcblk1/python-3.11
```

This step will roughly take 30 minutes.

### Step 1.4: Build Python

Start the build process:

```bash
make install
```

This step will roughly take 45 minutes.

## 2) Configure Python Installation on TXT 4.0
