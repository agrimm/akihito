# Query about frequent names
class FrequentNamesQuery
  def initialize(pmc_article_list)
    @pmc_article_list = pmc_article_list

    @name_frequency = determine_name_frequency
    @output_text = determine_output_text
  end

  def determine_name_frequency
    @pmc_article_list.pmc_articles.each_with_object(Hash.new(0)) do |pmc_article, result|
      next unless article_suitable?(pmc_article)
      pmc_article.names.each do |name|
        result[name.downcase] += 1
      end
    end
  end

  def determine_output_text
    sorted_frequency = @name_frequency.sort_by do |name, frequency|
      [-frequency, name]
    end
    lines = sorted_frequency.map do |name, frequency|
      [name, frequency].join("\t")
    end
    lines.join("\n")
  end

  def run
    File.write(output_filename, @output_text)
  end
end

# Query for frequent names in Japan
class FrequentNamesJapanQuery < FrequentNamesQuery
  def article_suitable?(pmc_article)
    pmc_article.affiliation_japanese?
  end

  def output_filename
    'frequent_names_japan.txt'
  end
end

# Query for frequent names outside of Japan
class FrequentNamesNotJapanQuery < FrequentNamesQuery
  def article_suitable?(pmc_article)
    !pmc_article.affiliation_japanese? &&
      pmc_article.affiliation_non_japanese?
  end

  def output_filename
    'frequent_names_not_japan.txt'
  end
end
