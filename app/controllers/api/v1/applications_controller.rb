# frozen_string_literal: true

module Api
  module V1
    # Temporary utility api controller to allow integration between Crime Apply
    # and Review during development
    class ApplicationsController < ActionController::API
      LIMIT = 50

      # Omits any records that do not satisfy schema
      #
      def index
        crime_apps = CrimeApplication.all.limit(LIMIT)

        render json: ApplicationSerializer.collection(crime_apps).select(&:valid?)
      end

      # Shows schema errors if they exist
      #
      def show
        application = ApplicationSerializer.new(CrimeApplication.find(params[:id]))

        if application.valid?
          render json: application
        else
          render json: application, status: 451
        end
      rescue ActiveRecord::RecordNotFound
        head :not_found
      else
      end
    end
  end
end
