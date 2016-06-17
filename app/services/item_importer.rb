require 'restclient'

class ItemImporter

  attr_reader :proposal, :archive

  def initialize(proposal)
    @proposal = proposal
  end

  def import(archive)
    @archive = archive
    execute
  end

  private

  def zipfile
    @_zipfile ||= begin
      url = archive.archive.direct_fog_url(with_path: true)
      response = RestClient::Request.execute({url: url, method: :get, content_type: 'application/zip'})
      zipfile = Tempfile.new("downloaded")
      zipfile.binmode
      zipfile.write(response)
      zipfile
    end
  end

  def execute
    extract_entries
    group_by_item
    massage_attrs

    @massaged_attrs.each do |attrs|
      ItemCreator.new(@proposal).create(attrs)
    end
  end

  def extract_entries
    @entries ||= begin
      Zip::File.open(zipfile.path) do |zip_file|
        zip_file.entries.map do |entry|
          next if entry.name =~ /__MACOSX/ or entry.name =~ /\.DS_Store/ or !entry.file?
          entry
        end
      end
    end.compact
  end

  def group_by_item
    @items ||= begin
      @entries.group_by do |entry|
        entry.name.split("/").second
      end
    end
  end

  def massage_attrs
    @massaged_attrs ||= begin
      @items.map do |attrs, photos|
        {
          description: description(attrs),
          account_item_number: item_number(attrs),
          initial_photos: process_images(photos)
        }
      end
    end
  end

  def description(attrs)
    attrs.split("-").last
  end

  def item_number(attrs)
    attrs.split("-").shift.to_i
  end

  def process_images(entries)
    entries.map do |entry|
      data = entry.get_input_stream.read
      file = StringIO.new(data)
      file.class.class_eval { attr_accessor :original_filename, :content_type }
      file.original_filename = entry.name.split("/").last
      file.content_type = "image/#{entry.name.split('.').last}"
      file
    end
  end

end
