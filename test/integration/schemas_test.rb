# frozen_string_literal: true

require 'test_helper'

class SchemataTest < ActionDispatch::IntegrationTest
  test 'GET /api/schemata/application.json' do
    get '/api/schemas/application.json'

    assert_response :success

    schema = JSON.parse(response.body)
    assert_equal schema['$schema'], 'http://json-schema.org/draft-06/schema#'
    assert schema['properties']['application_reference']
  end

  test 'GET /api/schemata/case_details_schema.json' do
    get '/api/schemas/case_details.json'

    assert_response :success

    schema = JSON.parse(response.body)
    assert schema['properties']['case_type']
  end

  test 'GET /api/schemata/not_a_schema.json' do
    get '/api/schemas/not_a_schema.json'

    assert_response :not_found
  end
end
