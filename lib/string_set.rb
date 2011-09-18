class StringSet
  extend Forwardable
  include Enumerable

  def initialize
    @set = []
  end

  def_delegators :@set, :empty?, :size, :include?

  alias :count :size

  def ==(another)
    return false if self.size != another.size
    self.all? { |string| another.include? string }
  end

  def add(*strings)
    Array(strings).each do |string|
      @set << string unless @set.include?(string)
    end
  end

  def remove(string)
    @set.delete string
  end

  def each(&block)
    @set.each &block
  end

  def union(another)
    StringSet.new.tap do |result|
      result.add *(another.to_a | self.to_a)
    end
  end

  def intersect(another)
    StringSet.new.tap do |result|
      result.add *(another.to_a & self.to_a)
    end
  end

  def clear
    @set = []
  end

end
