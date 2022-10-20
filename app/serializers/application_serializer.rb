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

  attr_reader :crime_app

  def to_builder
    Jbuilder.new do |json|
      json.id crime_app.id
      json.application_reference "LAA-#{crime_app.id[0..5]}"
      json.application_start_date crime_app.updated_at.to_s
      json.submission_date crime_app.updated_at.to_s
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
          json.date_of_birth applicant&.date_of_birth
        end
      end
    end
  end

  def case_details_to_builder
    Jbuilder.new do |json|
      json.court_name kase&.hearing_court_name
      json.urn kase&.urn
      json.case_type kase&.case_type
      json.co_defendants(co_defendants, :first_name, :last_name, :conflict_of_interest)
      json.interests_of_justice(iojs, :reason, :type)
      json.offences(offences, :name, :date, :class)
    end
  end

  def address_to_builder
    Jbuilder.new do |json|
      json.address_line_one address&.address_line_one
      json.address_line_two address&.address_line_two
      json.postcode address&.postcode
      json.county address&.country
    end
  end

  def kase
    crime_app.case
  end

  def co_defendants
    return [] unless kase

    kase.codefendants
  end

  # TODO: update when ready
  def iojs
    [OpenStruct.new(reason: 'Loss of liberty', type: 'liberty')]
  end

  # TODO: update when conflict btn schema and apply resolved
  def offences
    return [] unless kase

    kase.charges.map do |charge|
      OpenStruct.new(name: charge.offence_name, date: '2001-01-01', class: 'CONFLICT IN DATA MODEL')
    end
  end

  def address
    crime_app.applicant&.home_address
  end

  def applicant
    crime_app.applicant
  end
end
