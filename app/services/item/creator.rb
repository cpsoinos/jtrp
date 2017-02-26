class Item::Creator

  attr_reader :proposal, :account

  def initialize(proposal)
    @proposal = proposal
    @account = @proposal.account
  end

  def create(attrs)
    initial_photo_attrs = attrs.delete(:initial_photos)
    listing_photo_attrs = attrs.delete(:listing_photos)
    if attrs[:account_item_number].blank?
      attrs[:account_item_number] = account.last_item_number + 1
    end

    if attrs[:parent_item_id].present?
      @item = Item.find(attrs[:parent_item_id]).build_child_item
      @item.update(attrs)
      deactivate_parent_item
    else
      @item = proposal.items.new(attrs)
    end

    if @item.description.nil?
      @item.description = "Item No. #{@item.account_item_number}"
    end

    if @item.save
      check_category
      process_photos(initial_photo_attrs, "initial") if initial_photo_attrs
      process_photos(listing_photo_attrs, "listing") if listing_photo_attrs
      account.save
    end

    @item
  end

  private

  def process_photos(photo_attrs, type)
    photo_attrs.reject! { |p| p.empty? }
    photos = Photo.where(id: photo_attrs)
    photos.update_all(item_id: @item.id, photo_type: type)
  end

  def deactivate_parent_item
    @item.parent_item.mark_inactive
  end

  def check_category
    if @item.category.nil?
      @item.category = Category.find_by(name: "Uncategorized")
      @item.save
    end
  end

end
