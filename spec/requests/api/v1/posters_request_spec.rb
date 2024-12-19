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
      expect(posters[:meta][:count]).to be_an(Integer)
      expect(posters[:meta][:count]).to eq(3)
    
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
    expect(new_poster[:name]).to eq("FUTILITY")
    expect(new_poster[:description]).to eq(poster_params[:description])
    expect(new_poster[:price]).to eq(poster_params[:price])
    expect(new_poster[:year]).to eq(poster_params[:year])
    expect(new_poster[:vintage]).to eq(poster_params[:vintage])
    expect(new_poster[:img_url]).to eq(poster_params[:img_url])
  end

  it "can update exiting poster" do
    id = Poster.create(
      name: "DEFEAT",
      description: "It's too late to start now.",
      price: 35.00,
      year: 2023,
      vintage: false,
      img_url:  "./assets/defeat.jpg").id

    headers = {"CONTENT_TYPE" => "application/json"}
    
    poster_params = {name:"DETERMINATION"}

    patch "/api/v1/posters/#{id}", headers: headers, params: JSON.generate({poster: poster_params})
    
    poster = Poster.find_by(id: id)
    
    expect(response).to be_successful
    expect(poster.name).to_not eq("DEFEAT")
    expect(poster.name).to eq("DETERMINATION")
  end

  it "can delete a poster"do
    poster = Poster.last
    
    delete "/api/v1/posters/#{poster.id}"
    
    expect(response).to be_successful
    expect(Poster.all).to_not include(poster)
  end

  it "can sort posters by created_at in ascending" do
    get '/api/v1/posters', params: {sort: 'asc'}
  
    expect(response).to be_successful
    posters = JSON.parse(response.body, symbolize_names: true)
  
    created_at_dates = posters[:data].map { |poster| poster[:attributes][:created_at] }
  
    expect(created_at_dates).to eq(created_at_dates.sort)
  end
  
  it "can sort posters by created_at in descending" do
    get '/api/v1/posters', params: {sort: 'desc'}
  
    expect(response).to be_successful
    posters = JSON.parse(response.body, symbolize_names: true)
  
    created_at_dates = posters[:data].map { |poster| poster[:attributes][:created_at] }
  
    expect(created_at_dates).to eq(created_at_dates.sort.reverse)
  end

  it "can fetch a poster by name" do

    get "/api/v1/posters?name=gre"
    expect(response).to be_successful

    poster = JSON.parse(response.body, symbolize_names: true)
    expect(poster[:data].count).to eq(1)
    expect(poster[:meta][:count]).to be_an(Integer)
    expect(poster[:meta][:count]).to eq(1)

    test_poster = poster[:data][0]

    expect(test_poster).to have_key(:id)
    expect(test_poster[:id]).to be_an(Integer)

    expect(test_poster).to have_key(:type)
    expect(test_poster[:type]).to be_an(String)
    expect(test_poster[:type]).to eq("poster")

    expect(test_poster).to have_key(:attributes)
    expect(test_poster[:attributes]).to be_an(Hash)

    expect(test_poster[:attributes]).to have_key(:name)
    expect(test_poster[:attributes][:name]).to be_a(String)
    expect(test_poster[:attributes][:name]).to eq("REGRET")

    expect(test_poster[:attributes]).to have_key(:price)
    expect(test_poster[:attributes][:price]).to be_a(Float)
    expect(test_poster[:attributes][:price]).to eq(89.00)

    expect(test_poster[:attributes]).to have_key(:year)
    expect(test_poster[:attributes][:year]).to be_a(Integer)
    expect(test_poster[:attributes][:year]).to eq(2018)

    expect(test_poster[:attributes]).to have_key(:vintage)
    expect(test_poster[:attributes][:vintage]).to be_in([true, false])
    expect(test_poster[:attributes][:vintage]).to eq(true)

    expect(test_poster[:attributes]).to have_key(:img_url)
    expect(test_poster[:attributes][:img_url]).to be_a(String)
    expect(test_poster[:attributes][:img_url]).to eq("./assets/regret.jpg")
  end

  it "can find multiple posters by name and return them in alphabetical order" do
    get "/api/v1/posters?name=re"
    expect(response).to be_successful

    poster = JSON.parse(response.body, symbolize_names: true)
    expect(poster[:data].count).to eq(2)
    expect(poster[:meta][:count]).to be_an(Integer)
    expect(poster[:meta][:count]).to eq(2)

    test_poster1 = poster[:data][0]
    test_poster2 = poster[:data][1]
    

    expect(test_poster1).to have_key(:id)
    expect(test_poster2).to have_key(:id)
    expect(test_poster1[:id]).to be_an(Integer)
    expect(test_poster2[:id]).to be_an(Integer)

    expect(test_poster1).to have_key(:type)
    expect(test_poster2).to have_key(:type)
    expect(test_poster1[:type]).to be_an(String)
    expect(test_poster2[:type]).to be_an(String)
    expect(test_poster1[:type]).to eq("poster")
    expect(test_poster2[:type]).to eq("poster")

    expect(test_poster1).to have_key(:attributes)
    expect(test_poster2).to have_key(:attributes)
    expect(test_poster1[:attributes]).to be_an(Hash)
    expect(test_poster2[:attributes]).to be_an(Hash)

    expect(test_poster1[:attributes]).to have_key(:name)
    expect(test_poster2[:attributes]).to have_key(:name)
    expect(test_poster1[:attributes][:name]).to be_a(String)
    expect(test_poster2[:attributes][:name]).to be_a(String)
    expect(test_poster1[:attributes][:name]).to eq("FAILURE")
    expect(test_poster2[:attributes][:name]).to eq("REGRET")


    expect(test_poster1[:attributes]).to have_key(:price)
    expect(test_poster2[:attributes]).to have_key(:price)
    expect(test_poster1[:attributes][:price]).to be_a(Float)
    expect(test_poster2[:attributes][:price]).to be_a(Float)
    expect(test_poster1[:attributes][:price]).to eq(68.00)
    expect(test_poster2[:attributes][:price]).to eq(89.00)

    expect(test_poster1[:attributes]).to have_key(:year)
    expect(test_poster2[:attributes]).to have_key(:year)
    expect(test_poster1[:attributes][:year]).to be_a(Integer)
    expect(test_poster2[:attributes][:year]).to be_a(Integer)
    expect(test_poster1[:attributes][:year]).to eq(2019)
    expect(test_poster2[:attributes][:year]).to eq(2018)

    expect(test_poster1[:attributes]).to have_key(:vintage)
    expect(test_poster2[:attributes]).to have_key(:vintage)
    expect(test_poster1[:attributes][:vintage]).to be_in([true, false])
    expect(test_poster2[:attributes][:vintage]).to be_in([true, false])
    expect(test_poster1[:attributes][:vintage]).to eq(true)
    expect(test_poster2[:attributes][:vintage]).to eq(true)

    expect(test_poster1[:attributes]).to have_key(:img_url)
    expect(test_poster2[:attributes]).to have_key(:img_url)
    expect(test_poster1[:attributes][:img_url]).to be_a(String)
    expect(test_poster2[:attributes][:img_url]).to be_a(String)
    expect(test_poster1[:attributes][:img_url]).to eq("./assets/failure.jpg")
    expect(test_poster2[:attributes][:img_url]).to eq("./assets/regret.jpg")
  end

  it "can fetch a poster by min_price" do
    get "/api/v1/posters?min_price=70"
    expect(response).to be_successful

    poster = JSON.parse(response.body, symbolize_names: true)
    expect(poster[:data].count).to eq(2)
    expect(poster[:meta][:count]).to be_an(Integer)
    expect(poster[:meta][:count]).to eq(2)
  end

  it "returns an empty dataset if no min_price matches" do
    get "/api/v1/posters?min_price=2000"
    expect(response).to be_successful

    poster = JSON.parse(response.body, symbolize_names: true)
    expect(poster[:data].count).to eq(0)
    expect(poster[:meta][:count]).to be_an(Integer)
    expect(poster[:meta][:count]).to eq(0)
  end

  it "can fetch a poster by max_price" do
    get "/api/v1/posters?max_price=75"
    expect(response).to be_successful

    poster = JSON.parse(response.body, symbolize_names: true)
    expect(poster[:data].count).to eq(1)
    expect(poster[:meta][:count]).to be_an(Integer)
    expect(poster[:meta][:count]).to eq(1)
  end
end