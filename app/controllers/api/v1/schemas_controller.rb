# frozen_string_literal: true

module Api
  module V1
    # Shows api schema in json-schema format
    class SchemasController < ActionController::API
      def show
        case params[:id]
        when 'application'
          schema = LaaCrimeApplyDevApi::ApplicationSchema
        when 'case_details'
          schema = LaaCrimeApplyDevApi::CaseDetailsSchema
        else
          return head :not_found
        end

        render json: schema.json_schema
      end
    end
  end
end
