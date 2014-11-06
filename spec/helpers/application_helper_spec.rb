require 'spec_helper'

describe ApplicationHelper do
  describe "#notices" do
    context "when flash[:success] is set" do
      before { flash[:success] = "Success!!" }

      it "should return a success alert" do
        helper.notices.should =~ Regexp.new(flash[:success])
      end
    end

    context "when flash[:notice] is set" do
      before { flash[:notice] = "Notice" }

      it "should return a normal alert" do
        helper.notices.should =~ Regexp.new(flash[:notice])
      end
    end

    context "when flash[:alert] is set" do
      before { flash[:alert] = "Alert" }

      it "should return a normal alert" do
        helper.notices.should =~ Regexp.new(flash[:alert])
      end
    end

    context "when flash[:error] is set" do
      before { flash[:error] = "Error!!" }

      it "should return an error alert" do
        helper.notices.should =~ Regexp.new(flash[:error])
      end
    end
  end
end
