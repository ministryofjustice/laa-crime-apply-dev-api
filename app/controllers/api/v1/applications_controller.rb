# frozen_string_literal: true

require 'dry-types'

module Types
  include Dry.Types()
end

module Api
  module V1
    class CrimeApplicationResource < Dry::Struct
      # NOTE: schema is based on that used by
      # https://github.com/ministryofjustice/laa-crime-apply-prototype-api

      attribute :application_start_date, Types::Nominal::DateTime

      attribute :client_details do
        attribute :client do
          attribute :first_name, Types::String
          attribute :last_name, Types::String
        end
      end

      # TODO: add reference to schema
      # laa_reference is not included in prototype schema but is required by review
      attribute :application_reference, Types::String

      class << self
        def build_from_crime_application(crime_app)
          new(
            application_start_date: crime_app.updated_at,

            client_details: {
              client: {
                first_name: crime_app.first_name,
                last_name: crime_app.last_name,
                national_insurance_number: crime_app.applicant&.nino
              }
            },

            application_reference: crime_app.laa_reference
          )
        end
      end
    end

    class ApplicationsController < ActionController::API
      LIMIT = 100

      def index
        resources = CrimeApplication.all.limit(LIMIT).map do |application|
          CrimeApplicationResource.build_from_crime_application(
            CrimeApplicationPresenter.new(application)
          )
        end

        render json: resources
      end
    end
  end
end
