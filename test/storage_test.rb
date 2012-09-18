require 'mongo/storage'
require 'test/unit'

class StorageTest < Test::Unit::TestCase

  def setup
    @store = Storage.new("localhost", 27017, "scratch")
    @store.connect
  end

  def teardown
    @store.disconnect
  end

  def test_connection
    assert(@store.connected?)
  end

  def test_save
    collection = @store.collection "test_save"
    collection.save({'name' => 'Sean Monaghan', 'age' => 35})

    doc = collection.find_one({'name' => 'Sean Monaghan'})
    assert_equal(doc['age'], 35)

    collection.remove doc
    assert_nil collection.find_one({'name' => 'Sean Monaghan'})

    collection.drop
  end

  def test_iter
    collection = @store.collection "test_iter"
    collection.save({'fname' => 'Blue', 'lname' => 'Berry', 'age' => 35})
    collection.save({'fname' => 'Red', 'lname' => 'Berry', 'age' => 36})
    collection.save({'fname' => 'Purple', 'lname' => 'Berry', 'age' => 5})
    collection.save({'fname' => 'Orange', 'lname' => 'Berry', 'age' => 2})

    collection.find({'lname' => 'Berry'}) { |cursor|
      assert_equal(4, cursor.count)
      cursor.each { |record| p record }
    }

    collection.drop

  end
end
