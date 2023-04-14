class EmailController < ApplicationController
  def create
    sender_name = params[:name]
    sender_address = params[:email]
    msg_subject = params[:subject]
    msg_body = params[:body]

    return render response(400, 'Please include an email address.') if sender_address.blank?
    return render response(400, 'Please include a name.') if sender_name.blank?
    return render response(400, 'Please include a message body.') if msg_body.blank?

    unless validate_email(sender_address)
      return render response(400, "The provided email doesn't seem to be valid. If you think this error is a mistake, please let me know by emailing me directly at brinkman.spenser@gmail.com.")
    end

    # Return false success message to spam attempts
    return render response(200, 'Message successfully sent!') if SpamFilter.filter(msg_body)

    payload = generate_payload(sender_name, sender_address, msg_subject, msg_body)

    res = send_email(payload)

    if res['success']
      render response(200, 'Message successfully sent!')
    elsif res['error'].present?
      render response(400, res['error'])
    else
      render response(500, 'There was an error delivering your message. I would appreciate you bringing this to my attention by emailing me directly at brinkman.spenser@gmail.com.')
    end
  end

  private

  def validate_email(email)
    email.match?(/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/)
  end

  def response(status, message)
    {
      status:,
      json: { message: }
    }
  end

  def generate_payload(sender_name, sender_address, msg_subject, msg_body)
    {
      'from' => 'brinkmn.spenser@gmail.com',
      'fromName' => "#{sender_name} (via portfolio)",
      'replyTo' => sender_address,
      'msgTo' => ['brinkman.spenser@gmail.com'],
      'subject' => msg_subject.present? ? msg_subject : 'A message was sent via your portfolio',
      'body' => "The following message was sent via the contact form on <a href=\"spenserbrinkman.com\">spenserbrinkman.com</a>:<br><br><br>From: #{sender_name}<br>Email: #{sender_email}<br>Subject: #{msg_subject}<br><br>#{msg_body}",
      'apikey' => Rails.application.credentials.apikey
    }
  end

  def send_email(payload)
    url = 'https://api.elasticemail.com/v2/email/send'
    HTTParty.post(url, payload)
  end
end
