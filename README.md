# Welcome to Robowars

Robowars is a Rails 3 app for running a Robowars Tournament Event.

It allows for players to log in via Twitter or Github, then create and test their robots.

Staff users can enter the tournament section, where the matches are played.

### Development

You can run Robowars in development without Twitter or Github setup.

To access as a player, run:

```bash
MOCK_USER=true bundle exec rails s
```

To access as staff, run:

```bash
MOCK_USER=staff bundle exec rails s
```

### Testing

Tests are in rspec, the whole app is not covered, but there's enough for you to check out how you can test additions.

### License

License is MIT. See LICENSE for details.

