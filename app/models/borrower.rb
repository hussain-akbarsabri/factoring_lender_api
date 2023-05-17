# frozen_string_literal: true

# The borrower model
class Borrower < User
  default_scope -> { where(role_type: 'borrower') }
end
