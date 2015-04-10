require 'factory_girl'
require_relative './support/factory_girl'
require_relative './factories/pmc_article_list_factory'
require 'frequent_names_runner'

require_relative './factories/pmc_article_list_factory'

RSpec.describe FrequentNamesRunner do
  let(:pmc_article_list) { build(:pmc_article_list) }

  it 'does not blow up' do
    FrequentNamesRunner.new(pmc_article_list)
  end
end
