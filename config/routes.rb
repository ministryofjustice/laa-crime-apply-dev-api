# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, format: :json do
    scope module: :v1 do
      resources :applications, format: :json, only: %i[index show]
      resources :schemas, format: :json, only: %i[show]
    end
  end
end
