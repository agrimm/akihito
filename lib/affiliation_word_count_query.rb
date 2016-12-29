require 'pmc_article_list'

# Show how many words are in the affiliation
class AffiliationWordCountQuery
  def self.run
    pmc_article_list = PMCArticleList.new_using_config
    affiliation_word_count_query = new(pmc_article_list)
    affiliation_word_count_query.run
  end

  def initialize(pmc_article_list)
    @pmc_article_list = pmc_article_list

    @frequency = Hash.new(0)
    process_words
    @sorted_rows = determine_sorted_rows
    @output_text = determine_output_text
  end

  def process_words
    @pmc_article_list.pmc_articles.each do |article|
      @frequency[article.affiliation_words.count] += 1
    end
  end

  def rows
    @frequency.map do |affiliation_word_count, frequency|
      [affiliation_word_count, frequency]
    end
  end

  def determine_sorted_rows
    rows.sort_by do |affiliation_word_count, _frequency|
      affiliation_word_count
    end
  end

  def determine_output_text
    lines = @sorted_rows.map { |row| row.join("\t") }
    lines.join("\n")
  end

  def run
    File.write('affiliation_word_counts.txt', @output_text)
  end
end
