class Server
  def initialize
    @ram_max_slots = 16
    @ram_allowed_type = :ddr4
    @cpu_max_slots = 2
    @cpu_allowed_gen = 3
    @cpu = []
    @ram = []
  end

  def add_cpu(cpu_obj)
    if( cpu_obj.is_a? CPU )
      raise "Cant add more CPU, all slots are occupied" if @cpu.size == @cpu_max_slots
      raise "Unsupported CPU generation, supported generation is #{@cpu_allowed_gen}" if cpu_obj.cpu_full_spec[:generation] != @cpu_allowed_gen
      if @cpu.size == 0
        @cpu.push(cpu_obj)
      else
         raise "Only equal CPU are supported" if cpu_obj.getTechSpec != @cpu[@cpu.size - 1].getTechSpec
         @cpu.push(cpu_obj)
      end

    else
      raise "You must supply CPU object!"
    end
  end

  def add_memory(mem_obj)
    if( mem_obj.is_a? Memory )
      raise "Cant add more memory, all slots are occupied" if @ram.size == @ram_max_slots
      raise "Unsupported Memory type, supported type is #{@ram_allowed_type}" if mem_obj.mem_full_spec[:type] != @ram_allowed_type
      @ram.push(mem_obj)
    else
      raise "You must supply Memory object!"
    end
  end

  def memory_size
    #@ram.select{|key, value| key == ':ddr4'}.reduce(0){|acc, item| acc + item[:amount]}
    @ram.reduce(0){|acc, item| acc + item.getTechSpec[:amount]}
  end

  def bootable?
    # is server bootable            Nope    Yeap
    (@cpu.empty? or @ram.empty?) ? false : true
  end
end

class CPU
  attr_reader :cpu_full_spec
  @cpu_full_spec
  @cpu_tech_spec

  def initialize(id, freq, cores, generation)
    @cpu_full_spec = {:id => id, :freq => freq, :cores => cores, :generation => generation}
  end
  def getTechSpec
    @cpu_full_spec.select{|key, value| key != :id}
  end
  def == (other)
    if(other.is_a? CPU)
      self.getTechSpec == other.getTechSpec
    else
      raise 'You tried to compare CPU with something else. it\'s an error :)'
    end
  end

end

class Memory
  attr_reader :mem_full_spec
  @mem_full_spec
  @@memid = 0
  @mem_tech_spec

  def initialize(id = @@memid, type, amount)
    @mem_full_spec = {:id => @@memid, :type => type, :amount => amount}
    @@memid+=1
  end

  def getTechSpec
    @mem_full_spec.select{|key, value| key != :id}
  end

  def == (other)
    if(other.is_a? Memory)
      self.getTechSpec == other.getTechSpec
    else
      raise 'You tried to compare Memory with something else. it\'s an error :)'
    end
  end

end
