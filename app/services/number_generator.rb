class NumberGenerator
  def call
    SecureRandom.base58(12)
  end
end
