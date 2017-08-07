class PdfGeneratorJob < ApplicationJob
  queue_as :default

  attr_reader :object

  def perform(options)
    @object = options[:object_type].constantize.find(options[:object_id])
    generate_pdf
  end

  private

  def generate_pdf
    @_pdf = PdfGenerator.new(object).render_pdf
  end

end
