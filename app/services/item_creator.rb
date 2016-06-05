class ItemCreator

  attr_reader :proposal

  def initialize(proposal)
    @proposal = proposal
  end

  def create(attrs)
    initial_photo_attrs = attrs.delete(:initial_photos)
    listing_photo_attrs = attrs.delete(:listing_photos)

    @item = proposal.items.new(attrs)
    if @item.save
      process_photos(initial_photo_attrs, "initial") if initial_photo_attrs
      process_photos(listing_photo_attrs, "listing") if listing_photo_attrs
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
