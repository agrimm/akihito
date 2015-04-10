require 'set'

# PMC article
class PMCArticle
  attr_reader :article_id_pmid, :authors, :aff

  def initialize(article_id_pmid, authors, aff)
    @article_id_pmid = article_id_pmid
    @authors = authors
    @aff = aff
  end

  JAPAN_STRING = 'Japan'
  def affiliation_japanese?
    @aff.include?(JAPAN_STRING)
  end

  NON_JAPAN_WORDS = Set.new(%w(
    saudi ireland singapore columbia mexico portugal finland norway denmark israel austria greece taiwan poland belgium
    turkey iran switzerland korea spain brazil india australia france italy nigeria netherlands germany sweden china
    canada africa tunisia zealand
    usa
    morocco qatar thailand malaysia georgia sri
    uk colombia russia pakistan egypt czech england wales
    argentina hungary kuwait slovenia romania serbia brasil chile kingdom lebanon scotland salvador
    states russian hong
    nebraska maryland kentucky minnesota texas alberta illinois carolina tennessee california indiana oregon kansas
    ohio pennsylvania connecticut arizona atlanta washington
    bangladesh ukraine emirates indies bulgaria indonesia lithuania kenya vietnam luxembourg jordan
    iowa utah ontario massachusetts alabama
    croatia louisiana colorado michigan mississippi florida virginia arkansas jersey dakota
    rhode
  ))
  NON_JAPAN_WORDS_INCLUDE = NON_JAPAN_WORDS.method(:include?)
  def affiliation_non_japanese?
    affiliation_words.map(&:downcase).any?(&NON_JAPAN_WORDS_INCLUDE)
  end

  def surnames
    @authors.map(&:surname)
  end

  def given_names_list
    @authors.map(&:given_names)
  end

  def names
    @authors.flat_map(&:names)
  end

  def affiliation_words
    @aff.split(/[.,; \n\t\(\)]/).reject(&:empty?)
  end
end
