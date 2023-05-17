# frozen_string_literal: true

# The borrower model
class Borrower < User
  default_scope -> { where(role_type: 'borrower') }

  has_many :invoices, dependent: :restrict_with_exception
end
