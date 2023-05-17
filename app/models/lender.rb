# frozen_string_literal: true

# The lender model
class Lender < User
  default_scope -> { where(role_type: 'lender') }

  has_many :invoices, dependent: :nullify
end
