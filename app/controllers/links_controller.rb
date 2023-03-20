class LinksController < ApplicationController
  before_action :authorize_request

  def encode
    @link = Link.find_by(url: url)

    if (@link.present?)
      render json: { url: @link.url, encoded: @link.shorter_url }, status: :ok
      return
    end

    service = LinkService.new(url: url)
    if (service.shorten)
      render json: { url: service.results[:url], encoded: service.results[:shorter_url] }, status: :ok
    else
      render json: { errors: service.errors.messages }, status: :unprocessable_entity
    end
  end

  def decode
    @link = Link.find_by(shorter_url: url)
    
    if (@link.present?)
      render json: { url: @link.shorter_url, decoded: @link.url }, status: :ok
    else
      render json: { errors: { base: 'Url not found' } }, status: :not_found
    end
  end

  private

  def url
    @_url ||= params[:url]
  end
end