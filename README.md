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
sudo apt-get install -y nodejs

curl --silent --show-error https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install yarn
```

### 4. Database.

install:

```sh
sudo apt-get install -y postgresql postgresql-client libpq-dev postgresql-contrib
```

create user:

```sh
sudo -u postgres createuser --createdb bookshare
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

### 6. Nginx.

```sh
sudo apt-get install nginx
```


## deployment

```sh
rails db:create
rails db:migrate
```