# frozen_string_literal: true

# The invoice model
class Invoice < ApplicationRecord
  before_validation :generate_invoice_number, on: :create

  belongs_to :lender, optional: true
  belongs_to :borrower

  enum status: { created: 0, rejected: 1, approved: 2, purchased: 3, closed: 4 }

  validates :invoice_number, presence: true, uniqueness: true
  validates :invoice_amount, presence: true, numericality: { greater_than: 0 }
  validates :invoice_due_date, presence: true
  validates :status, presence: true

  has_one_attached :invoice_image

  private

  def generate_invoice_number
    self.invoice_number ||= loop do
      random_code = rand(100_000..999_999)
      break random_code unless Invoice.exists?(invoice_number: random_code)
    end
  end
end
