require 'minitest/autorun'
require_relative 'lib/server.rb'

class ClassTest < MiniTest::Test

  def test_cpu_compare
    cpu1 = CPU.new(1, 2500, 12, 3)
    cpu2 = CPU.new(2, 2500, 12, 3)

    assert cpu1 == cpu2
  end

  def test_memory_compare
    mem1 = Memory.new(:ddr4, 16)
    mem2 = Memory.new(:ddr4, 16)

    assert mem1 == mem2
  end

  def test_memory_size
    server = Server.new
    server.add_memory Memory.new(:ddr4, 16)
    server.add_memory Memory.new(:ddr4, 16)

    assert_equal 32, server.memory_size
  end

  def test_empty_server
    server = Server.new

    refute server.bootable?
  end

  def test_server_no_cpu
    server = Server.new
    server.add_memory Memory.new(:ddr4, 16)

    refute server.bootable?
  end

  def test_unsupported_cpu_generation
    assert_raises(RuntimeError) do
      server = Server.new
      server.add_cpu CPU.new(2, 2500, 12, 4)
    end
  end

  def test_different_cpus
    assert_raises(RuntimeError) do
      server = Server.new
      server.add_cpu CPU.new(2, 2500, 12, 3)
      server.add_cpu CPU.new(2, 2500, 16, 3)
    end
  end

  def test_too_much_cpus
    assert_raises(RuntimeError) do
      server = Server.new
      server.add_cpu CPU.new(2, 2500, 12, 3)
      server.add_cpu CPU.new(2, 2500, 12, 3)
      server.add_cpu CPU.new(2, 2500, 12, 3)
    end
  end

  def test_server_no_memory
    server = Server.new
    server.add_cpu CPU.new(2, 2500, 12, 3)

    refute server.bootable?
  end

  def test_unsupported_memory_type
    assert_raises(RuntimeError) do
      server = Server.new
      server.add_memory Memory.new(:ddr3, 16)
    end
  end

  def test_too_much_memory
    assert_raises(RuntimeError) do
      server = Server.new
      17.times { server.add_memory Memory.new(:ddr4, 16) }
    end
  end

  def test_max_memory
    server = Server.new
    16.times { server.add_memory Memory.new(:ddr4, 16) }

    pass
  end

  def test_bootable
    server = Server.new
    server.add_memory Memory.new(:ddr4, 16)
    server.add_cpu CPU.new(2, 2500, 12, 3)

    assert server.bootable?
  end
end
