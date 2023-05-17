# frozen_string_literal: true

# InvoiceSerializer
class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :invoice_number, :invoice_amount, :invoice_due_date, :status, :invoice_image, :lender, :borrower

  def invoice_image
    object.invoice_image.attributes.merge(url: Cloudinary::Utils.cloudinary_url(object.invoice_image.key)) if object.invoice_image.attached?
  end

  def lender
    UserSerializer.new(object.lender) if object.lender
  end

  def borrower
    UserSerializer.new(object.borrower)
  end
end
