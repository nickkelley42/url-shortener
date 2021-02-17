require 'net/http'
require 'uri'

class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validate :validate_full_url
  validates_presence_of :full_url

  def short_code
    return nil if new_record?

    # Build a string representing the id in base b, where b is 
    # the length of CHARACTERS; this is our short_code

    b = CHARACTERS.length
    remaining = id
    code = ""
    while remaining > 0
      code += CHARACTERS[remaining % b]
      remaining /= b
    end

    code.reverse
  end

  def update_title!
    url = URI(full_url)
    html = Net::HTTP.get(url)
    html.scan(/<title>(.*?)<\/title>/) do |new_title|
      update!(:title => new_title[0])
      break
    end
  end

  def self.find_by_short_code(sc)
    # Build the id from sc; this assumes that sc is the ID in base b,
    # where b is the length of CHARACTERS.
    # This is roughly O(L) time, where L is the length of sc.
    b = CHARACTERS.length
    power = 0
    url_id = 0
    
    sc.reverse.each_char do |c|
      url_id += CHARACTERS.find_index(c) * (b ** power)
      power += 1
    end

    self.find url_id
  end

  private

  def validate_full_url
    unless full_url =~ /\A#{URI::regexp(['http', 'https'])}\z/ 
      errors.add(:full_url, "is not a valid url")
    end
  end

end
