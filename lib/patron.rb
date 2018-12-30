class Patron
  attr_reader   :name,
                :interests
  attr_accessor :spending_money,
                :visited_exhibits

  def initialize(name, spending_money)
    @name = name
    @spending_money = spending_money
    @interests = []
    @visited_exhibits = []
  end

  def add_interest(name)
    @interests << name
  end

end
