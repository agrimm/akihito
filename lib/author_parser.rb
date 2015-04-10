require 'author'

# Parse XML documents to create authors
class AuthorParser
  attr_reader :authors

  def initialize(document)
    @document = document

    @authors = create_authors
  end

  AUTHOR_XPATH = './/contrib-group/contrib/name'
  def create_authors
    author_name_nodes = @document.xpath(AUTHOR_XPATH)
    author_name_nodes.map(&method(:create_author))
  end

  SURNAME_XPATH = 'surname'
  GIVEN_NAMES_XPATH = 'given-names'
  def create_author(author_name_node)
    surname_node = author_name_node.at_xpath(SURNAME_XPATH)
    surname = surname_node.content
    given_names_node = author_name_node.at_xpath(GIVEN_NAMES_XPATH)
    given_names = given_names_node.nil? ? '' : given_names_node.content
    Author.new(surname, given_names)
  end
end
