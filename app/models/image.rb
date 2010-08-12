class Image < ActiveRecord::Base

  belongs_to :organisation
	belongs_to :liability

  has_attachment :content_type => :image,
                :storage => :file_system,
								:resize_to => '600x400',
                :thumbnails => {:thumb => '50x50'},
                :thumbnail_class => 'Image'
	validates_as_attachment

end
