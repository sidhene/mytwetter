require 'spec_helper'

describe FollowsController do
  context "when no user is logged in" do
    describe "GET index" do
      subject { response }
      before { get :index }

      it { should_not be_successful }
    end

    describe "POST create" do
      subject { response }
      before { post :create, :follow => { :following_id => 1 } }

      it { should_not be_successful }
    end

    describe "DELETE destroy" do
      let(:follow) { FactoryGirl.create(:follow) }
      subject { response }

      before { delete :destroy, :id => follow.id }

      it{ should_not be_successful }
    end
  end

  context "when a user is logged in" do
    let(:user) { FactoryGirl.create(:user) }

    before { sign_in user }

    describe "GET index" do
      subject { response }

      before do
        10.times { FactoryGirl.create(:user) }
        get :index
      end

      it { should be_successful }

      it "should assign @users to all Users but the logged in one" do
        assigns(:users).map(&:id).should == User.all_except(user).load.map(&:id)
      end
    end

    describe "POST create" do
      context "with a valid user id to follow" do
        let(:following) { FactoryGirl.create(:user) }

        before { post :create, :follow => { :following_id => following.id } }

        it "should redirect to GET index" do
          response.should redirect_to follows_path
        end

        it "should display a success message" do
          flash[:success].should == "You are following @#{following.username}"
        end

        it "should create a new record" do
          expect {
            post :create, :follow => { :following_id => FactoryGirl.create(:user).id }
          }.to change { Follow.count }.by(1)
        end
      end

      context "with an invalid user id to follow" do
        before { post :create, :follow => { :following_id => -1 } }

        it "should redirect to GET index" do
          response.should redirect_to follows_path
        end

        it "should display an error message" do
          flash[:error].should == "Your attempt to follow was unsuccessful"
        end

        it "should not create a new record" do
          expect {
            post :create, :follow => { :following_id => -1 }
          }.to_not change { Follow.count }
        end
      end
    end

    describe "DELETE destroy" do
      context "when the Follow is a valid instance" do
        let(:follow) { FactoryGirl.create(:follow) }

        before { delete :destroy, :id => follow.id }

        context "that belongs to the current_user" do
          let(:follow) { FactoryGirl.create(:follow, :user => user) }

          it "should redirect to GET index" do
            response.should redirect_to follows_path
          end

          it "should display a success message" do
            flash[:success].should == "You are no longer following @#{follow.following.username}"
          end

          it "should delete the record" do
            Follow.where(:id => follow.id).should_not exist
          end
        end

        context "that does not belong to the current_user" do
          it "should redirect to GET index" do
            response.should redirect_to follows_path
          end

          it "should display and error message" do
            flash[:error].should == "Your attempt to unfollow was not successful"
          end

          it "should not delete the record" do
            Follow.where(:id => follow.id).should exist
          end
        end
      end
    end
  end
end
