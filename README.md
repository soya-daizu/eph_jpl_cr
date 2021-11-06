# EphJplCr

Crystal port of Ruby library [EphJpl](https://github.com/komasaru/eph_jpl), which calculates ephemeris data by JPL(NASA Jet Propulsion Laboratory) method.

See the original libary for more detail.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     eph_jpl_cr:
       github: soya-daizu/eph_jpl_cr
   ```

2. Run `shards install`

## Usage

```crystal
require "eph_jpl_cr"

session = EphJplCr::Session.new("/path/to/JPLEPH")
# Target celestial body num, center celestial body num, julian day
session.set_args(11, 3, 2457465.5)
session.calc #=> [x, y, z-position, x, y, z-velocity]
```

## Contributing

1. Fork it (<https://github.com/soya-daizu/eph_jpl_cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [soya_daizu](https://github.com/soya-daizu) - creator and maintainer

- [komasaru](https://github.com/komasaru) - author of the original Ruby library
