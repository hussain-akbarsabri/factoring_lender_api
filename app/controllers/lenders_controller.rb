# frozen_string_literal: true

# LendersController
class LendersController < ApplicationController
  def index
    render json: Lender.all, status: :ok
  end

  def lender_invoices
    lender = Lender.find(params[:id])
    render json: lender.invoices, status: :ok
  end
end
