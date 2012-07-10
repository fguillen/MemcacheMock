require "memcache_mock/version"

class MemcacheMock
  def initialize( )
    @values = {}
  end

  def incr( key, value, ttl, default_value )
    if @values[key]
      append( key, value )
    else
      @values[key] = default_value
    end
  end

  def get( key )
    @values.fetch(key, nil)
  end

  def get_multi( keys, options = nil )
    @values.select { |k, v| keys.include?( k ) }
  end

  def set( key, value, ttl = nil, options = {} )
    @values[key] = value
  end

  def update( key, default, ttl = nil, options = nil )
    @values[key] = yield( @values.fetch(key, default ))
  end
  
  def add( key, value, ttl=nil, options = nil )
    unless @values.include? key
      @values[key] = value
      true
    else
      false
    end
  end
  
  def cas( key, ttl = nil, options = nil )
    if @values.include? key
      @values[key] = yield @values[key]
      true
    else
      nil
    end
  end
  
  def append( key, value )
    if @values[key]
      @values[key] += value
    end
  end
  
  def delete(key)
    @values.delete(key)
  end

  def flush
    @values.clear
  end

  def flush_all
    flush
  end
end
