# Deployment

## Preparation

Requirements:

* Ubuntu Server
* Git
* Ruby >= 2.6
* Node >= v12.0, yarn >= v1.10.0.
* PostgreSQL >= 12.0
* Redis >= 4.0
* Nginx

### Ubuntu Server

```sh
# run as root!
apt-get update -y
apt-get upgrade -y
apt-get install sudo -y
```

```sh
# Install vim and set as default editor
sudo apt-get install -y vim
sudo update-alternatives --set editor /usr/bin/vim.basic
```

System users:

```sh
sudo adduser --disabled-login --gecos 'BookShare' bookshare
```

make link:

```sh
sudo ln -s /home/deploy/bookshare/current/ /var/www/bookshare
```

### Git

```sh
# Install Git
sudo apt-get install -y git-core

# Make sure Git is version 2.0 or higher
git --version
```

### Ruby

#### 1. Install Ruby from source


#### 2. Install Ruby via rbenv

```sh
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL
rbenv install 2.6.5
rbenv global 2.6.5
ruby -v
# ruby 2.6.5
```

gem mirror:

```sh
```

```sh
gem install bundler
```

#### 3. Install Ruby via rvm

### Node

```sh
# install node v12.x
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs

curl --silent --show-error https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install yarn
```

### PostgreSQL

add sources:

```sh
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo apt-get update
```

```sh
sudo apt-get install -y postgresql postgresql-client libpq-dev postgresql-contrib
```

start server:
```sh
/usr/lib/postgresql/12/bin/pg_ctl -D /var/lib/postgresql/12/main -l logfile start
```

create user && database:

```sh
sudo -u postgres createuser --createdb deploy

sudo -u postgres psql

CREATE DATABASE pg_bookshare_production OWNER deploy;

postgres=# \q
```

Try to connect:

```sh
sudo -u bookshare -H psql -d pg_bookshare_production

postgres=# \q
```

### Redis

```sh
sudo apt-get install redis-server

sudo systemctl enable redis-server.service

sudo systemctl restart redis.service
sudo systemctl status redis
```

### Nginx

```sh
sudo apt-get install nginx
```

## Installation

### 1. Cap deploy

```shell
cap production deploy
```

### 2. Puma & sidekiq service

```shell
$ sudo cp lib/support/systemd/puma.service /etc/systemd/system/puma.service
$ sudo cp lib/support/systemd/sidekiq.service /etc/systemd/system/sidekiq.service
```

Modify below section in `/etc/systemd/system/puma.service`:
```
Environment=PORT=3000
Environment=WECHAT_APP_ID=xxx
Environment=WECHAT_APP_SECRET=xxx
```

```shell
$ sudo systemctl daemon-reload

$ sudo systemctl enable puma
$ sudo systemctl start puma

$ sudo systemctl enable sidekiq
$ sudo systemctl start sidekiq

$ sudo systemctl status puma.service
$ sudo systemctl status sidekiq.service
```

### 3. Nginx setup

http:

```shell
cp lib/support/nginx/bookshare.conf /etc/nginx/sites-available/bookshare
ln -sf /etc/nginx/sites-available/bookshare /etc/nginx/sites-enabled/default

systemctl restart nginx
```

https:

```shell
cp lib/support/nginx/bookshare-ssl.conf /etc/nginx/sites-available/bookshare-ssl
ln -sf /etc/nginx/sites-available/bookshare-ssl /etc/nginx/sites-enabled/default

systemctl restart nginx
```

## Upgrading

### 1. Cap deploy

```shell
cap production deploy
```

### 2. Restart puma & sidekiq service

```shell
$ sudo systemctl restart puma
$ sudo systemctl restart sidekiq
```

## References

[1]: https://gorails.com/deploy/ubuntu/18.04
[2]: https://github.com/mperham/sidekiq
[3]: https://github.com/mperham/sidekiq/blob/master/6.0-Upgrade.md
[4]: https://github.com/ddollar/foreman
[5]: https://capistranorb.com/
