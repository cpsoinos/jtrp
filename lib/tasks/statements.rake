namespace :statements do

  task :remove_duplicates => :environment do |task|

    puts "Compiling duplicate statements..."

    accounts = Account.joins(:statements).merge(Statement.all)
    months = Statement.all.map { |s| s.date.month }.uniq.compact

    accounts.each do |account|
      months.each do |month|
        this_month_statements = account.statements.map { |s| s if s.date.month == month + 1 }.compact
        if this_month_statements.length > 1
          kept_statement = this_month_statements.shift
          this_month_statements.map(&:destroy)
        end
      end
    end
    
  end

end
