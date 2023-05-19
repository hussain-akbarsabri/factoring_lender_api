# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { User.create(email: 'test@example.com', password: 'password', name: 'John Doe', role_type: 'lender') }
  let(:lender) { User.create(email: 'test1@example.com', password: 'password', name: 'John Doe', role_type: 'lender') }
  let(:borrower) { User.create(email: 'test2@example.com', password: 'password', name: 'John Doe', role_type: 'borrower') }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new invoice' do
        expect do
          post :create, params: { invoice_amount: 100, invoice_due_date: Date.today, borrower_id: borrower.id }
        end.to change(Invoice, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity' do
        expect do
          post :create, params: { invoice_amount: -100, invoice_due_date: Date.today, borrower_id: borrower.id }
        end.not_to change(Invoice, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let(:invoice) { Invoice.create(invoice_amount: 100, invoice_due_date: Date.today, borrower_id: borrower.id) }

    it 'updates the status of the invoice' do
      patch :update, params: { id: invoice.id, status: 'approved' }

      invoice.reload
      expect(invoice.status).to eq('approved')
      expect(response).to have_http_status(:ok)
    end

    it 'returns unprocessable entity if status update fails' do
      patch :update, params: { id: invoice.id, status: 'invalid_status' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid status')
    end
  end

  describe 'GET #index' do
    let!(:invoice1) { Invoice.create(invoice_amount: 100, invoice_due_date: Date.today, borrower_id: borrower.id) }
    let!(:invoice2) { Invoice.create(invoice_amount: 200, invoice_due_date: Date.today, borrower_id: borrower.id) }

    context 'without filtering parameters' do
      it 'returns all invoices' do
        get :index

        invoices = JSON.parse(response.body)
        expect(invoices.length).to eq(2)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with lender_id parameter' do
      let!(:invoice3) { Invoice.create(invoice_amount: 300, invoice_due_date: Date.today, borrower_id: borrower.id, lender_id: lender.id) }

      it 'returns invoices associated with the lender' do
        get :index, params: { lender_id: lender.id }

        invoices = JSON.parse(response.body)
        expect(invoices.length).to eq(1)
        expect(invoices.first['id']).to eq(invoice3.id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with borrower_id parameter' do
      it 'returns invoices associated with the borrower' do
        get :index, params: { borrower_id: borrower.id }

        invoices = JSON.parse(response.body)
        expect(invoices.length).to eq(2)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
