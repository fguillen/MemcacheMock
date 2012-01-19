# Memcache Mock

Simple library to mock a **key/value** storage system.

The _API_ is based in the **Dalli Memcache Ruby Client**.

## Use
    gem install memcache_mock
    cache = MemcacheMock.new
    cache.set( "key", "value" )
    cache.get( "key" )            # => "value"

## Status

The actual status is **Beta** and the _API_ only support the methods we have needed so far.

If you have any suggestion we'll appreciate _pull requests_.