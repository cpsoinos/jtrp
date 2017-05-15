module ApplicationHelper

  def consignment_headers
    ["Account Item No.", "Period", "Starting Asking Price", "Starting Min. Price", "Consignment Fee"]
  end

  def consignment_values(item)
    {
      "Account Item No."          =>  item.account_item_number,
      "Period"                    =>  "90 days",
      "Starting Asking Price"     =>  humanized_money_with_symbol(item.listing_price),
      "Starting Min. Price"       =>  humanized_money_with_symbol(item.minimum_sale_price),
      "Consignment Fee"           =>  "#{item.consignment_rate}%"
    }
  end

  def purchase_invoice_headers
    ["SKU", "Account Item No.", "Amount"]
  end

  def purchase_invoice_values(item)
    {
      "SKU"               =>  item.id,
      "Account Item No."  =>  item.account_item_number,
      "Amount"            =>  humanized_money_with_symbol(item.purchase_price)
    }
  end

  def general_headers
    if current_user.try(:internal?)
      ["Account Item No.", "JTRP No.", "Consignment Rate", "Listing Price", "Min. Sale Price", "Sale Date", "Sale Price"]
    else
      ["Price"]
    end
  end

  def header_sort_values
    {
      "Account Item No."      =>  "account_item_number",
      "JTRP No."              =>  "jtrp_number",
      "Consignment Rate"      =>  "consignment_rate",
      "Listing Price"         =>  "listing_price_cents",
      "Min. Sale Price"       =>  "minimum_sale_price_cents",
      "Sale Date"             =>  "sold_at",
      "Sale Price"            =>  "sale_price_cents",
      "Price"                 =>  "listing_price_cents",
      "Period"                =>  "consignment_period",
      "Starting Asking Price" =>  "listing_price_cents",
      "Starting Min. Price"   =>  "minimum_sale_price_cents",
      "Consignment Fee"       =>  "consignment_rate",
      "SKU"                   =>  "id",
      "Item"                  =>  "description"
    }
  end

  def general_values(item)
    if current_user.try(:internal?)
      {
        "Account Item No."    =>  item.account_item_number,
        "JTRP No."            =>  (best_in_place item, :jtrp_number, place_holder: 'N/A'),
        "Consignment Rate"    =>  (item.consigned? ? "#{item.consignment_rate}%" : "N/A"),
        "Listing Price"       =>  humanized_money_with_symbol(item.listing_price),
        "Min. Sale Price"     =>  humanized_money_with_symbol(item.minimum_sale_price),
        "Sale Date"           =>  ((item.sold? && item.sold_at.present?) ? item.sold_at.strftime('%-m/%-d/%y') : ""),
        "Sale Price"          =>  (item.sold? ? humanized_money_with_symbol(item.sale_price) : ""),
      }
    else
      {
        "Price"               =>  humanized_money_with_symbol(item.listing_price)
      }
    end
  end

  def summary_headers
    ["SKU", "Account", "Amount"]
  end

  def summary_values(item)
    {
      "SKU"     => item.id,
      "Account" => (item.client_intention == "consign" ? item.account.short_name : "JTRP"),
      "Amount"  => "#{humanized_money_with_symbol(item.listing_price)}<br>
                   <i>#{item.discounts.present? ? humanized_money_with_symbol(item.discounts.first.amount) : ''}</i><br>
                   <b>#{humanized_money_with_symbol(item.sale_price)}</b>".html_safe
    }
  end

  def intentions_map
    {
      "consign"   => { display_name: "consigned", icon: "<i class='material-icons'>supervisor_account</i>", color: "secondary-primary" },
      "sell"      => { display_name: "owned", icon: "<i class='material-icons'>store</i>", color: "complement-primary" },
      "donate"    => { display_name: "will donate", icon: "<i class='fa fa-gift' aria-hidden='true'></i>", color: "secondary-darker" },
      "dump"      => { display_name: "will dump", icon: "<i class='material-icons'>delete</i>", color: "complement-darker" },
      "undecided" => { display_name: "undecided", icon: "<i class='fa fa-question' aria-hidden='true'></i>", color: "primary-lighter" },
      "nothing"   => { display_name: "client kept", icon: "<i class='material-icons'>weekend</i>", color: "primary-lighter" },
      "decline"   => { display_name: "client declined", icon: "<i class='material-icons'>weekend</i>", color: "primary-lighter" }
    }
  end

end
