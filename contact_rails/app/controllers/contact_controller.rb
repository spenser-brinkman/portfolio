require 'net/http'
require 'uri'
require 'json'

class ContactController < ApplicationController
  def send_email
    payload = {
      'from' => params[:email],
      'fromName' => params[:name],
      'to' => 'bob@example.com',
      'subject' => params[:subject],
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
