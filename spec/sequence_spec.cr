require "./spec_helper"

describe Sequence do

  # it "deal with ranges" do
  #   p (1..Float32::INFINITY).each
  # end

  it "should create empty sequence when iterable is nil" do
    Sequence(Int32).sequence(nil).should have(Sequence(Int32).empty)
  end

  it "should support head / first" do
    Sequence(Int32).sequence(1, 2).head.should eq(1)
    Sequence(Int32).sequence(1, 2).first.should eq(1)
  end

  it "should return same result when head called many times" do
    s = Sequence(Int32).sequence(1, 2)
    s.head.should eq(1)
    s.head.should eq(1)
  end

  #   it 'should support head_option' do
  #   expect(sequence(1).head_option).to eq(some(1))
  #   expect(empty.head_option).to eq(none)
  # end
  #
  it "should support reverse" do
    Sequence(Int32).sequence(1, 2, 3).reverse.should have(Sequence(Int32).sequence(3, 2, 1))
  end

  it "should support last" do
    Sequence(Int32).sequence(1, 2, 3).last.should eq(3)
  end

  # it 'should support last_option' do
  #   expect(sequence(1, 2, 3).last_option).to eq(some(3))
  #   expect(empty.last_option).to eq(none)
  # end
  #
  it "should support tail" do
    Sequence(Int32).sequence(1, 2, 3).tail.should have(Sequence(Int32).sequence(2, 3))
  end

  # it 'should lazily return tail' do
  #   expect(Sequence.new((1..Float::INFINITY).lazy).tail.head).to eq(2)
  #   expect(range_from(100).tail.head).to eq(101)
  # end
  #
  it "should return empty tail on sequence with 1 item" do
    Sequence(Int32).sequence(1).tail.should have(Sequence(Int32).empty)
  end

  it "should raise NoSuchElementException when getting a tail of empty" do
    expect_raises(NoSuchElementException) do
      Sequence(Int32).empty.tail
    end
  end

  it "should support init" do
    Sequence(Int32).sequence(1, 2, 3).init.should have(Sequence(Int32).sequence(1, 2))
  end

  it "should raise NoSuchElementException when getting init of an empty" do
    expect_raises(NoSuchElementException) do
      Sequence(Int32).empty.init
    end
  end

  it "should support map" do
    Sequence(Int32).sequence(1, 2, 3).map(Numbers(Int32).multiply(2)).should have(Sequence(Int32).sequence(2, 4, 6))
    Sequence(Int32).sequence(1, 2, 3).map { |v| v * 2 }.should have(Sequence(Int32).sequence(2, 4, 6))
  end


  # it "should ensure map is lazy" do
  #   result = Sequence(Int32).sequence(returns(1), call_raises(RuntimeError.new)).map(call_fn)
  #   expect(result.head).to eq(1)
  # end
  #
  it "should support filter" do
    Sequence(Int32).sequence(1, 2, 3, 4).filter(Numbers(Int32).even?).should have(Sequence(Int32).sequence(2, 4))
    Sequence(Int32).sequence(1, 2, 3, 4).filter { |value| value % 2 == 0 }.should have(Sequence(Int32).sequence(2, 4))
  end
  #
  # it 'should ensure filter is lazy' do
  #   result = sequence(returns(1), returns(2), call_raises(RuntimeError.new)).map(call_fn).filter(even)
  #   expect(result.head).to eq(2)
  # end
  #
  # it 'should support composite predicates' do
  #   expect(sequence(1, 2, 3, 4).filter(is_not(even))).to eq(sequence(1, 3))
  # end
  #
  it "should support reject" do
    Sequence(Int32).sequence(1, 2, 3, 4).reject(Numbers(Int32).even?).should have(Sequence(Int32).sequence(1, 3))
    Sequence(Int32).sequence(1, 2, 3, 4).reject { |value| value % 2 == 0 }.should have(Sequence(Int32).sequence(1, 3))
  end

  it "should support fold (aka fold_left)" do
    Sequence(Int32).sequence(1, 2, 3).fold(0, Numbers(Int32).sum).should eq(6)
    # expect(sequence(1, 2, 3).fold(0) { |a, b| a + b }).to eq(6)
    # expect(sequence(1, 2, 3).fold_left(0, sum)).to eq(6)
    # expect(sequence(1, 2, 3).fold_left(0) { |a, b| a + b }).to eq(6)
    # expect(sequence('1', '2', '3').fold(0, join)).to eq('0123')
    # expect(sequence('1', '2', '3').fold_left(0, join)).to eq('0123')
  end

  # it 'should support reduce (aka reduce_left)' do
  #   expect(sequence(1, 2, 3).reduce(sum)).to eq(6)
  #   expect(sequence(1, 2, 3).reduce { |a, b| a + b }).to eq(6)
  #   expect(sequence(1, 2, 3).reduce_left(sum)).to eq(6)
  #   expect(sequence(1, 2, 3).reduce_left { |a, b| a + b }).to eq(6)
  #   expect(sequence('1', '2', '3').reduce(join)).to eq('123')
  #   expect(sequence('1', '2', '3').reduce_left(join)).to eq('123')
  # end
  #
  # it 'should support reduce of empty sequence' do
  #   expect(empty.reduce(sum)).to eq(0)
  # end
  #
  # it 'should support fold_right' do
  #   expect(empty.fold_right(4, sum)).to eq(4)
  #   expect(sequence(1).fold_right(4, sum)).to eq(5)
  #   expect(sequence(1, 2).fold_right(4, sum)).to eq(7)
  #   expect(sequence(1, 2, 3).fold_right(4, sum)).to eq(10)
  #   expect(sequence(1, 2, 3).fold_right(4) { |a, b| a + b }).to eq(10)
  #   expect(empty.fold_right('4', join)).to eq('4')
  #   expect(sequence('1').fold_right('4', join)).to eq('14')
  #   expect(sequence('1', '2').fold_right('4', join)).to eq('124')
  #   expect(sequence('1', '2', '3').fold_right('4', join)).to eq('1234')
  # end
  #
  # it 'should support reduce_right' do
  #   expect(empty.reduce_right(sum)).to eq(0)
  #   expect(sequence(1).reduce_right(sum)).to eq(1)
  #   expect(sequence(1, 2).reduce_right(sum)).to eq(3)
  #   expect(sequence(1, 2, 3).reduce_right(sum)).to eq(6)
  #   expect(sequence(1, 2, 3).reduce_right { |a, b| a+b }).to eq(6)
  #   expect(empty.reduce_right(join)).to eq('')
  #   expect(sequence('1').reduce_right(join)).to eq('1')
  #   expect(sequence('1', '2').reduce_right(join)).to eq('12')
  #   expect(sequence('1', '2', '3').reduce_right(join)).to eq('123')
  # end
  #
  # it 'should support find' do
  #   expect(empty.find(even)).to eq(none)
  #   expect(sequence(1, 3, 5).find(even)).to eq(none)
  #   expect(sequence(1, 2, 3).find(even)).to eq(some(2))
  #   expect(sequence(1, 2, 3).find { |value| even.(value) }).to eq(some(2))
  # end
  #
  # it 'should support find_index_of' do
  #   expect(sequence(1, 3, 5).find_index_of(even)).to eq(none)
  #   expect(sequence(1, 3, 6).find_index_of(even)).to eq(some(2))
  #   expect(sequence(1, 3, 6).find_index_of { |value| even.(value) }).to eq(some(2))
  # end
  #
  # it 'should support finding the first some' do
  #   expect(sequence(none, some(2), some(3)).flat_map(identity).head_option).to eq(some(2))
  # end
  #
  # it 'should support zip_with_index' do
  #   expect(sequence('Dan', 'Kings', 'Raymond').zip_with_index).to eq(sequence(pair(0, 'Dan'), pair(1, 'Kings'), pair(2, 'Raymond')))
  # end
  #
  # it 'should support zip' do
  #   sequence = sequence(1, 3, 5)
  #   expect(sequence.zip(sequence(2, 4, 6, 8))).to eq(sequence(pair(1, 2), pair(3, 4), pair(5, 6)))
  #   expect(sequence.zip(sequence(2, 4, 6))).to eq(sequence(pair(1, 2), pair(3, 4), pair(5, 6)))
  #   expect(sequence.zip(sequence(2, 4))).to eq(sequence(pair(1, 2), pair(3, 4)))
  # end
  #
  # it 'should support take' do
  #   sequence = sequence(1, 2, 3).take(2)
  #   expect(sequence).to eq(sequence(1, 2))
  #   expect(sequence(1).take(2)).to eq(sequence(1))
  #   expect(empty.take(2)).to eq(empty)
  # end
  #
  # it 'should not take more than it needs' do
  #   sequence = repeat_fn(-> { raise RuntimeError }).take(0)
  #   expect(sequence.is_empty?).to eq(true)
  #   expect(sequence.size).to eq(0)
  # end
  #
  # it 'should support take_while' do
  #   sequence = sequence(1, 3, 5, 6, 8, 1, 3)
  #   expect(sequence.take_while(odd)).to eq(sequence(1, 3, 5))
  #   expect(sequence.take_while { |value| odd.(value) }).to eq(sequence(1, 3, 5))
  #   expect(sequence(1).take_while(odd)).to eq(sequence(1))
  #   expect(empty.take_while(odd)).to eq(empty)
  # end
  #
  #
  # it 'should support size' do
  #   expect(range(10000000000, 10000000099).size).to eq(100)
  # end
  #
  # it 'should support repeat' do
  #   expect(repeat(10).take(5)).to eq(sequence(10, 10, 10, 10, 10))
  #   expect(repeat_fn(returns(20)).take(5)).to eq(sequence(20, 20, 20, 20, 20))
  # end
  #
  # it 'should support is_empty?' do
  #   expect(empty.is_empty?).to be(true)
  #   expect(sequence(1).is_empty?).to be(false)
  # end
  #
  # it 'should support flat_map' do
  #   expect(sequence('Hello').flat_map(to_characters)).to eq(sequence('H', 'e', 'l', 'l', 'o'))
  #   expect(sequence(sequence(1, 2), sequence(3, 4)).flat_map { |s| s.map { |v| v+1 } }).to eq(sequence(2, 3, 4, 5))
  #   expect(sequence(sequence(1, 2), sequence(3, 4)).flat_map { |s| s }).to eq(sequence(1, 2, 3, 4))
  #   expect(sequence(pair(1, 2), pair(3, 4)).flat_map { |s| s }).to eq(sequence(1, 2, 3, 4))
  #   expect(sequence(some(1), none, some(2)).flat_map { |s| s }).to eq(sequence(1, 2))
  # end
  #
  # it 'should support flatten' do
  #   expect(sequence('Hello').map(to_characters).flatten).to eq(sequence('H', 'e', 'l', 'l', 'o'))
  #   expect(sequence(some(1), none, some(3)).flatten).to eq(sequence(1, 3))
  #   expect(sequence(sequence(1)).flatten).to eq(sequence(1))
  # end
  #
  # it 'should allow flattening multiple times' do
  #   sequence = sequence(sequence('1', '2'), empty, sequence('4', '5'))
  #   expect(sequence.flatten).to eq(sequence('1', '2', '4', '5'))
  #   expect(sequence.flatten).to eq(sequence('1', '2', '4', '5'))
  # end
  #
  # it 'should support drop' do
  #   expect(sequence(1, 2, 3).drop(2)).to eq(sequence(3))
  #   expect(sequence(1).drop(2)).to eq(empty)
  #   expect(empty.drop(1)).to eq(empty)
  # end
  #
  # it 'should support drop_while' do
  #   sequence = sequence(1, 3, 5, 6, 8, 1, 3)
  #   expect(sequence.drop_while(odd)).to eq(sequence(6, 8, 1, 3))
  #   expect(sequence.drop_while { |value| odd.(value) }).to eq(sequence(6, 8, 1, 3))
  #   expect(sequence(1).drop_while(odd)).to eq(empty)
  #   expect(empty.drop_while(odd)).to eq(empty)
  # end
  #
  # it 'should support sort' do
  #   expect(sort(sequence(5, 6, 1, 3, 4, 2))).to eq(sequence(1, 2, 3, 4, 5, 6))
  #   expect(sort(sequence('Matt', 'Dan', 'Bob'))).to eq(sequence('Bob', 'Dan', 'Matt'))
  # end
  #
  # it 'should support sort descending' do
  #   expect(sort(sequence(5, 6, 1, 3, 4, 2), descending)).to eq(sequence(6, 5, 4, 3, 2, 1))
  #   expect(sequence(5, 6, 1, 3, 4, 2).sort_by(descending)).to eq(sequence(6, 5, 4, 3, 2, 1))
  #   expect(sort(sequence('Bob', 'Dan', 'Matt'), descending)).to eq(sequence('Matt', 'Dan', 'Bob'))
  #   expect(sequence('Bob', 'Dan', 'Matt').sort_by(descending)).to eq(sequence('Matt', 'Dan', 'Bob'))
  # end
  #
  # it 'should support contains' do
  #   expect(sequence(1, 3, 5).contains?(2)).to eq(false)
  #   expect(sequence(1, 2, 3).contains?(2)).to eq(true)
  # end
  #
  # it 'should support exists' do
  #   expect(sequence(1, 3, 5).exists?(even)).to eq(false)
  #   expect(sequence(1, 3, 5).exists? { |value| even.(value) }).to eq(false)
  #   expect(sequence(1, 2, 3).exists?(even)).to eq(true)
  # end
  #
  # it 'should support for_all' do
  #   expect(sequence(1, 3, 5).for_all?(odd)).to eq(true)
  #   expect(sequence(1, 3, 5).for_all? { |value| odd.(value) }).to eq(true)
  #   expect(sequence(1, 2, 3).for_all?(odd)).to eq(false)
  # end
  #
  # it 'should support group_by and preserve order' do
  #   groups_fn = sequence(1, 2, 3, 4).group_by(mod(2))
  #   expect(groups_fn.first).to eq(group(1, sequence(1, 3).enumerator))
  #   expect(groups_fn.second).to eq(group(0, sequence(2, 4).enumerator))
  #
  #   groups_block = sequence(1, 2, 3, 4).group_by { |value| mod(2).(value) }
  #   expect(groups_block.first).to eq(group(1, sequence(1, 3).enumerator))
  #   expect(groups_block.second).to eq(group(0, sequence(2, 4).enumerator))
  # end
  #
  # it 'should support each' do
  #   sum = 0
  #   sequence(1, 2).each(->(value) { sum = sum + value })
  #   expect(sum).to eq(3)
  #
  #   sequence(3, 4).each { |value| sum = sum + value }
  #   expect(sum).to eq(10)
  # end
  #
  # it 'should support map_concurrently' do
  #   strings = sequence(1, 2).map_concurrently(to_string)
  #   expect(strings).to eq(sequence('1', '2'))
  #
  #   strings_block = sequence(1, 2).map_concurrently { |value| to_string.(value) }
  #   expect(strings_block).to eq(sequence('1', '2'))
  # end
  #
  # it 'should allow arrays to be converted to sequences' do
  #   expect([1, 2, 3, 4, 5].to_seq).to eq(sequence(1, 2, 3, 4, 5))
  # end
  #
  # it 'should allow sequences to be converted to arrays' do
  #   expect(sequence(1, 2, 3, 4, 5).to_a).to eq([1, 2, 3, 4, 5])
  # end
  #
  # it 'should be able to display sequence as a string' do
  #   expect(sequence(1, 2, 3, 4, 5).to_s).to eq('[1,2,3,4,5]')
  #   expect(empty.to_s).to eq('[]')
  #   expect(sequence(sequence(1)).flatten.to_s).to eq('[1]')
  # end
  #
  # it 'should support join' do
  #   expect(sequence(1, 2, 3).join(sequence(4, 5, 6))).to eq(sequence(1, 2, 3, 4, 5, 6))
  # end
  #
  # it 'should support cycle' do
  #   expect(range(1, 3).cycle.take(10)).to eq(sequence(1, 2, 3, 1, 2, 3, 1, 2, 3, 1))
  # end
  #
  # it 'should raise exception if you try to use both lambda and block' do
  #   expect { empty.map(->(a) { a+1 }) { |b| b+2 } }.to raise_error(RuntimeError)
  #   expect { empty.map_concurrently(->(a) { a+1 }) { |b| b+2 } }.to raise_error(RuntimeError)
  #   expect { empty.flat_map(->(a) { a+1 }) { |b| b+2 } }.to raise_error(RuntimeError)
  #   expect { empty.fold(0, ->(a, b) { a+b }) { |a, b| a+b } }.to raise_error(RuntimeError)
  #   expect { empty.fold_left(0, ->(a, b) { a+b }) { |a, b| a+b } }.to raise_error(RuntimeError)
  #   expect { empty.fold_right(0, ->(a, b) { a+b }) { |a, b| a+b } }.to raise_error(RuntimeError)
  #   expect { empty.reduce(->(a, b) { a+b }) { |a, b| a+b } }.to raise_error(RuntimeError)
  #   expect { empty.reduce_left(->(a, b) { a+b }) { |a, b| a+b } }.to raise_error(RuntimeError)
  #   expect { empty.reduce_right(->(a, b) { a+b }) { |a, b| a+b } }.to raise_error(RuntimeError)
  #   expect { empty.find(->(_) { true }) { |_| true } }.to raise_error(RuntimeError)
  #   expect { empty.find_index_of(->(_) { true }) { |_| true } }.to raise_error(RuntimeError)
  #   expect { empty.take_while(->(_) { true }) { |_| true } }.to raise_error(RuntimeError)
  #   expect { empty.drop_while(->(_) { true }) { |_| true } }.to raise_error(RuntimeError)
  #   expect { empty.exists?(->(_) { true }) { |_| true } }.to raise_error(RuntimeError)
  #   expect { empty.for_all?(->(_) { true }) { |_| true } }.to raise_error(RuntimeError)
  #   expect { empty.filter(->(_) { true }) { |_| true } }.to raise_error(RuntimeError)
  #   expect { empty.reject(->(_) { true }) { |_| true } }.to raise_error(RuntimeError)
  #   expect { empty.group_by(->(_) { true }) { |_| true } }.to raise_error(RuntimeError)
  #   expect { empty.each(->(v) { puts(v) }) { |v| puts(v) } }.to raise_error(RuntimeError)
  # end
end
