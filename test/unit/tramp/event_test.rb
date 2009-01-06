require File.dirname(__FILE__) + '/../../test_helper'


class Tramp::Model::EventTest < ActiveSupport::TestCase
  
  def setup
    super
    @event = Tramp::Model::Event.new
  end
  
  test "should return empty rule" do
    assert_kind_of Tramp::Model::Rule, @event.rules.first
  end
  
  test "should eval empty rule" do
    assert_equal [], @event.rules.first.eval
    assert @event.rules.first.eval.empty?
  end
  
  test "should find rule" do
    event = MockEvent.new
    assert_kind_of MockRule, event.rules.first
  end
  
  test "should eval rule" do
    event = MockEvent.new
    assert_equal [{:debit=>20, :account=>"abc"}, {:credit=>20, :account=>"def"}], event.rules.first.eval
  end
  
  test "should create entries with hash" do
    assert container =  Tramp::Model::Event.new.create_entries({:debit=>10},{:credit=>10})
    assert_kind_of Tramp::Model::Entry, container.entries[0]
    assert !container.new_record?
    assert_equal 1000, container.entries.first.debit.to_i
  end
  
  test "should create movement with rule" do
    mock_event = MockEvent.new
    container = mock_event.create_entries
    assert_equal 20.0, container.entries.first.debit.to_f
  end
  
  test "should make new movement with rule" do
    mock_event = MockEvent.new
    container = mock_event.new_entries
    assert_equal 20.0, container.entries.first.debit.to_f
  end
  
  test "should destroy movement" do
    mock_event = MockEvent.new
    mock_event.create_entries
    assert mock_event.delete_entries
    assert_nil mock_event.movement
  end
  
  test "should update movement" do
    mock_event = MockEvent.new
    mock_event.create_entries
    mock_event.foo = 40
    assert mock_event.update_entries
    assert_equal 40, mock_event.entries[0].debit.to_f
  end
  
  test "should rescue to Tramp::Model::Rule for klass rule" do
    class TryEvent < Tramp::Model::Event; end
    assert_kind_of Tramp::Model::Rule, TryEvent.rule(:Toto).new
  end
  
  test "should able to have two rules" do
    assert_equal 2, EventTwoRules.new.rules.size
  end
  
  def teardown
    MockEvent.delete(:all)
  end
  
end
