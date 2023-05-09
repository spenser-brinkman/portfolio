class SpamFilter
  SPAM_PHRASES = [
    'buy now',
    'best advertising',
    'earn money fast',
    'seo'
  ].freeze

  # Returns `true` if filter finds a blacklisted phrase in the provided message
  def self.filter(message)
    SPAM_PHRASES.any? { |phrase| message.downcase.include?(phrase) }
  end
end
