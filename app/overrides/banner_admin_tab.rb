Deface::Override.new(:virtual_path => "spree/layouts/admin",
                      :name => "banner_box_admin_tab",
                      :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                      :text => "<ul class='nav nav-sidebar'><%= tab(:banner_boxes, :icon => 'icon icon-bookmark') %></ul>")

Deface::Override.new(:virtual_path => "spree/admin/shared/sub_menu/_configuration",
                      :name => "add_banner_box_settings",
                      :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
                      :text => "<%= configurations_sidebar_menu_item(:banner_box_settings, edit_admin_banner_box_settings_url) %>")