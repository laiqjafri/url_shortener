require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe "GET urls#index" do
    before(:each) do
      (Url::ITEMS_PER_PAGE + 10).times{Url.create :url => 'http://l@iq.com'}
    end

    it "should test the index page" do
      get :index
      expect(assigns(:urls).length).to eq Url::ITEMS_PER_PAGE
      expect(assigns(:urls).count).to  eq Url::ITEMS_PER_PAGE + 10
      expect(assigns(:url)).to be_a_new(Url)
    end

    it "should test if the new_url gets set" do
      session[:new_id] = Url.last.id
      get :index
      expect(assigns(:new_url).id).to be Url.last.id
    end
  end

  describe "GET urls#create" do
    it "should create a url and redirect to the root path" do
      post :create, :url => {:url => 'http://l@iq.com'}
      expect(Url.count).to eq 1
      expect(response).to redirect_to(root_path)
      expect(session[:new_id]).to eq Url.first.id
    end

    it "should generate an error and render the root action" do
      post :create, :url => {:url => 'l@iq'}
      expect(Url.count).to eq 0
      expect(assigns(:url).valid?).to eq false
      expect(response).not_to redirect_to(root_path)
      expect(response).to render_template(:index)
    end
  end

  describe "GET urls#show" do
    it "should redirect to the long url" do
      url = Url.create :url => 'http://l@iq.com'
      get :show, :key => url.key
      expect(assigns(:url).id).to eq url.id
      expect(response).to redirect_to(url.url)
    end

    it "should redirect to the root path with flash error" do
      url = Url.create :url => 'http://l@iq.com'
      get :show, :key => 'some-fake-key'
      expect(assigns(:url)).to be nil
      expect(flash[:danger]).to eql "No such entry in our system"
      expect(response).to redirect_to(root_path)
    end
  end
end
