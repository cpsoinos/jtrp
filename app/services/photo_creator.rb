class PhotoCreator

  attr_reader :base_object

  def initialize(base_object=nil)
    @base_object = base_object
  end

  def create_multiple(attrs)
    photo_attrs = attrs[:photos]
    return if photo_attrs.nil?
    photo_type = attrs[:photo_type]
    photo_attrs.map do |photo|
      photo_base.create!(photo: photo, photo_type: photo_type)
    end
  end

  private

  def photo_base
    @_photo_base ||= (base_object ? base_object.photos : Photo)
  end

end
