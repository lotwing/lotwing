class AddModelCodeToDeal < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :model_code, :string
  end
end
