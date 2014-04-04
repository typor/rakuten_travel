require 'spec_helper'

describe User do
  describe '#save' do
    it do
      u = User.new(email: 'foo@example.com', password: '12345678', password_confirmation: '12345678')
      expect { u.save }.to change(User, :count).by(1)
      expect(User.authenticate('foo@example.com', '12345678')).to be_present
      expect(User.authenticate('foo@example.com', '1234567')).to be_nil
    end
  end
end
