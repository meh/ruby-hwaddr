#! /usr/bin/env ruby
require 'net/http'
require 'stringio'

io = ARGV.empty? ?
	StringIO.new(Net::HTTP.get(URI.parse('http://standards.ieee.org/develop/regauth/oui/oui.txt'))) :
	File.open(ARGV.first, 'r:iso-8859-1:utf-8')

puts DATA.read

buf = ''
buf += io.readline while buf !~ /\n{3}$/

until io.eof?
	buf = ''
	buf += io.readline while !io.eof? and buf !~ /\n{2}$/

	if buf =~ /^([0-9a-fA-F]{2})-([0-9a-fA-F]{2})-([0-9a-fA-F]{2})\s+\(hex\)\s+(.+?)\n\1\2\3\s+\(base 16\)\s+\4\n(.*)$/m
		cid, org, addr = "#$1:#$2:#$3", $4, $5.split(/\n/).map(&:strip).join("\n")

		puts "HWAddr::Database.add(#{org.inspect}, #{cid.inspect}, #{addr.inspect})"
	end
end

__END__
# encoding: utf-8
#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'singleton'

class HWAddr

class Database
	def self.method_missing (*args, &block)
		instance.__send__(*args, &block)
	end

	class Company
		class Range < HWAddr
			attr_reader :company, :address

			def initialize (company, range, address = nil)
				super(range)

				@company = company
				@address = address
			end
		end

		include Enumerable

		attr_reader :name

		def initialize (name, entries = nil)
			@name    = name
			@entries = entries || []
		end

		def add (range, address = nil)
			@entries << Range.new(self, range, address)
		end

		def === (other)
			any? { |r| r =~ other }
		end

		alias include? ===
		alias member?  ===
		alias cover?   ===

		def each (&block)
			@entries.each(&block)
		end
	end

	include Singleton
	include Enumerable

	def initialize
		@companies = {}
	end

	def add (name, range, address = nil)
		company = @companies[name] ||= Company.new(name)
		company.add(range, address)

		self
	end

	def [] (name)
		name = name.to_s

		if HWAddr.valid?(name)
			find { |c| c === name }
		else
			find { |c| c.name == name }
		end
	end

	def each (&block)
		return to_enum unless block

		@companies.each_value(&block)
	end

	def entries (&block)
		return enum_for :entries unless block

		@companies.each {|company|
			company.each {|range|
				yield range
			}
		}
	end
end

end

