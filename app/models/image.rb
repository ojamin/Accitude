class Image < ActiveRecord::Base

  belongs_to :organisation

  has_attachment :content_type => :image,
                :storage => :file_system,
                :resize_to => '350x200',
                :thumbnails => {:thumb => '50x50'},
                :thumbnail_class => 'Image'
  validates_as_attachment

end
