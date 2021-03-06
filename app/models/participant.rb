class Participant < ApplicationRecord
  belongs_to :study
  has_many :sbsod_records, :dependent => :destroy
  has_many :mrt_records, :dependent => :destroy
  has_many :pf_records, :dependent => :destroy
  has_many :vv_records, :dependent => :destroy
  has_many :psas_records, :dependent => :destroy
  has_many :pvas_records, :dependent => :destroy
  has_many :virtual_navigation_logs, :dependent => :destroy
  has_many :virtual_map_arrangements, -> { order("created_at ASC") }, :dependent => :destroy
  has_many :virtual_distance_tests, -> { order("created_at ASC") }, :dependent => :destroy
  has_many :virtual_direction_tests, -> { order("created_at ASC") }, :dependent => :destroy
  has_many :vambler_demographics_records, :dependent => :destroy
  
  def title
    "#{identification}"
  end

  scope :who_elect_to_share_data, -> {
    where(share_data: true)
  }

  scope :with_currently_shared_data, -> {
    where(id: who_elect_to_share_data
      .joins(:study)
      .where("studies.when_to_share_data = 'immediately' or (studies.when_to_share_data = '3years' and participants.created_at <= ? )", 3.years.ago).pluck(:id))
  }
end
