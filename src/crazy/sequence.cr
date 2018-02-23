class NoSuchElementException < Exception
end

module Sequences
  def sequence(*items)
    Sequence.sequence(*items)
  end

  def empty
    Sequence.empty
  end

  class Sequence(T)
    getter iterator

    # macro define_map(klass)
    #   def map(&block : {{klass}} -> _)
    #     Sequence.new(_iterator.map{|v| block.call(v.unsafe_as({{klass}}))})
    #   end
    # end
    #
    # define_map(Int32)

    def initialize(@iterator : T)
      # p "intialized with #{typeof(@iterator)}"
      # raise "Sequence only accepts Iterator" unless
    end

    def self.sequence(*items)
      if items.first.nil?
        EMPTY
      else
        Sequence.new(items.each)
      end
    end

    def self.empty
      EMPTY
    end

    def head
      _iterator.first
    end

    def first
      _iterator.first
    end

    def last
      _iterator.to_a.last
    end

    def reverse
      Sequence.new(_iterator.to_a.reverse.each)
    end

    def tail
      unless has_next?(_iterator)
        raise NoSuchElementException.new
      end
      Sequence.new(_iterator.skip(1))
    end

    def init
      reverse.tail.reverse
    end

    def map(klass, proc)
      Sequence.new(_iterator.map { |v| proc.call(v.unsafe_as(klass)) })
    end

    def fold(klass, seed, proc)
      _iterator.reduce(seed){|accumulator, value| proc.call(value.unsafe_as(klass), accumulator.unsafe_as(klass)) }
    end

    # def map1(&block : T -> _)
    #   Sequence.new(_iterator.map{|v| block.call(v)})
    # end

    # def foo(klass, proc)
    #   # myArray : Array(Int32) = [1,2,3,4,5]
    #   # myArray2 : Array(Int32) = _iterator.to_a.unsafe_as(Array(Int32))
    #   # p typeof(_iterator.to_a)
    #   # p typeof(myArray2)
    #   # myArray2.map{|v| block.call v}
    #    # _iterator.map{|v| block.call v}
    #   # _iterator.map{|v| block.call v}
    #
    #   Sequence.new(_iterator.map do |v|
    #     # p typeof(v)
    #     # p v.class
    #
    #     proc.call(v.unsafe_as(klass))
    #   end)
    # end

    # def foo(klass, proc)
    #   myArray = [1,2,3,4,5]
    #   myArray.each.map{|v| proc.call(v.unsafe_as(klass))}
    # end

    # def map(klass, &block : klass -> _)
    #   Sequence.new(_iterator.map{|v| block.call(v.unsafe_as(klass))})
    # end

    def to_a
      _iterator.to_a
    end

    private def _iterator
      @iterator.dup
    end

    private def has_next?(it)
      !it.next.is_a?(Iterator::Stop)
    end
  end
end

EMPTY = Sequence.new(([] of String).each)
