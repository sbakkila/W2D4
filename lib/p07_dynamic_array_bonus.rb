require 'byebug'

class StaticArray
  attr_reader :store

  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    @store[i]

  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  def length
    @store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  include Enumerable
  attr_reader :count, :store, :length

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
    @length = store.length
  end

  def [](i)
    if i < 0
      return nil if count + i < 0
      @store[count + i]
    else
      @store[i]
    end
  end

  def []=(i, val)
    if i < 0
      @store[count + i] = val
    elsif i > @length
      resize! until @length >= i
      @store[i] = val
    else
      @store[i] = val
    end
  end

  def capacity
    @store.length
  end

  def include?(val)
    each do |value|
      return true if value == val
    end
    false
  end

  def push(val)
    resize! if count >= store.length

    store[count] = val
    @count += 1
  end

  def unshift(val)
    store.length.times do |i|
      new_idx = store.length - i - 1
      next if new_idx == 0
      store[new_idx] = store[new_idx - 1]
    end

    store[0] = val
    @count += 1

    resize! if count >= store.length
  end

  def pop
    return nil if length == 0
    pop_val = last
    store[count - 1] = nil
    @count -= 1
    pop_val
  end

  def shift
    return nil if store.length.zero?

    shift_val = first

    store.length.times do |i|
      next if i == store.length - 1
      store[i] = store[i + 1]
    end

    store[store.length - 1] = nil

    @count -= 1
    shift_val
  end

  def first
    store[0]
  end

  def last
    store[count - 1]
  end

  def each
    count.times do |i|
      yield(store[i])
    end
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    return false unless length == other.length

    if other.is_a? Array
      length.times do |i|
        return false unless store[i] == other[i]
      end
    elsif other.is_a? DynamicArray
      length.times do |i|
        return false unless store[i] == other.store[i]
      end
    end

    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    new_arr = StaticArray.new(@length * 2)
    #debugger
    @length.times do |i|
      new_arr[i] = store[i]
    end
    #debugger
    @length = new_arr.store.length
    @store = new_arr
  end
end
