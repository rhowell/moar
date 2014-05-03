# -*- encoding: utf-8 -*-

# -- this is magic line that ensures "../lib" is in the load path -------------
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'moar'
  gem.version       = ENV['MOAR_VER']
  gem.date          = '2014-04-02'
  gem.summary       = 'MOck Active Record (MOAR)'
  gem.description   = '*Not yet functional.*<br> MOAR allows you to mock up AcitveRecord models to prevent needing to load rails or databases while testing classes that use AR Models'
  gem.authors       = ['Ronnie Howell']
  gem.email         = 'ronniemhowell@gmail.com'
  gem.homepage      = 'https://github.com/rhowell/ar_mock'
  gem.executables  << 'ar_mock'
  gem.files         = `git ls-files lib spec`.split("\n")
  gem.files        << 'bin/ar_mock'
  gem.files        << `git ls-files tasks`.split("\n")
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  gem.license       = 'MIT'


  gem.add_dependency 'rails', '>= 3.1'

  gem.add_development_dependency 'rspec-rails', '~> 3.0.0.beta'
  gem.add_development_dependency 'sqlite3', '~> 0'
end
