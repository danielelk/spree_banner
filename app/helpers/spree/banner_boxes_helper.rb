# coding: utf-8
module Spree
  module BannerBoxesHelper
    
    def banner_image_tag(banner, ga_event, params={})
      link_to(image_tag(banner.attachment.url(params[:style].to_sym), alt: banner.presentation), (banner.url.blank? ? "javascript:void(0)" : banner.url), target: (banner.target_blank? ? "_blank" : ""), onClick: ga_event)
    end
        
    def insert_slider_box(params={})
      params[:category] ||= "home"
      params[:ul_class] ||= "bxslider-home"
      params[:li_class] ||= "clearfix"
      params[:div_class] ||= "slide-image"
      params[:style] ||= Spree::Config[:banner_default_style]
      @@banner = Spree::BannerBox.enable(params[:category])
      if @@banner.blank?
        return ''
      end
      res = []
      banner = @@banner.sort_by { |ban| ban.position }
                
      content_tag :ul, class: params[:ul_class] do
        banner.map do |ban| 
          content_tag :li, class: params[:li_class] do 
            content_tag :div, class: params[:div_class] do 
              link_to(image_tag(ban.attachment.url(params[:style].to_sym), alt: ban.presentation), (ban.url.blank? ? "javascript: void(0)" : ban.url), target: (ban.target_blank? ? "_blank" : ""))
            end
          end
        end.join().html_safe  
      end    
    end
    
    def insert_slider_box3(params={})
      params[:category] ||= "home"
      params[:ul_class] ||= "bxslider-home"
      params[:li_class] ||= "clearfix"
      params[:style] ||= Spree::Config[:banner_default_style]

      @@banner = Spree::BannerBox.enable(params[:category])

      return '' if @@banner.blank?

      ga_event = "ga('send', 'event', { eventCategory: 'internal-promotion', eventAction: 'clicked', eventLabel: 'GA_EVENTO'});" unless params[:ga_event].blank?

      banner = @@banner.sort_by { |ban| ban.position }
            
      content_tag :div, class: params[:ul_class] do 
        banner.each_with_index.map do |ban, i|
          ga_string = ""
          ga_string = ga_event.gsub("GA_EVENTO", "#{params[:ga_event]}-#{i+1}") unless params[:ga_event].blank?

          content_tag :div, class: params[:li_class] do
            link_to(image_tag(ban.attachment.url(params[:style].to_sym), alt: ban.presentation), (ban.url.blank? ? "javascript: void(0)" : ban.url), target: (ban.target_blank? ? "_blank" : ""), onClick: ga_string.html_safe)
          end
        end.join().html_safe
      end  
    end
      
    def insert_banner_box(params={})
      params[:category] ||= "home"
      params[:class] ||= "banner"
      params[:style] ||= Spree::Config[:banner_default_style]
      params[:list] ||= false
      @@banner = Spree::BannerBox.enable(params[:category])
              
      if @@banner.blank?
        return ''
      end
                
      res = []
      banner = @@banner.sort_by { |ban| ban.position }
              
      onClick_ga_event = "ga('send', 'event', { eventCategory: 'internal-promotion', eventAction: 'clicked', eventLabel: '#{params[:category]}'});"
                 
      if (params[:list])
        content_tag(:ul, banner.map{|ban| content_tag(:li, banner_image_tag(ban,onClick_ga_event,params), :class => params[:class])}.join().html_safe )
      else
        banner.map{|ban| content_tag(:div, banner_image_tag(ban,onClick_ga_event,params), :class => params[:class])}.join().html_safe
      end
    end
    
    def insert_banner_box3(params={})
      params[:category] ||= "home"
      params[:class] ||= "banner"
      params[:style] ||= Spree::Config[:banner_default_style]
      params[:list] ||= false
      
      @@banner = Spree::BannerBox.enable(params[:category])

      return '' if @@banner.blank?

      banner = @@banner.sort_by { |ban| ban.position }

      ga_event = "ga('send', 'event', { eventCategory: 'internal-promotion', eventAction: 'clicked', eventLabel: 'GA_EVENTO'});" unless params[:ga_event].blank?

      if (params[:list])
        content_tag :ul, :class => params[:class] do
          banner.each_with_index.map{ |ban, i|
            ga_string = ""
            ga_string = ga_event.gsub("GA_EVENTO", "#{params[:ga_event]}-#{i+1}") unless params[:ga_event].blank?
            content_tag(:li, banner_image_tag(ban, ga_string.html_safe, params))
          }.join().html_safe
        end
      else
        banner.each_with_index.map{ |ban, i| content_tag(:li, banner_image_tag(ban, "ga('send', 'event', { eventCategory: 'internal-promotion', eventAction: 'clicked', eventLabel: 'carousel-#{i+1}'});".html_safe, params), :class => params[:class])}.join().html_safe
      end
    end
    
    def insert_marcas_banner_pannel(params={})
      params[:category] ||= 'brandbanner'
      params[:class] ||= 'banner_pannel'
      params[:style] ||= Spree::Config[:banner_default_style]
      params[:btn_class] ||= "button"
      # params[:list] ||= false
      @@banner = Spree::BannerBox.enable(params[:category])
              
      if @@banner.blank?
        return ''
      end
              
      res = []
      banner = @@banner.sort_by { |ban| ban.position }
           
      ga_event = "ga('send', 'event', { eventCategory: 'internal-promotion', eventAction: 'clicked', eventLabel: '#{params[:category]}'});"
           
      banners_content = banner.map do |ban|
        banner_image = banner_image_tag(ban, ga_event, params)
        txt = ban.presentation.split("-")
        pannel_desc = []
             
        unless ban.url.blank?
          pannel_desc << content_tag(:div, link_to("Comprar", ban.url, class: params[:btn_class], target:(ban.target_blank? ? "_blank" : ""), onClick: ga_event), :class => "button-container")
        end
              
        pannel_desc = []
        pannel_desc << content_tag(:h4, txt[0])
        description = txt.size > 1 ? txt[1] : "#{txt[0]} com até 60% de desconto no Retroca!"
        pannel_desc << content_tag(:p, description)
                    
        content_tag(:div, banner_image + pannel_desc.join().html_safe, :class => params[:class])
             
      end.join().html_safe
        
      content_tag :div, banners_content, :class => 'banner-pannel-container'
    end
              
    def insert_marcas_banner_pannel3(params={})
      params[:category] ||= 'brandbanner'
      params[:class] ||= 'banner_pannel'
      params[:style] ||= Spree::Config[:banner_default_style]
      params[:btn_class] ||= "button"
      # params[:list] ||= false
      @@banner = Spree::BannerBox.enable(params[:category])
              
      if @@banner.blank?
        return ''
      end
              
      res = []
      banner = @@banner.sort_by { |ban| ban.position }
           
      ga_event = "ga('send', 'event', { eventCategory: 'internal-promotion', eventAction: 'clicked', eventLabel: '#{params[:category]}'});"
           
      banners_content = banner.map do |ban|
        content_tag :li do
          link_to (ban.url.blank? ? "javascript:void(0)" : ban.url), target: (ban.target_blank? ? "_blank" : ""), onClick: ga_event do
            content_tag :div, :class => 'bloco-marcas' do
              # image
              img = content_tag :div, :class => 'cut_img' do
                image_tag(ban.attachment.url(params[:style].to_sym), alt: ban.presentation)
              end
              
              # description
              description = content_tag :p, ban.presentation
              
              img + description
            end
          end
        end
      end.join().html_safe
              
      content_tag :ul, banners_content
    end
  end
end