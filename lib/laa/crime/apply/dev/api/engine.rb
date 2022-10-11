# frozen_string_literal: true

module Laa
  module Crime
    module Apply
      module Dev
        module Api
          class Engine < ::Rails::Engine
            config.generators.api_only = true
          end
        end
      end
    end
  end
end
