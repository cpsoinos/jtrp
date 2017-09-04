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

  task :build_statement_items => :environment do

    statements = Statement.includes(account: :items).all
    puts "Migrating #{statements.count} statements to the new item-statement relational schema..."

    bar = RakeProgressbar.new(statements.count)
    statements.each do |statement|
      Statements::ItemGatherer.new(statement, statement.account).execute
      bar.inc
    end

  end

  task :czerepak_second_june_statement => :environment do

    items = Item.where(id: [9572, 9562, 9561, 9565])
    account = Account.find('czerepak')

    puts "Creating second June statement for Czerepak..."
    statement = account.statements.create(date: DateTime.parse("June 15, 2017"))

    puts "Adding the specified items to this statement..."
    statement.items << items

    puts "Finished. Verify at #{statement.object_url}"

  end

end
