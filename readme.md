# Vagrant Lamp Stack

This is the Vagrant - Puppet configuration I use for developing my projects.
Credit goes to pyrocms's similar setup https://github.com/pyrocms/devops-vagrant

## How to use

Download this repository and use it as a git submoudle in your projects. Change the Vagrantfile settings to better suit your needs all the rest should work fine out of the box.

### Connecting to the DB

Since this was a pain for me at first, to connect to the DB from outside the VM you have to tunnel inside the machine, then connect to the database.