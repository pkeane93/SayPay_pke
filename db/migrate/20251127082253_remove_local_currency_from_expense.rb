class RemoveLocalCurrencyFromExpense < ActiveRecord::Migration[7.1]
  def change
    remove_column :expenses, :local_currency, :string
  end
end
