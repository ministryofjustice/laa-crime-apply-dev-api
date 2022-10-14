# frozen_string_literal: true

require 'jbuilder'
# Serialize Crime Apply data in line with prototype data api
class ApplicationSerializer
  def initialize(crime_application, exclude_details: false)
    @crime_app = crime_application
    @include_details = !exclude_details
    @result = schema.call(to_builder.attributes!)
  end

  def as_json(_options = {})
    if valid?
      @result.to_h
    else
      @result.errors(full: true).to_h
    end
  end

  def valid?
    @result.success?
  end

  def schema
    if @include_details
      LaaCrimeApplyDevApi::ApplicationSchema
    else
      LaaCrimeApplyDevApi::ApplicationListItemSchema
    end
  end

  class << self
    # Returns a collection of serialized crime applications.
    # Details are omitted by default.
    #
    def collection(crime_apps, include_details: false)
      crime_apps.map { |ca| new(ca, exclude_details: !include_details) }
    end
  end

  private

  def to_builder
    Jbuilder.new do |json|
      json.id crime_app.id
      json.application_reference "LAA-#{crime_app.id[0..5]}"
      json.application_start_date crime_app.updated_at.to_s
      json.client_details client_details_to_builder
      json.case_details case_details_to_builder if @include_details
    end
  end

  def client_details_to_builder
    Jbuilder.new do |json|
      json.client do
        json.first_name applicant&.first_name
        json.last_name applicant&.last_name
        if @include_details
          json.national_insurance_number applicant&.nino
          json.address address_to_builder
        end
      end
    end
  end

  def case_details_to_builder
    Jbuilder.new do |json|
      json.case_type crime_app.case.case_type
      json.co_defendants(crime_app.case.codefendants) do |cd|
        json.first_name cd.first_name
        json.last_name cd.last_name
        json.conflict_of_interest cd.conflict_of_interest
      end

      json.offences(crime_app.case.charges) do |charge|
        json.name charge.offence_name
        json.date '2001-01-01'
        json.class 'CONFLICT IN DATA MODEL'
      end

      fake_iojs = [OpenStruct.new(reason: 'Loss of liberty', type: 'liberty')]

      json.interests_of_justice(fake_iojs) do |ioj|
        json.reason ioj.reason
        json.type ioj.type
      end

      json.court_name crime_app.case.hearing_court_name
      json.urn crime_app.case.urn
    end
  end

  def address_to_builder
    Jbuilder.new do |json|
      json.address_line_one address.address_line_one
      json.address_line_two address.address_line_two
      json.postcode address.postcode
      # NOTE: beware typo on Crime Apply country/county
      json.county address.country
    end
  end

  attr_reader :crime_app

  def address
    crime_app.applicant&.home_address
  end

  def applicant
    crime_app.applicant
  end
end
