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

### 2. RVM, Ruby and Ruby Gems (bundler, etc.).

Install RVM:

```sh
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

curl -sSL https://get.rvm.io | bash -s stable
```

Install Ruby:

```sh
rvm list known

rvm install 2.6.5
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
sudo -u postgres createuser --createdb bookshare

sudo -u postgres psql

CREATE DATABASE pg_bookshare_production OWNER bookshare;

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