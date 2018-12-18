require 'pry'

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

  def patrons_by_exhibit_interest
    # patrons_by_interest
    new_hash = {}
    patrons = []
    @exhibits.each do |exhibit|
      @patrons.find_all do |patron|
        # patron.interests.each do |interest|
          # binding.pry
         if patron.interests.include?(exhibit.name)
           patrons << patron
         else
           patrons
        end
        new_hash[exhibit] = patrons.uniq
      end
    end
    new_hash
  end

  # def patrons_by_interest
  #   patrons = []
  #   @patrons.find_all do |patron|
  #     patron.interests.each do |interest|
  #     if interest == exhibit.name
  #       patrons << patron
  #     end
  #   end
  #   patrons
  # end

end
# def patrons_by_exhibit_interest
#   new_hash = {}
#   patrons = []
#   @exhibits.each do |exhibit|
#     @patrons.each do |patron|
#       patron.interests.each do |interest|
#         if interest == exhibit.name
#           patrons << patron
#           new_hash[exhibit] = patrons.uniq
#         else
#           new_hash[exhibit] = []
#           binding.pry
#         end
#       end
#     end
#   end
#   new_hash
# end
