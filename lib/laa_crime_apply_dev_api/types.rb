# frozen_string_literal: true

require 'dry-types'

module LaaCrimeApplyDevApi
  # Types for crime apply dev api schema
  class Types
    include Dry.Types()

    DateTime = Strict::DateTime | JSON::DateTime

    StrippedString = Types::String.constructor(&:strip)

    # TODO: add format to schema
    CrimeApplicationReference = Types::String
    Uuid = Types::String
  end
end
