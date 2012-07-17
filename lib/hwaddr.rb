#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

class HWAddr
	autoload :Database, 'hwaddr/database'

	def self.valid? (text)
		text =~ /^\w\w:\w\w:\w\w(?::\w\w:\w\w:\w\w)?$/
	end

	def initialize (value)
		@string = if value.is_a?(Array)
			if value.length > 6
				raise ArgumentError, "#{value.inspect} is too big for a MAC address"
			end

			value.map { |b| "%02x" % b }.join(':')
		elsif value.is_a?(Integer)
			array = []

			6.times {
				array << value & 0xff
				value >>= 8
			}

			array.map { |b| "%02x" % b }.join(':')
		else
			value.to_s
		end

		@string.tr! '-', ':'

		unless HWAddr.valid?(@string)
			raise ArgumentError, "#{value} isn't an usable MAC address"
		end
		
		@string.downcase!
	end

	def =~ (other)
		if group?
			to_s == other.to_s[0, 8]
		else
			to_s == other.to_s
		end
	end

	def group?
		to_s.length == 8
	end

	def broadcast?
		to_s == 'ff:ff:ff:ff:ff:ff'
	end

	def productor
		Database[to_s]
	end

	def to_s
		@string
	end
end
