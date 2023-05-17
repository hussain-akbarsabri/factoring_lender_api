# frozen_string_literal: true

# InvoicePolicy
class InvoicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    borrower?
  end

  def assign_invoice?
    borrower?
  end

  private

  def lender?
    @user.lender?
  end

  def borrower?
    @user.borrower?
  end
end
