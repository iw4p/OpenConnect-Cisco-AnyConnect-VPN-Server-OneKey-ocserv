# OpenConnect-VPN-Server
Buggy script for configuring OpenConnect (ocserv) protocol on the server easily and automatically.
Tested on ubuntu 18.04 and 16.04.

## Installation

Download and saving script on your server:
```bash
curl -O https://raw.githubusercontent.com/iw4p/OpenConnect-VPN-Server/master/ocserv-install.sh
```

Making script executable
```bash
chmod +x ocserv-install.sh
```

And then just run it:
```sh
./ocserv-install.sh
``` 
or
```sh
sudo bash ocserv-install.sh
``` 

## Features
- Installing 
- Uninstalling
- Add User
- Change Password
- Show All Users
- Delete User
- Lock User
- Unlock User

## Usage
For making connection to your server, you can use `AnyConnect`, `OpenConnect` or other alternative clients.

- AnyConnect: [GUI AnyConnect client for available platforms](https://it.umn.edu/vpn-downloads-guides).
- OpenConnect: [OpenConnect client for Linux](https://computingforgeeks.com/how-to-connect-to-vpn-server-with-openconnect-ssl-vpn-client-on-linux/).

And one more thing, contributions are welcome.
