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
    ["Account Item No.", "Amount"]
  end

  def purchase_invoice_values(item)
    {
      "Account Item No."          =>  item.account_item_number,
      "Amount"                    =>  humanized_money_with_symbol(item.purchase_price)
    }
  end

  def general_headers
    if current_user.try(:internal?)
      ["Account Item No.", "JTRP No.", "Consignment Rate", "Listing Price", "Min. Sale Price", "Sale Date", "Sale Price"]
    else
      ["Price"]
    end
  end

  def general_values(item)
    if current_user.try(:internal?)
      {
        "Account Item No."          =>  item.account_item_number,
        "JTRP No."                  =>  item.jtrp_number || "N/A",
        "Consignment Rate"          =>  (item.consigned? ? "#{item.consignment_rate}%" : "N/A"),
        "Listing Price"             =>  humanized_money_with_symbol(item.listing_price),
        "Min. Sale Price"           =>  humanized_money_with_symbol(item.minimum_sale_price),
        "Sale Date"                 =>  ((item.sold? && item.sold_at.present?) ? "<h4>#{item.sold_at.strftime('%-m/%-d/%y')}</h4>".html_safe : ""),
        "Sale Price"                =>  (item.sold? ? "<h4>#{humanized_money_with_symbol(item.sale_price)}</h4>".html_safe : ""),
      }
    else
      {
        "Price"                     =>  "<h4>#{humanized_money_with_symbol(item.listing_price)}</h4>".html_safe
      }
    end
  end

end
