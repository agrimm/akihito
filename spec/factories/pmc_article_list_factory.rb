require 'pmc_article_list'

FactoryGirl.define do
  factory :pmc_article_list, class: PMCArticleList do
    filenames ['../data_akihito/Gene/Gene_2008_Feb_29_410(1-2)_165-176.nxml']
    initialize_with { new(filenames) }
  end
end
