# This migration comes from noid_rails_engine (originally 20161021203429)
# frozen_string_literal: true

class RenameMinterStateRandomToRand < ActiveRecord::Migration[5.0]
  def change
    rename_column :minter_states, :random, :rand
  end
end
