# frozen_string_literal: true

# InvoicesController
class InvoicesController < ApplicationController
  before_action :authorize_invoice, only: [:assign_invoice]
  before_action :find_invoice, only: %i[assign_invoice update]

  def index
    invoices = if params[:lender_id]
                 Lender.find(params[:lender_id]).invoices
               elsif params[:borrower_id]
                 Borrower.find(params[:borrower_id]).invoices
               else
                 Invoice.all
               end
    render json: invoices, status: :ok
  end

  def create
    invoice = Invoice.new(invoice_params)

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

  def update
    invoice = Invoice.find(params[:id])
    if invoice.update(status: params[:status])
      render json: invoice, status: :ok
    else
      render json: { error: invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_invoice
    Invoice.find(params[:id])
  end

  def invoice_params
    params.permit(:invoice_amount, :invoice_due_date, :invoice_image, :borrower_id)
  end

  def authorize_invoice
    authorize Invoice
  end
end
