class PosterSerializer
  def self.format_posters(posters)
    posters.map do |poster|
      format_poster(poster)
    end
  end

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
end