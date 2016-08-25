namespace :agreements do
  task :convert_pdf => :environment do |task|

    puts "begin converting agreements to pdf"

    agreements = Agreement.all.map { |a| a if a.scanned_agreement.nil? }.compact

    bar = RakeProgressbar.new(agreements.count)

    agreements.each do |agreement|
      PdfGeneratorJob.perform_later(agreement)
      bar.inc
    end

    bar.finished

    puts "finished converting #{agreements.count} agreements to pdf"
  end

end
