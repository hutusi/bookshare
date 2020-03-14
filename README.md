# Bookshare 

Bookshare app server.

## Deployment

[Deployment guide](deploy.md)

## Development

* Ruby >= 2.6
* Node, yarn
* PostgreSQL
* Redis

### MacOS

PostgreSQL: 

```sh
brew install postgresql
brew services start postgresql
createuser --createdb bookshare
```

Redis:

```sh
brew install redis
brew services start redis

redis-cli ping
```

### Bundle install & migrate

```sh
bundle
bundle exec rails db:setup
bundle exec rails db:migrate
```

### Start server

```sh
bundle exec rails s
```

or 

```sh
foreman start
```

### Testing

Run rspec tests:

```sh
rspec
```

Run rubocop:

```sh
rubocop
```

or:

```sh
guard
```

## Changelogs

[CHANGELOG.md](CHANGELOG.md)

## TODO

- [ ] Refine sidekiq
- [ ] Caching queries
- [ ] API: search
- [X] Remove unused code
- [ ] Rspec test cover
- [ ] CI enabled
- [X] Backup database
- [X] Use Pundit instead of cancancan
- [ ] Limits creating sharing
