class ItemCreator

  attr_reader :proposal

  def initialize(proposal=nil)
    @proposal = proposal
  end

  def create(attrs)
    @attrs = attrs
    photo_attrs = attrs.delete(:initial_photos)

    @item = creator.new(attrs)
    if @item.save
      process_photos(photo_attrs)
    end

    @item
  end

  private

  def process_photos(photo_attrs)
    photo_attrs.each do |photo|
      @item.photos.create!(photo: photo, photo_type: "initial")
    end
  end

  def creator
    if proposal
      proposal.items
    else
      Item
    end
  end

end
