# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "country-select"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Koziarski", "James Dean Shepherd"]
  s.date = "2012-03-01"
  s.description = "Provides a form helper to insert a country select box using the ISO 3166 country list"
  s.email = "jamesds2007@gmail.com"
  s.homepage = "http://github.com/jamesds/country-select"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Country select box"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
