require 'spec_helper'
require Rails.root.join('lib', 'kanji_stats')

describe KanjiStats do
  it "takes a user and a kanji" do
    user = Factory.build(:user)
    kanji = Factory.build(:kanji)
    stats = KanjiStats.new(user, kanji)

    stats.instance_variable_get(:@user).should == user
    stats.instance_variable_get(:@kanji).should == kanji
  end

  describe "stats" do
    let(:user) { Factory.create(:user) }
    let(:kanji) { Factory.create(:kanji) }

    it "returns a hash" do
      stats = KanjiStats.new(user, kanji)

      stats.stats.should be_an_instance_of Hash
    end

    describe "stats[:last_seen]" do
      it "returns the last time a kanji was seen" do
        last_check = Factory.create(:check, :user => user, :kanji => kanji, :created_at => 2.days.ago)
        this_check = Factory.create(:check, :user => user, :kanji => kanji, :created_at => 1.day.ago)

        stats = KanjiStats.new(user, kanji)

        stats.stats[:last_seen].should == last_check.created_at
      end

      it "returns nil if this is the first time a kanji has been seen" do
        this_check = Factory.create(:check, :user => user, :kanji => kanji)

        stats = KanjiStats.new(user, kanji)
        stats.stats[:last_seen].should be_nil
      end
    end

    describe "counts" do
      before(:each) do
        generate_counts
      end

      describe "stats[:hard_count]" do
        it "returns the number of times the user had a hard time remembering the kanji" do
          stats = KanjiStats.new(user, kanji)
          stats.stats[:hard_count].should == 3
        end
      end

      describe "stats[:normal_count]" do
        it "returns the number of times the user had a normal time remembering a kanji" do
          stats = KanjiStats.new(user, kanji)
          stats.stats[:normal_count].should == 5
        end
      end

      describe "stats[:easy_count]" do
        it "returns the number of times the user had an easy time remembering a kanji" do
          stats = KanjiStats.new(user, kanji)
          stats.stats[:easy_count].should == 8
        end
      end
    end
  end
end

def generate_counts
  3.times do
    Factory.create(:check, :user => user, :kanji => kanji, :result => :hard)
  end

  5.times do
    Factory.create(:check, :user => user, :kanji => kanji, :result => :normal)
  end

  8.times do
    Factory.create(:check, :user => user, :kanji => kanji, :result => :easy)
  end
end
