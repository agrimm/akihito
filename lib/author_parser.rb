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

  def create_author(author_name_node)
    surname = determine_surname(author_name_node)
    given_names = determine_given_names(author_name_node)
    Author.new(surname, given_names)
  end

  SURNAME_XPATH = 'surname'
  def determine_surname(author_name_node)
    surname_node = author_name_node.at_xpath(SURNAME_XPATH)
    surname_node.content
  end

  GIVEN_NAMES_XPATH = 'given-names'
  def determine_given_names(author_name_node)
    # People can have no given names, with no warning of that information.
    given_names_node = author_name_node.at_xpath(GIVEN_NAMES_XPATH)
    given_names_node.nil? ? '' : given_names_node.content
  end
end
