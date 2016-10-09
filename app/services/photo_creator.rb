class PhotoCreator

  attr_reader :proposal

  def initialize(proposal)
    @proposal = proposal
  end

  def create_multiple(attrs)
    photo_attrs = attrs[:photos]
    return if photo_attrs.nil?
    photo_type = attrs[:photo_type]
    photo_attrs.each do |photo|
      proposal.photos.create!(photo: photo, photo_type: photo_type)
    end
  end

end
