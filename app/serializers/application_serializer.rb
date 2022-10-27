# frozen_string_literal: true

require 'jbuilder'
# Serialize Crime Apply data in line with prototype data api
class ApplicationSerializer
  def initialize(crime_application)
    @crime_app = crime_application
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
    LaaCrimeApplyDevApi::ApplicationSchema
  end

  class << self
    def collection(crime_apps)
      crime_apps.map { |ca| new(ca) }
    end
  end

  private

  attr_reader :crime_app

  def to_builder
    Jbuilder.new do |json|
      json.id crime_app.id
      json.application_reference "LAA-#{crime_app.id[0..5]}"
      json.application_start_date crime_app.date_stamp.to_s
      json.submission_date crime_app.submitted_at.to_s
      json.client_details client_details_to_builder
      json.case_details case_details_to_builder
      json.interests_of_justice(iojs_as_an_array, :reason, :type)
    end
  end

  # TODO: discuss IoJ data model with Apply team
  def iojs_as_an_array
    ioj_obj = kase&.ioj

    return [] unless ioj_obj

    ioj_obj.types.filter_map do |set_types|
      # TODO: fix typos on apply
      case set_types
      when 'loss_of_livelyhood'
        set_types = 'loss_of_livelihood'
      end

      OpenStruct.new(type: set_types, reason: ioj_obj.public_send("#{set_types}_justification")) unless set_types.empty?
    end
  end

  def client_details_to_builder
    Jbuilder.new do |json|
      json.client do
        json.first_name applicant&.first_name
        json.last_name applicant&.last_name
        json.national_insurance_number applicant&.nino
        json.address address_to_builder(home_address)
        json.date_of_birth applicant&.date_of_birth
        json.telephone_number applicant&.telephone_number
        json.correspondence_address_type applicant&.correspondence_address_type

        if applicant&.correspondence_address_type == 'other_address'
          json.correspondence_address address_to_builder(correspondence_address)
        end
      end
    end
  end

  def case_details_to_builder
    Jbuilder.new do |json|
      json.court_name kase&.hearing_court_name
      json.hearing_court_name kase&.hearing_court_name
      json.hearing_date kase&.hearing_date
      json.urn kase&.urn
      json.case_type kase&.case_type
      json.co_defendants(co_defendants, :first_name, :last_name, :conflict_of_interest)
      json.offences(offences, :name, :date, :class)
    end
  end

  def address_to_builder(address)
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

  # TODO: update when conflict btn schema and apply resolved
  def offences
    return [] unless kase

    kase.charges.map do |charge|
      charge = ChargePresenter.present(charge)
      # TODO: work out what's going on with offence dates?
      OpenStruct.new(name: charge.offence_name, date: charge.offence_dates.first, class: charge.offence_class)
    end
  end

  def home_address
    crime_app.applicant&.home_address
  end

  def correspondence_address
    crime_app.applicant&.correspondence_address
  end

  def applicant
    crime_app.applicant
  end
end
