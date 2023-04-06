require 'net/http'
require 'uri'
require 'json'

class EmailController < ApplicationController
  def create
    sender_name = params[:name]
    sender_email = params[:email]
    msg_subject = params[:subject]
    msg_body = params[:body]

    if sender_email.blank? || sender_name.blank? || msg_body.blank?
      return render json: { status: 'failure' }, status: :bad_request
    end

    payload = {
      'from' => 'brinkman.spenser@gmail.com',
      'fromName' => sender_name
      'replyTo' => sender_email,
      'msgTo' => ['brinkman.spenser@gmail.com'],
      'subject' => msg_subject || 'A message was sent via your portfolio',
      'body' => "From: #{sender_name}<br>Email: #{sender_email}<br>Subject: #{msg_subject}<br><br>#{msg_body}",
      'apikey' => Rails.application.credentials.apikey
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
