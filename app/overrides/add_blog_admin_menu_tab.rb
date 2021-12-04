Deface::Override.new(virtual_path: 'spree/admin/shared/_main_menu',
                     name: "blog_admin_tabs",
                     insert_bottom: 'nav',
                     text: "<% if Spree.user_class && can?(:admin, Spree::BlogEntry) %><ul class='nav nav-sidebar'><%= tab 'BLOG', url: spree.admin_blog_entries_path, icon: 'comment' %></ul><% end %>",
                     disabled: false)
