require 'spec_helper'

describe Check do
  it { should allow_mass_assignment_of :result }
  it { should allow_mass_assignment_of :kanji_id }
  it { should allow_mass_assignment_of :user_id }

  it { should belong_to :kanji }
  it { should belong_to :user }

  it { should validate_presence_of :result }
  it { should validate_presence_of :kanji_id }
  it { should validate_presence_of :user_id }

  [:again, :hard, :normal, :easy].each do |result|
    it { should allow_value(result).for(:result) }
  end
end
