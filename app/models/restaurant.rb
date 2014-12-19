class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :reviews, dependent: :destroy
  validates :name, length: {minimum: 3}, uniqueness: true


  has_attached_file :image, 
                    :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
                    :default_url => "/images.:style/missing.png", 
                    :s3_options => { :server => "s3-eu-west-1.amazonaws.com"  }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  def average_rating
    return 'N/A' if reviews.none?
    # reviews.inject(0) {|memo, review| memo + review.rating} / reviews.count
    reviews.average(:rating)
  end
end
