# Memcache Mock

Simple library to mock a **key/value** storage system.

The _API_ is based in the [Dalli Memcache Ruby Client](https://github.com/mperham/dalli). So any time you need to mock your code that integrates _Dalli_ you can exponse an instance of _MemcacheMock_ instead.

## Use

    require "memcache_mock"

    cache = MemcacheMock.new
    cache.set( "key", "value" )
    cache.get( "key" )            # => "value"

## Status

The actual status is **Beta** but functional. The _API_ only supports the methods we have needed so far.

If you have any suggestion we'll appreciate _pull requests_.