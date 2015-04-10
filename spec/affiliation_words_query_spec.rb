require 'factory_girl'
require_relative './support/factory_girl'
require_relative './factories/pmc_article_list_factory'
require 'affiliation_words_query'

RSpec.describe AffiliationWordsQuery do
  let(:pmc_article_list) { build(:pmc_article_list) }

  it 'does not blow up' do
    AffiliationWordsQuery.new(pmc_article_list)
  end
end
