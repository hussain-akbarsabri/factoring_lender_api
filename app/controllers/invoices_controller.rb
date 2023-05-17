# frozen_string_literal: true

# InvoicesController
class InvoicesController < ApplicationController
  def create
    borrower = Borrower.find(params[:borrower_id])
    invoice = borrower.invoices.build(invoice_params)

    if invoice.save
      render json: invoice, status: :created
    else
      render json: invoice.errors, status: :unprocessable_entity
    end
  end

  def assign_invoice
    invoice = Invoice.find(params[:id])
    lender = Lender.find(params[:lender_id])
    invoice.update(lender:)
    render json: invoice, status: :ok
  end

  private

  def invoice_params
    params.permit(:invoice_amount, :invoice_due_date, :invoice_image)
  end
end
