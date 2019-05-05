ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Apartments" do
          ul do
            Apartment.find_each do |apt|
              li class: 'panel_box' do
                div class: 'category_icon fa fa-angle-right'
                div link_to("#{apt.property_name} / #{apt.property_developer}", admin_apartment_path(apt)), class: 'category_name'
                div link_to("Add a room", new_admin_room_path)
              end
              div class: "panel" do
                if apt.rooms and apt.rooms.count > 0
                  render 'rooms_partial', { apt: apt }
                end
              end
            end
          end
        end
      end
    end
  end
end
