require_relative "test_helper"

class MemcacheMockTest < Test::Unit::TestCase
  def setup
    @cache = MemcacheMock.new
  end

  def test_initialize
    assert( @cache.is_a? MemcacheMock )
    assert_equal( {}, @cache.instance_variable_get( :@values ) )
  end

  def test_incr_when_key_not_exists
    @cache.incr( "key", "value", nil, "default_value" )
    assert_equal( "default_value", @cache.get( "key" ))
  end

  def test_incr
    @cache.set( "key", "original_value" )
    @cache.expects( :append ).with( "key", "value" )

    @cache.incr( "key", "value", nil, nil )
  end

  def test_decr_when_key_not_exists
    @cache.decr( "key", "value", nil, "default_value" )
    assert_equal( "default_value", @cache.get( "key" ))
  end

  def test_decr
    @cache.set( "key", "original_value" )
    @cache.expects( :substract ).with( "key", "value" )

    @cache.decr( "key", "value", nil, nil )
  end

  def test_get_when_key_not_exists
    assert_equal( nil, @cache.get( "key" ) )
  end

  def test_get
    @cache.set( "key", "value" )
    assert_equal( "value", @cache.get( "key" ) )
  end

  def test_get_multi
    @cache.set( "key1", "value1" )
    @cache.set( "key2", "value2" )
    @cache.set( "key3", "value3" )

    result = @cache.get_multi( ["key1", "key2", "key3", "key4" ] )

    assert_equal( "value1", result["key1"] )
    assert_equal( "value3", result["key3"] )
    assert_equal( nil, result["key4"] )
  end

  def test_get_multi_splat_args
    @cache.set( "key1", "value1" )
    @cache.set( "key2", "value2" )

    result = @cache.get_multi("key1", "key2")

    assert_equal( "value1", result["key1"] )
    assert_equal( "value2", result["key2"] )
  end

  def test_set
    @cache.set( "key", "value" )
    assert_equal( "value", @cache.get( "key" ) )
  end

  def test_append
    @cache.set( "key", "value1" )
    @cache.append( "key", "|value2" )

    assert_equal( "value1|value2", @cache.get( "key" ) )
  end

  def test_add
    assert_equal( true, @cache.add( "key", "value" ) )
  end

  def test_add_when_key_exists
    @cache.set( "key", "value" )
    assert_equal( false, @cache.add( "key", "value" ) )
  end

  def test_add_when_expired_key_exists
    @cache.set( "key", "value", 5 )

    Timecop.freeze(Time.now + 6) do
      assert_equal( true, @cache.add( "key", "value" ) )
    end
  end

  def test_substract
    @cache.set( "key", 7 )
    @cache.substract( "key", 5 )

    assert_equal( 2, @cache.get( "key" ) )
  end

  def test_fetch
    assert_equal( nil, @cache.fetch( "key0" ) )

    @cache.set( "key1", "value1" )
    assert_equal( "value1", @cache.fetch( "key1" ) )

    assert_equal( "value1", @cache.fetch( "key1" ) { "value2" } )
    assert_equal( "value2", @cache.fetch( "key2" ) { "value2" } )

    @cache.fetch( "key3" ) { "value3" }
    assert_equal( "value3", @cache.get( "key3" ) )
  end

  def test_flush
    @cache.set( "key", "value1" )
    @cache.flush
    assert_equal( nil, @cache.get( "key" ) )
  end

  def test_delete
    @cache.set( "key", "value1" )
    assert_equal( "value1", @cache.get( "key" ) )
    @cache.delete( "key" )
    assert_nil( @cache.get( "key" ) )
  end

  def test_touch
    @cache.touch("key")
    @cache.touch("key", 60)
  end
end
