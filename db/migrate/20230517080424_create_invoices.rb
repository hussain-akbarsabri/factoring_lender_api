# frozen_string_literal: true

# CreateInvoices
class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.string :invoice_number, null: false
      t.float :invoice_amount, null: false
      t.date :invoice_due_date, null: false
      t.integer :status, null: false, default: 0
      t.references :lender, foreign_key: { to_table: :users }
      t.references :borrower, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :invoices, :invoice_number, unique: true
  end
end
