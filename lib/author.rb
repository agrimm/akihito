# Author of an article
class Author
  attr_reader :surname, :given_names

  def initialize(surname, given_names)
    @surname = surname
    @given_names = given_names
  end

  def names
    [@surname, @given_names]
  end
end
