# encoding: utf-8

#  Copyright (c) 2012-2020, CVP Schweiz. This file is part of
#  hitobito_cvp and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cvp.

class AddAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :street_short, null: false
      t.string :street_short_old, null: false
      t.string :street_long, null: false
      t.string :street_long_old, null: false
      t.string :town, null: false
      t.integer :zip_code, null: false
      t.string :state, null: false
      t.text :numbers
    end
    add_index :addresses, [:street_short, :street_long, :street_short_old, :street_long_old, :zip_code], name: :addresses_street_names
  end
end
