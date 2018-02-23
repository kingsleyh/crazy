require "spec"
require "../src/crazy"

module Spec
  struct HaveExpectation(Sequence)
    def initialize(@expected_sequence : Sequence)
    end

    def match(actual_value)
      actual_value.to_a == @expected_sequence.to_a
    end

    def failure_message(actual_value)
      "Expected:   #{actual_value.to_a.inspect}\nto equal: #{@expected_sequence.to_a.inspect}"
    end

    def negative_failure_message(actual_value)
      "Expected: value #{actual_value.to_a.inspect}\nto not equal: #{@expected_sequence.to_a.inspect}"
    end
  end

  module Expectations
    def have(value)
      HaveExpectation.new value
    end
  end
end
