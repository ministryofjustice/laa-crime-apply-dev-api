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

  CoDefendantSchema = Dry::Schema.Params do
    required(:conflict_of_interest).maybe(:bool)
    required(:first_name).value Types::String
    required(:last_name).value Types::String
  end

  OffenceSchema = Dry::Schema.Params do
    required(:class).value Types::String
    required(:date).value Types::JSON::Date
    required(:name).value Types::String
  end

  InterestOfJusticeSchema = Dry::Schema.Params do
    required(:reason).value Types::String
    required(:type).value Types::InterestsOfJusticeCriterion
  end

  CaseDetailsSchema = Dry::Schema.Params do
    required(:case_type).value Types::CaseType
    # required(:court_type).value Types::String
    required(:co_defendants).array(CoDefendantSchema)
    required(:offences).array(OffenceSchema)
    required(:hearing_court_name).value Types::String
    required(:hearing_date).maybe(Types::Date)

    required(:urn).value Types::String
  end

  ApplicationListItemSchema = Dry::Schema.Params do
    required(:id).value(Types::Uuid)
    required(:application_reference).value(Types::CrimeApplicationReference)
    required(:application_start_date).value(Types::DateTime)
    required(:submission_date).value(Types::DateTime)
    required(:client_details).hash do
      required(:client).hash do
        required(:first_name).value Types::String
        required(:last_name).value Types::String
      end
    end
  end

  ApplicationSchema = Dry::Schema.Params do
    required(:id).value(Types::Uuid)
    required(:application_reference).value(Types::CrimeApplicationReference)
    required(:application_start_date).value(Types::DateTime)
    required(:application_type).value Types::String.default('initial_application')
    required(:submission_date).value(Types::DateTime)

    required(:client_details).hash do
      required(:client).hash do
        required(:address).hash(AddressSchema)
        required(:first_name).value Types::String
        required(:last_name).value Types::String
        required(:national_insurance_number).value Types::String
        required(:date_of_birth).value Types::JSON::Date
        required(:telephone_number).value Types::PhoneNumber
        required(:correspondence_address_type).value Types::CorrespondenceAddressType
        optional(:correspondence_address).hash(AddressSchema)
      end
    end

    required(:interests_of_justice).array(InterestOfJusticeSchema)

    required(:case_details).hash(CaseDetailsSchema)
  end
end
