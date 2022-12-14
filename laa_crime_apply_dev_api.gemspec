# frozen_string_literal: true

require_relative 'lib/laa_crime_apply_dev_api/version'

Gem::Specification.new do |spec|
  spec.name        = 'laa_crime_apply_dev_api'
  spec.version     = LaaCrimeApplyDevApi::VERSION
  spec.authors     = ['timpeat']
  spec.email       = ['tim.peat@digital.justice.gov.uk']
  spec.homepage    = 'https://github.com/ministryofjustice/laa-crime-apply-dev-api'
  spec.summary     = 'Temporary development tool to expose criminal legal aid application ' \
    'data from laa-apply-for-criminal-legal-aid'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ministryofjustice/laa-crime-apply-dev-api'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  end

  spec.required_ruby_version = '>= 3.0'

  spec.add_dependency 'dry-schema', '>= 1.10'
  spec.add_dependency 'jbuilder', '>= 2.11'
  spec.add_dependency 'rails', '>= 7.0'

  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'sqlite3'
end
