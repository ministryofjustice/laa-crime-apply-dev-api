# frozen_string_literal: true

module LaaCrimeApplyDevApi
  # Engine for LaaApplyForCriminalLegalAid to allow integration with
  # Review during development
  class Engine < ::Rails::Engine
    config.generators.api_only = true
  end
end
