require File.expand_path('../lib/conductor/version', __FILE__)

Gem::Specification.new do |s|
	s.name         = 'conductor'
	s.version      = Conductor::VERSION
	s.author       = 'marcpmichel'
	s.email        = 'marc.p.michel@gmail.com'
	s.homepage     = 'http://patatra.fr/conductor'
	s.summary      = 'basic job scheduler'
	s.description  = 'Simplistic job scheduler with inter-job dependencies'

	s.files          = `find ./lib -print`.split("\n")
	s.executables    = []
	s.test_files     = `fine ./spec -print`.split("\n")
	s.require_paths  = ['lib']

	s.add_dependency 'daytime'

	s.add_development_dependency 'rspec'
end
