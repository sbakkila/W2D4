require_relative 'p02_hashing'
require_relative 'p04_linked_list'
require 'byebug'

class HashMap
  include Enumerable
  attr_reader :count, :store

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    store[bucket(key)].include?(key)
  end

  def set(key, val)
    list = store[bucket(key)]

    if list.include?(key)
      list.update(key, val)
    else
      resize! if count == num_buckets
      list.append(key, val)
      @count += 1
    end
  end

  def get(key)
    store[bucket(key)].get(key)
  end

  def delete(key)
    if include?(key)
      store[bucket(key)].remove(key)
      @count -= 1
    end
  end

  def each
    store.each do |list|
      list.each do |link|
        yield(link.key, link.val)
      end
    end
  end

  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    store.length
  end

  def resize!
    new_hash_map = HashMap.new(num_buckets * 2)

    each do |key, val|
      new_hash_map.set(key, val)
    end

    @store = new_hash_map.store
  end

  def bucket(key)
    key.hash % num_buckets
  end
end
