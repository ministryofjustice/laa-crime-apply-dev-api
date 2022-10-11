# frozen_string_literal: true

require_relative 'lib/laa/crime/apply/dev/api/version'

Gem::Specification.new do |spec|
  spec.name        = 'laa-crime-apply-dev-api'
  spec.version     = Laa::Crime::Apply::Dev::Api::VERSION
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
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'dry-struct', '>= 1.0.0'
  spec.add_dependency 'rails', '>= 7.0.3'
end
