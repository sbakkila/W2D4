require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count, :map, :store, :max, :prc

  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if store.include?(key)
      value = map.get(key)
      store.remove(key)
      store.append(key, value)
    else
      value = calc!(key)
      store.append(key, value)
    end

    map.set(key, store.last)

    eject! if store.list.length - 2 > max
    value
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    prc.call(key)
  end

  def eject!
    store.remove(store.first.key)
    map.delete(store.first.key)
  end
end
