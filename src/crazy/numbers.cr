struct Numbers(T)
  def self.sum
    ->(a : T, b : T) { a + b }
  end

  def self.multiply(number)
    ->(v : T) { v * number }
  end

  def self.even?
    remainder_is(2, 0)
  end

  def self.remainder_is(divisor, remainder)
    ->(dividend : T) { remainder(dividend, divisor) == remainder }
  end

  def self.remainder(dividend, divisor)
    dividend % divisor
  end
end
