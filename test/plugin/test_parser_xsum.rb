require "helper"
require "fluent/plugin/parser_xsum.rb"

class XsumParserTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  CONFIG = %[

  ]

  test "plugin should parse text" do
    d = create_driver(CONFIG)
    text = "2014-04-03T00:00:02 1,1,1,1,1,1,1,1,1,1"
    expected_time = event_time("2014-04-03T00:00:02")
    d.instance.parse(text) do |time, record|
      assert_equal(expected_time, time)      
      assert_equal(10, record["sum"])
      assert_equal("1,1,1,1,1,1,1,1,1,1", record["str"])
    end
  end

  test "plugin should ignore non numbers" do
    d = create_driver(CONFIG)
    text = "2014-04-03T00:00:02 1,1,a,b,1,1,1,1,1,1,1,1"    
    d.instance.parse(text) do |_time, record|       
      assert_equal(10, record["sum"])      
    end    
  end

  test "plugin should ignore broken log" do
    d = create_driver(CONFIG)
    text = "1,1,a,b,1,1,1,1,1,1,1,1"    
    
    ret = d.instance.parse(text)
    assert_nil ret
  end

  test "plugin sum with dot delimiter" do    
    d = create_driver(%[
      sum_delimiter .
    ])
    text = "2014-04-03T00:00:02 1.1.1.1.1.1.1.1.1.1"
    expected_time = event_time("2014-04-03T00:00:02")
    d.instance.parse(text) do |time, record|
      assert_equal(expected_time, time)      
      assert_equal(10, record["sum"])
      assert_equal("1.1.1.1.1.1.1.1.1.1", record["str"])
    end    
  end


  private

  def create_driver(conf)
    Fluent::Test::Driver::Parser.new(Fluent::Plugin::XsumParser).configure(conf)
  end
end
