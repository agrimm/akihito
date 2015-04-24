require 'pmc_article'
require 'pmc_article_parser'

FactoryGirl.define do
  factory :pmc_article, class: PMCArticle do
    pmc_article_parser PMCArticleParser.new_using_filename('../data_akihito/Gene/Gene_2008_Feb_29_410(1-2)_165-176.nxml')
    initialize_with do
      pmc_article_parser.pmc_article
    end
  end
end
