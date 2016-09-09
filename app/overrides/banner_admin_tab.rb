Deface::Override.new(:virtual_path => "spree/layouts/admin",
                      :name => "banner_box_admin_tab",
                      :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                      :text => "<ul class='nav nav-sidebar'><%= tab t(:banner_boxes), url: admin_banner_boxes_url, icon: 'film' %></ul>")

Deface::Override.new(:virtual_path => "spree/admin/shared/sub_menu/_configuration",
                      :name => "add_banner_box_settings",
                      :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
                      :text => "<%= configurations_sidebar_menu_item(t(:banner_box_settings), edit_admin_banner_box_settings_url) %>")
