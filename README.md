# durian server

My home server died recently&mdash;after running for about 4+ years without any issues. The root cause is probably hardware related, as it won't even power up. It was pretty old&mdash;most of the components were from ~2014&mdash;so I decided to build a new server with more recent spare parts I had lying around. My least favorite part about setting up a server is installing and configuring all of the services that I plan to run. I figured this time around, I'll just run a bare bones Linux distro and containerize all the services, so that my next install would be a simple `git clone` and `docker-compose up`. The other thing I wanted to do this time around was document the process and make it publicly available to share with others.

### Hardware and OS Install 

I don't plan to document the hardware or operating system install, as both of those installs are relatively simple and straight forward. Plus, there's plenty of great tutorials on [building a computer](https://www.google.com/search?q=building+a+server+hardware) and [how to install Linux](https://www.google.com/search?q=install+linux+tutorial) (I can't believe the first link is from forbes.com at the time of this post) out on the net. As for my flavor of Linux, I'm using a Debian based distro, so YMMV with the commands/paths below.

_Here's a peak at the little guy :-). I didn't have a case, so I jerry-rigged one._

<img src="https://github.com/ikumen/durian-server/blob/master/images/IMG_20200514_161609.jpg" width="200"/> <img src="https://github.com/ikumen/durian-server/blob/master/images/IMG_20200514_161618.jpg" width="200"/> <img src="https://github.com/ikumen/durian-server/blob/master/images/IMG_20200514_161626.jpg" width="200"/>


### Post OS Intall

Once the operating system is installed, we'll need to lock it down a bit, install `docker`, generate our SSL certificates and finally create the data directories required for our services.

#### SSH Server

```bash
# /etc/ssh/sshd_config
Port <new port>
AllowUsers <list of users>
PermitRootLogin no
PermitEmptyPasswords no
```

#### Firewall

First we open all outgoing, then close all incoming, and finally open up for the services we need.

```bash
# Lock these down first
sudo ufw default allow outgoing
sudo ufw default deny incoming

# Then open what we need
sudo ufw allow <new ssh port>/tcp comment 'accept ssh connections'
sudo ufw allow 80/tcp comment 'accept HTTP connections'
sudo ufw allow 443/tcp comment 'accept HTTPS connections'
```

#### Install Docker

Install Docker, then enable and add user to `docker` group, install `docker-compose`.

```bash
sudo apt install docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker <user>
sudo apt install docker-compose
```

#### Certbot (Let's Encrypt) for SSL Certificate

I will be using [Let's Encrypt](https://letsencrypt.org/) as the certificate authority to create [SSL certificates](https://en.wikipedia.org/wiki/Public_key_certificate) for my [HTTPS services](https://en.wikipedia.org/wiki/HTTPS). If you've ever generated certificates before, you'll know that the process can be extremely tedious and error prone (I'm looking at you [StartCom](https://en.wikipedia.org/wiki/StartCom)). 

The Let's Encrypt community has developed plenty of libraries and scripts to automate the process of registering and generating your certificates, but you'll need to let most of them run as root. So instead, I'm going to use [certbot's](https://certbot.eff.org/) manual option&mdash;I only have one server and a couple domains, so the manual option is no big deal. 

First, if you don't already have certbot, go ahead and install it.

```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository universe
sudo apt update
sudo apt install certbot
```

The certbot method I like to use is the manual option with standalone dns challenge&mdash;you can run it on any computer, not just the server that will host the certificates, and you don't have to run it as root. The only downside to this method is __you'll need to log into your domain registry and add the challenge txt as a dns record__. So to start, we need to create the working directories for certbot.

```
mkdir -p certs/config certs/work certs/logs
cd certs
```

Then launch certbot.

```bash
certbot certonly \
  --manual 
  --preferred-challenges dns 
  --config-dir ./config 
  --work-dir ./work 
  --logs-dir ./logs
```

certbot will prompt and ask you to perform a series of steps, here's an overview:

1) you'll be prompted to enter your domains (_note: wildcards are supported e.g, *.yourdomain.com_)
1) certbot will generate a challenge snippet of text for each domain
1) you'll need to take that challenge text, and add it as a `TXT` record at your domain registry
1) **wait a couple of minutes** for the registry to propagate the new `TXT` record before continuing, you'll need to do this for each domain
1) continue certbot (e.g, "Enter to continue" )
1) that's it, you should have your new certificate(s) under `config/live/<yourdomain.com>/`

##### Create stronger Diffie Hellman parameters
The Diffie Hellman stuff is way over my head, but basically we need to create a stronger version of it.

```bash
# source: https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html#toc_5
openssl genpkey -genparam -algorithm DH -out config/live/<yourdomain>/dhparam4096.pem -pkeyopt dh_paramgen_prime_len:4096
```

After the certificates are all generated, we [need to copy them over](/ikumen/durian-server/tree/master/services/nginx#prerequisites) to `/var/nginx/certs` so they can be mounted them to our `nginx` container.

```bash
sudo cp -R config/live/<your.domain>/*.pem  /var/nginx/certs/
```

### Services

That's it for the post install steps. For the servers (e.g, Nginx, Postgres, ...) that we're running I simply refer to them as services. The next section describes how the services are defined and installed on the system. Hopefully after this initial set up we'll be able to simply check this project out of GitHub and run one install to bring up all of our services.

#### Adding a service

Here's the scheme we're using to add/define our services&mdash;it's simple and naive but gets the job done.

* each service can be found under `services` directory within this project
* the service directory name is also the name used when installing the service to [systemd](https://en.wikipedia.org/wiki/Systemd)
* each service directory contains 
  - a `docker-compose.yml` defining the service to run 
  - an `install.sh` script that installs the service to `systemd`

#### Managing the services

There is a `services/durian-service` script that helps manage all the services&mdash;assuming each directory contains the required `docker-compose.yml` and `install.sh`.

_Note: you can place environment variables in a `.secret` file and `durian-service` script will pick it up._

##### Install all services

```bash
cd services
sudo ./durian-service -i
```

##### Install a specific service

```bash
sudo ./durian-service -i nginx
```

##### Unintall a service

```bash
sudo ./durian-service -u nginx
```

##### Status of all services

```bash
sudo ./durian-service -s
```