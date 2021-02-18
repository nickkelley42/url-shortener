require 'rails_helper'

RSpec.describe IncrementClickCountJob, type: :job do
  include ActiveJob::TestHelper

  let(:short_url) { ShortUrl.create(full_url: "https://xkcd.com/74/") }
  let(:job) { IncrementClickCountJob.perform_later(short_url.id) }

  it "increments the click count" do
    expect(short_url.click_count).to eq(0) 
    perform_enqueued_jobs { job }
    short_url.reload
    expect(short_url.click_count).to eq(1)
  end
  
end
