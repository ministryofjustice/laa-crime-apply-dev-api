# frozen_string_literal: true

class ApiConstraint
  def initialize; end

  def matches?(_request)
    Rails.env.development?
  end
end

Rails.application.routes.draw do
  namespace :api, format: :json do
    scope module: :v1, constraints: ApiConstraint.new do
      resources :applications, format: :json, only: [:index]
    end
  end
end
