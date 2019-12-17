# frozen_string_literal: true

RSpec.shared_examples 'has password' do
  specify do
    user.password = '123'
    expect(user.correct_password?('123')).to be_truthy
    expect(user.correct_password?('321')).to be_falsey

    user.password = '321'
    expect(user.correct_password?('123')).to be_falsey
    expect(user.correct_password?('321')).to be_truthy
  end
end

RSpec.shared_examples 'has token' do
  specify do
    expect { user.regenerate_token }.to change(user, :token)
  end
end
