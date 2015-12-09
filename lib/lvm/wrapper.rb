require 'lvm/attributes'
require 'lvm/external'
require 'lvm/wrapper/constants'

module LVM
  module Wrapper
    module Reporting
      include Constants

      # Breakdown return values into attribute => value hash suitable for
      # OpenStruct
      def process_line(expected_attributes, line) #:nodoc:
        line.strip!
        values = line.split(SEPERATOR)
        # nil is easier
        values.map! { |v| (v.empty?) ? nil : v }

        attributes = {}
        # values and expected attributes are in the same order
        values.size.times do |i|
          value  = values[i]
          attribute = expected_attributes[i]

          name = attribute[:method].to_sym

          # use hints for type conversion
          case attribute[:type_hint]
          when "String"
          when "Integer"
            value = value.to_i
          when "Float"
            value = value.to_f
          end
          attributes[name] = value
        end

        return attributes
      end
      module_function :process_line

      def build_command(expected_attributes, base)
        opts = []
        expected_attributes.each do |a|
          opts << a[:column]
        end

        return base % opts.join(",")
      end
      module_function :build_command
    end # module Reporting
  end # module Wrapper
end # module LVM
