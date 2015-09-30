require 'minitest/autorun'

class Learning1Test < Minitest::Test

  def setup
    @servers = [
        {
            :id => 1,
            :model => 'R530',
            :cpu => [{:cores => 8, :frequency => 2.5}],
            :ram => [16, 16, 16, 16],
            :storage => [{:type => :ssd, :size => 400}, {:type => :ssd, :size => 400}, {:type => :ssd, :size => 400}, {:type => :ssd, :size => 400}]
        },
        {
            :id => 2,
            :model => 'R530',
            :cpu => [{:cores => 8, :frequency => 2.8}],
            :ram => [16, 16, 16, 16, 16, 16, 16, 16],
            :storage => [{:type => :sas, :size => 600}, {:type => :sas, :size => 600}]
        },
        {
            :id => 3,
            :model => 'R530',
            :cpu => [{:cores => 8, :frequency => 2.3}],
            :ram => [16, 16, 16, 16, 16, 16, 16, 16],
            :storage => [{:type => :sas, :size => 600}, {:type => :sas, :size => 600}, {:type => :ssd, :size => 400}, {:type => :ssd, :size => 400}]
        }
    ]
  end

  def sorted_ids_by_cpu_frequency(servers)
    return servers.sort_by {|el| el[:cpu][0][:frequency]}.map{|elem| elem[:id]}
  end

def find_ssd_only_ids(servers)
  return servers.select{|elem| elem[:storage][0][:type] == :ssd}.map{|el|el[:id]}
end

def find_ids_with_ram_over_100(servers)
  return servers.select{|item| item[:ram].reduce(:+) > 100}.map{|el| el[:id]}
end

def find_ssd_volume_per_server(servers)
  servers.map do |item|
    {item[:id] => item[:storage].select{|ssd| ssd[:type] == :ssd}.reduce(0){|acc, stor| acc + stor[:size]}}
  end
end


  # TODO Roma
  def test_ssd_only
    assert_equal [1], find_ssd_only_ids(@servers)
  end

  # TODO Sasha
  def test_find_ids_with_ram_over_100
    assert_equal [2,3], find_ids_with_ram_over_100(@servers)
  end

  # TODO Aleksey
  def test_find_ssd_volume_per_server
    assert_equal [{1=>1600}, {2=>0}, {3=>800}], find_ssd_volume_per_server(@servers)
  end

  # TODO Anatoly
  def test_sorted_ids_by_cpu_frequency
    assert_equal [3,1,2], sorted_ids_by_cpu_frequency(@servers)
  end
end
