# frozen_string_literal: true

module Api
  module V1
    class ApplicationsController < ActionController::API
      LIMIT = 100

      # list any application that satisfies the schema
      def index
        render json: resources
      end

      private

      def resources
        CrimeApplication.all.limit(LIMIT).filter_map do |application|
          build_from_crime_application(application)

        # Ignore applications that do not satisfy schema
        rescue Dry::Struct::Error => e
          false
        end
      end

      def build_from_crime_application(crime_app)
        LaaCrimeApplyDevApi::ApplicationResource.new(
          application_start_date: crime_app.updated_at,
          client_details: {
            client: {
              first_name: crime_app.applicant&.first_name,
              last_name: crime_app.applicant&.last_name,
              national_insurance_number: crime_app.applicant&.nino
            }
          },
          application_reference: "LAA-#{crime_app.id[0..5]}"
        )
      end
    end
  end
end
