require 'byebug'

class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    return 0.hash if empty?
    hash = []

    each.with_index do |el, i|
      hash << (el.hash + i).hash
    end

    hash.inject(:+)
  end
end

class String
  def hash
    return 0.hash if empty?
    hash = []

    each_char.with_index do |el, i|
      hash << (el.ord + i).hash
    end

    hash.inject(:+)
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    return 0.hash if empty?
    hash = Array.new

    each do |key, val|
      hash << (key.to_s.ord + val.ord).hash
    end

    hash.inject(:+)
  end
end
