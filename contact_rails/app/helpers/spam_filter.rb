class SpamFilter
  SPAM_PHRASES = [
    'buy now',
    'best advertising',
    'earn money fast',
    'seo',
    'webmaster',
    'capital',
    'invest',
    'promote',
    'entrepreneur',
    'free',
    'price'
  ].freeze

  BLACKLIST = [
    'RobertDip'
  ]

  # Returns `true` if filter finds a blacklisted phrase in the provided message
  def self.message_filter(message)
    SPAM_PHRASES.any? { |phrase| message.downcase.include?(phrase) }
  end

  def self.sender_filter(sender)
    BLACKLIST.any? { |name| sender.downcase.include?(name) }
  end
end
