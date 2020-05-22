# durian server

My home server die recently&mdash;after running for about 4+ years without any issues. The root cause is probably hardware related, as it won't even turn on. It was pretty old&mdash;most of the components were from ~2014&mdash;so I decided to build a new server with more recent spare parts I had lying around. My least favorite part about setting up a server is installing and configuring all of the services that I plan to run. I figured this time around, I'll just run a bare bones Linux distro and containerize all the services, so that my next install would be a simple `git clone` and `docker-compose up`. The other thing I wanted to do this time around was document the process and keep make it publicly available so I can share with others.

### Hardware and OS Install 

I don't plan to document the hardware or operating system install, as both of those installs are relatively simple and straight forward. Plus, there's plenty of great tutorials on [building a computer](https://www.google.com/search?q=building+a+server+hardware) and [how to install Linux](https://www.google.com/search?q=install+linux+tutorial) (I can't believe the first link is from forbes.com at the time of this post) out on the net. I will say that I'm using a Debian based distro, so YMMV with the commands/paths below.

_Here's a peak at the little guy :-). I didn't have a case, so I jerry-rigged one._

<img src="https://github.com/ikumen/durian-server/blob/master/images/IMG_20200514_161609.jpg" width="200"/> <img src="https://github.com/ikumen/durian-server/blob/master/images/IMG_20200514_161618.jpg" width="200"/> <img src="https://github.com/ikumen/durian-server/blob/master/images/IMG_20200514_161626.jpg" width="200"/>


### Post OS Intall

Once the OS is install, we'll need to lock it down a bit. It's not exhaustive but enough for me. 

#### SSH Server

```bash
# /etc/ssh/sshd_config
Port <new port>
AllowUsers <list of users>
PermitRootLogin no
PermitEmptyPasswords no
```

#### Firewall

Open all outgoing, close incoming, with the exception of a few services.

```bash
sudo ufw default allow outgoing
sudo ufw default deny incoming

# Our new ssh port
sudo ufw allow <new ssh port>/tcp comment 'accept ssh connections'
sudo ufw allow 80/tcp comment 'accept HTTP connections'
sudo ufw allow 443/tcp comment 'accept HTTPS connections'
```

#### Install Docker

Install Docker, enable and add user to docker group, install docker-compose.

```bash
sudo apt install docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker <user>

sudo apt install docker-compose
```
