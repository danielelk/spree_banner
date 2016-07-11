class AddTargetBlank < ActiveRecord::Migration
  def change
    add_column :spree_banner_boxes, :target_blank, :boolean, :default => false
  end
end
