Gem::Specification.new {|s|
	s.name         = 'hwaddr'
	s.version      = '0.0.2'
	s.author       = 'meh.'
	s.email        = 'meh@paranoici.org'
	s.homepage     = 'http://github.com/meh/ruby-hwaddr'
	s.platform     = Gem::Platform::RUBY
	s.summary      = 'MAC address handling.'

	s.files         = `git ls-files`.split("\n")
	s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
	s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
	s.require_paths = ['lib']
}
