class PdfGeneratorJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

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
