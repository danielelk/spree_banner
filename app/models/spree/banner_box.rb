module Spree
  class BannerBox < ActiveRecord::Base
    # has_attached_file :attachment,
    #                     :path => ":rails_root/public/spree/banners/:id/:style_:basename.:extension",
    #                     :styles => { :mini => "80x80#", :small => "120x120#" },
    #                     :s3_credentials => "#{Rails.root}/config/aws.yml",
    #                     :convert_options => { :all => '-strip -auto-orient' }

        has_attached_file :attachment,
                      s3_credentials: { access_key_id:  ENV['S3_ACCESS_KEY'], secret_access_key: ENV['S3_SECRET'], bucket: ENV['S3_BUCKET'] },
                      storage: :s3,
                      s3_headers: { "Cache-Control" => 1.year.from_now.httpdate },
                      s3_protocol:  "https",
                      s3_region: ENV['S3_REGION'],
                      bucket: ENV['S3_BUCKET'],
                      # styles: { mini:'192x64#', default:'1000x135>', logo:'250x71#', minibanner:'269x196#', banner_marca: '327x260#', banners_slider_home:'1362x440#', banners_home:'327x260#', banners_marcas:'1000x100#', banner_cupom:'1000x60#', banner_cupom_mobile:'260x57#' },
                      default_style: :default,
                      url: ":s3_alias_url",
                      path: "/banners/:id/:style/:basename.:extension",
                      default_url:  "/banners/:id/:style/:basename.:extension",
                      s3_host_alias: Proc.new {|attachment| "assets#{attachment.instance.id % 4}.retroca.com.br" },
                      convert_options: { all: '-strip -auto-orient -colorspace sRGB' }

    # save the w,h of the original image (from which others can be calculated)
    # we need to look at the write-queue for images which have not been saved yet
    after_post_process :find_dimensions

    validates_presence_of :category
    validates_attachment_presence :attachment
    validates_attachment_content_type :attachment, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/x-png', 'image/pjpeg'], :message => I18n.t(:images_only)

    # scope :enable, lambda { |category| {:conditions => {:enabled => true, :category => category}} }
    scope :enable, -> (category) { where(:enabled => true, :category => category) }

    # Load user defined paperclip settings
    Spree::BannerBox.attachment_definitions[:attachment][:styles] = ActiveSupport::JSON.decode(Spree::Config[:banner_styles]).symbolize_keys!
    # Spree::BannerBox.attachment_definitions[:attachment][:path] = Spree::Config[:banner_path]
    # Spree::BannerBox.attachment_definitions[:attachment][:url] = Spree::Config[:banner_url]
    # Spree::BannerBox.attachment_definitions[:attachment][:default_url] = Spree::Config[:banner_default_url]
    # Spree::BannerBox.attachment_definitions[:attachment][:default_style] = Spree::Config[:banner_default_style]

    def initialize(*args)
      super(*args)
      last_banner = BannerBox.last
      self.position = last_banner ? last_banner.position + 1 : 0
    end

    # for adding banner_boxes which are closely related to existing ones
    # define "duplicate_extra" for site-specific actions, eg for additional fields
    def duplicate
      p = self.dup
      p.category = 'COPY OF ' + category
      p.created_at = p.updated_at = nil
      p.url = url
      p.attachment = attachment

      # allow site to do some customization
      p.send(:duplicate_extra, self) if p.respond_to?(:duplicate_extra)
      p.save!
      p
    end

    def find_dimensions
      temporary = attachment.queued_for_write[:original]
      filename = temporary.path unless temporary.nil?
      filename = attachment.path if filename.blank?
      geometry = Paperclip::Geometry.from_file(filename)
      self.attachment_width = geometry.width
      self.attachment_height = geometry.height
    end

    def set_list_position(i)
      update_column(:position, i)
    end
  end
end
