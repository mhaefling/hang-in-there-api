class Api::V1::PostersController < ApplicationController
  def index
    if params[:sort] == 'desc'
      sort_order = 'desc'
    else
      sort_order = 'asc'
    end
    posters = Poster.order(created_at: sort_order)
    render json: PosterSerializer.format_posters(posters)
  end

  def show
    poster = Poster.find(params[:id])
    render json: {data: PosterSerializer.format_poster(poster)}
  end

  def create
    new_poster = Poster.create(poster_params)
    render json: PosterSerializer.format_poster(new_poster)
  end

  def update
    poster = Poster.find(params[:id])
    poster.update(poster_params)
    render json: {data: PosterSerializer.format_poster(poster)}
  end
  
  def destroy
    Poster.find(params[:id]).destroy
  end

  private

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end