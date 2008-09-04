require File.dirname(__FILE__) + "/spec_helper"

module RestrictParams
  describe Restriction do
    it "should raise an ArgumentError if initialized without a :to option" do
      lambda { Restriction.new(:foo => :bar) }.should raise_error(ArgumentError)
    end
  end
  
  describe Restriction, "on a MealsController, when restricting to :meat and :balls, with empty params" do
    before do
      @restriction = Restriction.new(:to => [:meat, :balls])
      @controller = stub_everything(:controller_name => "meals", :params => {})
    end
    
    it "should not raise an error when the resource params don't exist" do
      lambda { @restriction.apply(@controller) }.should_not raise_error
    end
  end
  
  describe Restriction, "on a MealsController, when restricting to :meat and :balls, with :meat and :ketchup in the params" do
    before do
      @controller = stub_everything(:controller_name => "meals")
      @controller.stubs(:params).returns("meal" => { "meat" => :foo, "ketchup" => :foo })
    end
  
    describe "with no extra options" do
      before do
        @restriction = Restriction.new(:to => [:meat, :balls])
      end
      
      it "should remove :ketchup" do
        @restriction.apply(@controller)
        @controller.params["meal"].keys.should_not include("ketchup")
      end
    end
    
    describe "only operating on the update action" do
      before do
        @restriction = Restriction.new(:to => [:meat, :balls], :only => :update)
      end
      
      it "should remove :ketchup when the action is 'update' and the params include meat and ketchup" do
        @controller.stubs(:action_name).returns("update")
        @restriction.apply(@controller)
        @controller.params["meal"].keys.should_not include("ketchup")
      end
      
      it "should not remove :ketchup when the action is 'new' and the params include meat and ketchup" do
        @controller.stubs(:action_name).returns("new")
        @restriction.apply(@controller)
        @controller.params["meal"].keys.should include("ketchup")
      end
    end
    
    describe "with a condition that the user must be logged out" do
      before do
        @restriction = Restriction.new(:to => [:meat, :balls], :if => :logged_out?)
      end
      
      it "should remove :ketchup when the user is logged out" do
        @controller.stubs(:logged_out?).returns(true)
        @restriction.apply(@controller)
        @controller.params["meal"].keys.should_not include("ketchup")
      end
      
      it "should not remove :ketchup when the user is not logged out" do
        @controller.stubs(:logged_out?).returns(false)
        @restriction.apply(@controller)
        @controller.params["meal"].keys.should include("ketchup")
      end
    end
    
    describe "with a condition not to run unless the user is hungry" do
      before do
        @restriction = Restriction.new(:to => [:meat, :balls], :unless => :hungry?)
      end
      
      it "should remove :ketchup when the user is not hungry and the params include meat and ketchup" do
        @controller.stubs(:hungry?).returns(false)
        @restriction.apply(@controller)
        @controller.params["meal"].keys.should_not include("ketchup")
      end
      
      it "should not remove :ketchup when the user is hungry and the params include meat and ketchup" do
        @controller.stubs(:hungry?).returns(true)
        @restriction.apply(@controller)
        @controller.params["meal"].keys.should include("ketchup")
      end
    end
  end
end
