require 'minitest/autorun'
require 'minitest/pride'
require './lib/exhibit'
require './lib/patron'
require './lib/museum'

class MuseumTest < Minitest::Test

  def test_it_exists
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_instance_of Museum, dmns
  end

  def test_it_has_attributes
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal "Denver Museum of Nature and Science", dmns.name
  end

  def test_it_starts_without_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal [], dmns.exhibits
  end

  def test_it_starts_without_patrons
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal [], dmns.patrons
  end

  def test_it_can_add_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    expected = [gems_and_minerals, dead_sea_scrolls, imax]
    assert_equal expected, dmns.exhibits
  end

  def test_it_can_find_affordable_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    bob = Patron.new("Bob", 20)
    dmns.admit(bob)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")
    bob.add_interest("IMAX")

    expected = [imax, dead_sea_scrolls, gems_and_minerals]
    assert_equal expected, dmns.find_affordable_exhibits(bob)
  end

  def test_it_can_recommend_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    bob = Patron.new("Bob", 20)
    dmns.admit(bob)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")
    sally = Patron.new("Sally", 20)
    dmns.admit(sally)

    expected = [dead_sea_scrolls, gems_and_minerals]
    assert_equal expected, dmns.recommend_exhibits(bob)
  end

  def test_it_can_find_interested_patrons
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    bob = Patron.new("Bob", 20)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")
    sally = Patron.new("Sally", 20)
    dmns.admit(sally)
    sally.add_interest("IMAX")

    expected = [sally]
    assert_equal expected, dmns.interested_patrons(imax)
  end

  def test_it_can_recommend_exhibits_to_another_patron
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    bob = Patron.new("Bob", 20)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")
    sally = Patron.new("Sally", 20)
    dmns.admit(sally)
    sally.add_interest("IMAX")

    expected = [imax]
    assert_equal expected, dmns.recommend_exhibits(sally)
  end

  def test_it_can_list_patrons_and_their_interests
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    # dmns.patrons
    bob = Patron.new("Bob", 20)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")
    sally = Patron.new("Sally", 20)
    sally.add_interest("Dead Sea Scrolls")
    dmns.admit(bob)
    dmns.admit(sally)
    dmns.patrons

    expected = ({
        gems_and_minerals => [bob],
        dead_sea_scrolls => [bob,sally],
        imax => []
    })
    assert_equal expected, dmns.patrons_of_exhibits
  end

  def test_it_can_calculate_revenue_no_entry
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)
    # This Patron is interested in two exhibits but none in their price range, so they attend none
    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    dmns.admit(tj)
    # dmns.admit_exhibits(tj, dead_sea_scrolls)

    assert_equal 7, tj.spending_money
    assert_equal 0, dmns.revenue
  end

  def test_it_can_calculate_revenue_one_exhibit
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    bob = Patron.new("Bob", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("IMAX")
    dmns.admit(bob)
    # dmns.admit_exhibits(bob, dead_sea_scrolls)

    assert_equal 0, bob.spending_money
    assert_equal 10, dmns.revenue
  end

  def test_it_can_follow_the_rules_and_calc_revenue
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)
    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX")
    sally.add_interest("Dead Sea Scrolls")
    dmns.admit(sally)

    # dmns.admit_exhibits(sally, imax)
    assert_equal 15, dmns.revenue
    assert_equal 5, sally.spending_money
  end

  def test_it_can_admit_those_with_the_appropriate_funds
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)
    # This Patron is interested in two exhibits but none in their price range, so they attend none
    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    dmns.admit(tj)
    assert_equal 7, tj.spending_money
    assert_equal 0, dmns.revenue
  end

  def test_it_can_admit_to_exhibits_in_price_range
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)
    bob = Patron.new("Bob", 10)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("IMAX")
    dmns.admit(bob)

    assert_equal 0, bob.spending_money
    assert_equal 10, dmns.revenue
  end

  def test_it_can_admit_most_expensive_exhibit_first
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)
    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX")
    sally.add_interest("Dead Sea Scrolls")
    dmns.admit(sally)

    assert_equal 5, sally.spending_money
    assert_equal 15, dmns.revenue
  end

  def test_it_admits_as_much_as_is_affordable_and_of_intertest
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)
    morgan = Patron.new("Morgan", 15)
    morgan.add_interest("Gems and Minerals")
    morgan.add_interest("Dead Sea Scrolls")
    dmns.admit(morgan)

    assert_equal 5, morgan.spending_money
    assert_equal 10, dmns.revenue
  end

  def test_it_can_list_patrons_of_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)
    morgan = Patron.new("Morgan", 15)
    morgan.add_interest("Gems and Minerals")
    morgan.add_interest("Dead Sea Scrolls")
    dmns.admit(morgan)
    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX")
    sally.add_interest("Dead Sea Scrolls")
    dmns.admit(sally)
    bob = Patron.new("Bob", 10)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("IMAX")
    dmns.admit(bob)

    expected =
        ({
          gems_and_minerals => [morgan],
          imax => [sally, bob],
          dead_sea_scrolls => [morgan, sally, bob]
        })
    assert_equal expected, dmns.patrons_of_exhibits
    assert_equal 35, dmns.revenue
  end
end
