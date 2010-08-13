class Image < ActiveRecord::Base

  belongs_to :organisation
	belongs_to :liability
	belongs_to :expense

  has_attachment :storage => :file_system,
								:resize_to => '600x400',
                :thumbnails => {:thumb => '50x50'},
                :thumbnail_class => 'Image'
	validates_as_attachment

end
