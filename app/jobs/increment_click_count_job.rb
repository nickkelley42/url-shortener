class IncrementClickCountJob < ApplicationJob
  queue_as :default

  def perform(short_url_id)
    short_url = ShortUrl.find short_url_id
    short_url.click_count += 1
    short_url.save
  end
end
