require 'minitest/autorun'
require 'minitest/pride'
require './lib/exhibit'
require './lib/patron'

class PatronTest < Minitest::Test

  def test_it_exists
    bob = Patron.new("Bob", 20)

    assert_instance_of Patron, bob
  end

  def test_it_has_attributes
    bob = Patron.new("Bob", 20)

    assert_equal "Bob", bob.name
    assert_equal 20, bob.spending_money
  end

  def test_interests_starts_empty
    bob = Patron.new("Bob", 20)

    assert_equal [], bob.interests
  end

  def test_it_can_add_interests
    bob = Patron.new("Bob", 20)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")
    expected = ["Dead Sea Scrolls", "Gems and Minerals"]
    assert_equal expected, bob.interests
  end
end
