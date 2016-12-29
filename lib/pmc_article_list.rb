require 'pmc_article_parser'

# A list of PMC articles
class PMCArticleList
  attr_reader :pmc_articles

  def self.new_using_config
    filenames = Dir.glob('../data_akihito/pubmed_central/**/*.nxml')
    new(filenames)
  end

  def initialize(filenames)
    @filenames = filenames

    @pmc_articles = create_pmc_articles
  end

  def create_pmc_articles
    @filenames.map(&method(:create_pmc_article))
  end

  def create_pmc_article(filename)
    pmc_article_parser = PMCArticleParser.new_using_filename(filename)
    pmc_article_parser.pmc_article
  end
end
