require 'net/http'
require 'uri'
require 'json'

class EmailController < ApplicationController
  def create
    if params[:email].blank? || params[:name].blank? || params[:body].blank?
      return render json: { status: 'failure' }, status: :bad_request
    end

    payload = {
      'from' => params[:email],
      'fromName' => params[:name],
      'msgTo' => ['brinkman.spenser@gmail.com'],
      'subject' => params[:subject] || 'A message was sent via your portfolio',
      'body' => params[:body],
      'apikey' => Rails.application.credentials.apikey,
    }

    uri = URI.parse('https://api.elasticemail.com/v2/email/send')
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(payload)

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      render json: { status: 'success' }, status: :ok
    else
      render json: { status: 'failure' }, status: :bad_request
    end
  end
end
