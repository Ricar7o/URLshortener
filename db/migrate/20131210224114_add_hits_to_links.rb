class AddHitsToLinks < ActiveRecord::Migration
  def change
    change_table :links do |t|
      t.integer   :hits, default: 0
    end
  end
end
