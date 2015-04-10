require 'pmc_article_list'

# List words mentioned in affiliation information, and whether or not they're associated with Japan
class AffiliationWordsQuery
  def self.run
    pmc_article_list = PMCArticleList.new_using_config
    affiliation_words_query = new(pmc_article_list)
    affiliation_words_query.run
  end

  def initialize(pmc_article_list)
    @pmc_article_list = pmc_article_list

    @frequency = Hash.new(0)
    @japan_affiliation_frequency = Hash.new(0)
    @not_japan_affiliation_frequency = Hash.new(0)
    @unknown_affiliation_frequency = Hash.new(0)
    process_words
    @sorted_rows = determine_sorted_rows
    @output_text = determine_output_text
  end

  def process_words
    @pmc_article_list.pmc_articles.each do |article|
      article.affiliation_words.each do |word|
        process_word(word, article)
      end
    end
  end

  def process_word(word, article)
    downcased_word = word.downcase
    @frequency[downcased_word] += 1
    if article.affiliation_japanese?
      @japan_affiliation_frequency[downcased_word] += 1
    elsif article.affiliation_non_japanese?
      @not_japan_affiliation_frequency[downcased_word] += 1
    else
      @unknown_affiliation_frequency[downcased_word] += 1
    end
  end

  def rows
    @frequency.map do |word, frequency|
      japan_frequency = @japan_affiliation_frequency[word]
      not_japan_frequency = @not_japan_affiliation_frequency[word]
      unknown_frequency = @unknown_affiliation_frequency[word]
      [word, frequency, japan_frequency, not_japan_frequency, unknown_frequency]
    end
  end

  def relevant_rows
    rows.find_all do |_word, frequency, _japan_frequency, _not_japan_frequency, _unknown_frequency|
      frequency > 50
    end
  end

  def determine_sorted_rows
    relevant_rows.sort_by do |word, frequency, japan_frequency, _not_japan_frequency, unknown_frequency|
      proportion_unknown = unknown_frequency * 1.0 / frequency
      [proportion_unknown, frequency, -japan_frequency, word]
    end
  end

  def determine_output_text
    lines = @sorted_rows.map { |row| row.join("\t") }
    lines.join("\n")
  end

  def run
    File.write('affiliation_words.txt', @output_text)
  end
end
