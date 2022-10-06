# OpenConnect-VPN-Server
**2022 OCT UPDATE**: We dockerized and added Dockerfile to run it anywhere you want on any linux distro easily.
Buggy script for configuring OpenConnect (ocserv) protocol on the server easily and automatically.
## Script Installation
Tested on ubuntu 18.04 and 16.04.

Download and saving script on your server:
```bash
curl -O https://raw.githubusercontent.com/iw4p/OpenConnect-Cisco-AnyConnect-VPN-Server-OneKey-ocserv/master/ocserv-install.sh
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

## Docker Installation
1. Install Docker
2. Build docker image
```bash
docker build -t ocserv https://github.com/iw4p/OpenConnect-Cisco-AnyConnect-VPN-Server-OneKey-ocserv.git
```

3. Run docker container
```bash
docker run --name ocserv --privileged -p 443:443 -p 443:443/udp -d ocserv
```

4. Add user
```bash
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd testUserName
```

5. Delete user
```bash
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -d testUserName
```

6. Lock user
```bash
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -l testUserName
```

6. Unlock user
```bash
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -u testUserName
```

6. Show all users
```bash
docker exec -ti cat /etc/ocserv/ocpasswd
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

## How to connect to it?
For making connection to your server, you can use `AnyConnect`, `OpenConnect` or other alternative clients.

- AnyConnect: [GUI AnyConnect client for available platforms](https://it.umn.edu/vpn-downloads-guides).
- OpenConnect: [OpenConnect client for Linux](https://computingforgeeks.com/how-to-connect-to-vpn-server-with-openconnect-ssl-vpn-client-on-linux/).

And one more thing, contributions are welcome.
