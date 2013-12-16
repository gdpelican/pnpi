class CreateCategories < ActiveRecord::Migration
  def change
    
    create_table :categories do |t|
      t.string :name
      t.string :type
    end
    
    create_table :categories_resources do |t|
      t.references :resource
      t.references :category
    end
    
    add_index :categories_resources, :resource_id
    add_index :categories_resources, :category_id
    
  end
end