# frozen_string_literal: true

require 'dry-struct'

module LaaCrimeApplyDevApi
  class ApplicationResource < Dry::Struct
    # NOTE: schema is based on that used by prototype api
    # https://github.com/ministryofjustice/laa-crime-apply-prototype-api
    #
    # TODO: review the following changes to the prototype api schema
    # -- application_reference, is required by review

    attribute :application_start_date, Types::Nominal::DateTime

    attribute :client_details do
      attribute :client do
        attribute :first_name, Types::String
        attribute :last_name, Types::String
      end
    end

    attribute :application_reference, Types::String
  end
end
