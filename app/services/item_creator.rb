class ItemCreator

  attr_reader :proposal, :account

  def initialize(proposal)
    @proposal = proposal
    @account = @proposal.account
  end

  def create(attrs)
    initial_photo_attrs = attrs.delete(:initial_photos)
    listing_photo_attrs = attrs.delete(:listing_photos)
    if attrs[:account_item_number].blank?
      attrs[:account_item_number] = account.last_item_number += 1
    end

    @item = proposal.items.new(attrs)
    if @item.save
      process_photos(initial_photo_attrs, "initial") if initial_photo_attrs
      process_photos(listing_photo_attrs, "listing") if listing_photo_attrs
      account.save
    end

    @item
  end

  private

  def process_photos(photo_attrs, type)
    photo_attrs.each do |photo|
      @item.photos.create!(photo: photo, photo_type: type)
    end
  end

end
