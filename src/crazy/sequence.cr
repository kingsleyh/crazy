module Sequences
  class WrongTypeException < Exception
  end

  class NoSuchElementException < Exception
  end

  class Sequence(T)
    include Indexable(T)

    getter iterator : Iterator(T)

    def initialize(@iterator : Iterator(T))
    end

    def self.sequence(*items)
      if items.first.nil?
        Sequence(T).empty
      else
        raise WrongTypeException.new("You specified: Sequence(#{T.inspect}) but supplied a sequence of type: #{typeof(items.first)}") unless items.first.is_a?(T)
        Sequence.new(items.to_a.each)
      end
    end

    def self.empty
      Sequence.new(([] of T).each)
    end

    def map(proc)
      Sequence.new(_iterator.unsafe_as(ItemIterator(Array(T), T)).map { |v| proc.call(v) }.as(Iterator(T)))
    end

    def map(&block : T -> _)
      Sequence.new(_iterator.unsafe_as(ItemIterator(Array(T), T)).map { |v| block.call(v) }.as(Iterator(T)))
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
      Sequence.new(_iterator.unsafe_as(ItemIterator(Array(T), T)).skip(1))
    end

    def init
      reverse.tail.reverse
    end

    def unsafe_at(index : Int)
      nil
    end

    def to_a
      _iterator.to_a
    end

    private def has_next?(it)
      !it.next.is_a?(Iterator::Stop)
    end

    private def _iterator
      @iterator.dup
    end
  end
end
