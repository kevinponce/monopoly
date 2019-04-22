# shuffle takes an array of models and require model to have column order
class ShuffleService
  attr_accessor :ar

  def initialize(ar)
    self.ar = ar.dup.to_a
  end

  def call
    i = 0
    
    while ar.length > 0
      item = ar.delete_at(rand(ar.length))
      item.update(order: i)
      i += 1
    end

    ar
  end

  class << self
    def call(ar)
      self.new(ar).call
    end
  end
end
