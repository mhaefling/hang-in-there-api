require 'rails_helper'

describe "Unmotivational Posters API", type: :request do
  before(:each) do
    Poster.create(  
      name: "FAILURE", 
      description: "Why bother trying? It's probably not worth it.",
      price: 68.00,
      year: 2019,
      vintage: true,
      img_url: "./assets/failure.jpg")
  
      Poster.create(
      name: "MEDIOCRITY",
      description: "Dreams are just that—dreams.",
      price: 127.00,
      year: 2021,
      vintage: false,
      img_url: "./assets/mediocrity.jpg")
  
      Poster.create(
      name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "./assets/regret.jpg")
  end

  it "sends a list of unmotivational posters" do
    get '/api/v1/posters'

    expect(response).to be_successful

    posters = JSON.parse(response.body, symbolize_names: true)
    expect(posters[:data].count).to eq(3)
    
    posters[:data].each do |poster|
      expect(poster).to have_key(:id)
      expect(poster[:id]).to be_an(Integer)
      
      expect(poster).to have_key(:type)
      expect(poster[:type]).to be_an(String)
      
      expect(poster).to have_key(:attributes)
      expect(poster[:attributes]).to be_an(Hash)
      
      expect(poster[:attributes]).to have_key(:name)
      expect(poster[:attributes][:name]).to be_a(String)
      
      expect(poster[:attributes]).to have_key(:price)
      expect(poster[:attributes][:price]).to be_a(Float)
      
      expect(poster[:attributes]).to have_key(:year)
      expect(poster[:attributes][:year]).to be_a(Integer)
      
      expect(poster[:attributes]).to have_key(:vintage)
      expect(poster[:attributes][:vintage]).to be_in([true, false])
      
      expect(poster[:attributes]).to have_key(:img_url)
      expect(poster[:attributes][:img_url]).to be_a(String)
    end
  end
  
  it "can send a poster by its id" do
    id = Poster.create(
      name: "DEFEAT",
      description: "It's too late to start now.",
      price: 35.00,
      year: 2023,
      vintage: false,
      img_url:  "./assets/defeat.jpg").id
      
      get "/api/v1/posters/#{id}"
      
      poster = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      
      test_poster = poster[:data]
      expect(test_poster).to have_key(:id)
      expect(test_poster[:id]).to be_an(Integer)

      expect(test_poster).to have_key(:type)
      expect(test_poster[:type]).to be_an(String)

      expect(test_poster).to have_key(:attributes)
      expect(test_poster[:attributes]).to be_an(Hash)

      expect(test_poster[:attributes]).to have_key(:name)
      expect(test_poster[:attributes][:name]).to be_a(String)

      expect(test_poster[:attributes]).to have_key(:price)
      expect(test_poster[:attributes][:price]).to be_a(Float)

      expect(test_poster[:attributes]).to have_key(:year)
      expect(test_poster[:attributes][:year]).to be_a(Integer)

      expect(test_poster[:attributes]).to have_key(:vintage)
      expect(test_poster[:attributes][:vintage]).to be_in([true, false])

      expect(test_poster[:attributes]).to have_key(:img_url)
      expect(test_poster[:attributes][:img_url]).to be_a(String)
  end

  it "can create a new poster" do
    poster_params = {
      name: "FUTILITY",
      description: "You're not good enough.",
      price: 150.00,
      year: 2016,
      vintage: false,
      img_url:  "./assets/futility.jpg"
    }

    headers = { "CONTENT_TYPE" => "application/json" }
  
    post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)
    new_poster = Poster.last
  
    expect(response).to be_successful
    expect(new_poster[:name]).to eq(poster_params[:name])
    expect(new_poster[:description]).to eq(poster_params[:description])
    expect(new_poster[:price]).to eq(poster_params[:price])
    expect(new_poster[:year]).to eq(poster_params[:year])
    expect(new_poster[:vintage]).to eq(poster_params[:vintage])
    expect(new_poster[:img_url]).to eq(poster_params[:img_url])
  end
end