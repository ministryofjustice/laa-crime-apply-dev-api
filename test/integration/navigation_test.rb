# frozen_string_literal: true

require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  test 'can get a list of applications' do
    CrimeApplication.expects(:all).returns(stub(limit: []))
    get '/api/applications'

    assert_response :success
  end
end
