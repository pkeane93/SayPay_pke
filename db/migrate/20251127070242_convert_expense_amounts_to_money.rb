class ConvertExpenseAmountsToMoney < ActiveRecord::Migration[7.1]
  def change
    # 1. Rename float columns → temporary names
    rename_column :expenses, :local_amount, :local_amount_float
    rename_column :expenses, :base_amount, :base_amount_float

    # 2. Add new integer columns for cents
    add_monetize :expenses, :local_amount
    add_monetize :expenses, :base_amount

    # 3. Remove the old float columns
    remove_column :expenses, :local_amount_float, :float
    remove_column :expenses, :base_amount_float, :float
  end
end
