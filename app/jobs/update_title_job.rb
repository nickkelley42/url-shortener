class UpdateTitleJob < ApplicationJob
  queue_as :default

  def perform(short_url_id)
    short_url = ShortUrl.find short_url_id
    short_url.update_title!
  end
end
