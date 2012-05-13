# coding: utf-8

require 'spec_helper'
include Warden::Test::Helpers

describe 'Quiz session' do
  before(:all) { Capybara.javascript_driver = :webkit }

  before(:each) do
    grade = Grade.create!
    Factory.create(:kanji, :glyph => '一', :meaning => 'one', :grade_id => grade.id)
    Factory.create(:kanji, :glyph => '二', :meaning => 'two', :grade_id => grade.id)
    Factory.create(:kanji, :glyph => '三', :meaning => 'three', :grade_id => grade.id)
  end

  it 'Can go through a full flashcard', :js => true do
    pending 'since we are picking kanji at random,
             first_glyph isnt ALWAYS different from the next one'
    user = Factory.create(:user)
    login_as user, scope: :user

    visit '/grades/1'
    first_glyph = find('.glyph').text
    first_glyph.should be_present
    Kanji.pluck(:glyph).should include(first_glyph)

    click_button 'Show'
    page.should have_content 'How well did you remember?'
    find('.meaning').text.should be_present

    click_button 'Again'
    find('time.last_seen').text.should == 'Never'
    click_button 'Next'
    find('.glyph').text.should_not == first_glyph
  end

  it 'cycles between each flashcard in the current grade', :js => true do
    user = Factory.create(:user)
    login_as user, scope: :user

    visit '/grades/1'
    glyphs = Kanji.pluck(:glyph)
    meanings = Kanji.pluck(:meaning)
    5.times do
      current_glyph = find('.glyph').text
      glyphs.should include(current_glyph)
      click_button 'Show'

      current_meaning = find('.meaning').text
      meanings.should include(current_meaning)
      click_button 'Again'
      click_button 'Next'
    end
  end
end
