# frozen_string_literal: true

require 'laa_crime_apply_dev_api/version'
require 'laa_crime_apply_dev_api/engine'
require 'laa_crime_apply_dev_api/types'
require 'dry-schema'

module LaaCrimeApplyDevApi
  AddressSchema = Dry::Schema.Params do
    required(:address_line_one).value(Types::String)
    required(:address_line_two).value(Types::String)
    required(:county).value(Types::String)
    required(:postcode).value(Types::String)
  end

  ApplicationSchema = Dry::Schema.Params do
    required(:id).value(Types::Uuid)
    required(:application_reference).value(Types::CrimeApplicationReference)
    required(:application_start_date).value(Types::DateTime)

    required(:client_details).hash do
      required(:client).hash do
        required(:address).hash(AddressSchema)
        required(:first_name).value Types::String
        required(:last_name).value Types::String
        required(:national_insurance_number).value Types::String
      end
    end

    required(:case_details).hash do
      required(:case_type).value Types::String
      # required(:court_type).value Types::String
      required(:co_defendants).array(:hash) do
        required(:conflict_of_interest).maybe(:bool)
        required(:first_name).value Types::String
        required(:last_name).value Types::String
      end

      required(:offences).array(:hash) do
        required(:class).value Types::String
        required(:date).value Types::String
        required(:name).value Types::String
      end

      required(:court_name).value Types::String
      required(:urn).value Types::String

      required(:interests_of_justice).array(:hash) do
        required(:reason).value Types::String
        required(:type).value Types::String
      end
    end
  end

  ApplicationListItemSchema = Dry::Schema.Params do
    required(:id).value(Types::Uuid)
    required(:application_reference).value(Types::CrimeApplicationReference)
    required(:application_start_date).value(Types::DateTime)
    required(:client_details).hash do
      required(:client).hash do
        required(:first_name).value Types::String
        required(:last_name).value Types::String
      end
    end
  end
  #  "interests_of_justice": [
  #   {
  #    "reason": "Client likely to receive custodial sentence",
  #    "type": "liberty"
  #   },
  #   {
  #    "type": "livelihood"
  #   }
  #  ],
  #  "provider_details": {
  #   "email": "mary@legal.com",
  #   "firm": "Legal ABC",
  #   "office": "London"
  #  },
  #  "provider_firm": "Legal ABC"
  # }
  #
end
