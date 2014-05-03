
Gem::Specification.new do |s|
  s.name        = 'ar_mock'
  s.version     = '0.0.1'
  s.date        = '2014-01-02'
  s.summary     = 'Active Record Mock'
  s.description = 'ARM allows you to mock up AcitveRecord models to prevent needing to load rails or databases while testing classes that use AR Models'
  s.authors     = ['Ronnie Howell']
  s.email       = 'ronniemhowell@gmail.com'
  s.homepage    = 'https://github.com/rhowell/ar_mock'
  s.executables << 'ar_mock'
  s.files       = `git ls-files lib spec`.split("\n")
  s.files       << 'bin/ar_mock'
end
