# frozen_string_literal: true

require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  setup do
    @uuid = 'H234asdf'

    applicant = stub(
      first_name: 'Zoe',
      last_name: 'Blogs',
      nino: 'QQ1223456B',
      home_address: OpenStruct.new
    )

    @crime_application = stub(
      id: @uuid,
      updated_at: 1.day.ago,
      applicant: applicant
    )
  end

  test 'GET /api/applications' do
    CrimeApplication.expects(:all).returns(
      stub(limit: [@crime_application])
    )

    get '/api/applications'

    assert_response :success

    assert_equal JSON.parse(response.body).first['id'], @uuid
  end

  test 'GET /api/applications/:id' do
    CrimeApplication.expects(:find).returns(@crime_application)

    get "/api/applications/#{@uuid}"

    # returns 451 and errors if the application does not match schema
    assert_response 451
    assert_match 'address_line_one must be a string', response.body
  end
end
