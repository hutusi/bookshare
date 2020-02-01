# bookshare 

Bookshare app server.

## Requirements

* Ruby >= 2.6
* PostgreSQL
* Redis

## Installation

### 1. Packages and dependencies

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

```sh
# Install Git
sudo apt-get install -y git-core

# Make sure Git is version 2.0 or higher
git --version
```

### 2. rbenv, Ruby and Ruby Gems (bundler, etc.).

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

### 3. Node.

* node >= v12.0
* yarn >= v1.10.0.

```sh
# install node v12.x
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs

curl --silent --show-error https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install yarn
```

### 4. System users

```sh
sudo adduser --disabled-login --gecos 'BookShare' bookshare
```

### 5. Database.

install:

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

On Mac: 

```sh
brew install postgresql
brew services start postgresql
createuser --createdb bookshare
```

```sh
```

### 5. Redis.

* redis >= 4.0

```sh
sudo apt-get install redis-server

sudo systemctl enable redis-server.service

sudo systemctl restart redis.service
sudo systemctl status redis
```

On Mac: 

```sh
brew install redis
brew services start redis
```

ping 

```sh
redis-cli ping
```

### 6. Nginx.

```sh
sudo apt-get install nginx
```


## deployment

```sh
rails db:create
rails db:migrate
```


<!-- ### 1. Clone the code repository

set deploy key (ssh key), follow: https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys

deploy to: ~~/var/www/bookshare~~

```
sudo su bookshare
cd /home/bookshare
git clone https://github.com/hutusi/bookshare.git
``` -->


on local machine:

### 1. cap deploy

```shell
cap production deploy
```

on remote server:

### 1. Set Environment Variables

```shell
vim /etc/environment

RAILS_ENV=production
RACK_ENV=production
```

### 2. Nginx

```shell
cp lib/support/nginx.conf /etc/nginx/sites-available/bookshare
ln -sf /etc/nginx/sites-available/bookshare /etc/nginx/sites-enabled/default

systemctl restart nginx
```

## HTTPS

More in lib/support/nginx/bookshare-ssl configure file. 

## Systemd service

```sh
$ sudo cp lib/support/systemd/puma.service /etc/systemd/system/puma.service
$ sudo cp lib/support/systemd/sidekiq.service /etc/systemd/system/sidekiq.service

$ sudo systemctl daemon-reload

$ sudo systemctl enable puma
$ sudo systemctl start puma

$ sudo systemctl enable sidekiq
$ sudo systemctl start sidekiq

$ sudo systemctl status puma.service
$ sudo systemctl status sidekiq.service
```

## References

[1]: https://gorails.com/deploy/ubuntu/18.04
