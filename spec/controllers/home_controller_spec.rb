# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #cities' do
    it 'returns http success' do
      get :cities
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #hospitals' do
    it 'returns http success' do
      get :hospitals
      expect(response).to have_http_status(:success)
    end
  end
end
