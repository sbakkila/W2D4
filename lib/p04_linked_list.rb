require 'byebug'

class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    @prev.next = @next
    @next.prev = @prev
  end
end

class LinkedList
  include Enumerable
  attr_reader :list, :head, :tail

  def initialize
    @list = []

    @head = Link.new
    @tail = Link.new

    @list << head
    @list << tail
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    head.next
  end

  def last
    tail.prev
  end

  def empty?
    @list.count == 2
  end

  def get(key)
    list.each do |link|
      return link.val if link.key == key
    end

    nil
  end

  def include?(key)
    list.each do |link|
      return true if link.key == key
    end

    false
  end

  def append(key, val)
    link = Link.new(key, val)
    index = list.size - 1

    link.prev = list[index - 1]
    link.next = list[index]

    list[index - 1].next = link
    list[index].prev = link

    list.insert(index, link)
  end

  def update(key, val)
    list.each do |link|
      return link.val = val if link.key == key
    end
  end

  def remove(key)
    list.each do |link|
      if link.key == key
        link.remove
        list.delete(link)
      end
    end
  end

  def each
    list.each do |link|
      next if link == head || link == tail
      yield(link)
    end
  end

  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
