class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    @short_urls = ShortUrl.order(click_count: :desc).limit 100
    render json: { :urls => @short_urls.map { |s| s.public_attributes } }
  end

  def create
    begin
      @short_url = ShortUrl.create!(full_url: params[:full_url])
    rescue ActiveRecord::RecordInvalid
      render json: { :errors => "Full url is not a valid url" }, :status => :bad_request
    else
      UpdateTitleJob.perform_later(@short_url.id)
      render json: { :short_code => @short_url.short_code }
    end
  end

  def show
    begin
      @short_url = ShortUrl.find_by_short_code params[:id]
    rescue ActiveRecord::RecordNotFound
      render json: "Not found", :status => :not_found
    else 
      IncrementClickCountJob.perform_later(@short_url.id)
      redirect_to @short_url.full_url
    end
  end

  private

  def short_url_params
    params.require[:full_url]
  end
end
