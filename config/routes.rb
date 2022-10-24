# frozen_string_literal: true

# Dev Api routes constrained to development test and staging only.
class ApiConstraint
  def initialize; end

  def matches?(_request)
    Rails.env.development? || Rails.env.test? || Rails.env.staging?
  end
end

Rails.application.routes.draw do
  namespace :api, format: :json do
    scope module: :v1, constraints: ApiConstraint.new do
      resources :applications, format: :json, only: %i[index show]
      resources :schemata, format: :json, only: %i[show]
    end
  end
end
