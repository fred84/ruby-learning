require 'minitest/autorun'
require_relative '../lib/container'

class R530 < Server
  memory_slots 16, :ddr4
  cpu_sockets 2, :haswell
end

class R920 < Server
  memory_slots 32, :ddr3
  cpu_sockets 4, :ivybridge
end

class E5_4650 < CPU
  def initialize
    super 2100, 12, :haswell
  end
end

class E5_4660 < CPU
  def initialize
    super 2100, 14, :haswell
  end
end

class E5_2620 < CPU
  def initialize
    super 2100, 6, :ivybridge
  end
end

class DDR3_16 < Memory
  def initialize
    super :ddr3, 16
  end
end

class DDR4_16 < Memory
  def initialize
    super :ddr4, 16
  end
end

class ClassesPt2Test < MiniTest::Test

  def assert_raises_with_message(clazz, message, &block)
    err = assert_raises(clazz, &block)
    assert_equal message, err.message
  end

  def assert_invalid_configuration(message, &block)
    assert_raises_with_message(InvalidConfiguration, message, &block)
  end

  def test_too_much_cpu
    assert_invalid_configuration 'No more sockets left' do
      server = R530.new
      server.cpu << E5_4650.new
      server.cpu << E5_4650.new
      server.cpu << E5_4650.new # third CPU!!!
    end
  end

  def test_invalid_cpu_type
    assert_invalid_configuration 'Unsupported CPU type' do
      server = R530.new
      server.cpu << E5_2620.new
    end
  end

  def test_different_cpu
    assert_invalid_configuration 'All CPUs should by identical' do
      server = R530.new
      server.cpu << E5_4650.new
      server.cpu << E5_4660.new  # more cores then 4650
    end
  end

  def test_too_much_memory
    assert_invalid_configuration 'No more memory slots left' do
      server = R920.new
      33.times { server.memory << DDR3_16.new } # oops.. 32 slots only
    end
  end

  def test_invalid_memory_type
    assert_invalid_configuration 'Unsupported memory type' do
      server = R920.new
      server.memory << DDR4_16.new
    end
  end

  def test_empty_server
    refute R920.new.bootable?
  end

  def test_min_configuration
    server = R530.new
    server.cpu << E5_4660.new
    server.memory << DDR4_16.new

    assert server.bootable?
  end

  def test_max_configuration
    server = R920.new
    4.times { server.cpu << E5_2620.new }
    32.times { server.memory << DDR3_16.new }

    assert server.bootable?
  end

  def test_memory_size
    server = R920.new
    32.times { server.memory << DDR3_16.new }

    assert_equal 512, server.memory_size
  end
end