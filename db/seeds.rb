require 'factory_girl_rails'
require 'faker'

def create_company
  Company.find_or_create_by!(
    name: "Just the Right Piece",
    slogan: "The best second-hand furniture you can find!",
    description:
    "<h1><b>Client Services</b></h1>\r\n<p><br></p>\r\n<p>Are you selling your home or moving from your apartment? Do you have several pieces of furniture and accessories you don’t know what to do with? Or do you have a home stager who’s telling you certain items must go for a proper staging to sell your house? If so, then Just the Right Piece is just the right company to help you out!</p>\r\n<p><br></p>\r\n<p><b>What we do:</b></p>\r\n<p><br></p>\r\n<p>We are much more than just a quality used furniture store. We offer a wide variety of services that other furniture stores do not. <u>We specialize in assisting home owners who are selling their houses (or renters who are moving) to do whatever it is they want with their furniture.</u> We have our own movers and box truck, so you can conduct all your business with us from the comfort of your own home.</p>\r\n<p><br></p>\r\n<p>If you would like to sell some furniture, we can buy it directly from you or sell it for you on consignment. If you want to donate some furniture, you can select a charity of your choice from our list of local charities, and we can take it there for you and give you a tax-deductible receipt in return. If you want to get rid of some worthless furniture, we can take it to the dump. If you want to keep some furniture, we can move it for you to your new home or to a storage unit (local moves only). The choice would be up to you, on an item by item basis.</p>\r\n<p><br></p>\r\n<p>To help you get started, we offer a free in-home consultation where you can ask us any questions you may have, show us your furniture, and discuss what it is you would like to do with each item.</p>\r\n<p><br></p>\r\n<p><b>Why consign with us?</b></p>\r\n<p><br></p>\r\n<ul>\r\n<li>We work with you in the comfort of your own home</li>\r\n<li>We can load the furniture from your house and transport it to the store for you</li>\r\n<li><span>We offer a competitive <b>50/50</b> consignment rate, and may offer you an even lower rate on some specified high-value items</span></li>\r\n<li>We stage your items in our 4,000+ square foot modern showroom in Salem, NH’s prime high-traffic shopping district - route 28</li>\r\n<li>We research each item to determine the best asking price and lowest price we would accept for it</li>\r\n<li>We strive to sell every item in a short period of time by pricing them to sell quickly and by negotiating with buyers</li>\r\n<li>We aggressively pursue buyers by advertising each item with photos on craigslist and numerous smartphone apps</li>\r\n<li>We keep you well-informed with detailed documentation filled with photos and information for each item on consignment and each item sold</li>\r\n</ul>\r\n<p><br></p>\r\n<p><b>Items that we consign:</b></p>\r\n<p><br></p>\r\n<p>We consign only furniture and accessories that are in suitable condition for resale and typically have a probable resale value of at least $40. If an item has scratches, dents, or stains, or just looks old and worn, then it’s probably not in suitable condition for resale. We do not consign mattresses, bedding, window treatments, appliances, tools, electronics, clothing, jewelry, toys, or books.</p>\r\n<p><br></p>\r\n<p><b>How we sell on consignment:</b></p>\r\n<p><br></p>\r\n<p>Unlike traditional consignment shops that just place consigned items in their cramped overstuffed shops, we showcase them in a beautiful modern showroom. But we don’t stop there - we take the extra step of aggressively pursuing buyers by advertising each item from our cellphones with photos, descriptions, and attractive prices on craigslist and numerous apps that target local consumers, such as OfferUp, Close5, Letgo, etc. These apps enable customers to respond to individual items with the tap of a button on their phone. Buyer responses can occur within minutes of listing an item for sale. We keep our phones on us at all times and immediately respond to each buyer response as it comes in. A buyer response could be an offer to purchase at the listed price, an offer to purchase at a lower price, a question, or a request to see the item in person. Our phones are constantly dinging and ka-chinging from customer responses! A ka-ching on our phones can mean a ka-ching in your pocket!&nbsp; Please see our Consignment Policies for more details.</p>\r\n<p><br></p>\r\n<p><b>Our Process:</b></p>\r\n<p><br></p>\r\n<p><u>Step 1 - In-Home Consultation:</u>&nbsp; The first step would be a free in-home consultation. We will meet with you at your house, where we can tell you about the services that we have to offer and can answer any questions you may have. You can show us each item of furniture (or accessory) and discuss what it is you would like to do with it. We will also take photos of the items that we can later use in a proposal to you.</p>\r\n<p><br></p>\r\n<p><u>Step 2 - Research:</u>&nbsp; After the free in-home consultation, we will do some research on each item to determine its value. We will determine a purchase price that we will offer to buy the item directly from you. We will also determine pricing for consignment - an “original asking price” that we will initially advertise the item for and a “minimum sale price” that would be the lowest price we will sell the item for. Our goal is to sell most items within a couple of weeks of listing them, so our pricing will be set accordingly (please do not compare our prices to prices of items listed on eBay - we do not sell on eBay; we sell locally at prices set to sell quickly!). We generally set an original asking price that is higher than what we’d expect to be able to sell the item for, but low enough to attract attention, and a minimum sale price at about 50% less. That leaves us plenty of room to negotiate with buyers. If an item isn’t selling, we will mark it down 10% after 30 days, and another 10% after 60 days.</p>\r\n<p><br></p>\r\n<p><u>Step 3 - Proposal:</u>&nbsp; After we’ve done our research, we will prepare a proposal for you containing photos and descriptions of each item with an offer to purchase at a stated purchase price and, alternatively, an offer to consign at a stated original asking price and minimum sale price. We will also prepare a Proposal Response form which will contain a photo and description of each item with a set of checkboxes where you can select whether you would like to sell the item to us at our purchase offer price, consign it with us at our consignment pricing, request our services to donate it to a local charity, bring it to the dump, or move it to another location, or do nothing with it. We will then email or mail these to you, and eagerly await your response.</p>\r\n<p><br></p>\r\n<p><u>Step 4 - Purchase Invoice, Consignment Agreement, and Charitable Donation Service Order:</u>&nbsp; Once you’ve let us know what you want to do with each item, we will then prepare and send you the appropriate following documents for your signature:</p>\r\n<ul>\r\n<li>if selling items to us - Purchase Invoice</li>\r\n<li>if consigning items with us - Consignment Agreement</li>\r\n<li>if requesting our donation to a local charity service - Charitable Donation Service Order</li>\r\n<li>if requesting our moving service or disposal service - no documents required</li>\r\n</ul>\r\n<p><br></p>\r\n<p><u>Step 5 - Schedule Pick-up:</u>&nbsp; Then we schedule a date and time to get your furniture and take it to wherever it’s going. There is a charge for this, however. We provide 2 movers and a box truck for $100 per hour, calculated in 15-minute increments from the time they arrive at your house until the time they leave (if your home is outside of our local service area, you may be charged an additional travel charge). See our Service Rate Schedule for more details. When we receive or pick up any items we are purchasing from you, we will at that time give you a check for those items.</p>\r\n<p><br></p>\r\n<p><u>Step 6 - Consignment:</u>&nbsp; If you are consigning any items with us, we will bring them to our store, clean them up, take new photos, place them in our showroom, and advertise them with photos, descriptions, and prices on our apps and/or craigslist. We will mail you a check for your portion of total sales each month on or before the 10th of the following month, along with a description, price, and consignment fee for each item sold.</p>",
    address_1: "369 South Broadway",
    address_2: "",
    city: "Salem",
    state: "NH",
    zip: "03079",
    phone: "(978) 835-8015",
    phone_ext: "",
    website: nil,
    logo: nil,
    consignment_policies:
    "<h1><b>Consignment Policies</b></h1>\r\n<p><br></p>\r\n<ul>\r\n<li><span><b>consignors:</b>&nbsp; You must be at least 18 years old to consign with us and you must own the items you consign.<br>\r\n</span></li>\r\n<li><span><b>consignable items:&nbsp; </b>We consign only furniture and accessories that are in suitable condition for resale and typically have a probable resale value of at least $40. If an item has scratches, dents, or stains, or just looks old and worn, then it’s probably not in suitable condition for resale. We do not consign mattresses, bedding, window treatments, appliances, tools, electronics, clothing, jewelry, toys, or books.<br>\r\n</span></li>\r\n<li><span><b>control of consigned items:</b>&nbsp; If you consign an item with us, we need to have the item in our possession and under our control. You would still own the item, but you’d be giving us the exclusive right to sell the item for you.<br>\r\n</span></li>\r\n<li><span><b>delivery of items to our store:</b>&nbsp; We will be happy to remove the items from your house and bring them to our store for a moving charge as stated in our Client Moving Services document.<br>\r\n</span></li>\r\n<li><span><b>consignment fee:</b>&nbsp; We’ll sell your consigned items for a <b>50/50 split</b> of the sale proceeds. This is a pretty standard consignment rate in this area. If you have a very high-value item, we may be willing to consign that item at an even lower rate.<br>\r\n</span></li>\r\n<li><span><b>consignment period:</b>&nbsp; Your items would be consigned for <b>90 days</b>. Near the end of the consignment period, we will send you an email stating that your contract is about to expire. Upon expiration, you’ll have 10 days to retrieve it, or you could simply leave it with us, at which point it would become our property. If you want us to deliver the items to you, you will be charged a delivery fee.<br>\r\n</span></li>\r\n<li><span><b>how we sell:</b>&nbsp; Unlike traditional consignment shops that just place consigned items in their shop and passively wait for a buyer to come in, we aggressively pursue buyers by advertising each item from our cellphones with photos, descriptions, and attractive prices on craigslist and numerous apps that target local consumers, such as OfferUp, Close5, Letgo, etc. These apps enable customers to respond to individual items with the tap of a button on their phone. Buyer responses can occur within minutes of listing an item for sale. We keep our phones on us at all times and immediately respond to each buyer response as it comes in. A buyer response could be an offer to purchase at the listed price, an offer to purchase at a lower price, a question, or a request to see the item in person. Our phones are constantly dinging and ka-chinging from customer responses! A ka-ching on our phones can mean a ka-ching in your pocket!<br>\r\n</span></li>\r\n<li><span><b>item price:</b>&nbsp; Our goal is to sell items within a couple weeks of advertising them. We set prices to sell quickly and we negotiate with buyers! Before we consign an item, we’ll examine it, do some research on it, and get back to you with an “original asking price” that we will initially advertise the item for and a “minimum sale price” that will be the lowest price we would sell an item for. The minimum sale price will typically be about 50% of the original asking price.<br>\r\n</span></li>\r\n<li><span><b>automatic markdowns:</b>&nbsp; If an item isn’t selling, it’s price is probably too high. So if an item hasn't sold after 30 days, we’ll start advertising it at 90% of the original asking price, and if it hasn’t sold after 60 days, we’ll start advertising it at 80% of the original asking price.</span></li><li><span><b>how we pay you:</b>&nbsp; We will mail you a check for your portion of total sales each month (after deducting our consignment fee), on or before the 10th of the following month. We’ll include with the check a summary of each item sold with its description, sale price, and consignment fee.<br>\r\n</span></li>\r\n<li><span><b>removal from consignment:</b>&nbsp; You may remove any or all of your items from consignment at any time during the consignment period subject to an early termination fee of 25% of the original asking price of the item. Since we put significant time and effort into advertising your items and deal with numerous customer responses on our phones, we unfortunately need to charge you for this expended time and effort. If you terminate early, you’ll have 10 days to retrieve your items.<br>\r\n</span></li>\r\n<li><span><b>item loss:</b>&nbsp; Unlike many consignment stores that state that items left in their possession is done so at your own risk, we will take that risk! If an Item is damaged, destroyed, or lost due to fire, water, theft, damage caused during moving, or any other cause while it is in our possession, we will reimburse you for the loss, up to a maximum of the minimum sale price for the item at the time of loss minus the consignment fee that would have been charged if the item had been sold on consignment.</span></li>\r\n</ul>",
    service_rate_schedule:
    "<h1><b>Service Rate Schedule</b></h1>\r\n<p><br></p>\r\n<p>(note: if you are a home stager, realtor, or broker, please see our <a target=\"_blank\" rel=\"nofollow\" href=\"http://localhost:3000/companies/1/agent_service_rate_schedule\">Service Rate Schedule for Agents</a>)</p>\r\n<p><br></p>\r\n<p><b>Standard Service (2 movers and a box truck)</b></p>\r\n<ul>\r\n<li>$100.00 per hour (1 hour minimum)</li>\r\n<ul>\r\n<li>additional movers - $50.00 per mover per hour (1 hour minimum)</li>\r\n</ul>\r\n<li>the time is calculated from the time the movers arrive at the home until the time they are finished at the home, and is rounded to the nearest 15 minute increment</li>\r\n<li>payment in full is required before the movers leave the home</li>\r\n<li>depending on the location, an additional travel charge may apply</li>\r\n<ul>\r\n<li>Service Area “A” - no charge</li>\r\n<ul>\r\n<li>NH: Atkinson, Pelham, Salem, Windham</li>\r\n<li>MA: Andover, Dracut, Haverhill, Lawrence, Lowell, Methuen, North Andover, Tewksbury</li>\r\n</ul>\r\n<li>Service Area “B” - additional $50.00</li>\r\n<ul>\r\n<li>NH: Derry, Hampstead, Hudson, Londonderry, Plaistow</li>\r\n<li>MA: Amesbury, Billerica, Boxford, Chelmsford, Georgetown, Groveland, Merrimac, Middleton, North Reading, Tyngsborough, West Newbury, Wilmington</li>\r\n</ul>\r\n<li>outside of Service Areas “A” and “B” - call for a quote</li>\r\n</ul>\r\n<li>if multiple trips are required (in the same day or over multiple days), each trip will be considered a new service, subject to a new 1 hour minimum and travel charge (if applicable)</li>\r\n</ul>\r\n<p><br></p>\r\n<p><b>Furniture Pick-up Service</b></p>\r\n<ul>\r\n<li>service: pick-up and transportation to our store of items you are selling to us or consigning with us</li>\r\n<li>Standard Service rate only</li>\r\n</ul>\r\n<p><br></p>\r\n<p><b>Charitable Donation Service</b></p>\r\n<ul>\r\n<li>service:&nbsp; pick-up and transportation of items to a local charity selected from our local charities list, and delivery to client of a tax-deductible receipt</li>\r\n<li>Standard Service rate + $100.00 per charity</li>\r\n<li>payment is required in advance</li>\r\n</ul>\r\n<p><br></p>\r\n<p><b>Disposal Service</b></p>\r\n<ul>\r\n<li>service:&nbsp; pick-up and transportation of items to the dump for disposal</li>\r\n<li>Standard Service rate + $100.00 + any fees charged by the dump</li>\r\n<li>$100.00 payment is required in advance; dump fees will be charged to client’s account</li>\r\n</ul>\r\n<p><br></p>\r\n<p><b>Moving Service</b></p>\r\n<ul>\r\n<li>service:&nbsp; local moving of items from home to a new home or storage unit</li>\r\n<li>Standard Service rate + $1.00 per mile from home to new location, however the time is calculated from the time the movers arrive at the home until the time they are finished at the new home or storage unit</li>\r\n<ul>\r\n<li>(the $1.00 per mile covers gas, insurance, and vehicle wear and tear)</li>\r\n</ul>\r\n<li>payment in full is required before the movers leave the new home or storage unit</li>\r\n</ul>\r\n<p><br></p>\r\n<p><b>Returned Consigned Items Service</b></p>\r\n<ul>\r\n<li>service:&nbsp; return consigned items that remain unsold after termination of the consignment agreement back to consignor (which could be to a new home or storage unit - local moves only)</li>\r\n<li>Standard Service rate, however, the time is calculated from the time the movers begin to load the furniture from the store onto the truck until the time they arrive at the home (or storage unit)</li>\r\n<li>payment in full is required before the movers remove the items from the truck</li>\r\n</ul>",
    agent_service_rate_schedule:
    "<h1><b>Service Rate Schedule for Agents</b></h1>\r\n<p><br></p>\r\n<ul>\r\n<li>for home stagers, realtors, and brokers</li>\r\n<li><b>box truck</b></li>\r\n<ul>\r\n<li>includes gasoline, truck insurance, and moving equipment</li>\r\n<li>$50.00 + $1.00 per mile</li>\r\n<li>our movers must drive the truck</li>\r\n</ul>\r\n<li><b>movers</b></li>\r\n<ul>\r\n<li>$40.00 per mover per hour (2 hour minimum)</li>\r\n<li>each mover’s time is calculated from the time he leaves the store until the time he arrives back to the store, and is rounded to the nearest 15 minute increment</li>\r\n</ul>\r\n</ul>",
    email: "cpsoinos@mac.com",
    team_email: "example_team_email@example.com",
    primary_contact: FactoryGirl.create(:internal_user)
  )
end

def create_categories
  Category.create([
    { name: "Bedroom" },
    { name: "Dining Room" },
    { name: "Living Room" },
    { name: "Uncategorized" }
  ])
end

def create_default_accounts
  yard_sale = Account.create(is_company: true, company_name: "Yard Sale")
  estate_sale = Account.create(is_company: true, company_name: "Estate Sale")
end

def create_default_photo
  Photo.create(photo_type: 'default', photo: File.open(File.join(Rails.root, 'app/assets/images/No_Image_Available.png')))
end

def create_admin
  FactoryGirl.create(:admin)
end

create_company
create_categories
create_default_accounts
create_default_photo
create_admin
