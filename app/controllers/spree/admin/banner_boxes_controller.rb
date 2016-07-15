module Spree
  module Admin
    class BannerBoxesController < ResourceController

      def index
        respond_with(@collection)
      end

      def show
        redirect_to( :action => :edit )
      end

      def clone
        @new = @banner_box.duplicate

        if @new.save
          flash.notice = I18n.t('notice_messages.banner_box_cloned')
        else
          flash.notice = I18n.t('notice_messages.banner_box_not_cloned')
        end

        respond_with(@new) { |format| format.html { redirect_to edit_admin_banner_box_url(@new) } }
      end

      protected
      def find_resource
        Spree::BannerBox.find(params[:id])
      end

      def location_after_save
        edit_admin_banner_box_url(@banner_box)
      end

      def collection
        return @collection if @collection.present?
        params[:q] ||= {}
        params[:q][:s] ||= "created_at desc"
        params[:page] ||= 1
        # params[:category] ||= "compra"
        # params[:q][:enabled_eq] = params[:enabled] if params[:enabled]

        # params[:q][:category_in] = case params[:category]
        #   when 'compra' then %w[mainbanner minibanner1 minibanner2]
        #   when 'narrow' then %w[narrowbanner cupombanner cupombannermobile]
        #   when 'landing' then %w[radio_landing apae_landing]
        #   when 'marcas' then %w[brandbanner]
        #   when 'logos' then %w[homelogo2]
        #   when 'lateral' then %w[sidebanner]
        #   else %w[params[:category]]
        # end

        @search = super.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(15)
      end
    end
  end
end
