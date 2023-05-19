# frozen_string_literal: true

# The invoice model
class Invoice < ApplicationRecord
  before_validation :generate_invoice_number, on: :create

  belongs_to :lender, optional: true
  belongs_to :borrower

  has_one_attached :invoice_image

  validates :invoice_number, presence: true, uniqueness: true
  validates :invoice_amount, presence: true, numericality: { greater_than: 0 }
  validates :invoice_due_date, presence: true
  validates :status, presence: true
  validate :approved_invoices_can_be_purchased
  validate :purchased_invoices_can_be_closed

  enum status: { created: 0, rejected: 1, approved: 2, purchased: 3, closed: 4 }

  private

  def generate_invoice_number
    self.invoice_number ||= loop do
      random_code = rand(100_000..999_999)
      break random_code unless Invoice.exists?(invoice_number: random_code)
    end
  end

  def approved_invoices_can_be_purchased
    return unless status == 'purchased' && status_was != 'approved'

    errors.add(:status, ': Only approved invoices can be purchased')
  end

  def purchased_invoices_can_be_closed
    return unless status == 'closed' && status_was != 'purchased'

    errors.add(:status, ': Only purchased invoices can be closed')
  end
end
