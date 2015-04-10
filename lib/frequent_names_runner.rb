require 'pmc_article_list'
require 'frequent_names_query'

# Run queries about frequent names in both Japan and outside of Japan
class FrequentNamesRunner
  def self.run
    pmc_article_list = PMCArticleList.new_using_config
    frequent_names_runner = new(pmc_article_list)
    frequent_names_runner.run
  end

  def initialize(pmc_article_list)
    @pmc_article_list = pmc_article_list

    @frequent_names_japan_query = FrequentNamesJapanQuery.new(@pmc_article_list)
    @frequent_names_not_japan_query = FrequentNamesNotJapanQuery.new(@pmc_article_list)
    @queries = [@frequent_names_japan_query, @frequent_names_not_japan_query]
  end

  def run
    @queries.each(&:run)
  end
end
