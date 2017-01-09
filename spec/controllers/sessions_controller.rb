require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  it 'does not log in a user with a non-existant username' do
    post :create, administrator: { email: 'notauser@example.com', password: '1234' }

    expect(response).to render_template(:new)
  end

  it 'does not log in with the wrong password' do
    admin = Administrator.create!(email: 'email@example.com', password: 'Pa$$w0rd')
    post :create, administrator: { email: admin.email, password: '1234' }

    expect(response).to render_template(:new)
  end

  it 'logs in with the right email and password' do
    password = 'Pa$$w0rd'
    admin = Administrator.create!(email: 'email@example.com', password: password)
    post :create, administrator: { email: admin.email, password: password }

    expect(response).to redirect_to(root_path)
  end
end

