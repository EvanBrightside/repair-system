ActiveAdmin.register Apartment do
  menu priority: 2
  permit_params :owner, :address, :property_name, :property_developer,
                :status, :number_of_rooms, :floor, :area_dimension,
                plans: [], photos: [], documents: [],
                rooms_attributes: [:id, :name, :area_dimension, :status, :_destroy]

  member_action :delete_elem, method: :delete do
    @elem = ActiveStorage::Attachment.find(params[:id])
    @elem.purge
    redirect_back(fallback_location: edit_admin_apartment_path)
  end

  show do
    attributes_table do
      row :owner
      row :address do
        span apartment.address
        span ' | '
        span link_to 'Open Google Map', ("https://maps.google.com/maps?q=#{apartment.geo_coords(apartment.address)[:lat]}, #{apartment.geo_coords(apartment.address)[:lon]}"), class: "popup-geo"
      end
      row :property_name
      row :property_developer
      row :status
      row :number_of_rooms
      row :floor
      row :area_dimension
      row :plans do
        ul do
          apartment.plans.each do |plan|
            span class: 'popup-plans' do
              if plan.variable?
                link_to (image_tag plan.variant(resize: '100x100!')), rails_blob_path(plan)
              end
            end
          end
        end
      end
      row :photos  do
        ul do
          apartment.photos.each do |photo|
            span class: 'zoom-gallery' do
              if photo.variable?
                link_to (image_tag photo.variant(resize: '100x100!')), rails_blob_path(photo)
              end
            end
          end
        end
      end
      row 'Documents', :documents  do
        ul do
          apartment.documents.each do |document|
            span do
              if document.previewable?
                link_to (image_tag document.preview(resize: '100x100!')), rails_blob_path(document), class: 'iframe-popup'
              end
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
      f.input :plans, as: :file, input_html: { multiple: true }
      ul class: 'attached_preview' do
        f.object.plans.map do |plan|
          div do
            li image_tag(plan.variant(resize: '100x100!'))
            li link_to 'Remove', delete_elem_admin_apartment_path(plan.id), method: :delete, data: { confirm: 'Are you sure?' }
          end
        end
      end
      f.input :photos, as: :file, input_html: { multiple: true }
      ul class: 'attached_preview' do
        f.object.photos.map do |photo|
          div do
            li image_tag(photo.variant(resize: '100x100!'))
            li link_to 'Remove', delete_elem_admin_apartment_path(photo.id), method: :delete, data: { confirm: 'Are you sure?' }
          end
        end
      end
      f.input :documents, as: :file, input_html: { multiple: true }
      ul class: 'attached_preview' do
        f.object.documents.map do |document|
          div do
            li image_tag(document.preview(resize: '100x100!'))
            li link_to 'Remove', delete_elem_admin_apartment_path(document.id), method: :delete, data: { confirm: 'Are you sure?' }
          end
        end
      end
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
