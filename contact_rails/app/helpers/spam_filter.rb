class SpamFilter
  SPAM_PHRASES = [
    'buy now',
    'best advertising',
    'earn money fast'
  ].freeze

  # Returns `true` if filter finds a blacklisted phrase in the provided message
  def self.filter(message)
    SPAM_PHRASES.any? { |phrase| message.include?(phrase) }
  end
end
