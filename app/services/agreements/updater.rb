module Agreements
  class Updater

    attr_reader :agreement

    def initialize(agreement)
      @agreement = agreement
    end

    def update(params)
      agreement.assign_attributes(params)
      pdf_changed = false
      if agreement.changed? && agreement.changes.include?("pdf")
        pdf_changed = true
      end
      if agreement.save
        if pdf_changed
          PdfService.new.save_page_count(agreement)
        end
        agreement.create_activity(:update, owner: agreement.updated_by)
      end
    end

  end
end
