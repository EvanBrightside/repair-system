ActiveAdmin.register Apartment do
  menu priority: 2
  permit_params :owner, :address, :property_name, :property_developer,
                :status, :number_of_rooms, :floor, :area_dimension,
                :floor_plan, :unit_plan, unit_photos: [],
                documents: [], rooms_attributes: [:id, :name, :area_dimension, :status, :_destroy]

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

  member_action :delete_unit_photo, method: :delete do
   @unit_photo = ActiveStorage::Attachment.find(params[:id])
   @unit_photo.purge
   redirect_back(fallback_location: edit_admin_apartment_path)
  end

  member_action :delete_document, method: :delete do
   @document = ActiveStorage::Attachment.find(params[:id])
   @document.purge
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
      row :unit_plan do |apartment|
        ul do
          li do
            link_to (image_tag (apartment.unit_plan).variant(resize: '500')), rails_blob_path(apartment.unit_plan), target: :blank
          end
          li do
            span link_to 'Download', apartment.unit_plan, download: apartment.unit_plan
            span ' | '
            span link_to 'Remove', delete_unit_plan_admin_apartment_path(apartment.unit_plan.id), method: :delete, data: { confirm: 'Are you sure?' }
          end
        end
      end
      row 'Unit Photos', :unit_photos  do
        ul do
          apartment.unit_photos.each do |unit_photo|
            li do
              link_to (image_tag unit_photo.variant(resize: '500')), rails_blob_path(unit_photo), target: :blank
            end
            li do
              span link_to 'Download', unit_photo, download: unit_photo
              span ' | '
              span link_to 'Remove', delete_unit_photo_admin_apartment_path(unit_photo.id), method: :delete, data: { confirm: 'Are you sure?' }
            end
          end
        end
      end
      row 'Documents', :documents  do
        ul do
          apartment.documents.each do |document|
            li do
              if document.previewable?
                link_to (image_tag document.preview(resize: '500')), rails_blob_path(document), target: :blank
              end
            end
            li do
              span link_to 'Download', document, download: document
              span ' | '
              span link_to 'Remove', delete_document_admin_apartment_path(document.id), method: :delete, data: { confirm: 'Are you sure?' }
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
      f.input :unit_plan, as: :file
      f.input :unit_photos, as: :file, input_html: { multiple: true }
      f.input :documents, as: :file, input_html: { multiple: true }
    end

    f.inputs 'Rooms' do
      f.has_many :rooms, heading: '', allow_destroy: true, new_record: 'Add a room' do |ff|
        ff.input :name
        ff.input :area_dimension
        ff.input :status
      end
    end
    f.actions
  end
end
