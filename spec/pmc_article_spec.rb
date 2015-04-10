require 'pmc_article'
require 'factory_girl'
require_relative './support/factory_girl'
require_relative './factories/pmc_article_factory'

RSpec.describe PMCArticle do
  let(:pmc_article) do
    build(:pmc_article)
  end

  it 'parses pmid' do
    expect(pmc_article.article_id_pmid).to eq '18234453'
  end

  it 'parses surnames' do
    # Avoid first author to make sure I'm not getting the first
    # author's details being put into every author
    author = pmc_article.authors[1]
    expect(author.surname).to eq 'Deloukas'
  end

  it 'parses given names' do
    author = pmc_article.authors[1]
    expect(author.given_names).to eq 'Panos'
  end

  it 'parses affiliation' do
    expect(pmc_article.aff).to eq \
      'Wellcome Trust Sanger Institute, Hinxton CB10 1SA Cambridge, UK'
  end

  it 'can determine an affiliation is with Japan' do
    expect(pmc_article).to_not be_affiliation_japanese
  end
end
