class PhotoUpdater

  attr_reader :photo

  def initialize(photo)
    @photo = photo
  end

  def update(attrs)
    if attrs[:primary].present?
      photo.item.photos.update_all(primary: nil)
      photo.update(attrs)
    end
  end

end
