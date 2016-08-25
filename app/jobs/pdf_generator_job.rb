class PdfGeneratorJob < ActiveJob::Base
  queue_as :default

  attr_reader :object

  def perform(object)
    @object = object
    generate_pdf
  end

  private

  def generate_pdf
    @_pdf = PdfGenerator.new(object).render_pdf
  end

end
