namespace :companies do

  task :fill_social_accounts => :environment do |task|

    company = Company.jtrp
    company.facebook_page = "justtherightpiece"
    company.twitter_account = "@JtRP_furniture"
    company.instagram_account = "justtherightpiece"
    company.google_plus_account = "+JusttheRightPieceSalem"
    company.linkedin_account = "just-the-right-piece"
    company.yelp_account = "just-the-right-piece-salem"
    company.houzz_account = "jtrp"
    company.pinterest_account = "justtherightpce"
    company.save

  end

end
