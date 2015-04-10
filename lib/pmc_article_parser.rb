require 'pmc_article'
require 'author_parser'
require 'nokogiri'
require 'forwardable'

# Parse XML documents to create PMC articles
class PMCArticleParser
  extend Forwardable

  attr_reader :pmc_article

  def_delegators :@author_parser, :authors

  def self.new_using_filename(filename)
    document = Nokogiri::XML(File.read(filename))
    new(document)
  end

  def initialize(document)
    @document = document

    @article_id_pmid = determine_article_id_pmid
    @aff = determine_aff
    @author_parser = create_author_parser
    @pmc_article = create_pmc_article
  end

  ARTICLE_ID_PMID_XPATH = './/article-id[contains(@pub-id-type, "pmid")]'
  def determine_article_id_pmid
    node = @document.at_xpath(ARTICLE_ID_PMID_XPATH)
    return '' if node.nil?
    node.content
  end

  AFF_XPATH = './/aff'
  def determine_aff
    node = @document.at_xpath(AFF_XPATH)
    return '' if node.nil?
    node.content
  end

  def create_author_parser
    AuthorParser.new(@document)
  end

  def create_pmc_article
    PMCArticle.new(@article_id_pmid, authors, @aff)
  end
end
