# frozen_string_literal: true

# BorrowersController
class BorrowersController < ApplicationController
  def borrower_invoices
    borrower = Borrower.find(params[:id])
    render json: borrower.invoices, status: :ok
  end
end
