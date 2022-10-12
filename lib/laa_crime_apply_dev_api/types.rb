# frozen_string_literal: true

require 'dry-types'

module LaaCrimeApplyDevApi
  class Types
    include Dry.Types()

    Date = Strict::Date | JSON::Date
    DateTime = Strict::DateTime | JSON::DateTime
  end
end
