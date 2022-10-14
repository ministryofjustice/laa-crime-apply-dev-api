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
  #
  # Prototype Api Schema
  #
  # {
  #  "application_start_date": "2022-09-01T10:55:20.284Z",
  #  "client_details": {
  #   "client": {
  #    "address": {
  #     "address_line_one": "14 Real Street",
  #     "address_line_two": "Sometown",
  #     "county": "Hampshire",
  #     "postcode": "AB1 2CD"
  #    },
  #    "first_name": "Janet",
  #    "last_name": "Dean",
  #    "national_insurance_number": "AA1234490D"
  #   },
  #   "means": {
  #    "passporting": true
  #   },
  #   "on_remand": false,
  #   "partner_conflict_of_interest": false,
  #   "partner_role_in_case": "none"
  #  },
  #  "case_details": {
  #   "case_type": "summary_only",
  #   "court_type": "magistrates",
  #   "co_defendants": [
  #    {
  #     "conflict_of_interest": false,
  #     "first_name": "Jill",
  #     "last_name": "Brown"
  #    }
  #   ],
  #   "offences": [
  #    {
  #     "class": "c",
  #     "date": "2020-06-22",
  #     "name": "Assault"
  #    }
  #   ],
  #   "URN": "123456"
  #  },
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
