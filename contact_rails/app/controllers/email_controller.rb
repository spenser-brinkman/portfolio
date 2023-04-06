require 'net/http'
require 'uri'
require 'json'

class EmailController < ApplicationController
  def create
    sender_name = params[:name]
    sender_email = params[:email]
    msg_subject = params[:subject]
    msg_body = params[:body]

    return render json: { message: 'Please include an email address with your message.' }, status: :bad_request if sender_email.blank?
    return render json: { message: 'Please include a name with your message.' }, status: :bad_request if sender_name.blank?
    return render json: { message: 'Please include a body for your message.' }, status: :bad_request if msg_body.blank?

    unless sender_email.match?(/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/)
      return render status: :bad_request,
                    json: { message: 'The provided email doesn\'t seem to be valid. If you think this error is a mistake, please let me know by emailing me directly at brinkman.spenser@gmail.com.' }
    end

    payload = {
      'from' => 'brinkman.spenser@gmail.com',
      'fromName' => "#{sender_name} (via portfolio)",
      'replyTo' => sender_email,
      'msgTo' => ['brinkman.spenser@gmail.com'],
      'subject' => msg_subject || 'A message was sent via your portfolio',
      'body' => "The following message was sent via the contact form on <a href=\"spenserbrinkman.com\">spenserbrinkman.com</a>:<br><br><br>From: #{sender_name}<br>Email: #{sender_email}<br>Subject: #{msg_subject}<br><br>#{msg_body}",
      'apikey' => Rails.application.credentials.apikey
    }

    uri = URI.parse('https://api.elasticemail.com/v2/email/send')
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(payload)

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if (response.body.include? 'success') && (response.body['success'] == false)
      render status: :bad_request,
             json: { message: response.body['error'] }
    elsif response.is_a?(Net::HTTPSuccess)
      render status: :ok,
             json: { message: 'Message successfully sent!' }
    else
      render status: 500,
             json: { message: 'There was an error delivering your message. I would appreciate you bringing this to my attention by emailing me directly at brinkman.spenser@gmail.com.' }
    end
  end
end
