class PdfService

  def save_page_count(object)
    resp = Cloudinary::Api.resource(object.pdf.file.public_id, pages: true)
    page_count = resp["pages"]
    object.pdf_pages = page_count
    object.save
  end

end
