class Server
  @ram = []
  @cpu = []

  def initialize
    @ram = []
    @cpu = []
    @ram_slots = 16
    @cpu_slots = 2
    @cpu_supported_gen = 3
  end
  def add_memory(mem_object)
    if( mem_object.is_a? Memory )
      raise 'I am already full, cant take another RAM slot  ' if @ram.size == @ram_slots
      raise 'Are you serious? That a SERVER!! Only DDR4!!!' if !(mem_object.spec.has_key? :ddr4)
      @ram.push(mem_object.spec)
    end
  end
  def add_cpu(cpu_object)
    if (cpu_object.is_a? CPU)
      raise 'Unsupported generation' if cpu_object[:gen] != @cpu_supported_gen
      raise 'Nope, too much CPU power for one little server' if @cpu.size == @cpu_slots
      @cpu.push(cpu_object.spec)
    end
  end
  def memory_size
    @ram.reduce(0){|acc, item| acc + item[:ddr4]}
  end
  def bootable?
  (@ram.empty? or @cpu.empty? ) ? false : true
  end
end

class Memory
  @spec
  def initialize(type, size)
    @spec = {type => size}
  end
  def ==(same_object)
    self.spec == same_object.spec ? 0 : 1 if same_object.is_a? Memory
  end
  def spec
    @spec
  end
end

class CPU
  @spec
  def initialize(id, freq, cores, gen)
    @spec = {:id => id, :freq => freq, :cores => cores, :gen => gen}
  end

  def spec
    [ @spec[:freq], @spec[:cores], @spec[:gen] ]
  end

  def ==( same_object )
     self.spec == same_object.spec ? 0 : 1 if same_object.is_a? CPU
  end
end
