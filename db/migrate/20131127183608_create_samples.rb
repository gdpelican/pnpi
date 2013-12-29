class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.belongs_to :person
      t.belongs_to :job
      t.has_attached_file :sample
      t.string :name
      t.timestamps
    end    
  end
end
