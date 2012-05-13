# coding: UTF-8

FactoryGirl.define do
  factory :user do
    email "testuser@kanjidrill.com"
    password "password"
  end

  factory :kanji do
    grade_id 1
    glyph '一'
    meaning 'one'
  end

  factory :check do
    user_id 1
    kanji_id 1
    result :easy
  end
end
