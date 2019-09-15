require "fluent/plugin/parser"
module Fluent
  module Plugin
    class XsumParser < Fluent::Plugin::Parser
      
      Fluent::Plugin.register_parser("xsum", self)

      config_param :delimiter, :string, default: " "   # delimiter is configurable with " " as default
      config_param :time_format, :string, default: nil # time_format is configurable
      config_param :sum_delimiter, :string, default: ","

      def configure(conf)
        super

        if @delimiter.length != 1
          raise ConfigError, "delimiter must be a single character. #{@delimiter} is not."
        end

        # TimeParser class is already given. It takes a single argument as the time format
        # to parse the time string with.
        @rime_parser = Fluent::TimeParser.new(@time_format)
      end

      def parse(text)        
        time, line = text.split(@delimiter, 2)
        if line
          sum = line.split(@sum_delimiter).inject(0){|r,e| r += e.to_i}
          time = @time_parser.parse(time)
          record = {'str' => line, 'sum' => sum}
          yield time, record
        else
          # I am not sure, if this is good practice on fluentd
          # maybe better just raise an error? and skip checking.
          warn "Ignoring uncompleted data. #{text}"
          nil
        end
      end

    end
  end
end
