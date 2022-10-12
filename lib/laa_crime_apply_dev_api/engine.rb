# frozen_string_literal: true

module LaaCrimeApplyDevApi
  class Engine < ::Rails::Engine
    config.generators.api_only = true
  end
end
