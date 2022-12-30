# Upgrade Python Installation

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

To make use of the full I/O capabilities, Python 3.11 (unfortunately) will have to be run with `sudo` privileges.
This makes setting the respective environment variables of the Python binary and library location a bit cumbersome. I propose the following workaround:

### Step 2.1: Create a wrapping shell script

Create a [shell script](/assets/py-sudo-wrapper.sh), which ...

- ... will be called with sudo privileges
- ... accepts the Python program to be run as an argument
- ... sets the Python binary location as well as the library location
- ... calls Python and passes the respective program as an argument

In essence, this script wraps the Python executable and temporarily sets the environment variables in the root context.
This ensures, that any existing installation of Python is not touched (and thus not broken).

In our case, the environment variables are set as follows:

```bash
export PATH=/opt/ft/workspaces/ext_sd/mmcblk1/python-3.11/bin:$PATH
export LD_LIBRARY_PATH=/opt/ft/workspaces/ext_sd/mmcblk1/python-3.11/lib:/$LD_LIBRARY_PATH
```

### Step 2.2: Check installation

Run the [wrapper script](/assets/py-sudo-wrapper.sh) from the previous step to check if the work has been successful so far.

```bash
sudo /home/david/py-sudo-wrapper.sh
```

### Step 2.3: Create symbolic links

OpenSource Python packages are typically installed with `pip`.
Unfortunately, the Python modules for controlling the I/Os of the TXT 4.0 are not publicly available.
As a workaround, we create symbolic links from our custom Python installation to the delivered Python installation for the following files or folders:

- `ft.py`
- `_ft.so`
- `ftlock.py`
- `_ftlock.so`
- `ft.py`
- `ft_controllerlib-6.1.2-py3.5.egg-info`
- `fischertechnik`

Example:

```bash
ln -s /usr/lib/python3.5/site-packages/ft.py /opt/ft/workspaces/ext_sd/mmcblk1/python-3.11/lib/python3.11/site-packages/ft.py
```

## Usage

Run the [wrapper script](/assets/py-sudo-wrapper.sh) with sudo privileges and pass a Python program of your choice as an argument:

Example (assuming `omniwheels.py` has been loaded to the TXT 4.0):

```bash
sudo /home/david/py-sudo-wrapper.sh /opt/ft/workspaces/omniwheels.py
```
