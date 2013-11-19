require 'spec_helper'

describe Web::CameosController do

  describe "Create" do
    before :all do
      @show = FactoryGirl.create :show
      @user = FactoryGirl.create :user
    end


    it "should accept a video file as object" do
      login( @user )

      @cameo_attributes =  {
        show_id: @show.id,
        title: "testing cameo",
        user_id: @user.id,
        director_id: @user.id,
        files_attributes:[
          {file: fixture_file_upload("spec/fixtures/videos/sample.mp4")}
        ]
      }
      expect{
        post :create, {:cameo => @cameo_attributes}
      }.to change(CameoFile, :count).by(2)

      response.should redirect_to( edit_web_cameo_url(assigns(:cameo)) )
    end

  end

end
