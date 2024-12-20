class Poster < ApplicationRecord

  def self.sorted(order)
    if order == 'desc'
      sort_order = 'desc'
    else
      sort_order = 'asc'
    end
    
    Poster.order(created_at: sort_order)
  end

  def self.sort_by_name(name)
    return Poster.where("name ILIKE ?", "%#{name}%").order(:name)
  end

  def self.sort_by_min_price(price)
    return Poster.where("price >= ?", price.to_f)
  end

  def self.sort_by_max_price(price)
    return Poster.where("price <= ?", price.to_f)
  end
end