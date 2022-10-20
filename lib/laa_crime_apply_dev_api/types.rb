# frozen_string_literal: true

require 'dry-types'

module LaaCrimeApplyDevApi
  COURT_TYPES = %w[
    crown
    magistrates
  ].freeze

  OFFENCE_CLASSES = %w[
    a b c d e f g h i j k
  ].freeze

  CASE_TYPES = %w[
    summary_only
    either_way
    indictable
    already_in_crown_court
    commital
    appeal_to_crown_court
    appeal_to_crown_court_with_changes
  ].freeze

  CORRESPONDENCE_ADDRESS_TYPES = %w[
    other_address
    home_address
    provider_address
  ].freeze

  INTERESTS_OF_JUSTICE_CRITERIA = %w[
    loss_of_liberty
    suspended_sentence
    loss_of_livelihood
    reputation
    question_of_law
    understanding
    witness_tracing
    expert_examination
    interest_of_another
    other
  ].freeze

  # Types for crime apply dev api schema
  class Types
    include Dry.Types()

    DateTime = Strict::DateTime | JSON::DateTime
    CorrespondenceAddressType = String.enum(*CORRESPONDENCE_ADDRESS_TYPES)
    OffenceClass = String.enum(*OFFENCE_CLASSES)
    CaseType = String.enum(*CASE_TYPES)
    CourtType = String.enum(*COURT_TYPES)
    InterestsOfJusticeCriterion = String.enum(*INTERESTS_OF_JUSTICE_CRITERIA)

    CrimeApplicationReference = Types::String
    Uuid = Types::String
    PhoneNumber = Types::String
  end
end
