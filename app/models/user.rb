class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
  authenticates_with_sorcery!
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, presence: true, on: :create
  validates :password, confirmation: true, length: { minimum: 8, maxmum: 64 }, allow_blank: true
  validates :password_confirmation, presence: true, if: Proc.new{ password.present? }
end
