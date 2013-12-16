class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.string :type
      t.text :description
      t.has_attached_file :picture
      t.text :details
      t.timestamps
    end
    
  end
end
