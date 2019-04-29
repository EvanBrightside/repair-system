ActiveAdmin.register Apartment do
  permit_params :owner, :address, :property_name, :property_developer,
                :status, :number_of_rooms, :floor, :area_dimension,
                :floor_plan, room_ids: [], unit_plans: []

  member_action :delete_unit_plan, method: :delete do
   @unit_plan = ActiveStorage::Attachment.find(params[:id])
   @unit_plan.purge_later
   redirect_back(fallback_location: edit_admin_apartment_path)
  end

  member_action :delete_floor_plan, method: :delete do
   @floor_plan = ActiveStorage::Attachment.find(params[:id])
   @floor_plan.purge
   redirect_back(fallback_location: edit_admin_apartment_path)
  end

  show do
    attributes_table do
      row :owner
      row :address
      row :property_name
      row :property_developer
      row :status
      row :number_of_rooms
      row :floor
      row :area_dimension
      row :floor_plan do |apartment|
        ul do
          li do
            link_to (image_tag (apartment.floor_plan).variant(resize: '500')), rails_blob_path(apartment.floor_plan), target: :blank
          end
          li do
            span link_to 'Download', apartment.floor_plan, download: apartment.floor_plan
            span ' | '
            span link_to 'Remove', delete_floor_plan_admin_apartment_path(apartment.floor_plan.id), method: :delete, data: { confirm: 'Are you sure?' }
          end
        end
      end
      row 'Unit Plan', :unit_plans  do
        ul do
          apartment.unit_plans.each do |unit_plan|
            li do
              link_to (image_tag unit_plan.variant(resize: '500')), rails_blob_path(unit_plan), target: :blank
            end
            li do
              span link_to 'Download', unit_plan, download: unit_plan
              span ' | '
              span link_to 'Remove', delete_unit_plan_admin_apartment_path(unit_plan.id), method: :delete, data: { confirm: 'Are you sure?' }
            end
          end
        end
      end
    end
  end

  form html: { multipart: true } do |f|
    f.inputs 'Apartment' do
      f.input :owner
      f.input :address
      f.input :property_name
      f.input :property_developer
      f.input :status
      f.input :number_of_rooms
      f.input :floor
      f.input :area_dimension
      f.input :floor_plan, as: :file
      f.input :unit_plans, as: :file, input_html: { multiple: true }
    end
    f.actions
  end
end
