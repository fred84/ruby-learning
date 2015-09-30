class InvalidConfiguration < Exception
end

class Server
  def self.memory_slots(count, type)
    define_method(:memory) do
      @memory ||= MemoryWrapper.new(count, type)
    end
  end
  def self.cpu_sockets(count, type)
    define_method(:cpu) do
      @cpu ||= CpuWrapper.new(count, type)
    end
  end
  def bootable?
    (memory.quantity == 0 or cpu.quantity == 0) ? false : true
  end

  def memory_size
    @memory.get_overall_size
  end
end

class CPU
  attr_reader :unit
  def initialize(freq, core_count, core_type)
    @unit = {freq: freq, core_count: core_count, core_type: core_type}
  end
end

class Memory
  attr_reader :unit
  def initialize(type, amount)
    @unit = {type: type, amount: amount}
  end
end
class CpuWrapper
  attr_reader :cpu_list
  def initialize(count, type)
    @spec = {count: count, type: type}
    @cpu_list = []
  end
  def quantity
    @cpu_list.size
  end
  def << obj
    raise InvalidConfiguration, 'Provide valid CPU object' if !(obj.is_a? CPU)
    raise InvalidConfiguration, 'No more sockets left' if @cpu_list.size == @spec[:count]
    raise InvalidConfiguration, 'Unsupported CPU type' if obj.unit[:core_type] != @spec[:type]
    raise InvalidConfiguration, 'All CPUs should by identical' if (@cpu_list.size != 0) and (@cpu_list.first.unit != obj.unit)
    @cpu_list.push(obj)
  end
end
class MemoryWrapper
  attr_reader :mem_list
  def initialize(count, type)
    @spec = {count: count, type: type}
    @mem_list = []
  end
  def quantity
    @mem_list.size
  end
  def get_overall_size
    @mem_list.reduce(0){|acc, item| acc + item.unit[:amount]}
  end
  def << obj
    raise InvalidConfiguration, 'Provide valid Memory object' if !(obj.is_a? Memory)
    raise InvalidConfiguration, 'No more memory slots left' if @mem_list.size == @spec[:count]
    raise InvalidConfiguration, 'Unsupported memory type' if obj.unit[:type] != @spec[:type]
    @mem_list.push(obj)
  end
end
