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

  def get_multi( *keys )
    keys.flatten!
    @values.select { |k, v| keys.include?( k ) }
  end

  def set( key, value, ttl = nil, options = {} )
    @values[key] = value
  end

  def update( key, default, ttl = nil, options = nil )
    @values[key] = yield( @values.fetch(key, default ))
  end

  def append( key, value )
    if @values[key]
      @values[key] += value
    end
  end

  def delete(key)
    @values.delete(key)
  end

  def fetch( key, ttl=nil, options=nil )
    val = get( key )

    if val.nil? && block_given?
      val = yield
      set( key, val )
    end
    val
  end

  def flush
    @values.clear
  end

  def flush_all
    flush
  end
end
