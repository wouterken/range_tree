require "range_tree/version"

module RangeTree
  class Tree
    require 'set'
    attr_accessor :children, :root, :starts, :ends, :rebuild_on_add

    MAX_REBUILD_SIZE = 500

    def initialize(rebuild_on_add: true)
      self.children = []
      self.rebuild_on_add = rebuild_on_add
      self.starts   = Hash.new{|h,k| h[k] = []}
      self.ends     = Hash.new{|h,k| h[k] = []}
    end

    def add(min, max, value)
      node =  Node.new(min, max, value)
      self.children                                          << node
      self.starts[min]                                       << node
      self.ends[max.respond_to?(:succ) ? max.succ : max + 1] << node
      self.rebuild if self.rebuild_on_add
    end

    def []=(min, max, value)
      add(min, max, value)
    end

    def >>(value)
      remove(value)
    end

    def remove(value)
      return unless node_to_remove = self.children.find{|child| child.value == value}
      self.children.delete(node_to_remove)
      self.starts[node_to_remove.min].delete(node_to_remove)
      self.ends[node_to_remove.max].delete(node_to_remove)
      self.rebuild if self.rebuild_on_add
      return node_to_remove.min..node_to_remove.max
    end

    def rebuild
      current_level = self.children.sort_by(&:mid_point)
      current_level = current_level.each_slice(2).map do |pair|
        Node.new(pair.map(&:min).min, pair.map(&:max).max, pair)
      end while current_level.length > 1
      self.root = current_level.first
    end


    def distinct &block
      iterate([*self.starts.keys, *self.ends.keys].uniq.sort).each(&block)
    end

    def all &block
      iterate(self.starts.keys.min..self.ends.keys.max).each(&block)
    end

    def [](index)
      return nil unless self.root
      case index
      when Range
        self.root.search_range(index).map(&:value)
      when Fixnum
        self.root.search(index).map(&:value)
      else
        raise "Unexpected index type #{index.class}"
      end
    end

    private
    def iterate(range)
      return [] unless self.root
      collection = Set.new(self.root.search(range.first))
      Enumerator.new do |enum|
        range.each do |current_point|
          self.ends[current_point].each{|node| collection.delete(node)} if self.ends.include?(current_point)
          self.starts[current_point].each{|node| collection << node }   if self.starts.include?(current_point)
          enum.yield current_point, collection.map(&:value)
        end
      end
    end

  end

  class Node
    attr_accessor :min, :max, :value, :mid_point
    def initialize(min, max, value)
      self.min, self.max, self.value = min, max, value
      self.mid_point = self.min + (self.max - self.min) / 2.0
    end

    def search(index)
      return [] unless (min..max) === index
      Array === value && value.map{|v| v.search(index)}.flatten || [self]
    end

    def search_range(range)
      return [] unless intersect((self.min..self.max),range)
      Array === value && value.map{|v| v.search_range(range)}.flatten || [self]
    end

    def intersect(r1, r2)
      !(r2.end < r1.first || r2.first > r1.end)
    end
  end
end
