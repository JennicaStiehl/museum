require './lib/exhibit'
require './lib/patron'

class ExhibitTest < Minitest::Test

  def test_it_exists
    exhibit = Exhibit.new("Gems and Minerals", 0)
    assert_instance_of Exhibit, exhibit
  end
end
