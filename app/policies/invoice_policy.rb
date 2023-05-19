# frozen_string_literal: true

# InvoicePolicy
class InvoicePolicy < ApplicationPolicy
  # Scope
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

  def update?
    lender?
  end

  private

  def lender?
    @user.lender?
  end

  def borrower?
    @user.borrower?
  end
end
