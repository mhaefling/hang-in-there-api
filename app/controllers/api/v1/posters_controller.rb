class Api::V1::PostersController < ApplicationController
  def index
    if params[:sort] == 'desc'
      sort_order = 'desc'
    else
      sort_order = 'asc'
    end
    posters = Poster.order(created_at: sort_order)
    
    if params[:name].present?
      posters = Poster.where("name ILIKE ?", "%#{params[:name]}%")
    elsif params[:min_price].present?
      posters = Poster.where("price >= ?", params[:min_price].to_f)
    elsif params[:max_price].present?
      posters = Poster.where("price <= ?", params[:max_price].to_f)
    else
      posters = Poster.all
    end

    render json: PosterSerializer.format_posters(posters)
  end

  def show
    poster = Poster.find(params[:id])
    render json: PosterSerializer.single_poster_json(poster)
  end

  def create
    new_poster = Poster.create(poster_params)
    render json: PosterSerializer.format_poster(new_poster)
  end

  def update
    poster = Poster.find(params[:id])
    poster.update(poster_params)
    render json: PosterSerializer.single_poster_json(poster)
  end
  
  def destroy
    Poster.find(params[:id]).destroy
  end

  private

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end