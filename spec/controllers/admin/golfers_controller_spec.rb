require 'rails_helper'

RSpec.describe Admin::GolfersController, type: :controller do
  it 'requires a logged in user' do
    get :index
    expect(response).to redirect_to(new_session_path)
  end
end
