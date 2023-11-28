# redborder-cgroups

## Overview

The redborder-cgroups package provides tools and scripts for configuring cgroups in redborder environments. 

## Installation

To install redborder-cgroups, follow these steps:

1. Compile RPM package using redborder mock file.

2. Install the package using the following command:

   ```bash
   sudo rpm -i redborder-cgroups-<version>-<release>.noarch.rpm
   Replace <version> and <release> with the actual version and release numbers of the package.
   ```
3. After installation, the systemd service will be enabled

## Usage

Create a file in /etc/cgroup.conf with the services in yaml format, for more info take a look at [Cgroup Cookbook](https://github.com/redBorder/cookbook-rb-cgroup)

Then start `rb_configure_cgroup.sh` and it will reassign memory for each service

## Authors

Miguel Álvarez <malvarez@redborder.com>
