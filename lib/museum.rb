require 'pry'

class Museum
  attr_reader   :name,
                :exhibits,
                :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
    @revenue = 0
  end

  def add_exhibit(name)
    @exhibits << name
  end

  def interested_patrons(exhibit)
    @patrons.find_all do |patron|
      patron.interests.include?(exhibit.name)
    end
  end

  def find_affordable_exhibits(name)
    @exhibits.reverse.find_all do |exhibit|
      name.spending_money >= exhibit.cost
    end
  end

  def recommend_exhibits(patron)
    exhibits = find_affordable_exhibits(patron)
    exhibits.find_all do |exhibit|
      patron.interests.include?(exhibit.name)
    end
  end

  def admit_exhibits(name)
    exhibits = recommend_exhibits(name)
    exhibits.reverse.each do |exhibit|
      if name.spending_money >= exhibit.cost
        name.spending_money -= exhibit.cost
        @revenue += exhibit.cost
        name.visited_exhibits << exhibit.name
      end
    end
  end

  def admit(name)
    admit_exhibits(name)
    @patrons << name
  end

  def patrons_of_exhibits
    new_hash = {}
    @exhibits.each do |exhibit|
      patrons = interested_patrons(exhibit)
        new_hash[exhibit] = patrons.uniq
      end
      new_hash
    end

    def revenue
      @revenue
    end

end
