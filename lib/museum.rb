class Museum
  attr_reader   :name,
                :exhibits,
                :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(name)
    @exhibits << name
  end

  def recommend_exhibits(name)
    admit(name)
    recommendations = []
    @exhibits.each do |exhibit|
      @patrons.each do |patron|
        patron.interests.each do |interest|
          if interest == exhibit.name
            recommendations << exhibit
          end
        end
      end
    end
    recommendations
  end

  def admit(name)
    @patrons << name
  end
end
