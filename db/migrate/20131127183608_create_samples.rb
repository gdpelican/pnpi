class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.belongs_to :categories_resource
      t.has_attached_file :sample
      t.string :description
      t.timestamps
    end
    
    add_index :samples, :categories_resource_id
    
  end
end
