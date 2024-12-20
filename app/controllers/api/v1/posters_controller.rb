class Api::V1::PostersController < ApplicationController
  def index
    if params[:sort].present?
      posters = Poster.sorted(params[:sort])
    elsif params[:name].present?
      posters = Poster.sort_by_name(params[:name])
    elsif params[:min_price].present?
      posters = Poster.sort_by_min_price(params[:min_price])
    elsif params[:max_price].present?
      posters = Poster.sort_by_max_price(params[:max_price])
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
    render json: PosterSerializer.single_poster_json(new_poster)
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