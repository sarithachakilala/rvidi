require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ApisController do

  # This should return the minimal set of attributes required to create a valid
  # Api. As you add validations to Api, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ApisController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all apis as @apis" do
      api = Api.create! valid_attributes
      get :index, {}, valid_session
      assigns(:apis).should eq([api])
    end
  end

  describe "GET show" do
    it "assigns the requested api as @api" do
      api = Api.create! valid_attributes
      get :show, {:id => api.to_param}, valid_session
      assigns(:api).should eq(api)
    end
  end

  describe "GET new" do
    it "assigns a new api as @api" do
      get :new, {}, valid_session
      assigns(:api).should be_a_new(Api)
    end
  end

  describe "GET edit" do
    it "assigns the requested api as @api" do
      api = Api.create! valid_attributes
      get :edit, {:id => api.to_param}, valid_session
      assigns(:api).should eq(api)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Api" do
        expect {
          post :create, {:api => valid_attributes}, valid_session
        }.to change(Api, :count).by(1)
      end

      it "assigns a newly created api as @api" do
        post :create, {:api => valid_attributes}, valid_session
        assigns(:api).should be_a(Api)
        assigns(:api).should be_persisted
      end

      it "redirects to the created api" do
        post :create, {:api => valid_attributes}, valid_session
        response.should redirect_to(Api.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved api as @api" do
        # Trigger the behavior that occurs when invalid params are submitted
        Api.any_instance.stub(:save).and_return(false)
        post :create, {:api => { "name" => "invalid value" }}, valid_session
        assigns(:api).should be_a_new(Api)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Api.any_instance.stub(:save).and_return(false)
        post :create, {:api => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested api" do
        api = Api.create! valid_attributes
        # Assuming there are no other apis in the database, this
        # specifies that the Api created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Api.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
        put :update, {:id => api.to_param, :api => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested api as @api" do
        api = Api.create! valid_attributes
        put :update, {:id => api.to_param, :api => valid_attributes}, valid_session
        assigns(:api).should eq(api)
      end

      it "redirects to the api" do
        api = Api.create! valid_attributes
        put :update, {:id => api.to_param, :api => valid_attributes}, valid_session
        response.should redirect_to(api)
      end
    end

    describe "with invalid params" do
      it "assigns the api as @api" do
        api = Api.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Api.any_instance.stub(:save).and_return(false)
        put :update, {:id => api.to_param, :api => { "name" => "invalid value" }}, valid_session
        assigns(:api).should eq(api)
      end

      it "re-renders the 'edit' template" do
        api = Api.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Api.any_instance.stub(:save).and_return(false)
        put :update, {:id => api.to_param, :api => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested api" do
      api = Api.create! valid_attributes
      expect {
        delete :destroy, {:id => api.to_param}, valid_session
      }.to change(Api, :count).by(-1)
    end

    it "redirects to the apis list" do
      api = Api.create! valid_attributes
      delete :destroy, {:id => api.to_param}, valid_session
      response.should redirect_to(apis_url)
    end
  end

end
