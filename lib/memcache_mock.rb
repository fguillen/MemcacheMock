require "memcache_mock/version"

class MemcacheMock
  def initialize
    @values = {}
    @expires = {}
  end

  def incr( key, value, ttl, default_value )
    key = normalize_key(key)
    if @values[key]
      append( key, value )
    else
      set_value(key, default_value, ttl)
    end
  end

  def decr( key, value, ttl, default_value)
    key = normalize_key(key)
    if @values[key]
      substract( key, value )
    else
      set_value(key, default_value, ttl)
    end
  end

  def get( key )
    key = normalize_key(key)
    @values.fetch(normalize_key(key), nil)
  end

  def get_multi( *keys )
    keys.flatten!
    @values.select { |k, v| keys.include?( normalize_key(k) ) }
  end

  def set( key, value, ttl = nil, options = {} )
    key = normalize_key(key)
    set_value(key, value, ttl)
  end

  def update( key, default, ttl = nil, options = nil )
    key = normalize_key(key)
    @values[key] = yield( @values.fetch(key, default ))
  end

  def add( key, value, ttl = nil, options = nil )
    key = normalize_key(key)
    if unset?(key) || expired?(key)
      set(key, value, ttl, options)
      true
    else
      false
    end
  end

  def append( key, value )
    key = normalize_key(key)
    if @values[key]
      @values[key] += value
    end
  end

  def substract( key, value )
    key = normalize_key(key)
    if @values[key]
      @values[key] -= value
    end
  end

  def delete(key)
    key = normalize_key(key)
    @values.delete(key)
    @expires.delete(key)
  end

  def fetch( key, ttl=nil, options=nil )
    key = normalize_key(key)
    val = get( key )

    if val.nil? && block_given?
      val = yield
      set( key, val, ttl, options )
    end
    val
  end

  def flush
    @values.clear
    @expires.clear
  end

  def flush_all
    flush
  end

  def touch(key, ttl = nil)
    key = normalize_key(key)
    set_value(key, get(key), ttl)
  end

  private

  def set_value(key, value, ttl = nil)
    @values[key] = value
    @expires[key] = Time.now + ttl if ttl
    true
  end

  def unset?(key)
    !@values.has_key?(key)
  end

  def expired?(key)
    @expires.has_key?(key) && @expires[key] <= Time.now
  end

  def normalize_key(key)
    key.to_s
  end
end
