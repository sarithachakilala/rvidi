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
        file_attributes:{
          file: fixture_file_upload("spec/fixtures/videos/sample.mp4")
        }
      }
      expect{
        post :create, {:cameo => @cameo_attributes}
      }.to change(CameoFile, :count).by(1)

      response.should redirect_to( edit_web_cameo_url(assigns(:cameo)) )
    end

  end

  # # This should return the minimal set of attributes required to create a valid
  # # Cameo. As you add validations to Cameo, be sure to
  # # adjust the attributes here as well.
  # let(:valid_attributes) { { "video_id" => "1" } }

  # # This should return the minimal set of values that should be in the session
  # # in order to pass any filters (e.g. authentication) defined in
  # # CameosController. Be sure to keep this updated too.
  # let(:valid_session) { {} }

  # describe "GET index" do
  #   it "assigns all cameos as @cameos" do
  #     cameo = Cameo.create! valid_attributes
  #     get :index, {}, valid_session
  #     assigns(:cameos).should eq([cameo])
  #   end
  # end

  # describe "GET show" do
  #   it "assigns the requested cameo as @cameo" do
  #     cameo = Cameo.create! valid_attributes
  #     get :show, {:id => cameo.to_param}, valid_session
  #     assigns(:cameo).should eq(cameo)
  #   end
  # end

  # describe "GET new" do
  #   it "assigns a new cameo as @cameo" do
  #     get :new, {}, valid_session
  #     assigns(:cameo).should be_a_new(Cameo)
  #   end
  # end

  # describe "GET edit" do
  #   it "assigns the requested cameo as @cameo" do
  #     cameo = Cameo.create! valid_attributes
  #     get :edit, {:id => cameo.to_param}, valid_session
  #     assigns(:cameo).should eq(cameo)
  #   end
  # end

  # describe "POST create" do
  #   describe "with valid params" do
  #     it "creates a new Cameo" do
  #       expect {
  #         post :create, {:cameo => valid_attributes}, valid_session
  #       }.to change(Cameo, :count).by(1)
  #     end

  #     it "assigns a newly created cameo as @cameo" do
  #       post :create, {:cameo => valid_attributes}, valid_session
  #       assigns(:cameo).should be_a(Cameo)
  #       assigns(:cameo).should be_persisted
  #     end

  #     it "redirects to the created cameo" do
  #       post :create, {:cameo => valid_attributes}, valid_session
  #       response.should redirect_to(Cameo.last)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved cameo as @cameo" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Cameo.any_instance.stub(:save).and_return(false)
  #       post :create, {:cameo => { "video_id" => "invalid value" }}, valid_session
  #       assigns(:cameo).should be_a_new(Cameo)
  #     end

  #     it "re-renders the 'new' template" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Cameo.any_instance.stub(:save).and_return(false)
  #       post :create, {:cameo => { "video_id" => "invalid value" }}, valid_session
  #       response.should render_template("new")
  #     end
  #   end
  # end

  # describe "PUT update" do
  #   describe "with valid params" do
  #     it "updates the requested cameo" do
  #       cameo = Cameo.create! valid_attributes
  #       # Assuming there are no other cameos in the database, this
  #       # specifies that the Cameo created on the previous line
  #       # receives the :update_attributes message with whatever params are
  #       # submitted in the request.
  #       Cameo.any_instance.should_receive(:update_attributes).with({ "video_id" => "1" })
  #       put :update, {:id => cameo.to_param, :cameo => { "video_id" => "1" }}, valid_session
  #     end

  #     it "assigns the requested cameo as @cameo" do
  #       cameo = Cameo.create! valid_attributes
  #       put :update, {:id => cameo.to_param, :cameo => valid_attributes}, valid_session
  #       assigns(:cameo).should eq(cameo)
  #     end

  #     it "redirects to the cameo" do
  #       cameo = Cameo.create! valid_attributes
  #       put :update, {:id => cameo.to_param, :cameo => valid_attributes}, valid_session
  #       response.should redirect_to(cameo)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns the cameo as @cameo" do
  #       cameo = Cameo.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Cameo.any_instance.stub(:save).and_return(false)
  #       put :update, {:id => cameo.to_param, :cameo => { "video_id" => "invalid value" }}, valid_session
  #       assigns(:cameo).should eq(cameo)
  #     end

  #     it "re-renders the 'edit' template" do
  #       cameo = Cameo.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Cameo.any_instance.stub(:save).and_return(false)
  #       put :update, {:id => cameo.to_param, :cameo => { "video_id" => "invalid value" }}, valid_session
  #       response.should render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE destroy" do
  #   it "destroys the requested cameo" do
  #     cameo = Cameo.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => cameo.to_param}, valid_session
  #     }.to change(Cameo, :count).by(-1)
  #   end

  #   it "redirects to the cameos list" do
  #     cameo = Cameo.create! valid_attributes
  #     delete :destroy, {:id => cameo.to_param}, valid_session
  #     response.should redirect_to(cameos_url)
  #   end
  # end

end
