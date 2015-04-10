require 'pmc_article_list'

# Find examples of people with Japanese names but with non-Japanese affiliations
class MisplacedResearchersQuery
  def self.run
    pmc_article_list = PMCArticleList.new_using_config
    misplaced_researcher_query = new(pmc_article_list)
    misplaced_researcher_query.run
  end

  def initialize(pmc_article_list)
    @pmc_article_list = pmc_article_list

    @misplaced_researcher_articles = determine_misplaced_researcher_articles
  end

  def determine_misplaced_researcher_articles
    @pmc_article_list.pmc_articles.find_all(&method(:misplaced_researcher_article?))
  end

  def misplaced_researcher_article?(article)
    article.names.include?('Takashi') &&
      article.affiliation_non_japanese?
  end

  def run
    @misplaced_researcher_articles.each do |article|
      puts article.article_id_pmid
      puts article.names.inspect
      puts article.aff
    end
  end
end
