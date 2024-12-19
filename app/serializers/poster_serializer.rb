class PosterSerializer
  def self.format_poster(poster)
    {
      id: poster.id,
      type: "poster",
      attributes: {
        name: poster.name,
        description: poster.description,
        price: poster.price,
        year: poster.year,
        vintage: poster.vintage,
        img_url: poster.img_url }
    }
  end
  
  def self.format_posters(posters)
    { data:
        posters.map do |poster|
          format_poster(poster)
        end,
      meta: {
        count: posters.count
      }
    }
  end

  def self.single_poster_json(poster)
    { data:
      format_poster(poster)
    }
  end
end