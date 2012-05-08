require 'spec_helper'

describe Kanji do
  it { should allow_mass_assignment_of :glyph }
  it { should allow_mass_assignment_of :meaning }
  it { should allow_mass_assignment_of :grade_id }

  it { should have_many :checks }
  it { should belong_to :grade }

  it { should validate_presence_of :grade_id }
  it { should validate_presence_of :meaning }
  it { should validate_presence_of :glyph }
end
