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

  def test_set
    @cache.set( "key", "value" )
    assert_equal( "value", @cache.get( "key" ) )
  end

  def test_append
    @cache.set( "key", "value1" )
    @cache.append( "key", "|value2" )

    assert_equal( "value1|value2", @cache.get( "key" ) )
  end

  def test_flush
    @cache.set( "key", "value1" )
    @cache.flush
    assert_equal( nil, @cache.get( "key" ) )
  end
end