# Netra
Netra is Feature Testing platform to automagically create, maintain & execute test plans
For the feature support, refer [HELP.md](HELP.md)

## Deployment

* To deploy on the test node, use the following capistrano commands -

```
cap production deploy
```

* The test node is currently set to http://10.190.228.70

## Sidekiq Usage

* For batch processing support, Sidekiq will be used

* `/sidekiq` route is mounted and available for checking job status

* Redis server is required to run off jobs, use the following to install redis on your mac's -
```
brew install redis
```

* Redis server runs on port `6379` by default, [Redis Reference](https://github.com/mperham/sidekiq/wiki/Using-Redis)

* Start your redis server like so -
```
redis-server /usr/local/etc/redis.conf
```

* To process queued jobs -
```
bundle exec sidekiq
```

* Sidekiq Reference - https://github.com/mperham/sidekiq/wiki/Getting-Started

## Testing

```
RAILS_ENV=test rake db:drop db:create db:migrate
rspec
```

For coverage, using `simplecov`, use this command -
```
open target/coverage/index.html
```

## phantomjs
```
install phantomjs version 2.1.1
```

## Contributors

* Team POTC & Dev Academy Interns
* Solution Designers - Tanu Halder, Heather Fenstermann, Krishna Kumar
* Point of Contact - Supreeth Burji
