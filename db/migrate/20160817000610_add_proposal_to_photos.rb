class AddProposalToPhotos < ActiveRecord::Migration
  def change
    add_reference :photos, :proposal, index: true, foreign_key: true
  end
end
