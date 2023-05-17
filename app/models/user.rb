# frozen_string_literal: true

# User
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum role_type: { lender: 0, borrower: 1 }

  has_many :invoices, dependent: :restrict_with_exception
end
